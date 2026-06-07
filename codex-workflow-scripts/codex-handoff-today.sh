#!/usr/bin/env zsh
set -euo pipefail

# Generate a daily handoff checklist for Codex work.
# Environment variables:
#   OBSIDIAN_VAULT: path to the Obsidian vault
#   PROJECT_NAME:   short project name used in generated notes

DATE=${1:-$(date +%Y-%m-%d)}
OBSIDIAN_VAULT=${OBSIDIAN_VAULT:-"$HOME/Obsidian Vault"}
PROJECT_NAME=${PROJECT_NAME:-"codex-project"}
ROOT="$OBSIDIAN_VAULT/0_Codex闭环/20_项目归档"
OUTPUT="$ROOT/今日接手检查清单-${DATE}-1.0.md"
LOG="$OBSIDIAN_VAULT/11_Codex同步记录.md"

mkdir -p "$ROOT"

cat > "$OUTPUT" <<EOF2
---
title: "今日接手检查清单-${DATE}-1.0"
aliases: ["今日接手清单", "handoff checklist"]
tags: [codex, handoff, migration]
version: 1.0
date: ${DATE}
---

# 今日接手检查清单-${DATE}-1.0

## 5 分钟恢复
- [ ] 打开主入口：个人知识主索引
- [ ] 确认执行规则：版本化执行规则
- [ ] 检查当前项目：${PROJECT_NAME}
- [ ] 查看最新感悟与任务记录
- [ ] 核对 GitHub 发布留痕

## 接手确认
- [ ] 目标边界是否一致？
- [ ] 验收标准是否有遗漏？
- [ ] 最新任务是否已同步？
- [ ] 项目与全局技能清单是否一致？

## 证据路径
- \`~/.codex/AGENTS.md\`
- \`${OBSIDIAN_VAULT}\`
- \`11_Codex同步记录.md\`
EOF2

printf '%s | 生成今日接手清单：%s\n' "$(date '+%F %T')" "$OUTPUT" >> "$LOG"
printf '%s\n' "$OUTPUT"
