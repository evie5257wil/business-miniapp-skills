---
title: "obsidian-weekly-ops"
version: "1.0"
scope: "maintenance-ops"
---

# obsidian-weekly-ops

## Goal
Standardize weekly ops for Obsidian/graph-scan/backup-link-fix with one-click execution and auditable logs.

## Required cadence
- Weekly self-check for scripts and logs
- Keep one trace file per execution date
- Keep warning-level issues visible, failures blocked

## Workflow
1. Run one-click selfcheck script and confirm report output.
2. Run weekly execution command.
3. Confirm report files exist (vault path or fallback path).
4. Append result to closure record.

## Outputs
- Relationship graph weekly report
- Backup-link repair report
- Weekly trace in Obsidian vault

## Suggested default commands
- `zsh scripts/obsidian-weekly-selfcheck.sh`
- `zsh scripts/obsidian-weekly-runner.sh`

## Version policy
- File names and reports follow: `...-YYYY-MM-DD-版本.md`
- First publish is `1.0`

