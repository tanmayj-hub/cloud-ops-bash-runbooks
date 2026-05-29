# Service Health Check

## Role

Linux Admin / Support Engineer / Cloud Support

## Real-World Use Case

Use this script from a terminal, cron job, or simple monitoring workflow to check whether an expected Linux service is active. It is useful for confirming service status during incident response or after a deployment.

## Prerequisites

- Bash.
- `systemctl`.
- A Linux system where systemd is actually available.
- Permission to read service status.

## Usage

```bash
./service_health_check.sh --service <name>
./service_health_check.sh --help
```

## Example Commands

```bash
bash service_health_check.sh --service ssh
bash service_health_check.sh --service nginx
```

## Example Output

```text
Service Health Check
Service: nginx
State: active
OK: nginx is active/running.
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Service is active/running.
- `1` - Service is inactive/not running.
- `2` - Invalid input, `systemctl` unavailable, or systemd not available.

## Troubleshooting

- If `systemctl` exists but systemd is unavailable, you may be in WSL, a container, or a CI runner.
- If the service is reported inactive, verify the service name and inspect approved service logs.
- If a service name differs by distribution, check `systemctl list-units --type=service`.

## Safety Notes

This script is read-only. It does not start, stop, restart, reload, enable, disable, or modify services.

## Interview Explanation

This script shows a safe monitoring pattern: validate required input, rely on `systemctl is-active`, avoid service changes, and use exit codes that can integrate with cron or lightweight monitoring.
