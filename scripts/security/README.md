# Security Scripts

Scripts for SSH login review, file permission checks, and local security audit helpers.

Scripts in this folder should report findings safely and avoid changing security settings by default.

## Available Scripts

| Folder | Purpose |
| --- | --- |
| `failed-ssh-login-summary/` | Summarize failed SSH login attempts from Linux auth logs. |
| `file-permission-audit/` | Report potentially risky file permissions under a target directory. |
