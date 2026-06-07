#!/usr/bin/env bash
set -euo pipefail

# Generate a traceable checklist before publishing files to GitHub.
# Usage:
#   bash github-publish-trace.sh [--tag tag-name] <file1> [file2 ...]

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TRACE_DIR="${TRACE_DIR:-$ROOT/0_Codex闭环/20_项目归档}"
TRACE_REPORT="${TRACE_DIR}/github-发布留痕-$(date '+%Y-%m-%d')-1.0.md"
SANITIZE_SCRIPT="${SANITIZE_SCRIPT:-$ROOT/codex-workflow-scripts/pre-github-sanitize.sh}"

usage() {
  echo "用法: bash github-publish-trace.sh [--tag 标签] <文件1> [文件2 ...]"
}

if [[ "$#" -eq 0 ]]; then
  usage
  exit 1
fi

TAG="publish-$(date '+%Y%m%d-%H%M%S')"
if [[ "${1:-}" == "--tag" ]]; then
  if [[ "$#" -lt 3 ]]; then
    usage
    exit 1
  fi
  TAG="$2"
  shift 2
fi

mkdir -p "$TRACE_DIR"

{
  echo "# GitHub 发布留痕（$(date '+%F %T')）"
  echo
  echo "- 时间：$(date '+%F %T')"
  echo "- 标签：$TAG"
  echo "- 发布根目录：$ROOT"
  echo
  echo "## 1. 文件清单"
  for f in "$@"; do
    if [[ -f "$f" ]]; then
      rel="${f#$ROOT/}"
      echo "- [ ] $rel"
    else
      echo "- [缺失文件] $f"
    fi
  done
  echo
  echo "## 2. 脱敏输出"
  echo "- 脚本：$SANITIZE_SCRIPT"
  echo "- 建议命令：bash $SANITIZE_SCRIPT <上述文件>"
  echo "- 脱敏副本目录：$ROOT/.sanitized"
  echo
  echo "## 3. 发布动作清单"
  echo "- [ ] 运行脱敏脚本"
  echo "- [ ] 复核脱敏报告并确认无敏感信息"
  echo "- [ ] 按脱敏文件创建发布版本"
  echo "- [ ] 发布后回填 PR 链接与 Commit Hash"
} > "$TRACE_REPORT"

printf '%s\n' "$TRACE_REPORT"
