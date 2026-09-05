# Arbeitsregeln

## Ton

- Knapp. Sag, was zu sagen ist, dann Schluss. Kein Vorgeplänkel, keine
  Zusammenfassung des gerade Getanen, kein „gute Frage“, kein Wiederholen der
  Aufgabe.
- Keine Füll-Adjektive (robust, nahtlos, mächtig, umfassend, produktionsreif).
  Knapp sagen, was der Code tut, nicht wie gut er ist. Nicht paraphrasieren, was
  die nächsten Zeilen tun. Stattdessen das WARUM und WIE erklären, wenn das dem
  Verständnis wirklich hilft.
- Docs und READMEs: was es ist, wie man es nutzt, was es bereitstellt. Sonst
  nichts.
- Commit-Nachrichten: conventional-commit, Imperativ, möglichst einzeilig. Den
  Scope richtig wählen — Release-Tooling routet unter Umständen darüber. Breaking
  Changes bekommen ein `!` (`feat(api)!: …`) oder einen `BREAKING CHANGE:`-Footer.
  Betreffzeile ≤ 72 Zeichen, Imperativ („add“, „fix“, nicht „added“, „fixes“).
  Body auf 72 Zeichen umbrechen.
- Kleine, fokussierte Commits bevorzugen. Release-Tooling leitet Versionssprünge
  und Changelog oft aus den Commit-Betreffzeilen ab.
- Keine Ticket-Nummern in Code, Commits oder Docs.
- Kommentare erklären das *Warum*, nicht das *Was*. Code-Kommentare benennen die
  Absicht oder eine Einschränkung, die der Code nicht zeigen kann. Kommentare
  löschen, die den Code nur wiederholen.
- Kommentare und Docs immer als Ganzes betrachten. Nie nur anhängen. Im Kontext
  prüfen und auf den faktischen Stand bringen. Im Zweifel im Code recherchieren.
  Veraltete und aus dem Kontext gefallene Verweise entfernen, ebenso frühere
  Beobachtungen, Schilderungen von Situationen, die zu einer früheren Änderung
  führten, Maschinennamen oder -adressen sowie jede Vermutung über die
  nachgelagerte Nutzung dieses Repos und seiner Artefakte — abgesehen von
  gültigen, aktuellen Beispielen.
- Auf ein anderes Repository oder Projekt nur verweisen, wenn dessen Zustand der
  unmittelbare Grund für die Änderung ist (ein Dependency-Bump, ein eingespielter
  Fix, ein an eine veröffentlichte Version gebundener API-Vertrag). Kontext für
  Reviewer, Dank oder Querverweise gehören in den PR-Thread oder ein Issue, nicht
  in den Commit.
- Deklarative Fakten schreiben. Keine Personalpronomen („ich“, „wir“, „du“).
  Keine Leseransprache: kein „beachte, dass…“, „wie man sieht…“, „wir haben uns
  entschieden…“, „das sollte helfen…“. Die Regel gilt für Dokumentation, die
  ein Artefakt beschreibt. Ausgenommen sind die Lab-Anleitungen, siehe unten.
- Nicht erzählen. Keine Historie, was zuerst versucht wurde, was scheiterte oder
  welche Alternativen erwogen wurden.
- Keine Füll-Verben ohne Konkretes. „Aufräumen“, „verbessern“, „refactoren“
  allein sagen nichts; entweder die tatsächliche Änderung benennen oder die Zeile
  weglassen.
- Keine Checklisten, keine „Summary“-/„Test plan“-Abschnitte, keine
  Marketing-Sprache, keine Emojis.

## Lab-Anleitungen

Ein Lab ist genau eine `labs/NN-thema/README.md`, Screenshots daneben in
`images/`. Lehrmaterial, das die Pronomen- und Leseransprache-Regel aufhebt.

- **Gesiezt.** Durchgängig „Sie“ und „Ihr“. Das Verhältnis liegt bei 180 zu 6
  gegen Duzen; die wenigen geduzten Stellen sind Ausrutscher, keine Vorlage.
- Titelzeile ist `# NN - Thema`, mit Bindestrich und ohne das Wort „Lab“.
- Der Einleitungssatz nennt, was in dieser Aufgabe entsteht.
- Danach `##`-Abschnitte, die den Arbeitsschritt benennen („Projekt
  vorbereiten“, „Funktion erstellen“, „Funktion lokal ausführen“). Keine
  durchnummerierten Schritt-Überschriften erzwingen — die meisten Labs
  benennen den Schritt statt ihn zu zählen.
- Voraussetzungen im GCP-Projekt zuerst: welche APIs zu aktivieren sind, in
  welchem Projekt gearbeitet wird.
- Konsolen-Einstiegspunkte als Autolink in spitzen Klammern:
  `<https://console.cloud.google.com/apis/library>`.
- Kommandos und Code in Fences mit Sprache. Ein Fence enthält eine
  zusammenhängende Sequenz, keine Sammlung unverbundener Zeilen.
- Ressourcennamen, Dateinamen und Verzeichnisse in Backticks (`gcf`,
  `index.js`, `package.json`).
