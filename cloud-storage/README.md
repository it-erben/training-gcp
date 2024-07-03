# Google Cloud Storage SDK in Java

In dieser Übungsaufgabe werden Sie ein Java-CLI-Tool entwickeln, das eine Datei in einen Google Cloud Storage Bucket hochlädt. Das Projekt wird als Maven-Projekt aufgebaut.

Es wird vorausgesetzt, dass bereits ein GCP-Projekt mit einem Google Cloud Storage-Bucket vorhanden ist.

## Schritt 1: Projekt-Setup
Erstellen Sie ein neues Maven-Projekt.
```sh
mvn archetype:generate -DgroupId=com.example -DartifactId=gcs-uploader -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
cd gcs-uploader
```

## Schritt 2: Abhängigkeiten hinzufügen
Öffnen Sie die `pom.xml`-Datei und fügen Sie die notwendigen Abhängigkeiten für Google Cloud Storage hinzu.

```xml
<dependencies>
   <dependency>
       <groupId>com.google.cloud</groupId>
       <artifactId>google-cloud-storage</artifactId>
       <version>2.1.9</version>
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
                       <mainClass>com.example.GcsUploader</mainClass>
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
                       <mainClass>com.example.GcsUploader</mainClass>
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
Erstellen Sie eine neue Java-Klasse `GcsUploader` unter `src/main/java/com/example`.

   ```java
   package com.example;

   import com.google.cloud.storage.BlobInfo;
   import com.google.cloud.storage.Storage;
   import com.google.cloud.storage.StorageOptions;

   import java.io.File;
   import java.io.IOException;
   import java.nio.file.Files;
   import java.nio.file.Paths;

   public class GcsUploader {
       public static void main(String[] args) throws IOException {
           if (args.length < 2) {
               System.out.println("Usage: java -jar gcs-uploader.jar <file-path> <bucket-name>");
               System.exit(1);
           }

           String filePath = args[0];
           String bucketName = args[1];

           uploadFile(filePath, bucketName);
       }

       public static void uploadFile(String filePath, String bucketName) throws IOException {
           Storage storage = StorageOptions.getDefaultInstance().getService();

           File file = new File(filePath);
           BlobInfo blobInfo = BlobInfo.newBuilder(bucketName, file.getName()).build();

           storage.create(blobInfo, Files.readAllBytes(Paths.get(filePath)));

           System.out.println("File " + filePath + " uploaded to bucket " + bucketName);
       }
   }
   ```

## Schritt 5: Google Cloud SDK Konfiguration:**
Stellen Sie sicher, dass Sie die Google Cloud SDK installiert haben und sich authentifiziert haben:

```sh
gcloud auth login
# gegebenenfalls noch: gcloud config set project YOUR_PROJECT_ID
```

## Schritt 6: Erstellung des Fat JARs
Kompilieren und erstellen Sie das Fat JAR-File.

```sh
mvn clean package
```

Das Fat JAR-File befindet sich im `target`-Verzeichnis und heißt `gcs-uploader-1.0-SNAPSHOT-jar-with-dependencies.jar`.

## Schritt 7: Ausführung des Tools
Führen Sie das Tool aus, indem Sie das Fat JAR-File ausführen und die Datei und den Bucket-Namen als Argumente übergeben.

```sh
java -jar target/gcs-uploader-1.0-SNAPSHOT-jar-with-dependencies.jar /path/to/your/file.txt your-bucket-name
```
