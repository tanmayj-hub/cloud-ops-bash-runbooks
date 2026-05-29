#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--help]

Show Docker container health and status summary.

Options:
  --help, -h  Show this help message.

Exit codes:
  0  Docker summary completed successfully.
  2  Docker CLI missing, daemon unreachable, or invalid input.

Safety:
  Read-only only. Does not start, stop, restart, remove, or modify containers.
USAGE
}

check_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    printf 'Error: Docker CLI is not installed or not in PATH.\n' >&2
    return 2
  fi

  if ! docker info >/dev/null 2>&1; then
    printf 'Error: Docker daemon is not reachable. Confirm Docker is running and permissions are correct.\n' >&2
    return 2
  fi
}

print_running_containers() {
  printf '\nRunning Containers\n'
  printf '%s\n' '------------------------------'

  if [[ "$(docker ps -q | wc -l)" -eq 0 ]]; then
    printf 'No running containers found.\n'
    return 0
  fi

  docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
}

print_unhealthy_containers() {
  printf '\nUnhealthy Containers\n'
  printf '%s\n' '------------------------------'

  if [[ "$(docker ps --filter health=unhealthy -q | wc -l)" -eq 0 ]]; then
    printf 'No unhealthy containers found.\n'
    return 0
  fi

  docker ps --filter health=unhealthy --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}'
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

  check_docker

  printf 'Docker Container Health Check\n'
  print_running_containers
  print_unhealthy_containers
}

main "$@"
