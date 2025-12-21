import datetime
import os

import firebase_admin
from firebase_admin import firestore
from flask import Flask, render_template
from google.auth.credentials import AnonymousCredentials


def init_firestore_client():
    if not firebase_admin._apps:
        if os.getenv("FIRESTORE_EMULATOR_HOST"):
            firebase_admin.initialize_app(
                credential=AnonymousCredentials(),
                options={"projectId": os.getenv("GOOGLE_CLOUD_PROJECT", "demo-project")},
            )
        else:
            firebase_admin.initialize_app()

    return firestore.client()


firestore_client = init_firestore_client()

app = Flask(__name__)

@app.route("/")
def root():
    # Store the current access time in Firestore.
    store_time(datetime.datetime.now(tz=datetime.timezone.utc))

    # Fetch the most recent 10 access times from Firestore.
    times = fetch_times(10)

    return render_template("index.html", times=times)


def store_time(dt):
    doc_ref = firestore_client.collection("visits").document()
    doc_ref.set({"timestamp": dt})


def fetch_times(limit):
    visits_ref = (
        firestore_client.collection("visits")
        .order_by("timestamp", direction=firestore.Query.DESCENDING)
        .limit(limit)
    )
    times = [doc.to_dict() for doc in visits_ref.stream()]

    return times


if __name__ == "__main__":
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    # Flask's development server will automatically serve static files in
    # the "static" directory. See:
    # http://flask.pocoo.org/docs/1.0/quickstart/#static-files. Once deployed,
    # App Engine itself will serve those files as configured in app.yaml.
    app.run(host="127.0.0.1", port=8080, debug=True)
