#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} --service <name> [--help]

Check whether a Linux service is active using systemctl.

Required:
  --service <name>  Service name to check.

Options:
  --help, -h        Show this help message.

Exit codes:
  0  Service is active/running.
  1  Service is inactive/not running.
  2  Invalid input or systemctl unavailable.

Safety:
  Read-only check only. Does not start, stop, restart, reload, or modify
  the service.
USAGE
}

main() {
  local service_name=""
  local service_state

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --service)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --service requires a name.\n\n' >&2
          usage >&2
          return 2
        fi
        service_name="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  if [[ -z "$service_name" ]]; then
    printf 'Error: --service is required.\n\n' >&2
    usage >&2
    return 2
  fi

  if ! command -v systemctl >/dev/null 2>&1; then
    printf 'Error: systemctl is unavailable. This system may not use systemd.\n' >&2
    return 2
  fi

  service_state="$(systemctl is-active "$service_name" 2>/dev/null || true)"

  printf 'Service Health Check\n'
  printf 'Service: %s\n' "$service_name"
  printf 'State: %s\n' "$service_state"

  if [[ "$service_state" == "active" ]]; then
    printf 'OK: %s is active/running.\n' "$service_name"
    return 0
  fi

  printf 'ALERT: %s is inactive/not running.\n' "$service_name"
  return 1
}

main "$@"
