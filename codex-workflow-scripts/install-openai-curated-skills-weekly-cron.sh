#!/usr/bin/env bash
set -euo pipefail

# Install a weekly cron job for openai-curated-skills-update.sh.
# Usage:
#   bash install-openai-curated-skills-weekly-cron.sh /path/to/openai-curated-skills-update.sh [/path/to/project/.codex/skills]

UPDATER_SCRIPT="${1:-}"
PROJECT_SKILLS_DIR="${2:-}"
CRON_MARK="# CodexOpenAIWeeklyUpdater"

if [[ -z "$UPDATER_SCRIPT" ]]; then
  echo "usage: bash install-openai-curated-skills-weekly-cron.sh /path/to/openai-curated-skills-update.sh [/path/to/project/.codex/skills]" >&2
  exit 1
fi

if [[ ! -f "$UPDATER_SCRIPT" ]]; then
  echo "updater script not found: $UPDATER_SCRIPT" >&2
  exit 1
fi

if ! command -v crontab >/dev/null 2>&1; then
  echo "crontab not found" >&2
  exit 1
fi

if [[ -n "$PROJECT_SKILLS_DIR" ]]; then
  CRON_LINE="@weekly \"$UPDATER_SCRIPT\" --project \"$PROJECT_SKILLS_DIR\" >> \"$HOME/.codex/openai-curated-skills-weekly.log\" 2>&1"
else
  CRON_LINE="@weekly \"$UPDATER_SCRIPT\" >> \"$HOME/.codex/openai-curated-skills-weekly.log\" 2>&1"
fi

TMP_FILE="$(mktemp)"
crontab -l 2>/dev/null | grep -v "$CRON_MARK" | grep -v "openai-curated-skills-update.sh" > "$TMP_FILE" || true

{
  echo "$CRON_MARK"
  echo "$CRON_LINE"
} >> "$TMP_FILE"

crontab "$TMP_FILE"
rm -f "$TMP_FILE"

echo "installed weekly updater:"
echo "$CRON_LINE"
