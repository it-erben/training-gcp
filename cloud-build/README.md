# Build und Deployment einer Container-App mit Google Cloud Build

Mit dieser Anleitung lernst du, wie man eine einfache Python-Anwendung per Docker containerisiert, mit Google Cloud Build automatisiert baut und anschließend das Image in der Artifact Registry ablegt.

## Artefakt-Repository anlegen

Aktiviere die notwendigen APIs und speichere dir für später die aktuelle Projekt-ID in eine Variable:
```bash
gcloud services enable \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  run.googleapis.com

export PROJECT_ID=$(gcloud config get-value project)
```

Lege nun ein Artefakt-Repository an, in das die Docker-Images hochgeladen werden können.
```bash
gcloud artifacts repositories create my-python-repo \
  --repository-format=docker \
  --location=europe-west1 \
  --description="Repo für Python Test-App"
```

## Anwendung erstellen

Lege nun ein Verzeichnis für das Projekt an und wechsle in das Verzeichnis.

```bash
mkdir cloudbuild-demo
cd cloudbuild-demo
```

Erstelle eine Datei namens `app.py` mit folgendem Inhalt.
Es handelt sich um eine einfache Python-Flask-Webanwendung.

```python
from flask import Flask

app = Flask(__name__)

@app.route("/") # <-- Diese Zeile fehlt!
def hello():
    return "Hello from Google Cloud Build!", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
```

Lege eine `requirements.txt` mit folgendem Inhalt an:

```text
Flask==3.0.0
```

## Image bauen

Um das Image zu bauen, brauchen wir eine `Dockerfile`. Lege sie mit folgenden Inhalt an:

```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8080
CMD ["python", "app.py"]
```

Du kannst nun mit dem Befehl `docker build .` testen, ob deine Dockerfile korrekt ist. Der Befehl sollte erfolgreich ein Image bauen können.

## cloudbuild.yaml anlegen

Lege eine Datei `cloudbuild.yaml` mit folgenden Inhalt an:

```yaml
steps:
  - name: "gcr.io/cloud-builders/docker"
    args: [ "build", "-t", "europe-west1-docker.pkg.dev/$PROJECT_ID/my-python-repo/python-demo:latest", "." ]

  - name: "gcr.io/cloud-builders/docker"
    args: [ "push","europe-west1-docker.pkg.dev/$PROJECT_ID/my-python-repo/python-demo:latest" ]

images: [ "europe-west1-docker.pkg.dev/$PROJECT_ID/my-python-repo/python-demo:latest" ]
```

Übermittle dann den Build-Auftrag an GCP mit folgendem Kommando:

```bash
gcloud builds submit . --config=cloudbuild.yaml
```

## Anwendung in Cloud Run deployen

Zuletzt können wir die Anwendung in Cloud Run deployen, um sie zu testen:

```bash
gcloud run deploy python-demo \
  --image=europe-west1-docker.pkg.dev/$PROJECT_ID/my-python-repo/python-demo:latest \
  --platform=managed --region=europe-west1 --allow-unauthenticated
```

