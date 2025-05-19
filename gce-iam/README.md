# Aufgabe für GCP-Kurs: GCS-Bucket, Service Account und Compute VM mit der CLI erstellen

In dieser Aufgabe üben Sie den Umgang mit der `gcloud`-CLI für Google Compute Engine, IAM und Google Cloud Storage.

## Erstellen eines GCS-Buckets

Erstellen Sie einen neuen Google Cloud Storage Bucket. Der Name des Buckets muss weltweit eindeutig sein.

```sh
export BUCKET_NAME="mybucket-gfu-$RANDOM"
gsutil mb gs://$BUCKET_NAME
```

## Erstellen eines Service Accounts

Erstellen Sie einen neuen Service Account mit einem aussagekräftigen Namen.
Damit Sie in den folgenden Schritten immer den richtigen Projektnamen nutzen, sollten Sie ihn in einer Variable speichern. Bitte denken Sie daran, den richtigen Projektnamen einzutragen!

```sh
export PROJECT_ID="IHRE_PROJEKT_ID"
```

Danach können Sie den Account anlegen
```sh
gcloud iam service-accounts create gce-gcs-service-account \
   --description="Service account for accessing GCS" \
   --display-name="My Service Account"
```

## Zuweisen der Vollrechte auf GCS zum Service Account

Weisen Sie dem neu erstellten Service Account die Rolle `roles/storage.admin` zu, um ihm Vollzugriff auf Google Cloud Storage im aktuellen Projekt zu geben.
Sollten Sie im vorherigen Schritt einen anderen Namen für den Service Account als `gce-gcs-service-account` gewählt haben, müssen Sie den Befehl entsprechend anpassen:
```sh
gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member="serviceAccount:gce-gcs-service-account@${PROJECT_ID}.iam.gserviceaccount.com" \
   --role="roles/storage.admin"
```

## Erstellen einer Compute Engine VM

Erstellen Sie eine neue Compute Engine VM, die den Service Account verwendet. Denken Sie daran, die Projekt-ID richtig zu setzen.

```sh
gcloud compute instances create my-vm \
   --zone=europe-west1-b \
   --machine-type=f1-micro \
   --service-account=gce-gcs-service-account@${PROJECT_ID}.iam.gserviceaccount.com \
   --scopes=https://www.googleapis.com/auth/cloud-platform
   ```

## Verbinden per SSH

Um nun einen Test durchführen zu können, verbinden wir uns per SSH mit der VM:
```shell
gcloud compute ssh my-vm --zone=europe-west1-b
```

## Mit GCS verbinden

Zuletzt listen wir alle Buckets auf um zu testen, dass die Instanz Vollberechtigung auf Google Cloud Storage hat.

```shell
gsutil ls
```

## Aufräumen

Verlassen Sie die SSH-Sitzung in my-vm mit `exit`. Führen Sie folgende Befehle aus, um die Umgebung aufzuräumen.

```shell
gcloud compute instances delete my-vm --zone=europe-west1-b --quiet
gsutil rm -r gs://$BUCKET_NAME
gcloud iam service-accounts delete gce-gcs-service-account@${PROJECT_ID}.iam.gserviceaccount.com --quiet
```

