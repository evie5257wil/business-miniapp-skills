---
name: vehicle-repair-mini-maintainer
description: Use this skill when maintaining, extending, debugging, documenting, or preparing release packages for the Business Management Department vehicle repair WeChat Mini Program. It captures the repair workflow, eight-role permission model, approval chain, cloud deployment steps, reporting rules, and acceptance checks.
metadata:
  short-description: Maintain the vehicle repair mini program
---

# Vehicle Repair Mini Maintainer

Use this skill for work on the vehicle repair WeChat Mini Program, especially changes involving repair requests, quality inspection, approval chains, repair reports, acceptance, driver signoff, reports, exports, accounts, or WeChat cloud deployment.

## First Steps

1. Confirm the target version and source folder before editing. The latest known stable source is `作业车辆报修系统-v1.0.5/vehicle-repair-mini`.
2. Read [references/project.md](references/project.md) before implementation or review.
3. Keep changes narrow and preserve the existing WeChat Mini Program style.
4. Do not delete old release folders, imported account/vehicle data, logs, or project documents unless the user explicitly approves the deletion.

## Hard Rules

- The main cloud function is `cloudfunctions/api`.
- The system is an auditable closed loop. Preserve the chain from repair request through driver test-drive signoff.
- Approval information must not be visible to repair workers or repair managers.
- Export permission belongs only to business management and 分管领导. 董事 can view reports but cannot export.
- Account/password management belongs only to business management.
- Disabled accounts should stay as records; do not delete staff history by default.
- If a change touches cloud functions, tell the user that `cloudfunctions/api` must be redeployed in WeChat Developer Tools.
- Before claiming completion, run static checks that are possible locally and state what still requires WeChat Developer Tools or real-phone validation.

## Expected Output

For code changes, finish with:

- Changed behavior.
- Files touched.
- Verification performed.
- Whether cloud function redeployment is required.
- Whether Obsidian sync was completed.
