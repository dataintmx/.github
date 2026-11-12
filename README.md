# dataintmx/.github

Shared contribution standard for every `dataintmx` repository.

| File | Effect |
|---|---|
| `CONTRIBUTING.md` | Common guide. Each repository keeps its own copy with a filled-in **This repository** section (`templates/CONTRIBUTING.repo.md`). |
| `.github/pull_request_template.md` | Default pull request template for repositories without their own. |
| `.github/ISSUE_TEMPLATE/` | Default issue forms (bug, feature, maintenance); blank issues disabled. |
| `SECURITY.md` | Default security policy. |
| `labels.yml` | The labels every repository uses. |
| `scripts/sync-labels.sh` | Shows (default) or applies (`--apply`, `--prune`) `labels.yml` to the given repositories. |

GitHub only uses these defaults in repositories that do not have the same file. A repository with its own copy must keep it identical to this one, except for the **This repository** section of `CONTRIBUTING.md`.

Changes to this repository go through a pull request reviewed by the platform team.
