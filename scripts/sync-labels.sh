#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: $0 [--apply] [--prune] <repo>..." >&2
  echo "  Without --apply it only prints what would change." >&2
  echo "  --prune deletes labels that are not in labels.yml (GitHub defaults included), except Dependabot's" >&2
  echo "  ecosystem labels. Deleting a label removes it from every issue and PR that has it." >&2
  exit 2
}

apply=false
prune=false
repos=()
for arg in "$@"; do
  case "$arg" in
    --apply) apply=true ;;
    --prune) prune=true ;;
    -h|--help) usage ;;
    *) repos+=("$arg") ;;
  esac
done
[ "${#repos[@]}" -gt 0 ] || usage

labels_file="$(dirname "$0")/../labels.yml"
wanted="$(python3 -c '
import sys, yaml, json
print(json.dumps(yaml.safe_load(open(sys.argv[1]))))' "$labels_file")"

for repo in "${repos[@]}"; do
  case "$repo" in */*) ;; *) repo="dataintmx/$repo" ;; esac
  echo "== $repo"
  current="$(gh label list -R "$repo" --limit 200 --json name,color,description)"
  python3 - "$wanted" "$current" "$prune" <<'PY' | while IFS=$'\t' read -r action name color description; do
import json, sys
wanted = {l["name"]: l for l in json.loads(sys.argv[1])}
current = {l["name"]: l for l in json.loads(sys.argv[2])}
prune = sys.argv[3] == "true"
for name, w in wanted.items():
    c = current.get(name)
    if c is None:
        print("create", name, w["color"], w["description"], sep="\t")
    elif c["color"].lower() != w["color"].lower() or (c.get("description") or "") != w["description"]:
        print("update", name, w["color"], w["description"], sep="\t")
dependabot_defaults = {"dependencies", "python", "javascript", "docker", "github_actions", "go", "terraform", "java", "ruby", "rust"}
if prune:
    for name in current:
        if name not in wanted and name not in dependabot_defaults:
            print("delete", name, "", "", sep="\t")
PY
    echo "  $action: $name"
    $apply || continue
    case "$action" in
      create) gh label create "$name" -R "$repo" --color "$color" --description "$description" ;;
      update) gh label edit "$name" -R "$repo" --color "$color" --description "$description" ;;
      delete) gh label delete "$name" -R "$repo" --yes ;;
    esac
  done
done
