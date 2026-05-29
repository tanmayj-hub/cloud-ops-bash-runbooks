# Log Error Summary

## Role

Support Engineer / Linux Admin / Cloud Support

## Real-World Use Case

Use this script when reviewing application or service logs during incident triage. It quickly counts important severity keywords and shows the most recent matching lines for escalation notes.

## Prerequisites

- Bash.
- Standard Linux `grep` and `tail` commands.
- Read access to the target log file.

## Usage

```bash
./log_error_summary.sh --file <path>
./log_error_summary.sh --file <path> --lines 25
./log_error_summary.sh --help
```

## Example Commands

```bash
bash log_error_summary.sh --file /var/log/app.log
bash log_error_summary.sh --file ./examples/sample-app.log --lines 10
```

## Example Output

```text
Log Error Summary
File: ./examples/sample-app.log
Recent matching lines requested: 5

Counts
------------------------------
ERROR:    2
WARN:     1
FAILED:   1
CRITICAL: 1
TOTAL:    5

Recent Matching Lines
------------------------------
12:WARN cache response time exceeded threshold
18:ERROR database connection retry failed
22:FAILED payment worker exited unexpectedly
31:CRITICAL queue depth is above emergency threshold
40:ERROR request timeout from upstream service
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Summary completed successfully.
- `2` - Invalid input or unreadable file.

## Troubleshooting

- If the file cannot be read, check the path and permissions.
- If no matches appear, confirm the log uses uppercase `ERROR`, `WARN`, `FAILED`, or `CRITICAL`.
- If output is too long, lower the `--lines` value.

## Safety Notes

This script is read-only. It does not modify, rotate, truncate, delete, or upload log files.

## Interview Explanation

This script demonstrates a practical support task: reduce a noisy log file into counts and recent evidence that can be shared in an escalation without changing the source log.
