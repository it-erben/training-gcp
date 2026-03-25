import os

import pytest

if "FIRESTORE_EMULATOR_HOST" not in os.environ:
    pytest.skip("Firestore emulator is not configured", allow_module_level=True)

os.environ.setdefault("GOOGLE_CLOUD_PROJECT", "demo-project")

from main import app, fetch_times, firestore_client  # noqa: E402


def clear_visits():
    for doc in firestore_client.collection("visits").stream():
        doc.reference.delete()


def test_root_stores_and_renders():
    clear_visits()

    client = app.test_client()
    response = client.get("/")

    assert response.status_code == 200
    body = response.data.decode("utf-8")
    assert "Last 10 visits" in body

    times = fetch_times(1)
    assert times
    assert "timestamp" in times[0]
