#!/usr/bin/env bash
set -euo pipefail

# Create redacted copies of text files before publishing to GitHub.
# Usage:
#   bash pre-github-sanitize.sh <file1> [file2 ...]

TS="$(date +%Y%m%d_%H%M%S)"
OUT_DIR="${OUT_DIR:-$(pwd)/.sanitized}"
mkdir -p "$OUT_DIR"
REPORT="${OUT_DIR}/sanitization-report-${TS}.md"

cat > "$REPORT" <<REPORT_HEADER
# 脱敏报告

- 生成时间: $(date '+%F %T')

## 处理文件

REPORT_HEADER

sanitize_file() {
  local src="$1"
  local dst="$2"
  local rel="$3"

  cp "$src" "$dst"

  perl -pi -e 's#([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,})#{{USER_EMAIL}}#g' "$dst"
  perl -pi -e 's#(password|passwd|token|apikey|api[_-]?key|secret|private[_-]?key)\s*[:=]\s*["'"'"']?[^[:space:]"'"'"']+#$1={{REDACTED_CREDENTIAL}}#ig' "$dst"
  perl -pi -e 's#https?://[^[:space:])]+#{{URL_REDACTED}}#g' "$dst"
  perl -pi -e 's#/Users/[^[:space:]]+#/Users/{{USER_HOME}}#g' "$dst"
  perl -pi -e 's#/tmp/[^[:space:]]+#/tmp/{{TMP_REDACTED}}#g' "$dst"
  perl -pi -e 's#\b1[3-9][0-9]{9}\b#{{PHONE_REDACTED}}#g' "$dst"
  perl -pi -e 's#\b\d{3}-?\d{3}-?\d{4}\b#{{PHONE_REDACTED}}#g' "$dst"

  echo "- [ ] ${rel} -> $(basename "$dst")" >> "$REPORT"
  echo "  - 建议复查：姓名、工号、内部域名、组织名、业务明文仍需人工确认" >> "$REPORT"
}

if [[ "$#" -eq 0 ]]; then
  echo "usage: bash pre-github-sanitize.sh <file1> [file2 ...]" >&2
  exit 1
fi

for f in "$@"; do
  if [[ ! -f "$f" ]]; then
    echo "未找到文件：$f" >&2
    continue
  fi
  b=$(basename "$f")
  dst="$OUT_DIR/${TS}-${b}.redacted"
  sanitize_file "$f" "$dst" "$f"
done

printf '%s\n' "$REPORT"
