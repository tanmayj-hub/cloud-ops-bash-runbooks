# Disk Threshold Alert

## Role

Linux Admin / Support Engineer / Cloud Support

## Real-World Use Case

Use this script from cron or lightweight monitoring to alert when mounted filesystems exceed a configured disk usage threshold.

## Prerequisites

- Bash.
- Standard Linux `df` and `awk` commands.
- Permission to run read-only disk usage checks.

## Usage

```bash
./disk_threshold_alert.sh
./disk_threshold_alert.sh --threshold 90
./disk_threshold_alert.sh --help
```

## Example Commands

```bash
bash disk_threshold_alert.sh
bash disk_threshold_alert.sh --threshold 85
```

## Example Output

```text
CRITICAL disk_usage filesystem=/dev/sdb1 mount=/data usage=92% threshold=85% size=100G used=92G available=8G
```

When no filesystem exceeds the threshold:

```text
OK disk_usage all_filesystems_below_threshold threshold=85%
```

See `examples/example-output.txt` for sample output.

## Exit Codes

- `0` - OK. No filesystems exceeded the threshold.
- `1` - Alert. One or more filesystems exceeded the threshold.
- `2` - Invalid input.

## Troubleshooting

- If the threshold is rejected, use a whole number from `1` to `100`.
- If output is unexpected, confirm `df -hP` works on the host.
- If alerts are noisy, review mounted temporary filesystems and adjust the monitoring design before suppressing important signals.

## Safety Notes

This script is read-only. It does not delete files, resize disks, unmount filesystems, or modify cron configuration.

## Interview Explanation

This script demonstrates a cron-friendly monitoring pattern: concise `OK` or `CRITICAL` output, input validation, clear exit codes, and safe read-only system inspection.
