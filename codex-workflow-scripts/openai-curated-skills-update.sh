#!/usr/bin/env bash
set -euo pipefail

# Update installed OpenAI curated skills in a global Codex directory and optional project directories.
# Usage:
#   bash openai-curated-skills-update.sh [--project PATH] [--dry-run]

SCRIPT_NAME="openai-curated-skills-updater"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${LOG_DIR:-$SCRIPT_DIR/logs}"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME}.log"
GLOBAL_SKILLS_DIR="$CODEX_HOME/skills"
OFFICIAL_REPO="${OFFICIAL_REPO:-https://github.com/openai/skills.git}"
CURATED_API="${CURATED_API:-https://api.github.com/repos/openai/skills/contents/skills/.curated}"
TMP_DIR="${TMPDIR:-/tmp}/codex-openai-curated-sync"

log() {
  mkdir -p "$LOG_DIR"
  printf '%s [%s] %s\n' "$(date '+%F %T')" "$SCRIPT_NAME" "$*" | tee -a "$LOG_FILE"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    log "missing command: $1"
    exit 1
  }
}

usage() {
  cat <<'USAGE'
Usage:
  openai-curated-skills-update.sh [--project PATH] [--dry-run]

Options:
  --project PATH   Also sync this project's .codex/skills directory. May be repeated.
  --dry-run        Print updates without overwriting files.
USAGE
}

DRY_RUN=0
PROJECTS=()

while (($#)); do
  case "$1" in
    --project)
      PROJECTS+=("$2")
      shift 2
      ;;
    --dry-run|--once)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      log "unknown argument: $1"
      usage
      exit 2
      ;;
  esac
done

require_cmd python3
require_cmd git
require_cmd curl
require_cmd rsync

mkdir -p "$TMP_DIR"

if ! CURATED_LIST_JSON="$(curl -fsSL -H 'User-Agent: codex-skills-updater/1.0' "$CURATED_API")"; then
  log "first fetch failed, retrying without proxy environment"
  CURATED_LIST_JSON="$(HTTPS_PROXY='' HTTP_PROXY='' ALL_PROXY='' https_proxy='' http_proxy='' all_proxy='' curl -fsSL -H 'User-Agent: codex-skills-updater/1.0' "$CURATED_API")"
fi

readarray -t OFFICIAL_SKILLS < <(python3 - <<'PY' <<<"$CURATED_LIST_JSON"
import json, sys
for item in json.loads(sys.stdin.read()):
    if item.get('type') == 'dir' and item.get('name'):
        print(item['name'])
PY
)

if ((${#OFFICIAL_SKILLS[@]} == 0)); then
  log "official skill list is empty"
  exit 1
fi

if [[ -d "$TMP_DIR/repo/.git" ]]; then
  (cd "$TMP_DIR/repo" && git fetch --depth 1 origin main && git checkout origin/main)
else
  rm -rf "$TMP_DIR/repo"
  git clone --depth 1 --filter=blob:none --sparse "$OFFICIAL_REPO" "$TMP_DIR/repo"
fi

(cd "$TMP_DIR/repo" && git sparse-checkout set skills/.curated)

sync_dir() {
  local skills_dir="$1"
  if [[ ! -d "$skills_dir" ]]; then
    log "skip missing directory: $skills_dir"
    return
  fi

  local updated=0
  for installed in "$skills_dir"/*; do
    [[ -d "$installed" ]] || continue
    local name
    name="$(basename "$installed")"

    local matched=0
    for official in "${OFFICIAL_SKILLS[@]}"; do
      if [[ "$official" == "$name" ]]; then
        matched=1
        break
      fi
    done

    (( matched == 1 )) || continue

    local src="$TMP_DIR/repo/skills/.curated/$name"
    [[ -d "$src" ]] || continue

    if (( DRY_RUN == 1 )); then
      log "[dry-run] would update: $skills_dir/$name"
    else
      rsync -a --delete "$src/" "$installed/"
      log "updated skill: $skills_dir/$name"
    fi
    ((updated++))
  done

  log "sync complete: $skills_dir ($updated matched skills)"
}

sync_dir "$GLOBAL_SKILLS_DIR"
for project in "${PROJECTS[@]}"; do
  sync_dir "$project"
done

log "curated skills update complete"
