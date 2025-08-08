# Videogenerierung mit Vertex AI

In dieser Übungsaufgabe werden Sie ein Python-Skript erstellen, welches mit dem Veo 3-Modell von Vertex AI beliebige Videos generieren kann.

## Skript erstellen

Erstellen Sie eine neue Datei namens `veo.py` und kopieren Sie folgenden Inhalt in die Datei.

```python
import time
from google import genai
from google.genai import types

client = genai.Client(
    project="<<YOUR PROJECT ID>>",
    location="us-central1",
    vertexai=True
)

prompt = """Ein sonniger Tag in Köln."""

operation = client.models.generate_videos(
    model="veo-3.0-generate-preview",
    prompt=prompt,
)

# Poll the operation status until the video is ready.
while not operation.done:
    print("Waiting for video generation to complete...")
    time.sleep(10)
    operation = client.operations.get(operation)

# Write the generated video
generated_video = operation.response.generated_videos[0]

with open("generated_video.mp4", "wb") as f:
    f.write(generated_video.video.video_bytes)
```

> [!important]
> Ersetzen Sie die Projekt-ID im Skript! Den Prompt können Sie außerdem beliebig anpassen.

## Skript ausführen

Führen Sie nun das Skript aus in dem Verzeichnis, in dem sich die Skript-Datei befindet

```bash
python3 veo.py
```

## Video herunterladen und abspielen

Das Skript legt das neue Video unter dem Namen `generated_video.mp4` ab. Sie können es runterladen, indem sie im Cloud Shell Editor rechts auf die Datei und dann auf "Download" klicken.
