# Contributing to Dataint repositories

This guide is the same in every `dataintmx` repository. Each repository adds its own commands and particulars in the section **This repository** at the end of its `CONTRIBUTING.md`. If a rule here and a rule in that section disagree, the repository section wins for that repository.

Agent instruction files (`CLAUDE.md`, `AGENTS.md`, `.github/copilot-instructions.md`, prompts) must point to this document for workflow rules instead of restating them.

## 1. Workflow

1. **Plan in Notion.** Work starts as a task in Notion (Initiative → Roadmap → Tasks). Bugs reported by users, regressions found in QA and small follow-ups can start directly as a GitHub issue.
2. **One GitHub issue per task.** The issue describes the problem or goal, the expected result and the context needed to implement it. Use the issue forms; blank issues are disabled.
3. **One branch per issue**, created from `dev` (see §2).
4. **One pull request per branch**, linked to its issue with `Closes #<number>`.
5. **Review and CI.** A PR is merged only with one approval from a code owner and every required check green.
6. **Release** from `dev` to `main` through a `release/*` branch (see §5).

All issues, pull requests, commit messages, code comments and repository documentation are written in **English**.

## 2. Branches

| Branch | Purpose | Created from | Merged into |
|---|---|---|---|
| `dev` | Integration. Deployed to the development environment (`*.dataint.dev`). | — | — |
| `main` | Production. Deployed to production (`*.dataint.mx`). | — | — |
| `feat/<short-name>` | New features or enhancements | `dev` | `dev` |
| `fix/<short-name>` | Bug fixes and regressions | `dev` | `dev` |
| `docs/`, `chore/`, `refactor/`, `ci/` `<short-name>` | Documentation, maintenance, refactors, CI/CD | `dev` | `dev` |
| `release/<version>` | Promote a tested set of changes to production | `dev` | `main` |
| `hotfix/<short-name>` | Urgent production fix | `main` | `main`, then `dev` |

Rules:

- No direct commits to `dev` or `main`; every change goes through a pull request.
- Only `release/*` and `hotfix/*` branches merge into `main`.
- After a hotfix reaches `main`, merge `main` back into `dev` the same day.
- Large features: create `feat/<feature>` from `dev`, open sub-branches from it, and target the sub-branch PRs at `feat/<feature>`. Merge `feat/<feature>` into `dev` only when it is complete.
- Short names are lowercase with hyphens: `feat/saved-views`, `fix/events-filter-regression`.

## 3. Commits

Commits follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <summary in the imperative, lowercase, no final period>

<optional body: what and why, wrapped at 72 characters>

<optional footer: Closes #123, BREAKING CHANGE: ...>
```

| Type | Use for |
|---|---|
| `feat` | A new feature or user-visible enhancement |
| `fix` | A bug fix |
| `sec` | A security fix or hardening |
| `perf` | A performance improvement |
| `refactor` | A code change that neither fixes a bug nor adds a feature |
| `test` | Adding or fixing tests |
| `docs` | Documentation only |
| `ci` | CI/CD workflows and build configuration |
| `chore` | Maintenance: dependencies, tooling, housekeeping |
| `revert` | Reverting a previous commit |

`<scope>` is the module, package or service touched (for example `auth`, `events`, `api`). Use `!` after the type or a `BREAKING CHANGE:` footer for incompatible changes.

## 4. Pull requests

- Fill in the pull request template: description, linked issue, type of change, how it was tested, deployment notes and rollback.
- Keep PRs focused on their issue. Split unrelated changes.
- The PR title follows the commit format (`feat(events): add saved views`); it becomes the squash commit message.
- Merge strategy:
  - into `dev` and feature branches: **squash and merge**;
  - `release/*` and `hotfix/*` into `main`: **merge commit** (keeps the release history).
- Delete the branch after merging.

## 5. Versions and releases

Versions use calendar versioning: **`YYYY.MM.N`**, where `N` starts at `0` for the first release of the month and increases by one with each release in that month (`2026.11.0`, `2026.11.1`, `2026.12.0`).

1. Create `release/<version>` from `dev` when the changes for the release are ready and verified in the development environment.
2. Update `CHANGELOG.md` with a section for the version:

   ```
   ## [YYYY.MM.N] - YYYY-MM-DD
   ### Added
   ### Changed
   ### Fixed
   ### Security
   ```

3. Open a PR from `release/<version>` to `main` using the release checklist in the PR template.
4. After the merge, the CD pipeline tags `v<version>` and deploys to production. Merge `main` back into `dev`.

Dependabot security updates target the default branch; the repository's sync workflow merges them back into `dev`.

## 6. Code quality

- Every repository runs its formatter, linter and tests in CI; the commands are in **This repository**. Run them locally before pushing.
- Do not disable a lint rule or skip a test to make CI pass; fix the cause or explain the exception in the PR.
- Configuration values (limits, timeouts, origins, URLs) live in the repository's configuration module or file, not scattered in the code.
- **No comments in code.** Names, types, small functions and tests carry the meaning; explanations of why a change was made go in the commit message and the pull request, and design or operational documentation goes in the repository documentation or Notion. Only machine-read directives are allowed (`# noqa`, `# type: ignore`, `// eslint-disable-next-line`, shebangs, encoding or license headers required by a tool), each with the narrowest scope possible.

## 7. Security

- Never commit secrets, tokens, passwords, connection strings or `.env` files. Runtime secrets live in OpenBao and reach the services through External Secrets; CI secrets live in GitHub Actions secrets.
- Never paste secrets in issues, pull requests or chat. If one leaks, report it so it can be rotated.
- Do not log credentials, tokens or personal data.
- Report vulnerabilities as described in [SECURITY.md](SECURITY.md).

## 8. Labels

Every repository uses the same labels:

| Group | Labels |
|---|---|
| Type | `Type: Bug`, `Type: Enhancement`, `Type: Design`, `Type: Documentation`, `Type: Maintenance`, `Type: Deployment`, `Type: Security`, `Type: Release`, `Type: Revert`, `Type: Dependabot` |
| Status | `Status: Unresolved`, `Status: In Progress`, `Status: Waiting for Approval`, `Status: Waiting for Changes`, `Status: Resolved`, `Status: Won't fix` |
| Priority | `Priority: Low`, `Priority: Medium`, `Priority: High` |

Each issue has one `Type` and one `Priority`; `Status` follows the work.

## This repository

<!-- Copied from templates/CONTRIBUTING.repo.md and filled in per repository. -->
