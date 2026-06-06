---
name: warehouse-mini-maintainer
description: Use this skill when maintaining, extending, debugging, documenting, or preparing release packages for the Business Management Department warehouse WeChat Mini Program. It captures the project's roles, audit rules, cloud function deployment rules, versioning workflow, and acceptance checks.
metadata:
  short-description: Maintain the warehouse mini program
---

# Warehouse Mini Maintainer

Use this skill for work on the warehouse management WeChat Mini Program, especially changes involving inventory, records, approvals, roles, audit trails, WeChat cloud development, release notes, or deployment instructions.

## First Steps

1. Confirm the target version and source folder before editing. The latest known stable source is `files10/warehouse-mini`, version v1.9.1.
2. Read [references/project.md](references/project.md) before implementation or review.
3. Keep changes narrow and preserve the existing WeChat Mini Program style.
4. Do not delete records, logs, old release folders, or project documents unless the user explicitly approves the deletion.

## Hard Rules

- The cloud function name is `warehouseApi`. Do not revert it to `api`; that caused conflicts with the vehicle repair mini program.
- Treat audit behavior as core business logic: records are append-only, mistakes are voided with traces, and operation logs are append-only.
- Role and team isolation must be enforced on the backend, not only by hiding buttons in the UI.
- If a change touches cloud functions, tell the user that `cloudfunctions/warehouseApi` must be redeployed in WeChat Developer Tools.
- If a change affects release behavior, update the same version consistently in update notes, operation steps, usage instructions, and project records when those files exist.
- Before claiming completion, run static checks that are possible locally and state what still requires WeChat Developer Tools or real-phone validation.

## Expected Output

For code changes, finish with:

- Changed behavior.
- Files touched.
- Verification performed.
- Whether cloud function redeployment is required.
- Whether Obsidian sync was completed.
