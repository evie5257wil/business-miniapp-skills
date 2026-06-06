# Business Management Department Warehouse Mini Program

## Current Project

- Product: Business Management Department warehouse materials in/out Mini Program.
- Platform: WeChat Mini Program with WeChat Cloud Development.
- Latest known version: v1.9.1, dated 2026-06-05.
- Latest known local source: `业务管理部仓库管理小程序/files10/warehouse-mini`.
- Key deployment folder: `cloudfunctions/warehouseApi`.

## Business Scope

The system manages warehouse materials for three teams:

- 清道
- 清运
- 医废

Core functions include inbound registration, outbound registration, photos with watermark, inventory query, in/out records, stocktaking, return-to-stock, return-to-supplier, summary reports, Excel export, account management, and operation logs.

## Roles

Known login identities:

- 清道班组长
- 清运班组长
- 医废班组长
- 中层管理人员
- 分管领导

Management level:

- 班组长 < 中层管理人员 < 分管领导

Key role rules:

- Team leaders only access their own team.
- Middle management can access all teams and perform administrative operations.
- 分管领导 has middle-management permissions plus final approval signature authority.
- Login identity must match the account's real role.
- At least one 分管领导 account is required for the outbound approval chain to complete.

## Audit And Data Rules

- Inbound/outbound records are append-only. Do not edit or delete historical records.
- Mistakes are corrected through voiding and re-entry. Voiding requires who, when, why, and automatic stock reversal.
- Void reasons and stocktaking/return notes must be meaningful, not one-word placeholders.
- Operation logs are append-only and must cover account changes, role changes, password resets, voids, exports, stocktaking, returns, minimum-stock updates, and clear-test-data actions.
- Server time is authoritative.
- Backend identity must use WeChat `OPENID` and server-side account lookup, not client-reported role/team data.

## Approval Flow

Outbound approval is a three-level workflow:

1. Team leader creates request with item, quantity, and unit.
2. Middle management signs electronically.
3. 分管领导 signs electronically.
4. Middle management issues materials against an approved request.

Issuing rules:

- Team leaders cannot operate the issuing page.
- Issuer is fixed by backend business rule.
- Receiver must be the matching team leader and must sign with account/password.
- One approval can be used only once.
- Item and quantity must match the approval.
- Rejections and all approval actions must be logged.

## Deployment Rules

When importing or releasing:

1. Open `warehouse-mini` in WeChat Developer Tools.
2. Confirm the version shown in the app matches the release version.
3. If cloud functions changed, deploy `cloudfunctions/warehouseApi`.
4. Compile and check for visible errors.
5. Verify the version in the "我的" page.
6. Phone preview is required for camera, location, photo watermark, and real-role workflows.

## Collections

Known collections include:

- `materials`
- `records`
- `users`
- `counters`
- `options`
- `logs`
- `approvals`

Do not rename collections casually. If schema changes are needed, document migration and backward compatibility.

## Regression Checklist

Before release, check:

- Five login identities.
- Team isolation for each team leader.
- Middle management can switch teams and export.
- Approval creation, two signatures, issuing, receiver signature, and single-use approval.
- Inbound and outbound photo requirement.
- Stock change after inbound, outbound, stocktaking, return-to-stock, return-to-supplier, and voiding.
- Excel export includes expected columns.
- Operation logs include sensitive actions.
- WeChat real phone validation for camera, location, and watermarks.
