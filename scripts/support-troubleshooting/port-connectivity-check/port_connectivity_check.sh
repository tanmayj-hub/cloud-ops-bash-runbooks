#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly CONNECT_TIMEOUT_SECONDS=5

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} --host <hostname-or-ip> --port <port> [--help]

Check whether a host and port are reachable for basic troubleshooting.

Required:
  --host <hostname-or-ip>  Hostname or IP address to check.
  --port <port>           TCP port number from 1 to 65535.

Options:
  --help, -h              Show this help message.

Exit codes:
  0  Reachable.
  1  Not reachable.
  2  Invalid input or missing dependency.

Safety:
  Performs a basic TCP connectivity check only. Does not install packages
  or modify network configuration.
USAGE
}

is_integer() {
  [[ "${1:-}" =~ ^[0-9]+$ ]]
}

validate_port() {
  local port="$1"

  if ! is_integer "$port"; then
    printf 'Error: port must be numeric.\n' >&2
    return 2
  fi

  if ((port < 1 || port > 65535)); then
    printf 'Error: port must be between 1 and 65535.\n' >&2
    return 2
  fi
}

check_with_nc() {
  local host="$1"
  local port="$2"

  nc -z -w "$CONNECT_TIMEOUT_SECONDS" "$host" "$port" >/dev/null 2>&1
}

check_with_bash_tcp() {
  local host="$1"
  local port="$2"

  timeout "$CONNECT_TIMEOUT_SECONDS" bash -c "cat < /dev/null > \"/dev/tcp/\${1}/\${2}\"" _ "$host" "$port" >/dev/null 2>&1
}

main() {
  local host=""
  local port=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help | -h)
        usage
        return 0
        ;;
      --host)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --host requires a value.\n\n' >&2
          usage >&2
          return 2
        fi
        host="$2"
        shift 2
        ;;
      --port)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --port requires a value.\n\n' >&2
          usage >&2
          return 2
        fi
        port="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  if [[ -z "$host" ]]; then
    printf 'Error: --host is required.\n\n' >&2
    usage >&2
    return 2
  fi

  if [[ -z "$port" ]]; then
    printf 'Error: --port is required.\n\n' >&2
    usage >&2
    return 2
  fi

  validate_port "$port"

  printf 'Port Connectivity Check\n'
  printf 'Target: %s:%s\n' "$host" "$port"
  printf 'Timeout: %s seconds\n\n' "$CONNECT_TIMEOUT_SECONDS"

  if command -v nc >/dev/null 2>&1; then
    if check_with_nc "$host" "$port"; then
      printf 'SUCCESS: %s:%s is reachable.\n' "$host" "$port"
      return 0
    fi
  elif command -v timeout >/dev/null 2>&1; then
    if check_with_bash_tcp "$host" "$port"; then
      printf 'SUCCESS: %s:%s is reachable.\n' "$host" "$port"
      return 0
    fi
  else
    printf 'Error: missing dependency. Install nc or timeout, then try again.\n' >&2
    return 2
  fi

  printf 'FAILURE: %s:%s is not reachable.\n' "$host" "$port"
  return 1
}

main "$@"
