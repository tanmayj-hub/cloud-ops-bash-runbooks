#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly DEFAULT_THRESHOLD=80

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--threshold <number>] [--help]

Check mounted filesystem disk usage and warn when usage is above a threshold.

Options:
  --threshold <number>  Warning threshold percentage from 1 to 100.
                        Default: ${DEFAULT_THRESHOLD}
  --help, -h            Show this help message.

Exit codes:
  0  OK. No filesystem exceeded the threshold.
  1  Warning. One or more filesystems exceeded the threshold.
  2  Invalid usage or input.

Safety:
  Uses read-only disk reporting commands. Does not modify filesystems.
USAGE
}

is_integer() {
  [[ "${1:-}" =~ ^[0-9]+$ ]]
}

validate_threshold() {
  local threshold="$1"

  if ! is_integer "$threshold"; then
    printf 'Error: threshold must be a number between 1 and 100.\n' >&2
    return 2
  fi

  if (( threshold < 1 || threshold > 100 )); then
    printf 'Error: threshold must be between 1 and 100.\n' >&2
    return 2
  fi
}

main() {
  local threshold="$DEFAULT_THRESHOLD"
  local warning_found=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --threshold)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --threshold requires a number.\n\n' >&2
          usage >&2
          return 2
        fi
        threshold="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  validate_threshold "$threshold"

  printf 'Disk Usage Check\n'
  printf 'Threshold: %s%%\n\n' "$threshold"
  printf '%-28s %-8s %-8s %-8s %-8s %s\n' 'Filesystem' 'Size' 'Used' 'Avail' 'Use%' 'Mounted on'
  printf '%-28s %-8s %-8s %-8s %-8s %s\n' '----------' '----' '----' '-----' '----' '----------'

  while read -r filesystem size used available use_percent mount_point; do
    local usage_number

    usage_number="${use_percent%%%}"

    printf '%-28s %-8s %-8s %-8s %-8s %s\n' "$filesystem" "$size" "$used" "$available" "$use_percent" "$mount_point"

    if (( usage_number > threshold )); then
      warning_found=true
    fi
  done < <(df -hP | awk 'NR > 1')

  printf '\n'
  if [[ "$warning_found" == true ]]; then
    printf 'WARNING: One or more filesystems are above %s%% usage.\n' "$threshold"
    return 1
  fi

  printf 'OK: No filesystems are above %s%% usage.\n' "$threshold"
  return 0
}

main "$@"
