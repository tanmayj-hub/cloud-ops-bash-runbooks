#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_NAME="$(basename "$0")"

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--help] [--dry-run]

Description:
  Short description of the operational task this script supports.

Options:
  --help      Show this help message.
  --dry-run   Show what would happen without making changes.

Safety:
  This template does not perform destructive actions.
USAGE
}

main() {
  local dry_run=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
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

  if [[ "$dry_run" == true ]]; then
    printf 'Dry run enabled. No changes will be made.\n'
  fi

  printf 'Template ready. Replace this message with safe script logic.\n'
}

main "$@"
