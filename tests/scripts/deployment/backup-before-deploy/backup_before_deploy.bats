#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../../../" && pwd)"
  SCRIPT="${REPO_ROOT}/scripts/deployment/backup-before-deploy/backup_before_deploy.sh"
  TEST_ROOT="${BATS_TEST_TMPDIR}/backup-before-deploy"
  SOURCE_DIR="${TEST_ROOT}/source"
  DEST_DIR="${TEST_ROOT}/backups"
  MOCK_BIN="${TEST_ROOT}/mock-bin"
  mkdir -p "$SOURCE_DIR"
  printf 'sample file\n' >"${SOURCE_DIR}/app.txt"
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

@test "backup_before_deploy creates unique names for two backups in the same second" {
  mkdir -p "$MOCK_BIN"
  cat >"${MOCK_BIN}/date" <<'EOF'
#!/usr/bin/env bash
printf '20260529-153000\n'
EOF
  chmod +x "${MOCK_BIN}/date"
  export PATH="${MOCK_BIN}:${PATH}"

  run bash "$SCRIPT" --source "$SOURCE_DIR" --dest "$DEST_DIR"
  [ "$status" -eq 0 ]

  run bash "$SCRIPT" --source "$SOURCE_DIR" --dest "$DEST_DIR"
  [ "$status" -eq 0 ]

  archive_count="$(find "$DEST_DIR" -maxdepth 1 -name '*.tar.gz' | wc -l)"
  [ "$archive_count" -eq 2 ]

  archive_list="$(find "$DEST_DIR" -maxdepth 1 -name '*.tar.gz' -printf '%f\n' | sort)"
  unique_archive_count="$(printf '%s\n' "$archive_list" | uniq | wc -l)"
  [ "$unique_archive_count" -eq 2 ]
}
