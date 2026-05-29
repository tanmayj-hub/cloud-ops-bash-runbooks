# Failed SSH Login Summary

## Role

Linux Admin / Support Engineer / Cloud Support

## Real-World Use Case

Use this script during security triage or routine server review to summarize failed SSH login attempts from a readable Linux authentication log.

## Prerequisites

- Bash.
- Standard Linux `grep` and `tail` commands.
- Read access to the auth log file.

## Usage

```bash
./failed_ssh_login_summary.sh
./failed_ssh_login_summary.sh --file /var/log/auth.log
./failed_ssh_login_summary.sh --help
```

## Example Commands

```bash
bash failed_ssh_login_summary.sh --file /var/log/auth.log
bash failed_ssh_login_summary.sh --file ./examples/sample-auth.log
```

## Example Output

```text
Failed SSH Login Summary
Log file: ./examples/sample-auth.log
Failed SSH login lines: 3

Recent Failed SSH Login Lines
------------------------------
4:May 29 10:15:22 lab sshd[1201]: Failed password for invalid user test from 203.0.113.10 port 42422 ssh2
7:May 29 10:17:03 lab sshd[1210]: Invalid user admin from 203.0.113.11 port 42424
9:May 29 10:18:42 lab sshd[1220]: Failed password for root from 203.0.113.12 port 42426 ssh2
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Summary completed successfully.
- `2` - Invalid input or log file unavailable.

## Troubleshooting

- If `/var/log/auth.log` does not exist, the system may use `/var/log/secure` or `journalctl`.
- If permission is denied, run with an approved account that can read auth logs.
- If no lines are found, confirm SSH logs are written to the file being inspected.

## Safety Notes

This script is read-only. It does not modify, truncate, rotate, delete, or upload logs.

## Interview Explanation

This script demonstrates a safe security support workflow: validate log access, summarize failed SSH activity, and show recent evidence without changing log files.
