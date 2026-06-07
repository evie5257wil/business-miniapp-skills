# 个人 Skill 发布清单（1.0）

## 基础信息
- 技能名：
- 版本：1.0（同名同日递增）
- 发布标签：
- 发布人：
- 发布时间：

## 版本化文件
- [ ] SKILL.md 已更新
- [ ] 对应 `assets/`、`scripts/`、`references/` 与 `rules/` 文件同步齐全
- [ ] 文档按 `文件名-YYYY-MM-DD-版本号` 命名

## 脱敏与安全
- [ ] 本地/敏感字段脱敏（个人身份、单位、账号、内网域名、凭证、AppID、路径）
- [ ] 生成脱敏报告并校验清单

## 发布留痕
- [ ] 运行：`zsh scripts/github-auto-delivery.sh --apply --tag <tag> <技能目录>`
- [ ] 生成留痕：`outputs/github-发布留痕-YYYY-MM-DD-1.0.md`
- [ ] 在留痕内补全 PR/Release 链接与 Commit Hash

## GitHub 上传
- [ ] commit 已推送
- [ ] 目标仓库：`evie5257wil/business-miniapp-skills`
- [ ] PR/Release 描述已补齐验证步骤与风险说明

