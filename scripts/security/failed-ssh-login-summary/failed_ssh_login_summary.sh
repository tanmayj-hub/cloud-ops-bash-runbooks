#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly DEFAULT_AUTH_LOG="/var/log/auth.log"
readonly RECENT_LINE_LIMIT=20
readonly FAILED_SSH_PATTERN='sshd.*(Failed password|Invalid user|authentication failure|Failed publickey)'

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--file <path>] [--help]

Summarize failed SSH login attempts from Linux auth logs.

Options:
  --file <path>  Auth log file to inspect.
                 Default: ${DEFAULT_AUTH_LOG}
  --help, -h     Show this help message.

Exit codes:
  0  Summary completed successfully.
  2  Invalid input or log file unavailable.

Safety:
  Read-only only. Does not modify, truncate, rotate, delete, or upload logs.
USAGE
}

validate_file() {
  local file_path="$1"

  if [[ ! -e "$file_path" ]]; then
    printf 'Error: auth log file does not exist: %s\n' "$file_path" >&2
    printf 'Note: some Linux systems use /var/log/secure or journalctl instead of /var/log/auth.log.\n' >&2
    return 2
  fi

  if [[ ! -f "$file_path" ]]; then
    printf 'Error: path is not a regular file: %s\n' "$file_path" >&2
    return 2
  fi

  if [[ ! -r "$file_path" ]]; then
    printf 'Error: auth log file is not readable: %s\n' "$file_path" >&2
    return 2
  fi
}

main() {
  local file_path="$DEFAULT_AUTH_LOG"
  local failed_count

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --file)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --file requires a path.\n\n' >&2
          usage >&2
          return 2
        fi
        file_path="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  validate_file "$file_path"

  failed_count="$(grep -Eic "$FAILED_SSH_PATTERN" "$file_path" || true)"

  printf 'Failed SSH Login Summary\n'
  printf 'Log file: %s\n' "$file_path"
  printf 'Failed SSH login lines: %s\n' "$failed_count"

  printf '\nRecent Failed SSH Login Lines\n'
  printf '%s\n' '------------------------------'
  if [[ "$failed_count" -eq 0 ]]; then
    printf 'No failed SSH login lines found.\n'
  else
    grep -Ein "$FAILED_SSH_PATTERN" "$file_path" | tail -n "$RECENT_LINE_LIMIT"
  fi
}

main "$@"
