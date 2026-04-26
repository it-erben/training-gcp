# 06 - Cloud Run Functions mit HTTP-Trigger in Node.js

In dieser Aufgabe werden wir eine Google Cloud Run Functions-Anwendung
bereitstellen, die über einen HTTP-Trigger ausgeführt werden kann.

## Projekt vorbereiten

Für Google Cloud Run Functions müssen eine Reihe von APIs im GCP-Projekt aktiviert
sein. Wechseln Sie als erstes im Browser in das GCP-Projekt, in dem Sie arbeiten
möchten.
Rufen Sie dann die API-Bibliothek auf:

<https://console.cloud.google.com/apis/library>

Aktivieren Sie dort die folgenden APIs:

- Cloud Functions API
- Cloud Build API
- Artifact Registry API
- Cloud Run API
- Cloud Logging API

## Node.js-Projekt anlegen und vorbereiten

Wechseln Sie in den Cloud Shell Editor.
Erstellen Sie ein neues Node.js-Projekt.

```shell
mkdir gcf
cd gcf
npm init -y
```

Installieren Sie die notwendigen Abhängigkeiten für Google Cloud Run Functions.

```shell
npm install --save @google-cloud/functions-framework
```

## Funktion erstellen

Erstellen Sie im Verzeichnis `gcf` eine Datei `index.js` mit folgendem
Code, um eine einfache HTTP-Funktion bereitzustellen:

```javascript
const functions = require('@google-cloud/functions-framework');
// HTTP-Trigger, um "Hello World" auszugeben
functions.http('helloWorld', (req, res) => {
    res.send('Hello World!');
});
```

Fügen Sie außerdem ein Startskript in Ihre `package.json`-Datei hinzu, um die
Funktion lokal auszuführen:

```json
{
    "scripts": {
        "start": "functions-framework --target=helloWorld"
    }
}
```

## Funktion lokal ausführen

Um zu testen, ob die Funktion korrekt aufgesetzt ist, können Sie im
Projektverzeichnis folgenden Befehl ausführen:

```shell
npm install && npm start
```

In der Terminal-Ausgabe erscheint nun folgende Meldung:

```text
Serving function...
Function: helloWorld
Signature type: http
URL: http://localhost:8080/
```

Wenn Sie auf die URL klicken, öffnet die Cloud Console automatisch einen
neuen Browser-Tab, in dem die Funktion aufgerufen wird.

Drücken Sie in der Terminal-Ausgabe STRG+C, um den Server zu beenden.

## Funktion deployen

Um die Funktion in der Google Cloud zu deployen, führen Sie zuletzt folgende
Befehle aus.

```shell
gcloud functions deploy my-nodejs-http-function \
    --gen2 \
    --entry-point=helloWorld \
    --runtime=nodejs24 \
    --region=europe-west1 \
    --source=. \
    --trigger-http \
    --allow-unauthenticated
```

Wenn Sie dabei Fehler erhalten, stellen Sie sicher, dass alle notwendigen APIs
aktiviert wurden, und versuchen Sie es erneut.

Wenn die Funktion erfolgreich deployt wurde, erhalten Sie die folgende Ausgabe:

```text
state: ACTIVE
updateTime: '2024-07-03T13:41:15.155204213Z'
url: https://europe-west1-my-project.cloudfunctions.net/my-nodejs-http-function
```

Rufen Sie die angegebene URL im Browser auf, um das Ergebnis zu prüfen. Sie
sollten “Hello World!” sehen.
