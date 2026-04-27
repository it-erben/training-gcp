# 13 - Pub/Sub: Dead-Letter, Push und BigQuery-Subscription (CLI)

In dieser Aufgabe üben Sie den Umgang mit der `gcloud`-CLI für Google Cloud
Pub/Sub. Sie erstellen ein Topic, eine Pull-Subscription mit Dead-Letter-Topic,
eine Push-Subscription sowie eine BigQuery-Subscription, die eingehende
Nachrichten direkt in eine BigQuery-Tabelle schreibt.

## Erstellen eines Pub/Sub Topics

Erstellen Sie ein neues Pub/Sub Topic. Topic-Namen müssen innerhalb des
Projekts eindeutig sein.

```sh
gcloud pubsub topics create my-topic
```

## Erstellen eines Dead-Letter Topics

Nachrichten, die nicht erfolgreich verarbeitet werden können, sollen später in
ein separates Dead-Letter-Topic (DLQ) umgeleitet werden. Damit die DLQ
Nachrichten auch tatsächlich aufbewahrt, legen Sie zusätzlich eine
Subscription darauf an.

```sh
gcloud pubsub topics create my-topic-dlq
gcloud pubsub subscriptions create my-topic-dlq-sub \
   --topic=my-topic-dlq
```

## Berechtigungen für das Dead-Lettering

Damit Pub/Sub Nachrichten in die DLQ weiterleiten darf, benötigt der
Pub/Sub-Service-Agent die Rolle `roles/pubsub.publisher` auf dem
DLQ-Topic.

```sh
PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT \
   --format="value(projectNumber)")
PUBSUB_SA="service-${PROJECT_NUMBER}@gcp-sa-pubsub.iam.gserviceaccount.com"

gcloud pubsub topics add-iam-policy-binding my-topic-dlq \
   --member="serviceAccount:${PUBSUB_SA}" \
   --role="roles/pubsub.publisher"
```

## Erstellen einer Pull-Subscription mit Dead-Letter Policy

Erstellen Sie nun die eigentliche Pull-Subscription. Mit
`--max-delivery-attempts=5` wird eine Nachricht nach fünf erfolglosen
Zustellversuchen in die DLQ verschoben. Der Pub/Sub-Service-Agent benötigt
zusätzlich die Rolle `roles/pubsub.subscriber` auf der Subscription.

```sh
gcloud pubsub subscriptions create my-subscription \
   --topic=my-topic \
   --ack-deadline=10 \
   --dead-letter-topic=my-topic-dlq \
   --max-delivery-attempts=5

gcloud pubsub subscriptions add-iam-policy-binding my-subscription \
   --member="serviceAccount:${PUBSUB_SA}" \
   --role="roles/pubsub.subscriber"
```

## Eine Nachricht in die Dead-Letter Queue befördern

Publizieren Sie eine Nachricht und rufen Sie sie wiederholt ab, ohne sie zu
bestätigen. Nach Ablauf des `ack-deadline` (10 Sekunden) wird die Nachricht
erneut zugestellt. Nach fünf Versuchen wandert sie automatisch in die DLQ.

```sh
gcloud pubsub topics publish my-topic --message="Hello DLQ"

for i in $(seq 1 6); do
   echo "Versuch $i:"
   gcloud pubsub subscriptions pull my-subscription --limit=1
   sleep 11
done
```

## Inspizieren der Dead-Letter Queue

Die nicht verarbeitete Nachricht sollte nun in der DLQ-Subscription liegen.

```sh
gcloud pubsub subscriptions pull my-topic-dlq-sub \
   --limit=1 \
   --auto-ack
```

## Erstellen einer Push-Subscription

Eine Push-Subscription stellt eingehende Nachrichten aktiv per HTTP-POST an
einen externen Endpunkt zu. Öffnen Sie für diese Übung
[https://webhook.site](https://webhook.site) in einem neuen Tab und kopieren
Sie den Wert "Your unique URL". Tragen Sie diese URL in `PUSH_URL` ein:

```sh
export PUSH_URL="https://webhook.site/..."

gcloud pubsub subscriptions create my-push-subscription \
   --topic=my-topic \
   --push-endpoint=$PUSH_URL

gcloud pubsub topics publish my-topic --message="Hello Push"
```

Wechseln Sie zurück in den Browser-Tab. Nach wenigen Sekunden erscheint dort
der eingehende Request mit der Nachricht im Body.

## Erstellen einer BigQuery-Subscription

Eine BigQuery-Subscription schreibt empfangene Nachrichten direkt in eine
BigQuery-Tabelle, ohne dass eigener Subscriber-Code nötig wäre. Erstellen Sie
zunächst Dataset und Tabelle:

```sh
bq mk --location=europe-west1 -d pubsub_demo
bq mk --table $GOOGLE_CLOUD_PROJECT:pubsub_demo.messages data:STRING
```

Vergeben Sie dem Pub/Sub-Service-Agent die nötigen BigQuery-Rechte:

```sh
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
   --member="serviceAccount:${PUBSUB_SA}" \
   --role="roles/bigquery.dataEditor"
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
   --member="serviceAccount:${PUBSUB_SA}" \
   --role="roles/bigquery.metadataViewer"
```

Erstellen Sie die Subscription und publizieren Sie eine Nachricht:

```sh
gcloud pubsub subscriptions create my-bq-subscription \
   --topic=my-topic \
   --bigquery-table=$GOOGLE_CLOUD_PROJECT:pubsub_demo.messages

gcloud pubsub topics publish my-topic --message="Hello BigQuery"
```

Prüfen Sie nach kurzer Wartezeit das Ergebnis in BigQuery:

```sh
bq query --use_legacy_sql=false \
   "SELECT * FROM \`$GOOGLE_CLOUD_PROJECT.pubsub_demo.messages\`"
```

## Aufräumen

Führen Sie folgende Befehle aus, um die Umgebung aufzuräumen.

```sh
gcloud pubsub subscriptions delete \
   my-subscription \
   my-topic-dlq-sub \
   my-push-subscription \
   my-bq-subscription \
   --quiet

gcloud pubsub topics delete my-topic my-topic-dlq --quiet

bq rm -r -f -d $GOOGLE_CLOUD_PROJECT:pubsub_demo

gcloud projects remove-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
   --member="serviceAccount:${PUBSUB_SA}" \
   --role="roles/bigquery.dataEditor"
gcloud projects remove-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
   --member="serviceAccount:${PUBSUB_SA}" \
   --role="roles/bigquery.metadataViewer"
```
