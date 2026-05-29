# Top Processes Report

## Role

Linux Admin / Support Engineer / Cloud Support

## Real-World Use Case

Use this script when a server feels slow, CPU usage is high, memory pressure is suspected, or a support ticket needs quick process-level evidence.

## Prerequisites

- Bash.
- Standard Linux `ps`, `head`, and `grep` commands.
- Permission to view process information on the host.

## Usage

```bash
./top_processes_report.sh
./top_processes_report.sh --limit 5
./top_processes_report.sh --help
```

## Example Commands

```bash
bash top_processes_report.sh
bash top_processes_report.sh --limit 15
```

## Example Output

```text
Top Processes Report
Limit: 3 processes per section

Top CPU Processes
------------------------------
    PID    PPID USER     COMMAND         %CPU %MEM
   1821       1 app      java            47.2 18.4
   2440    1821 app      worker          22.5  5.1
    901       1 root     containerd       4.0  1.3

Top Memory Processes
------------------------------
    PID    PPID USER     COMMAND         %CPU %MEM
   1821       1 app      java            47.2 18.4
   1188       1 mysql    mysqld           2.3 12.9
   2440    1821 app      worker          22.5  5.1
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Report completed successfully.
- `2` - Invalid usage or input.

## Troubleshooting

- If the script reports `limit must be a positive number`, pass a whole number such as `10`.
- If process names appear truncated, use the PID to inspect the process with other approved tools.
- If expected processes are missing, confirm the script is running on the correct host or container.

## Safety Notes

This script is read-only. It does not kill, restart, renice, or modify processes.

## Interview Explanation

This script demonstrates a common support workflow: quickly identify high CPU and memory consumers, format the results clearly, validate options, and avoid unsafe process changes.
