# Demo zu Google Cloud API Gateway

## Schritt 1: Google APIs aktivieren

```shell
gcloud services enable apigateway.googleapis.com
gcloud services enable servicemanagement.googleapis.com
gcloud services enable servicecontrol.googleapis.com
```

## Schritt 2: Function deployen

Deployen Sie die Beispielanwendung mit dem Befehl

```shell
gcloud functions deploy nodejs-http-function --gen2 --runtime=nodejs20 --source=. --entry-point=helloGET --trigger-http --region europe-west1
```

## Schritt 3: API Erstellen

Die API wird mit folgendem Befehl angelegt:

```shell
gcloud api-gateway apis create helloworldapi
```

Informationen über die neue API lassen sich so anzeigen:

```shell
gcloud api-gateway apis describe helloworldapi 
```

## Schritt 4: API Konfigurieren

Erstellen Sie eine OpenAPI v2-Datei mit folgender API-Spezifikation. Denken Sie daran, den GCF-Endpunkt einzutragen, der in Schritt 2 erzeugt wurde.

```yaml
# openapi2-functions.yaml
swagger: '2.0'
info:
  title: myapi optional-string
  description: Sample API on API Gateway with a Google Cloud Functions backend
  version: 1.0.0
schemes:
  - https
produces:
  - application/json
paths:
  /hello:
    get:
      summary: Greet a user
      operationId: hello
      x-google-backend:
        address: https://europe-west1-gfu-s3493-apr-2024.cloudfunctions.net/nodejs-http-function
      responses:
        '200':
          description: A successful response
          schema:
            type: string
```

Erstellen Sie nun die eigentliche API. Für den Backend-Service-Account brauchen wir die Projektnummer, die wir hier mit einem gcloud-Befehl auslesen.
```shell
export PROJECT_NUMBER=$(gcloud projects describe $(gcloud config get-value project) --format="value(projectNumber)")
gcloud api-gateway api-configs create my-config \
  --api=helloworldapi --openapi-spec=api.yaml \
  --backend-auth-service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com
```

## Schritt 5: Gateway bereitstellen

Nachdem nun die Konfiguration bereit ist, können wir das eigentliche Gateway erstellen.

```shell
gcloud api-gateway gateways create my-gateway \
  --api=helloworldapi --api-config=my-config \
  --location=europe-west1
```

Danach lässt sich die URL wie folgt auslesen:

```shell
gcloud api-gateway gateways describe my-gateway --location europe-wes
t1
```
In diesem Fall muss noch `/hello` an das Ende angehängt werden.

Danach können wir uns noch die Konsole anschauen.
