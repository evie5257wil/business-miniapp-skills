---
title: "github-delivery-trace"
version: "1.0"
scope: "publish-governance"
---

# github-delivery-trace

## Goal
Guarantee every release can be reconstructed and audited:
- what changed
- what was sanitized
- where evidence is stored
- where GitHub publish action was executed

## Publish rules
1. All deliverables should pass `pre-github-sanitize.sh` (or equivalent).
2. Generate trace before/with publish.
3. Record PR/commit/branch in trace.
4. Use version naming rule (`文件名-YYYY-MM-DD-版本号`).

## Script
- Use `scripts/github-auto-delivery.sh`

## Default check items
- Trace file exists
- Sanitization report exists
- Commit + push evidence captured
- PR/Release link backfilled

