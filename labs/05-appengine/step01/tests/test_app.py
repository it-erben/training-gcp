import datetime

from main import app


def test_root_renders_dummy_times():
    client = app.test_client()
    response = client.get("/")

    assert response.status_code == 200
    body = response.data.decode("utf-8")

    assert "Last 10 visits" in body
    assert str(datetime.datetime(2018, 1, 1, 10, 0, 0)) in body
