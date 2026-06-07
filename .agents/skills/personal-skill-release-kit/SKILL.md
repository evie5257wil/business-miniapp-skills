---
title: "personal-skill-release-kit"
version: "1.0"
scope: "skill-governance"
---

# personal-skill-release-kit

## Goal
Use one standard for creating or updating any personal skill so every release is:
- versioned
- sanitized
- traceable
- upload-ready to GitHub

## Scope
- New SKILL.md authoring
- Release evidence generation
- PR/Release note draft

## Standard operating procedure
1. Place skill content under `.agents/skills/<skill-name>/`
2. Fill required metadata and scope in `SKILL.md`
3. Generate release checklist file with version and date
4. Run `pre-github-sanitize.sh` if applicable
5. Run `github-auto-delivery.sh --apply --tag <tag> <skill-dir>`
6. Push and update PR/commit links in trace

## Required evidence checklist (copy into project trace)
- skill root
- SKILL.md
- version file list
- sanitization report / redacted artifact
- release command
- commit hash + PR/Release URL

