# Codex Workflow Scripts

这个目录保存可复用的 Codex 工作流脚本。

本次上传原则：
- 只上传通用脚本和说明。
- 不上传单位业务原始数据、人员台账、车辆台账、压缩包、PDF 原件。
- 本地路径、用户名、内部项目名已改为环境变量或通用占位。

## 脚本清单

- `codex-handoff-today.sh`：生成每日接手清单，便于重装电脑、换模型或继续项目时快速恢复上下文。
- `codex-inventory.sh`：生成项目脚本与自动化清单。
- `pre-github-sanitize.sh`：上传 GitHub 前生成脱敏副本和脱敏报告。
- `github-publish-trace.sh`：生成 GitHub 发布留痕清单。

## 使用方式

脚本默认使用当前目录或环境变量，不绑定个人电脑路径。

示例：

```bash
export OBSIDIAN_VAULT="$HOME/Obsidian Vault"
export PROJECT_NAME="my-codex-project"
zsh codex-handoff-today.sh
```

## 敏感信息规则

任何小程序、脚本、文档上传前，先执行：

```bash
zsh pre-github-sanitize.sh <file1> <file2>
```

复核 `.sanitized/` 目录下的脱敏副本和报告后，再发布。
