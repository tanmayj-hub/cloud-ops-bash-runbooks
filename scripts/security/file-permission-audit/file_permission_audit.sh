#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly DEFAULT_MAX_DEPTH=3

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} --path <directory> [--max-depth <number>] [--help]

Find potentially risky file permissions under a target directory.

Required:
  --path <directory>      Directory to audit.

Options:
  --max-depth <number>    Maximum directory depth to inspect.
                          Default: ${DEFAULT_MAX_DEPTH}
  --help, -h              Show this help message.

Exit codes:
  0  Audit completed successfully.
  2  Invalid input.

Safety:
  Read-only only. Does not change permissions or ownership.
USAGE
}

is_non_negative_integer() {
  [[ "${1:-}" =~ ^[0-9]+$ ]]
}

validate_inputs() {
  local target_path="$1"
  local max_depth="$2"

  if [[ -z "$target_path" ]]; then
    printf 'Error: --path is required.\n\n' >&2
    usage >&2
    return 2
  fi

  if [[ ! -d "$target_path" ]]; then
    printf 'Error: path must exist and be a directory: %s\n' "$target_path" >&2
    return 2
  fi

  if ! is_non_negative_integer "$max_depth"; then
    printf 'Error: --max-depth must be a non-negative number.\n' >&2
    return 2
  fi
}

count_findings() {
  find "$@" -print 2>/dev/null | wc -l
}

print_world_writable() {
  local target_path="$1"
  local max_depth="$2"

  printf '\nWorld-Writable Files and Directories\n'
  printf '%s\n' '------------------------------'
  if [[ "$(count_findings "$target_path" -maxdepth "$max_depth" -perm -0002)" -eq 0 ]]; then
    printf 'No world-writable files or directories found.\n'
    return 0
  fi

  find "$target_path" -maxdepth "$max_depth" -perm -0002 -printf '%M %u:%g %p\n' 2>/dev/null
  printf 'Recommendation: review whether these paths need world-writable permissions.\n'
}

print_setuid_setgid() {
  local target_path="$1"
  local max_depth="$2"

  printf '\nSetuid or Setgid Files\n'
  printf '%s\n' '------------------------------'
  if [[ "$(count_findings "$target_path" -maxdepth "$max_depth" -type f -perm /6000)" -eq 0 ]]; then
    printf 'No setuid or setgid files found.\n'
    return 0
  fi

  find "$target_path" -maxdepth "$max_depth" -type f -perm /6000 -printf '%M %u:%g %p\n' 2>/dev/null
  printf 'Recommendation: confirm these privileged executables are expected and documented.\n'
}

print_world_executable_files() {
  local target_path="$1"
  local max_depth="$2"

  printf '\nWorld-Executable Regular Files\n'
  printf '%s\n' '------------------------------'
  if [[ "$(count_findings "$target_path" -maxdepth "$max_depth" -type f -perm -0001)" -eq 0 ]]; then
    printf 'No world-executable regular files found.\n'
    return 0
  fi

  find "$target_path" -maxdepth "$max_depth" -type f -perm -0001 -printf '%M %u:%g %p\n' 2>/dev/null
  printf 'Recommendation: review executable files in application or config directories and remove execute bits only after approval.\n'
}

main() {
  local target_path=""
  local max_depth="$DEFAULT_MAX_DEPTH"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --path)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --path requires a directory.\n\n' >&2
          usage >&2
          return 2
        fi
        target_path="$2"
        shift 2
        ;;
      --max-depth)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --max-depth requires a number.\n\n' >&2
          usage >&2
          return 2
        fi
        max_depth="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  validate_inputs "$target_path" "$max_depth"

  printf 'File Permission Audit\n'
  printf 'Path: %s\n' "$target_path"
  printf 'Max depth: %s\n' "$max_depth"
  printf 'Mode: read-only audit\n'

  print_world_writable "$target_path" "$max_depth"
  print_setuid_setgid "$target_path" "$max_depth"
  print_world_executable_files "$target_path" "$max_depth"

  printf '\nSummary Recommendation\n'
  printf '%s\n' '------------------------------'
  printf 'Review findings with the application owner before changing permissions. This script made no changes.\n'
}

main "$@"
