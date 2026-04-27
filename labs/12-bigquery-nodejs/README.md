# 12 - BigQuery SDK in Node.js

In dieser Übungsaufgabe entwickeln Sie ein Node.js-CLI-Tool, das eine CSV-Datei
in eine bereits existierende Google BigQuery-Tabelle lädt. Es wird davon
ausgegangen, dass bereits ein GCP-Projekt vorhanden ist.

## Voraussetzungen

Stellen Sie sicher, dass Sie die Google Cloud SDK installiert haben und sich
authentifiziert haben:

```shell
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

Aktivieren Sie die benötigten APIs:

```shell
gcloud services enable bigquery.googleapis.com bigquerystorage.googleapis.com storage.googleapis.com
```

Erstellen Sie Application Default Credentials, damit das Node.js-SDK sich
authentifizieren kann:

```shell
gcloud auth application-default login
```

## Storage Bucket, Dataset und Tabelle erstellen

Erstellen Sie ein Dataset mit dem Namen spotify:

```shell
bq --location=EU mk -d spotify
```

Erstellen Sie eine Tabelle `tracks` im Dataset `spotify`:

```shell
bq mk --table spotify.tracks \
  id:STRING,name:STRING,genre:STRING,artists:STRING,album:STRING, \
  popularity:INTEGER,duration:INTEGER,explicit:STRING
```

Erstellen Sie einen GCS-Bucket für diese Aufgabe. Sie können einen beliebigen
Bucket-Name wählen – Sie brauchen den Namen aber später.
Das folgende Skript wird einen zufälligen Namen erzeugen und in einer
Shell-Variable namens `BUCKET_NAME` speichern. Sofern Sie in der gleichen
Shell-Sitzung weiterarbeiten, wird die Variable weiter zur Verfügung stehen.

```shell
BUCKET_SUFFIX=$(LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 10)
export BUCKET_NAME="bucket-${BUCKET_SUFFIX}"
echo "Using bucket name ${BUCKET_NAME}"
gsutil mb -l EU gs://${BUCKET_NAME}
```

Kopieren Sie die CSV mit Beispieldaten in den neuen Bucket. Die Datei
finden Sie [hier](../../material/bigquery/spotify.csv)

```shell
gsutil cp spotify.csv gs://${BUCKET_NAME}/spotify.csv
```

## Projekt-Setup

Erstellen Sie ein neues Node.js-Projekt:

```shell
mkdir bq-uploader
cd bq-uploader
npm init -y
```

## Abhängigkeiten hinzufügen

Installieren Sie die Google Cloud BigQuery und Storage SDKs:

```shell
npm install --save @google-cloud/bigquery @google-cloud/storage
```

## CLI-Skript erstellen

Erstellen Sie eine Datei `bqUploader.js` im Projektverzeichnis mit folgendem
Inhalt:

```javascript
const { BigQuery } = require('@google-cloud/bigquery');
const { Storage } = require('@google-cloud/storage');

async function uploadCsvToBigQuery(bucketName, filename) {
    const bigQuery = new BigQuery();
    const storage = new Storage();

    const datasetId = 'spotify';
    const tableId = 'tracks';

    const metadata = {
        sourceFormat: 'CSV',
        skipLeadingRows: 1,
    };

    // Job-Konfiguration für das Hochladen der CSV-Datei
    const [job] = await bigQuery
        .dataset(datasetId)
        .table(tableId)
        .load(storage.bucket(bucketName).file(filename), metadata);

    console.log(`Job ${job.id} gestartet.`);

    // Überprüfen, ob der Job abgeschlossen wurde
    const jobStatus = job.status;
    if (jobStatus.state === 'DONE') {
        console.log('CSV-Datei erfolgreich nach BigQuery geladen.');
    } else {
        console.error(`Fehler beim Laden der Datei: ${jobStatus.errorResult.message}`);
    }
}

if (process.argv.length < 4) {
    console.log('Usage: node bqUploader.js <bucket> <filename>');
    process.exit(1);
}

const bucket = process.argv[2];
const filename = process.argv[3];
uploadCsvToBigQuery(bucket, filename).catch(console.error);
```

## Ausführung des Tools

Führen Sie das Tool aus, indem Sie das Node.js-Skript mit der CSV-Datei als
Argument aufrufen:

```shell
node bqUploader.js ${BUCKET_NAME} spotify.csv
```

## SQL-Abfragen gegen BigQuery ausführen

Führen Sie einige Beispiel-Queries mit dem bq-CLI aus:

```shell
bq query 'SELECT * FROM spotify.tracks LIMIT 10'
bq query --format json 'SELECT * FROM spotify.tracks LIMIT 5'
bq query 'SELECT genre, COUNT(genre) FROM spotify.tracks GROUP BY genre'
bq query 'SELECT album, popularity FROM spotify.tracks ORDER BY popularity' \
  'DESC LIMIT 20'
```
