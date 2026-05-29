# Disk Usage Check

## Role

Linux Admin / Support Engineer / Cloud Support

## Real-World Use Case

Use this script during routine system checks or incident triage to quickly identify mounted filesystems that are close to full. Disk pressure can cause failed deployments, application errors, log write failures, and database issues.

## Prerequisites

- Bash.
- Standard Linux `df` and `awk` commands.
- Permission to run read-only system inspection commands.

## Usage

```bash
./disk_usage_check.sh
./disk_usage_check.sh --threshold 90
./disk_usage_check.sh --help
```

## Example Commands

```bash
bash disk_usage_check.sh
bash disk_usage_check.sh --threshold 75
```

## Example Output

```text
Disk Usage Check
Threshold: 80%

Filesystem                   Size     Used     Avail    Use%     Mounted on
----------                   ----     ----     -----    ----     ----------
/dev/sda1                    40G      26G      14G      65%      /
/dev/sdb1                    100G     88G      12G      88%      /data

WARNING: One or more filesystems are above 80% usage.
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - OK. No filesystem exceeded the threshold.
- `1` - Warning. One or more filesystems exceeded the threshold.
- `2` - Invalid usage or input.

## Troubleshooting

- If the script reports `threshold must be a number`, pass a whole number such as `80`.
- If output is empty or unusual, confirm `df -hP` works on the host.
- If a filesystem is unexpectedly high, investigate log growth, temporary files, application data, or mounted volumes.

## Safety Notes

This script is read-only. It does not delete files, resize partitions, unmount filesystems, or modify system configuration.

## Interview Explanation

This script shows a practical Linux Admin troubleshooting workflow: collect disk usage from standard tools, validate user input, compare usage against a configurable threshold, and return meaningful exit codes for automation or monitoring.
