#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly DEFAULT_LINES=50
readonly MATCH_PATTERN='ERROR|WARN|FAILED|CRITICAL'

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} --file <path> [--lines <number>] [--help]

Summarize ERROR, WARN, FAILED, and CRITICAL lines from a log file.

Required:
  --file <path>      Path to the log file.

Options:
  --lines <number>   Number of recent matching lines to show.
                     Default: ${DEFAULT_LINES}
  --help, -h         Show this help message.

Safety:
  Reads the log file only. Does not modify, truncate, or rotate logs.
USAGE
}

is_positive_integer() {
  [[ "${1:-}" =~ ^[1-9][0-9]*$ ]]
}

validate_file() {
  local file_path="$1"

  if [[ ! -e "$file_path" ]]; then
    printf 'Error: file does not exist: %s\n' "$file_path" >&2
    return 2
  fi

  if [[ ! -f "$file_path" ]]; then
    printf 'Error: path is not a regular file: %s\n' "$file_path" >&2
    return 2
  fi

  if [[ ! -r "$file_path" ]]; then
    printf 'Error: file is not readable: %s\n' "$file_path" >&2
    return 2
  fi
}

count_matches() {
  local label="$1"
  local file_path="$2"

  grep -Ec "$label" "$file_path" || true
}

main() {
  local file_path=""
  local line_count="$DEFAULT_LINES"
  local total_matches

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
      --lines)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --lines requires a number.\n\n' >&2
          usage >&2
          return 2
        fi
        line_count="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  if [[ -z "$file_path" ]]; then
    printf 'Error: --file is required.\n\n' >&2
    usage >&2
    return 2
  fi

  if ! is_positive_integer "$line_count"; then
    printf 'Error: --lines must be a positive number.\n' >&2
    return 2
  fi

  validate_file "$file_path"

  total_matches="$(grep -Ec "$MATCH_PATTERN" "$file_path" || true)"

  printf 'Log Error Summary\n'
  printf 'File: %s\n' "$file_path"
  printf 'Recent matching lines requested: %s\n\n' "$line_count"

  printf 'Counts\n'
  printf '%s\n' '------------------------------'
  printf 'ERROR:    %s\n' "$(count_matches 'ERROR' "$file_path")"
  printf 'WARN:     %s\n' "$(count_matches 'WARN' "$file_path")"
  printf 'FAILED:   %s\n' "$(count_matches 'FAILED' "$file_path")"
  printf 'CRITICAL: %s\n' "$(count_matches 'CRITICAL' "$file_path")"
  printf 'TOTAL:    %s\n' "$total_matches"

  printf '\nRecent Matching Lines\n'
  printf '%s\n' '------------------------------'
  if [[ "$total_matches" -eq 0 ]]; then
    printf 'No matching lines found.\n'
  else
    grep -En "$MATCH_PATTERN" "$file_path" | tail -n "$line_count"
  fi
}

main "$@"
