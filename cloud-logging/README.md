# Umgebung für Google Cloud Logging-Demo

Dieses Beispiel dient dazu, Logging-Daten in Cloud Logs zu erzeugen.

```shell
gcloud functions deploy logging-example-http-function \
  --gen2 \
  --runtime=nodejs20 \
  --source=. \
  --entry-point=helloGET \
  --trigger-http \
  --region europe-west1
```
