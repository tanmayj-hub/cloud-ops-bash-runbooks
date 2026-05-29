#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../../../" && pwd)"
  SCRIPT="${REPO_ROOT}/scripts/deployment/backup-before-deploy/backup_before_deploy.sh"
  TEST_ROOT="${BATS_TEST_TMPDIR}/backup-before-deploy"
  SOURCE_DIR="${TEST_ROOT}/source"
  DEST_DIR="${TEST_ROOT}/backups"
  mkdir -p "$SOURCE_DIR"
  printf 'sample file\n' > "${SOURCE_DIR}/app.txt"
}

@test "backup_before_deploy shows help" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"--source"* ]]
}

@test "backup_before_deploy rejects missing source" {
  run bash "$SCRIPT"

  [ "$status" -eq 2 ]
  [[ "$output" == *"--source is required"* ]]
}

@test "backup_before_deploy dry-run does not create archive" {
  run bash "$SCRIPT" --source "$SOURCE_DIR" --dest "$DEST_DIR" --dry-run

  [ "$status" -eq 0 ]
  [[ "$output" == *"DRY RUN"* ]]
  [ ! -d "$DEST_DIR" ]
}

@test "backup_before_deploy creates tar.gz archive" {
  run bash "$SCRIPT" --source "$SOURCE_DIR" --dest "$DEST_DIR"

  [ "$status" -eq 0 ]
  [[ "$output" == *"OK: backup created"* ]]
  archive_count="$(find "$DEST_DIR" -maxdepth 1 -name '*.tar.gz' | wc -l)"
  [ "$archive_count" -eq 1 ]
}
