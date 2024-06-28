# Appengine Demo Application

In dieser Demo erarbeiten wir eine Python-Anwendung, die AppEngine und seine Integration in andere Google-Services demonstriert.

## Schritt 1: Einfache Anwendung ohne Zusatzdienste

Diese Anwendung kann sofort auf AppEngine im Standard environment installiert werden.
Dazu einfach im [step01](./step01)-Verzeichnis `gcloud app deploy` aufrufen.

## Schritt 2: Persistente Daten mit Cloud Datastore

In diesem Verzeichnis wurde die Anwendung erweitert um eine Anbindung an Cloud Datastore, um die Seitenaufrufe persistent zu speichern.
Die Änderungen im Einzelnen:
---
neu in [main.py](step02/main.py)
```python
from google.cloud import datastore

datastore_client = datastore.Client()


def store_time(dt):
    entity = datastore.Entity(key=datastore_client.key("visit"))
    entity.update({"timestamp": dt})

    datastore_client.put(entity)


def fetch_times(limit):
    query = datastore_client.query(kind="visit")
    query.order = ["-timestamp"]

    times = query.fetch(limit=limit)

    return times
```
---
geändert in [main.py](step02/main.py)
```python
@app.route("/")
def root():
    # Store the current access time in Datastore.
    store_time(datetime.datetime.now(tz=datetime.timezone.utc))

    # Fetch the most recent 10 access times from Datastore.
    times = fetch_times(10)

    return render_template("index.html", times=times)
```
---
geändert in [index.html](step02/templates/index.html)
```html
<h2>Last 10 visits</h2>
{% for time in times %}
  <p>{{ time['timestamp'] }}</p>
{% endfor %}
```
---
geändert in [requirements.txt](./step02/requirements.txt)
```txt
Flask==3.0.0
google-cloud-datastore==2.15.1
```
---
Anschließend die Anwendung mit `gcloud app deploy` aktualisieren.
