#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly PASSWD_FILE="/etc/passwd"
readonly GROUP_FILE="/etc/group"

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--help]

Create a basic read-only local user and group audit report.

Reports:
  - Current local users from ${PASSWD_FILE}
  - Users with login shells
  - Local groups from ${GROUP_FILE}

Options:
  --help, -h  Show this help message.

Safety:
  Uses read-only user and group files. Does not modify users or groups.
USAGE
}

print_users() {
  printf '\nCurrent Local Users\n'
  printf '%s\n' '------------------------------'
  awk -F: '{printf "%-24s UID=%-8s GID=%-8s HOME=%s\n", $1, $3, $4, $6}' "$PASSWD_FILE"
}

print_login_shell_users() {
  printf '\nUsers With Login Shells\n'
  printf '%s\n' '------------------------------'
  awk -F: '$7 !~ /(nologin|false)$/ {printf "%-24s SHELL=%s\n", $1, $7}' "$PASSWD_FILE"
}

print_groups() {
  printf '\nLocal Groups\n'
  printf '%s\n' '------------------------------'
  awk -F: '{printf "%-24s GID=%-8s MEMBERS=%s\n", $1, $3, ($4 == "" ? "-" : $4)}' "$GROUP_FILE"
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help | -h)
        usage
        return 0
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  if [[ ! -r "$PASSWD_FILE" ]]; then
    printf 'Error: cannot read %s.\n' "$PASSWD_FILE" >&2
    return 2
  fi

  if [[ ! -r "$GROUP_FILE" ]]; then
    printf 'Error: cannot read %s.\n' "$GROUP_FILE" >&2
    return 2
  fi

  printf 'User and Group Audit Report\n'
  printf 'Source files: %s, %s\n' "$PASSWD_FILE" "$GROUP_FILE"

  print_users
  print_login_shell_users
  print_groups
}

main "$@"
