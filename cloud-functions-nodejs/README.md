# Google Cloud Functions mit HTTP-Trigger in Node.js

In dieser Aufgabe werden wir eine Google Cloud Functions-Anwendung bereitstellen, die über einen HTTP-Trigger ausgeführt werden kann.

## Projekt vorbereiten

Für Google Cloud Functions müssen eine Reihe von APIs im GCP-Projekt aktiviert sein. Wechseln Sie als erstes im Browser in das GCP-Projekt, in dem Sie arbeiten möchten.
Rufen Sie dann folgende URL auf:

https://console.cloud.google.com/apis/enableflow?apiid=cloudfunctions.googleapis.com,%20%20%20%20%20cloudbuild.googleapis.com,artifactregistry.googleapis.com,%20%20%20%20%20run.googleapis.com,logging.googleapis.com

Dies wird die benötigten APIs aktivieren.

## Node.js-Projekt anlegen und vorbereiten

Erstellen Sie ein neues Node.js-Projekt.

```shell
mkdir gcf
cd gcf
npm init -y
```

Installieren Sie die notwendigen Abhängigkeiten für Google Cloud Functions.
```shell
npm install --save @google-cloud/functions-framework
```

## Funktion erstellen

Erstellen Sie eine Datei `index.js` mit folgendem Code, um eine einfache HTTP-Funktion bereitzustellen:

```javascript
const functions = require('@google-cloud/functions-framework');
// HTTP-Trigger, um "Hello World" auszugeben
functions.http('helloWorld', (req, res) => {
    res.send('Hello World!');
});
```

Fügen Sie außerdem ein Startskript in Ihre package.json-Datei hinzu, um die Funktion lokal auszuführen:
```json
{
  "name": "gcf",
  "version": "1.0.0",
  "main": "index.js",
  "license": "MIT",
  "scripts": {
    "start": "functions-framework --target=helloWorld"
  },
  "dependencies": {
    "@google-cloud/functions-framework": "^3.1.1"
  }
}
```


## Funktion lokal ausführen

Um zu testen, ob die Funktion korrekt aufgesetzt ist, können Sie im Projektverzeichnis folgenden Befehl ausführen:

```shell
npm start
```

Besuchen Sie in Ihrem Browser http://localhost:8080, um das Ergebnis der Funktion zu sehen. Sie sollten die Nachricht “Hello World!” erhalten.

## Funktion deployen

Um die Funktion in der Google Cloud zu deployen, führen Sie zuletzt folgende Befehle aus. Bitte ersetzen Sie die Projekt-ID passend.

```shell
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
gcloud functions deploy my-nodejs-http-function \
    --gen2 \
    --entry-point=helloWorld \
    --runtime=nodejs18 \
    --region=europe-west1 \
    --source=. \
    --trigger-http \
    --allow-unauthenticated
```


Wenn Sie dabei Fehler erhalten, stellen Sie sicher, dass alle notwendigen APIs aktiviert wurden, und versuchen Sie es erneut.

Wenn die Funktion erfolgreich deployt wurde, erhalten Sie die folgende Ausgabe:
```
state: ACTIVE
updateTime: '2024-07-03T13:41:15.155204213Z'
url: https://europe-west1-my-project.cloudfunctions.net/my-nodejs-http-function
```

Rufen Sie die angegebene URL im Browser auf, um das Ergebnis zu prüfen. Sie sollten “Hello World!” sehen.
