#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly DEFAULT_DEST="./backups"

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} --source <path> [--dest <path>] [--dry-run] [--help]

Create a timestamped tar.gz backup of a target directory before deployment.

Required:
  --source <path>  Source directory to back up.

Options:
  --dest <path>    Destination directory for backups.
                   Default: ${DEFAULT_DEST}
  --dry-run        Show the planned backup without creating it.
  --help, -h       Show this help message.

Exit codes:
  0  Backup completed or dry-run completed.
  2  Invalid input or backup failure.

Safety:
  Does not delete, overwrite source files, or remove old backups.
USAGE
}

main() {
  local source_path=""
  local dest_path="$DEFAULT_DEST"
  local dry_run=false
  local timestamp
  local source_name
  local backup_name
  local backup_path
  local parent_dir
  local base_name
  local collision_count=1

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help | -h)
        usage
        return 0
        ;;
      --source)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --source requires a path.\n\n' >&2
          usage >&2
          return 2
        fi
        source_path="$2"
        shift 2
        ;;
      --dest)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --dest requires a path.\n\n' >&2
          usage >&2
          return 2
        fi
        dest_path="$2"
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

  if [[ -z "$source_path" ]]; then
    printf 'Error: --source is required.\n\n' >&2
    usage >&2
    return 2
  fi

  if [[ ! -d "$source_path" ]]; then
    printf 'Error: source must exist and be a directory: %s\n' "$source_path" >&2
    return 2
  fi

  if [[ -z "$dest_path" ]]; then
    printf 'Error: destination path cannot be empty.\n' >&2
    return 2
  fi

  timestamp="$(date +%Y%m%d-%H%M%S)"
  source_name="$(basename "$source_path")"
  backup_name="${source_name}-${timestamp}-$$.tar.gz"
  backup_path="${dest_path}/${backup_name}"
  parent_dir="$(dirname "$source_path")"
  base_name="$(basename "$source_path")"

  while [[ -e "$backup_path" ]]; do
    backup_name="${source_name}-${timestamp}-$$-${collision_count}.tar.gz"
    backup_path="${dest_path}/${backup_name}"
    collision_count=$((collision_count + 1))
  done

  printf 'Backup Before Deploy\n'
  printf 'Source: %s\n' "$source_path"
  printf 'Destination directory: %s\n' "$dest_path"
  printf 'Backup path: %s\n' "$backup_path"

  if [[ "$dry_run" == true ]]; then
    printf 'DRY RUN: backup archive would be created. No files were written.\n'
    return 0
  fi

  mkdir -p "$dest_path"
  tar -czf "$backup_path" -C "$parent_dir" "$base_name"

  printf 'OK: backup created at %s\n' "$backup_path"
  return 0
}

main "$@"
