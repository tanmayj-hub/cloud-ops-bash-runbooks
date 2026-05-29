#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} --vars "VAR1,VAR2,VAR3" [--help]

Validate required environment variables before deployment.

Required:
  --vars "VAR1,VAR2"  Comma-separated variable names to validate.

Options:
  --help, -h          Show this help message.

Exit codes:
  0  All required variables are set and non-empty.
  1  One or more required variables are missing or empty.
  2  Invalid input.

Safety:
  Prints variable names and status only. Does not print variable values.
USAGE
}

trim_spaces() {
  local value="$1"

  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

is_valid_var_name() {
  [[ "$1" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
}

main() {
  local vars_csv=""
  local missing_found=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --vars)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --vars requires a comma-separated list.\n\n' >&2
          usage >&2
          return 2
        fi
        vars_csv="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  if [[ -z "$vars_csv" ]]; then
    printf 'Error: --vars is required.\n\n' >&2
    usage >&2
    return 2
  fi

  IFS=',' read -r -a required_vars <<< "$vars_csv"

  if [[ "${#required_vars[@]}" -eq 0 ]]; then
    printf 'Error: --vars must include at least one variable name.\n' >&2
    return 2
  fi

  printf 'Deployment Environment Variable Validation\n'
  printf '%-32s %s\n' 'Variable' 'Status'
  printf '%-32s %s\n' '--------' '------'

  for raw_var_name in "${required_vars[@]}"; do
    var_name="$(trim_spaces "$raw_var_name")"

    if [[ -z "$var_name" ]]; then
      printf 'Error: empty variable name found in --vars list.\n' >&2
      return 2
    fi

    if ! is_valid_var_name "$var_name"; then
      printf 'Error: invalid variable name: %s\n' "$var_name" >&2
      return 2
    fi

    if [[ -n "${!var_name:-}" ]]; then
      printf '%-32s %s\n' "$var_name" 'SET'
    else
      printf '%-32s %s\n' "$var_name" 'MISSING'
      missing_found=true
    fi
  done

  if [[ "$missing_found" == true ]]; then
    printf '\nFAIL: one or more required environment variables are missing or empty.\n'
    return 1
  fi

  printf '\nOK: all required environment variables are set and non-empty.\n'
  return 0
}

main "$@"
