#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly DEFAULT_THRESHOLD=85

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--threshold <number>] [--help]

Check disk usage and print cron-friendly alert messages when threshold is exceeded.

Options:
  --threshold <number>  Alert threshold percentage from 1 to 100.
                        Default: ${DEFAULT_THRESHOLD}
  --help, -h            Show this help message.

Exit codes:
  0  OK. No filesystems exceeded the threshold.
  1  Alert. One or more filesystems exceeded the threshold.
  2  Invalid input.

Safety:
  Read-only disk usage check. Does not modify filesystems.
USAGE
}

is_integer() {
  [[ "${1:-}" =~ ^[0-9]+$ ]]
}

validate_threshold() {
  local threshold="$1"

  if ! is_integer "$threshold"; then
    printf 'CRITICAL invalid_input: threshold must be numeric\n' >&2
    return 2
  fi

  if (( threshold < 1 || threshold > 100 )); then
    printf 'CRITICAL invalid_input: threshold must be between 1 and 100\n' >&2
    return 2
  fi
}

main() {
  local threshold="$DEFAULT_THRESHOLD"
  local alert_found=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --threshold)
        if [[ $# -lt 2 ]]; then
          printf 'CRITICAL invalid_input: --threshold requires a number\n\n' >&2
          usage >&2
          return 2
        fi
        threshold="$2"
        shift 2
        ;;
      *)
        printf 'CRITICAL invalid_input: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  validate_threshold "$threshold"

  while read -r filesystem size used available use_percent mount_point; do
    local usage_number

    usage_number="${use_percent%%%}"

    if (( usage_number > threshold )); then
      printf 'CRITICAL disk_usage filesystem=%s mount=%s usage=%s threshold=%s%% size=%s used=%s available=%s\n' \
        "$filesystem" "$mount_point" "$use_percent" "$threshold" "$size" "$used" "$available"
      alert_found=true
    fi
  done < <(df -hP | awk 'NR > 1')

  if [[ "$alert_found" == true ]]; then
    return 1
  fi

  printf 'OK disk_usage all_filesystems_below_threshold threshold=%s%%\n' "$threshold"
  return 0
}

main "$@"