- Labs, die kostenpflichtige Ressourcen anlegen, schließen mit `## Aufräumen`
  und bauen sie wieder ab. Bisher tun das nur `04-gce-iam` und `13-pubsub`;
  bei jedem weiteren Lab, das Ressourcen stehen lässt, gehört der Abschnitt
  nachgezogen.
- Knapp auf Satzebene gilt weiterhin: keine Füll-Adjektive, kein Marketing,
  keine Zusammenfassung des Abschnitts darüber.

## Vor dem Abschluss

- Lint, Tests und Build des Projekts für alles Berührte ausführen.
- `pre-commit run --all-files` laufen lassen und alle Befunde beheben.
- Was die CI zusätzlich prüft, lokal nachziehen, sobald der jeweilige Bereich
  berührt wurde:
  - `npm run lint:js` für `material/cloud-logging`
  - `ruff check labs/cloud-storage-emulator` und
    `black --check labs/cloud-storage-emulator`
  - `terraform fmt -check -diff` und `terraform validate` in
    `labs/cloud-loadbalancer` und in `terraform/`
  - `npm test` in `material/cloud-logging`
- Nicht „fertig“ behaupten, ohne die Prüfung ausgeführt zu haben. Belege vor
  Behauptungen.
- Alle TODO-Marker entfernen, die du in deiner Sitzung hinzugefügt hast, und
  nacharbeiten — oder dem Nutzer sagen, dass ein Follow-up nötig ist. Alle Marker
  und Verweise auf deine eigene Aufgabenliste oder historische Arbeitsschritte
  (P2, P3a, Item 1, Task A usw.) samt ihrer Erzählung entfernen. Wenn wirklich
  etwas offen bleibt, dem Nutzer außerhalb von Code, Docs, Markdown, Kommentaren,
  PR-Beschreibungen, Commit-Nachrichten oder allem anderen in diesem Repo und
  seiner angeschlossenen Pipeline Bescheid geben.

## Aufbau dieses Repos

Kurs „GCP für Entwickler“. Der Schwerpunkt liegt auf den Labs; die Folien
liegen nur als fertiges PDF vor.

- `labs/01-…` bis `labs/15-…` — durchnummerierte Übungen entlang der
  Kursreihenfolge, jede eine `README.md`.
- `labs/cloud-loadbalancer` und `labs/cloud-storage-emulator` — Labs ohne
  Nummer, weil sie nicht fest im Ablauf stehen. Sie enthalten Code statt
  Anleitung: Terraform beziehungsweise Python.
- `material/` — lauffähige Beispiele, auf die Labs verweisen: `bigquery`,
  `bigtable-demo`, `cloud-logging` (Node, mit Tests).
- `terraform/` — nicht Kursinhalt, sondern die GCP-Projekte der Teilnehmer.
  Der State liegt im GitLab-Terraform-Backend dieses Projekts.
- `slides/slides.pdf` — der Foliensatz. Es gibt keine Marp-Quelle im Repo.

## Fallstricke dieses Repos

- **`terraform/` provisioniert echte Projekte.** `apply:terraform:projects`
  läuft auf jedem Tag gegen das geteilte Backend, mit `resource_group` gegen
  parallele Läufe. Eine Änderung dort ist keine Doku-Änderung; erst `plan`
  lesen. Nicht mit `labs/cloud-loadbalancer` verwechseln, das reiner
  Kursinhalt ist und nur `validate` durchläuft.
- **Die Folien sind ein 25-MB-PDF ohne Quelle.** `slides/slides.pdf` lässt
  sich aus diesem Repo nicht neu bauen. Inhaltliche Folienänderungen sind hier
  nicht möglich; nur die Labs sind editierbar.
- **Die Sprachkennung an Code-Fences ist uneinheitlich**: `js` und
  `javascript`, `sh`, `bash` und `shell` stehen nebeneinander. Innerhalb einer
  Datei die dort vorhandene Variante fortführen, statt eine Datei einseitig
  umzustellen.
- **Die CI lintet mehr als Markdown.** Auf GitLab laufen ESLint, ruff,
  black und Terraform nur in Merge Requests (`if: $CI_MERGE_REQUEST_ID`),
  ein direkter Push auf `main` prüft diese Bereiche dort nicht. Lokal
  ausführen.
- **`.markdownlint.json` gibt es nicht.** markdownlint-cli2 läuft auf
  Defaults. Prosa an der Zeilenbreite der bestehenden Labs ausrichten
  (rund 80 Zeichen).
- **`material/cloud-logging/node_modules` liegt lokal, ist aber ignoriert.**
  Kein Suchtreffer von dort in eine Aussage über das Repo übernehmen.
- **Die CI läuft auf zwei Plattformen.** `.gitlab-ci.yml` bindet die
  GitLab-Komponenten ein, `.github/workflows/ci.yml` ruft `lint.yml`,
  `slides.yml`, `release.yml` und `pages.yml` aus
  `it-erben/ci`. ESLint, ruff, black und die
  Terraform-Prüfungen stehen dort als eigene Jobs im Repo und laufen auch
  bei einem Push auf `main`. `plan` und `apply` für `terraform/` gibt es
  nur auf GitLab, weil der State im GitLab-Backend liegt.
