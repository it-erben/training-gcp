# 05 - AppEngine Demo Application

In dieser Demo erarbeiten wir eine Python-Anwendung, die AppEngine und seine
Integration in andere Google-Services demonstriert. Unsere Beispielanwendung
wird alle Seitenaufrufe aufzeichnen und in einer HTML-Seite anzeigen.

> **Material:** Die Quelldateien für diese Übung finden Sie im Material-ZIP
> unter `appengine/` ([Material herunterladen](../../material/)).

## Schritt 1: Einfache Anwendung ohne Zusatzdienste

Diese Anwendung kann sofort auf AppEngine im Standard environment installiert
werden.
Sie zeigt nur Dummy-Daten an und dient als Ausgangspunkt.

Dazu einfach im [step01](./step01)-Verzeichnis `gcloud app deploy` aufrufen.
Wenn Sie aufgefordert werden, eine Region zu wählen, dann empfiehlt sich
`europe-west`.

Erläuterungen zur Anwendung:

- [main.py](./step01/main.py) enthält eine eine Dummy-Anwendung, die Daten für
  die HTML-Templates erzeugt
- [static](./step01/templates/index.html) ist ein Flask-Template, welches die in
  Python generierten Daten rendert
- [static](./step01/static) enthält einige für die HTML-Seite notwendigen Assets
- [app.yaml](./step01/app.yaml) konfiguriert die AppEngine-Anwendung –
  insbesondere die Runtime und die Pfade
- [requirements.txt](./step01/requirements.txt) definiert die für Python
  notwendigen Abhängigkeiten

## Schritt 2: Persistente Daten mit Cloud Datastore

In diesem Verzeichnis wurde die Anwendung erweitert um eine Anbindung an Cloud
Datastore, um die Seitenaufrufe persistent zu speichern.
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
firebase-admin==6.5.0
```

---

Anschließend die Anwendung mit `gcloud app deploy` aktualisieren.

In dieser Version ist die Anwendung nun fähig, alle Seitenaufrufe in einer
Cloud-Datenbank aufzuzeichnen und danach anzuzeigen.
