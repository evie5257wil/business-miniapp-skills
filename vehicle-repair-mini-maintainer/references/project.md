# Business Management Department Vehicle Repair Mini Program

## Current Project

- Product: 作业车辆报修系统.
- Platform: WeChat Mini Program with WeChat Cloud Development.
- Latest known version: v1.0.5.
- Latest known local source: `业务管理部车辆保修管理小程序/file2/作业车辆报修系统-v1.0.5/vehicle-repair-mini`.
- Key deployment folder: `cloudfunctions/api`.

## Roles

The system uses eight roles:

- 驾驶员
- 班长
- 质检人员
- 维修人员
- 维修负责人
- 业务管理部
- 分管领导
- 董事

Role consolidation:

- 报修专员 and 复核员 are handled as 质检人员.
- 安设 is handled as 业务管理部.
- Legacy `repairer` and `reviewer` accounts should map to 质检人员.
- Legacy `safety` accounts should map to 业务管理部.

## Permission Rules

- Only 业务管理部 and 分管领导 can export.
- 董事 can view reports but cannot export.
- 维修人员 and 维修负责人 cannot view approval information, reports, or exports.
- Account/password management is only for 业务管理部.
- Driver full personal details are visible only to 业务管理部 in account management.
- Passwords must not be shown in plaintext.
- Disabled staff accounts should be disabled, not deleted by default, to preserve history.

## Repair Workflow

Closed-loop workflow:

1. 驾驶员 submits fault and photos.
2. 班长 or 质检人员 may submit on behalf of a driver, but must select the real driver.
3. 质检人员 enters inspection opinion, estimated amount, and amount tier.
4. Approval chain is selected by amount:
   - Under 1000: 业务管理部.
   - Under 2000: 业务管理部 and 分管领导.
   - 2000 and above: 业务管理部, 分管领导, and 董事.
5. After approval, 班长 or 质检人员 notifies 环汇 for repair.
6. 维修人员 enters repair content, fault cause, repair photos, material fee, labor fee, and signature.
7. 维修负责人 confirms repair result.
8. 质检人员 confirms repair report or repair list.
9. 质检人员, 班组班长, 业务管理部, and 报修驾驶员 complete four-party acceptance.
10. Driver performs test-drive confirmation and signoff to close the case.

If recheck, acceptance, or test-drive fails, the case returns to repair and does not restart approval.

## Data And Reports

Known imported data files:

- `初始账号示例-导入repair_users.json` imports into `repair_users`.
- `初始车辆台账-导入vehicles-v1.0.5.json` imports into `vehicles`.

Known reporting surfaces:

- Repair ledger.
- Repair reports.
- Cost details.
- Settlement list.
- Operation logs.

Operation logs should cover login, repair request, inspection, approval, repair submission, confirmations, acceptance, signoff, account actions, and exports.

## Deployment Rules

When importing or releasing:

1. Open `vehicle-repair-mini` in WeChat Developer Tools.
2. Confirm the app version is v1.0.5 or the intended new version.
3. Deploy `cloudfunctions/api` if backend or cloud logic changed.
4. Confirm the WeChat cloud environment is the original project environment.
5. Import or verify `repair_users` and `vehicles` only when setting up initial data.
6. Compile and check for visible errors.

## Regression Checklist

Before release, check:

- All eight roles can log in according to their permissions.
- Inspection amount tier routes to the correct approval chain.
- Repair workers see only repair tasks and not approval details.
- Repair managers confirm repair results and do not see approval details.
- Rejected recheck/acceptance/test-drive returns to repair without restarting approval.
- Four-party acceptance must complete before driver test-drive signoff.
- Only 业务管理部 and 分管领导 can export.
- 董事 can view reports but cannot export.
- Account disabling and account management leave operation logs.
