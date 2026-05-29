# Troubleshooting Guide

Use this guide when a script fails, returns an unexpected exit code, or produces confusing output.

## First Checks

Start with the basics:

- Run the script with `--help`.
- Confirm you are using Bash, not another shell.
- Confirm required tools are installed.
- Confirm input files and directories exist.
- Confirm the current user has read permission.
- Confirm no real secrets or private data are being used as sample input.
- Read the script folder `README.md` for role-specific notes.

## Common Exit Codes

Most scripts follow this pattern:

| Exit Code | Meaning |
| --- | --- |
| `0` | Success, OK, or report completed. |
| `1` | Warning, not reachable, missing resource, or check failed in an expected way. |
| `2` | Invalid input, missing dependency, unreadable file, or unavailable context. |
| `3` | State-changing operation failed after confirmation, used only where documented. |

Always check each script README because some scripts have script-specific meanings.

## Common Issues

### Permission Denied

If the script itself is not executable, either run it with Bash:

```bash
bash path/to/script.sh --help
```

Or make it executable:

```bash
chmod +x path/to/script.sh
```

Avoid `sudo` unless the script documentation clearly explains why elevated permissions are required.

### Command Not Found

Install the missing dependency through your normal system process. Common optional tools include:

- `docker` for Docker scripts.
- `kubectl` for Kubernetes scripts.
- `aws` for AWS scripts.
- `systemctl` for systemd service scripts.
- `shellcheck`, `shfmt`, and `bats` for local quality checks.

### Missing Log File

Some Linux distributions use different auth log paths:

- Debian/Ubuntu often use `/var/log/auth.log`.
- RHEL/CentOS/Amazon Linux often use `/var/log/secure`.
- Some systems use `journalctl`.

Use `--file <path>` when a script supports it.

### AWS Access Problems

Check:

- AWS CLI is installed.
- The correct profile or SSO session is active.
- Region is configured or passed with `--region`.
- IAM permissions are read-only and include the actions listed in the script README.

Do not paste real access keys, account IDs, ARNs, or private data into issues.

### Docker Daemon Unreachable

Check:

- Docker Desktop or Docker Engine is running.
- Your user has permission to access the Docker daemon.
- The script is running in the environment where Docker is available.

The Docker scripts are informational and do not prune or delete resources.

### Kubernetes Context Unavailable

Check:

```bash
kubectl config current-context
kubectl config get-contexts
```

Confirm the namespace exists and that your RBAC permissions allow read access.

### Tests Do Not Run

If `bats` is missing, install Bats first. CI installs it automatically.

Run:

```bash
bats tests
```

For linting:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shellcheck
```

## Escalation Notes

When documenting a problem, include:

- Script name.
- Command used.
- Exit code.
- Sanitized output.
- Operating system and shell version.
- Tool versions, such as `aws --version` or `kubectl version --client`.
- Safe sample input or mock data.

Never include secrets, tokens, private keys, private logs, real AWS account IDs, ARNs, customer data, or production-only identifiers.
