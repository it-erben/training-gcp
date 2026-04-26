# 08 - Cloud Logging-Demo

Dieses Beispiel dient dazu, Logging-Daten in Cloud Logs zu erzeugen.

> **Material:** Die Quelldateien für diese Übung finden Sie im Material-ZIP
> unter `cloud-logging/` ([Material herunterladen](../../material/)).

Entpacken Sie das Material-ZIP und wechseln Sie in das Verzeichnis
`cloud-logging/`. Deployen Sie dann die Beispielanwendung:

```shell
gcloud functions deploy logging-example-http-function \
  --gen2 \
  --runtime=nodejs20 \
  --source=. \
  --entry-point=helloGET \
  --trigger-http \
  --region europe-west1
```
