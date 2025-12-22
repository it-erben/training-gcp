# AGENTS

Diese Repos verwenden Pre-Commit Hooks mit folgenden Einstellungen:

- Markdown: `markdownlint-cli2` mit `--fix`
- YAML: `yamllint` (extends relaxed, line-length max 140)
- Links: `lychee` mit `--accept 429,200`, `--exclude http://localhost.*`,
  `--exclude-path .npm-cache`, `--max-concurrency 4`, `--retry-wait-time 2`,
  `--timeout 20`, `--cache`

Bitte halte `.pre-commit-config.yaml` und diese Einstellungen synchron, wenn du
die Linter- oder Link-Check-Regeln aenderst.
