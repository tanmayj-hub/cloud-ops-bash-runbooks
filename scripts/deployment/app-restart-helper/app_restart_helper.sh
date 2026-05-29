#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} --service <name> [--dry-run] [--help]

Safely restart an application service with pre-checks.

Required:
  --service <name>  Service name to restart.

Options:
  --dry-run         Show planned action without restarting.
  --help, -h        Show this help message.

Exit codes:
  0  Dry-run completed, restart completed, or user cancelled safely.
  1  Restart attempted but service is not active after restart.
  2  Invalid input or systemctl unavailable.
  3  Restart command failed.

Safety:
  Shows current status first. Dry-run does not restart. Normal mode asks for
  explicit confirmation before restart.
USAGE
}

print_service_status() {
  local service_name="$1"

  systemctl --no-pager --lines=5 status "$service_name" || true
}

main() {
  local service_name=""
  local dry_run=false
  local confirmation
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
      --dry-run)
        dry_run=true
        shift
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

  printf 'Application Restart Helper\n'
  printf 'Service: %s\n\n' "$service_name"
  printf 'Current status:\n'
  print_service_status "$service_name"

  if [[ "$dry_run" == true ]]; then
    printf '\nDRY RUN: would run: systemctl restart %s\n' "$service_name"
    printf 'No restart was performed.\n'
    return 0
  fi

  printf '\nType yes to restart service "%s": ' "$service_name"
  read -r confirmation

  if [[ "$confirmation" != "yes" ]]; then
    printf 'Cancelled: no restart performed.\n'
    return 0
  fi

  if ! systemctl restart "$service_name"; then
    printf 'ERROR: restart command failed for %s.\n' "$service_name" >&2
    return 3
  fi

  printf '\nStatus after restart:\n'
  print_service_status "$service_name"

  service_state="$(systemctl is-active "$service_name" 2>/dev/null || true)"
  if [[ "$service_state" == "active" ]]; then
    printf '\nOK: %s is active after restart.\n' "$service_name"
    return 0
  fi

  printf '\nWARNING: %s is not active after restart. Current state: %s\n' "$service_name" "$service_state"
  return 1
}

main "$@"
