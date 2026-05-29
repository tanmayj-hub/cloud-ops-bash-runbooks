# CPU Memory Report

## Role

Linux Admin / Support Engineer / Cloud Support

## Real-World Use Case

Use this script during performance troubleshooting to quickly capture load average, memory usage, and the processes consuming the most CPU and memory.

## Prerequisites

- Bash.
- Standard Linux `ps`, `head`, and `grep` commands.
- `free` is preferred for memory output, with `/proc/meminfo` used as a fallback.

## Usage

```bash
./cpu_memory_report.sh
./cpu_memory_report.sh --help
```

## Example Commands

```bash
bash cpu_memory_report.sh
```

## Example Output

```text
CPU and Memory Health Report

Load Average
------------------------------
1 min: 0.32, 5 min: 0.25, 15 min: 0.18

Memory Usage
------------------------------
               total        used        free      shared  buff/cache   available
Mem:           7.7Gi       1.4Gi       5.1Gi        18Mi       1.2Gi       6.0Gi

Top CPU Processes
------------------------------
    PID    PPID USER     COMMAND         %CPU %MEM
   1801       1 app      java            35.2 18.4
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Report completed successfully.
- `2` - Invalid input or missing required command.

## Troubleshooting

- If process output is missing, confirm `ps` is installed and works.
- If memory output is limited, confirm `free` is installed or `/proc/meminfo` exists.
- If load average seems high, compare it to CPU core count and review top CPU processes.

## Safety Notes

This script is read-only. It does not kill, restart, renice, or modify processes or system settings.

## Interview Explanation

This script demonstrates a lightweight monitoring report: combine load average, memory usage, and process ranking into a quick health snapshot without changing the system.
