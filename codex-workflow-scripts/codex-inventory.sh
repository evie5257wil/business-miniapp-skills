#!/usr/bin/env zsh
set -euo pipefail

# Generate a Markdown inventory of scripts and automation files in a project.

DATE=${1:-$(date +%Y-%m-%d)}
PROJECT_DIR=$(cd "$(dirname "$0")/.." && pwd)
OUT_DIR="$PROJECT_DIR/0_Codex闭环/20_项目归档"
OUT_FILE="$OUT_DIR/项目脚本与自动化清单-${DATE}-1.0.md"
LAUNCH_DIR="$HOME/Library/LaunchAgents"

mkdir -p "$OUT_DIR"

{
  echo "# 项目脚本与自动化清单 (${DATE})"
  echo
  echo "## 项目"
  echo "- ${PROJECT_DIR}"
  echo
  echo "## 可执行脚本"
  echo

  if command -v rg >/dev/null 2>&1; then
    rg --files "$PROJECT_DIR" -g '*.sh' -g '*.py' -g '*.js' -g '*.ts' -g '*.tsx' -g '*.mjs' | while IFS= read -r f; do
      rel=${f#$PROJECT_DIR/}
      if [[ -x "$f" ]]; then
        echo "- [x] $rel"
      else
        echo "- [ ] $rel"
      fi
    done
  else
    find "$PROJECT_DIR" -type f \( -name '*.sh' -o -name '*.py' -o -name '*.js' -o -name '*.ts' -o -name '*.tsx' -o -name '*.mjs' \) | while IFS= read -r f; do
      rel=${f#$PROJECT_DIR/}
      if [[ -x "$f" ]]; then
        echo "- [x] $rel"
      else
        echo "- [ ] $rel"
      fi
    done
  fi

  echo
  echo "## LaunchAgent 自动化任务"
  echo

  if [[ -d "$LAUNCH_DIR" ]] && command -v rg >/dev/null 2>&1; then
    rg -l "codex|Codex|handoff" "$LAUNCH_DIR"/*.plist 2>/dev/null | while IFS= read -r p; do
      rel=${p#$HOME/}
      echo "- $rel"
    done
  else
    echo "- 未检测到相关 LaunchAgent 或未安装 rg"
  fi

  echo
  echo "## 生成时间"
  echo "- $(date '+%F %T')"
} > "$OUT_FILE"

printf '%s\n' "$OUT_FILE"
