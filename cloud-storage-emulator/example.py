# This script shows how to run and use the Google Cloud Storage emulator provided on https://github.com/fsouza/fake-gcs-server
# 1 - Start the emulator docker container: "docker run -d --name fake-gcs-server -p 4443:4443 fsouza/fake-gcs-server -scheme http"
# 2 - Install requirements: "pip install -r requirements.txt"
# 3 - Run this script

import os
import random
import string

from google.auth.credentials import AnonymousCredentials
from google.cloud import storage

NUM_BUCKETS = 3
FILES_PER_BUCKET = 3

# This environment variable will point the Google Cloud Storage SDK to the emulator
os.environ.setdefault("STORAGE_EMULATOR_HOST", "http://localhost:4443")

client = storage.Client(
    credentials=AnonymousCredentials(),
    project="test",
)


# Generate a random string for bucket and file names
def random_name(prefix, length=8):
    return prefix + "-" + "".join(
        random.choices(string.ascii_lowercase + string.digits, k=length)
    )


# Generate random file content
def random_content(size=100):
    return os.urandom(size)


if __name__ == "__main__":
    for _ in range(NUM_BUCKETS):
        bucket_name = random_name("demo-bucket")
        bucket = client.bucket(bucket_name)
        bucket.storage_class = "STANDARD"
        bucket = client.create_bucket(bucket, location="US")
        print(f"Created bucket {bucket.name}")

        for i in range(FILES_PER_BUCKET):
            blob_name = random_name(f"file{i}", length=5) + ".txt"
            blob = bucket.blob(blob_name)
            content = random_content(50)
            blob.upload_from_string(content)
            print(f"  Uploaded {blob_name} with {len(content)} bytes")

    # List the Buckets
    for bucket in client.list_buckets():
        print(f"Bucket: {bucket.name}\n")

        # List the Blobs in each Bucket
        for blob in bucket.list_blobs():
            print(f"Blob: {blob.name}")
