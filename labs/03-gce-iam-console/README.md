# 03 - GCS-Bucket, Service Account, VM (Konsole)

In dieser Aufgabe erstellen Sie einen Service Account, einen Storage Bucket und
eine VM. Sie lernen, wie sie korrekt die notwendigen Berechtigungen zur
Verwendung des Buckets vergeben.

## Erstellen eines GCS-Buckets

Wechseln Sie über die Suchleiste auf die Cloud Storage-Ansicht.

![image](images/gcs-01-menu.png)

---

Klicken Sie auf "Bucket erstellen"

![image](images/gcs-02-create-bucket.png)

---

Wählen Sie einen beliebigen Namen. Als Location wählen Sie bitte "eu".

![image](images/gcs-03-bucket-name.png)
![image](images/gcs-04-bucket-location.png)

---

Sie können alle anderen Einstellungen belassen wie Sie sind und die Anlage
abschließen. Auch den Dialog, dass öffentlicher Zugriff deaktiviert wird,
können Sie bestätigen.

## Erstellen eines Service Accounts

Navigieren Sie über die Suchleiste in der Konsole auf die Dienstkonten-Ansicht.

![01-sa-search.png](images/sa-01-search.png)

---

Klicken Sie auf "Dienstkonto erstellen".

![02-sa-create.png](images/sa-02-create.png)

---

Im nun folgenden Formular können Sie einen beliebigen Namen eingeben.

![03-sa-name.png](images/sa-03-name.png)

---

Klicken Sie auf "Erstellen und fortfahren".
Wählen Sie nun die Rolle "Storage-Administrator" aus. Bitte achten Sie darauf,
dass Sie wirklich exakt diese und nicht eine gleichlautende Rolle wählen.
Es ist außerdem wichtig, dass die nach der Wahl der Rolle einmal auf "Weiter"
klicken, damit die Rolle angewandt wird.

![04-sa-role.png](images/sa-04-role.png)

Sie können die Erstellung nun abschließen.

## Erstellen einer Compute Engine VM

Wechseln Sie über die Menüleiste in die Compute Engine-Ansicht.

![image.png](images/gce-01-compute-menu.png)

---

Klicken Sie auf "Instanz erstellen".

![image.png](images/gce-02-create-instance.png)

---

Wählen Sie einen beliebigen Namen und einen europäischen Standort (egal
welchen).

![image.png](images/gce-03-machine-name-region.png)

---

Als Instanztyp wählen sie e2-micro.

![image.png](images/gce-04-compute-type.png)

---

Klicken Sie links auf den Reiter "Sicherheit".

![image.png](images/gce-05-select-security.png)

---

Wählen Sie den soeben angelegen Service Account aus.

![image.png](images/gce-06-select-sa.png)

Sie können die Anlage nun abschließen.

## Verbinden per SSH

Um nun einen Test durchführen zu können, verbinden wir uns per SSH mit der VM.
Klicken Sie dazu auf den SSH-Knopf in der Liste der VMs.

![image.png](images/gce-07-ssh.png)

Zuletzt listen wir alle Buckets auf um zu testen, dass die Instanz
Vollberechtigung auf Google Cloud Storage hat.

```shell
gsutil ls
```
