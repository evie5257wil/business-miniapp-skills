---
title: "obsidian-closure-loop"
version: "1.0"
scope: "delivery-loop"
---

# obsidian-closure-loop

## Goal
Build a full delivery loop so every task can close with:
- requirement confirmation
- execution plan (2-5 steps)
- in-progress milestone
- completion evidence
- automatic trace + optional upload

## When to use
- Task execution
- Operation closure and handoff
- Routine work review

## Core workflow
1. Input: clearly restate goal, constraints, and acceptance criteria.
2. Plan: list 2-5 steps with milestones and pass/fail check.
3. Confirm: user confirms before execution.
4. Execute: do minimum necessary changes.
5. Verify: generate evidence files and self-check.
6. Record: write closure + append evidence in versioned files.
7. Upload: use `github-auto-delivery.sh` as default publishing entry.

## Required evidence
- One trace file per task (close with path + timestamp)
- One versioned record file (name: `YYYY-MM-DD-1.0` format)

## Example
- Task: "Scan obsidian and codebase"
- Output: scan reports + issue list + automation improvement plan
- Publish command:
  - `zsh scripts/github-auto-delivery.sh --apply --tag v1.0 reports/...`

