# 08 - Cloud Logging-Demo

Dieses Beispiel dient dazu, Logging-Daten in Cloud Logs zu erzeugen.

**Material:** Die Quelldateien für diese Übung finden Sie [hier](../../material/cloud-logging).

Kopieren Sie sie in einen Ordner auf Ihrem Rechner oder in Cloud Shell.

Führen Sie dann folgenden Befehl aus:

```shell
gcloud functions deploy logging-example-http-function \
  --gen2 \
  --runtime=nodejs24 \
  --source=. \
  --entry-point=helloGET \
  --trigger-http \
  --region europe-west1
```
