# 09 - Cloud Storage SDK in Node.js

In dieser Übungsaufgabe werden Sie ein Node.js-CLI-Tool entwickeln, das eine
Datei in einen Google Cloud Storage-Bucket hochlädt. Es wird vorausgesetzt,
dass bereits ein GCP-Projekt mit einem Google Cloud Storage-Bucket vorhanden
ist.

## Schritt 1: Vorbereitungen

Öffnen Sie die Cloud Shell.

Erstellen Sie einen neuen Google Cloud Storage Bucket. Der Name des Buckets
muss weltweit eindeutig sein.

```sh
export BUCKET_NAME="mybucket-gfu-$RANDOM"
gcloud storage buckets create gs://$BUCKET_NAME
```

Erstellen Sie ein neues Node.js-Projekt in einem neuen Verzeichnis namens `gcs-uploader`.

```shell
mkdir gcs-uploader
cd gcs-uploader
npm init -y
```

## Schritt 2: Abhängigkeiten hinzufügen

Installieren Sie die notwendigen Abhängigkeiten für Google Cloud Storage.

```shell
npm install --save @google-cloud/storage
```

## Schritt 3: CLI-Skript erstellen

Erstellen Sie eine neue Datei `index.js` im Verzeichnis `gcs-uploader`.
Fügen Sie den folgenden Code in die Datei ein:

```javascript
const { Storage } = require('@google-cloud/storage');
const path = require('path');
const fs = require('fs');

async function uploadFile(filePath, bucketName) {
    const storage = new Storage();
    const bucket = storage.bucket(bucketName);
    const fileName = path.basename(filePath);

    await bucket.upload(filePath, {
        destination: fileName,
    });

    console.log(`File ${filePath} uploaded to bucket ${bucketName}`);
}

if (process.argv.length < 4) {
    console.log('Usage: node index.js <file-path> <bucket-name>');
    process.exit(1);
}

const filePath = process.argv[2];
const bucketName = process.argv[3];

uploadFile(filePath, bucketName).catch(console.error);
```

## Schritt 4: Ausführung des Tools

Führen Sie das Tool aus, indem Sie das Node.js-Skript ausführen
und eine neu angelegte Datei sowie den Bucket-Namen als Argumente
übergeben.

```shell
cd ~/gcs-uploader
echo "Dies ist eine Testdatei." > testfile.txt
node index.js testfile.txt $BUCKET_NAME
```
