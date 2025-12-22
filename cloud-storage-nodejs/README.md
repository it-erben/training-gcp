# Google Cloud Storage SDK in Node.js

In dieser Übungsaufgabe werden Sie ein Node.js-CLI-Tool entwickeln, das eine
Datei in einen Google Cloud Storage-Bucket hochlädt. Es wird vorausgesetzt,
dass bereits ein GCP-Projekt mit einem Google Cloud Storage-Bucket vorhanden
ist.

## Schritt 1: Projekt-Setup

Erstellen Sie ein neues Node.js-Projekt.

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

Erstellen Sie eine neue Datei gcsUploader.js im Projektverzeichnis.
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
    console.log('Usage: node gcsUploader.js <file-path> <bucket-name>');
    process.exit(1);
}

const filePath = process.argv[2];
const bucketName = process.argv[3];

uploadFile(filePath, bucketName).catch(console.error);
```

## Schritt 4: Ausführung des Tools

Führen Sie das Tool aus, indem Sie das Node.js-Skript ausführen und die Datei
sowie den Bucket-Namen als Argumente übergeben.

```shell
node gcsUploader.js /path/to/your/file.txt your-bucket-name
```
