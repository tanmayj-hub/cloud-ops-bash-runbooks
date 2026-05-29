#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--help]

Show Docker resources that could be cleaned up, without deleting anything.

Options:
  --help, -h  Show this help message.

Exit codes:
  0  Dry-run report completed successfully.
  2  Docker CLI missing, daemon unreachable, or invalid input.

Safety:
  Informational only. Does not run docker rm, docker rmi, docker volume rm,
  docker system prune, or any delete/prune command.
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

print_stopped_containers() {
  printf '\nStopped Containers\n'
  printf '%s\n' '------------------------------'

  if [[ "$(docker ps -a --filter status=exited --filter status=created -q | wc -l)" -eq 0 ]]; then
    printf 'No stopped containers found.\n'
    return 0
  fi

  docker ps -a --filter status=exited --filter status=created \
    --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}'
}

print_dangling_images() {
  printf '\nDangling Images\n'
  printf '%s\n' '------------------------------'

  if [[ "$(docker images --filter dangling=true -q | wc -l)" -eq 0 ]]; then
    printf 'No dangling images found.\n'
    return 0
  fi

  docker images --filter dangling=true --format 'table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}'
}

print_unused_volumes() {
  printf '\nUnused Volumes\n'
  printf '%s\n' '------------------------------'

  if [[ "$(docker volume ls -qf dangling=true | wc -l)" -eq 0 ]]; then
    printf 'No unused volumes found.\n'
    return 0
  fi

  docker volume ls -f dangling=true
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
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

  printf 'Docker Cleanup Dry Run\n'
  printf 'Informational only: no Docker resources will be deleted.\n'

  print_stopped_containers
  print_dangling_images
  print_unused_volumes
}

main "$@"
