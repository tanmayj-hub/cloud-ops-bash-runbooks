#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly DEFAULT_LIMIT=10

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--limit <number>] [--help]

Show top CPU and memory consuming processes for quick troubleshooting.

Options:
  --limit <number>  Number of processes to show in each section.
                    Default: ${DEFAULT_LIMIT}
  --help, -h        Show this help message.

Safety:
  Uses read-only process reporting commands. Does not stop or modify processes.
USAGE
}

is_positive_integer() {
  [[ "${1:-}" =~ ^[1-9][0-9]*$ ]]
}

validate_limit() {
  local limit="$1"

  if ! is_positive_integer "$limit"; then
    printf 'Error: limit must be a positive number.\n' >&2
    return 2
  fi
}

print_process_section() {
  local title="$1"
  local sort_key="$2"
  local limit="$3"

  printf '\n%s\n' "$title"
  printf '%s\n' '------------------------------'
  ps --cols 120 -eo pid,ppid,user,comm,%cpu,%mem --sort="$sort_key" \
    2> >(grep -v 'screen size is bogus' >&2) \
    | head -n "$((limit + 1))"
}

main() {
  local limit="$DEFAULT_LIMIT"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --limit)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --limit requires a number.\n\n' >&2
          usage >&2
          return 2
        fi
        limit="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  validate_limit "$limit"

  printf 'Top Processes Report\n'
  printf 'Limit: %s processes per section\n' "$limit"

  print_process_section 'Top CPU Processes' '-%cpu' "$limit"
  print_process_section 'Top Memory Processes' '-%mem' "$limit"
}

main "$@"
