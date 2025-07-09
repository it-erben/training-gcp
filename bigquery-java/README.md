
# Google BigQuery SDK in Java

## Ziel
In dieser Übungsaufgabe werden Sie ein Java-CLI-Tool entwickeln, das eine CSV-Datei in eine bereits existierende Google BigQuery-Tabelle lädt. Das Projekt wird als Maven-Projekt aufgebaut.

Es wird vorausgesetzt, dass bereits ein GCP-Projekt vorhanden ist.

## Schritt 0: Storage Bucket, Dataset und Tabelle erstellen

Erstellen Sie ein Dataset mit dem Namen `spotify`:

```sh
bq --location=EU mk -d spotify
```

Erstellen Sie eine Tabelle `tracks` im Dataset `spotify`:

```sh
bq mk --table spotify.tracks \
id:STRING,name:STRING,genre:STRING,artists:STRING,album:STRING,popularity:INTEGER,duration:INTEGER,explicit:STRING
```

Erstellen Sie nun einen GCS-Bucket für diese Aufgabe. Sie können einen beliebigen Bucket-Name wählen – Sie brauchen den Namen aber später.

```shell
gsutil mb -l EU gs://YOUR_BUCKET_NAME
```

Kopieren Sie die CSV mit Beispieldaten aus diesem Verzeichnis in den neuen Bucket:

```shell
gsutil cp spotify.csv gs://YOUR_BUCKET_NAME/spotify.csv
```


## Schritt 1: Projekt-Setup
Erstellen Sie ein neues Maven-Projekt.

```sh
mvn archetype:generate -DgroupId=com.example -DartifactId=bq-uploader -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
cd bq-uploader
```

## Schritt 2: Abhängigkeiten hinzufügen
Öffnen Sie die `pom.xml`-Datei und fügen Sie die notwendigen Abhängigkeiten für Google BigQuery hinzu.

```xml
<dependencies>
    <dependency>
        <groupId>com.google.cloud</groupId>
        <artifactId>google-cloud-bigquery</artifactId>
        <version>2.40.3</version>
    </dependency>
</dependencies>
```

## Schritt 3: Ergänzung des Manifests in `pom.xml`
Um sicherzustellen, dass die Main-Class im Manifest des JAR-Files enthalten ist, müssen wir das `pom.xml`-File anpassen.

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <version>3.2.0</version>
            <configuration>
                <archive>
                    <manifest>
                        <mainClass>com.example.BqUploader</mainClass>
                    </manifest>
                </archive>
            </configuration>
        </plugin>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-assembly-plugin</artifactId>
            <version>3.3.0</version>
            <configuration>
                <archive>
                    <manifest>
                        <mainClass>com.example.BqUploader</mainClass>
                    </manifest>
                </archive>
                <descriptorRefs>
                    <descriptorRef>jar-with-dependencies</descriptorRef>
                </descriptorRefs>
            </configuration>
            <executions>
                <execution>
                    <id>make-assembly</id>
                    <phase>package</phase>
                    <goals>
                        <goal>single</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

## Schritt 4: Java-Klasse erstellen
Entfernen Sie das `src/test`-Verzeichnis sowie die Datei `App.java` im Verzeichnis `src/main/java/com/example`.

Erstellen Sie eine neue Java-Klasse `BqUploader` unter `src/main/java/com/example`.

```java
package com.example;

import com.google.cloud.bigquery.BigQuery;
import com.google.cloud.bigquery.BigQueryOptions;
import com.google.cloud.bigquery.FormatOptions;
import com.google.cloud.bigquery.Job;
import com.google.cloud.bigquery.JobInfo;
import com.google.cloud.bigquery.LoadJobConfiguration;
import com.google.cloud.bigquery.TableId;
import com.google.cloud.bigquery.JobId;

import java.util.UUID;

public class BqUploader {
    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: java -jar bq-uploader.jar <gs-file>");
            System.exit(1);
        }

        String gsFile = args[0];

        try {
            uploadCsvToBigQuery(gsFile);
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public static void uploadCsvToBigQuery(String gsFile) throws Exception {
        BigQuery bigQuery = BigQueryOptions.getDefaultInstance().getService();
        TableId tableId = TableId.of( "spotify", "tracks");

        LoadJobConfiguration loadConfig = LoadJobConfiguration.newBuilder(
                tableId,
                gsFile,
                FormatOptions.csv().toBuilder().setSkipLeadingRows(1).build())
            .build();

        Job job = bigQuery.create(JobInfo.newBuilder(loadConfig).setJobId(JobId.of(UUID.randomUUID().toString())).build());
        
        job = job.waitFor();
        
        if (job.isDone()) {
            System.out.println("CSV file successfully loaded to BigQuery");
        } else {
            System.out.println("BigQuery was unable to load the CSV file: \n" + job.getStatus().getError());
        }
    }
}

```

## Schritt 5: Erstellung des Fat JARs
Kompilieren und erstellen Sie das Fat JAR-File.

```sh
mvn clean package
```

Das Fat JAR-File befindet sich im `target`-Verzeichnis und heißt `bq-uploader-1.0-SNAPSHOT-jar-with-dependencies.jar`.

## Schritt 6: Ausführung des Tools
Führen Sie das Tool aus, indem Sie das Fat JAR-File ausführen und die CSV-Datei sowie die Projekt- und Tabellendetails als Argumente übergeben.
Der Pfad zur Datei muss eine Google Cloud Storage-URI sein.

```sh
java -jar target/bq-uploader-1.0-SNAPSHOT-jar-with-dependencies.jar gs://YOUR_BUCKET_NAME/spotify.csv
```

## Schritt 7: SQL-Abfrage gegen BigQuery ausführen

Führen Sie einige Beispiel-Queries mit dem bq-CLI aus:

```shell
bq query 'SELECT * FROM spotify.tracks LIMIT 10'
bq query --format json 'SELECT * FROM spotify.tracks LIMIT 5'
bq query 'SELECT genre, COUNT(genre) FROM spotify.tracks GROUP BY genre'
bq query 'SELECT album, popularity FROM spotify.tracks ORDER BY popularity DESC LIMIT 20'
```
