#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly PROCESS_LIMIT=5

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--help]

Print a simple CPU and memory health report.

Reports:
  - load average
  - memory usage
  - top CPU processes
  - top memory processes

Options:
  --help, -h  Show this help message.

Safety:
  Read-only report only. Does not modify processes or system settings.
USAGE
}

print_load_average() {
  printf '\nLoad Average\n'
  printf '%s\n' '------------------------------'

  if [[ -r /proc/loadavg ]]; then
    awk '{printf "1 min: %s, 5 min: %s, 15 min: %s\n", $1, $2, $3}' /proc/loadavg
  else
    uptime
  fi
}

print_memory_usage() {
  printf '\nMemory Usage\n'
  printf '%s\n' '------------------------------'

  if command -v free >/dev/null 2>&1; then
    free -h
  elif [[ -r /proc/meminfo ]]; then
    awk '
      /^MemTotal:/ {total=$2}
      /^MemAvailable:/ {available=$2}
      END {
        used=total-available
        printf "MemTotal: %.1f MiB\nMemUsed: %.1f MiB\nMemAvailable: %.1f MiB\n", total/1024, used/1024, available/1024
      }
    ' /proc/meminfo
  else
    printf 'Memory information is not available on this system.\n'
  fi
}

print_process_section() {
  local title="$1"
  local sort_key="$2"

  printf '\n%s\n' "$title"
  printf '%s\n' '------------------------------'
  ps --cols 120 -eo pid,ppid,user,comm,%cpu,%mem --sort="$sort_key" \
    2> >(grep -v 'screen size is bogus' >&2) \
    | head -n "$((PROCESS_LIMIT + 1))"
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  if ! command -v ps >/dev/null 2>&1; then
    printf 'Error: missing required command: ps\n' >&2
    return 2
  fi

  if ! command -v head >/dev/null 2>&1; then
    printf 'Error: missing required command: head\n' >&2
    return 2
  fi

  if ! command -v grep >/dev/null 2>&1; then
    printf 'Error: missing required command: grep\n' >&2
    return 2
  fi

  printf 'CPU and Memory Health Report\n'
  print_load_average
  print_memory_usage
  print_process_section 'Top CPU Processes' '-%cpu'
  print_process_section 'Top Memory Processes' '-%mem'
}

main "$@"
