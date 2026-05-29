# App Restart Helper

## Role

DevOps Engineer / Linux Admin / Cloud Support

## Real-World Use Case

Use this script when an application service must be restarted during a deployment or recovery workflow. It shows current status first, supports dry-run, and requires explicit confirmation before restarting.

## Prerequisites

- Bash.
- `systemctl`.
- A Linux system where systemd is actually available.
- Permission to view and restart the target service.

## Usage

```bash
./app_restart_helper.sh --service <name> --dry-run
./app_restart_helper.sh --service <name>
./app_restart_helper.sh --help
```

## Example Commands

```bash
bash app_restart_helper.sh --service nginx --dry-run
bash app_restart_helper.sh --service nginx
```

## Example Output

```text
Application Restart Helper
Service: nginx

Current status:
...systemctl status output...

DRY RUN: would run: systemctl restart nginx
No restart was performed.
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Dry-run completed, restart completed, or user cancelled safely.
- `1` - Restart was attempted but service is not active after restart.
- `2` - Invalid input, `systemctl` unavailable, or systemd not available.
- `3` - Restart command failed.

## Troubleshooting

- If `systemctl` exists but systemd is unavailable, you may be in WSL, a container, or a CI runner.
- If restart fails, inspect service logs and unit configuration using approved operational procedures.
- If the service is inactive after restart, verify dependencies, configuration, ports, and recent deployment changes.

## Safety Notes

This script can restart a service only after explicit confirmation. Use `--dry-run` first when documenting or reviewing a deployment plan.

## Interview Explanation

This script demonstrates a safe operational helper: inspect current state, support dry-run, require confirmation for a state-changing action, verify post-action status, and return meaningful exit codes.
