#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../../../" && pwd)"
  SCRIPT="${REPO_ROOT}/scripts/security/file-permission-audit/file_permission_audit.sh"
  AUDIT_DIR="${BATS_TEST_TMPDIR}/permission-audit"
  mkdir -p "$AUDIT_DIR"
  printf 'debug\n' >"${AUDIT_DIR}/debug.conf"
  chmod 666 "${AUDIT_DIR}/debug.conf"
  printf '#!/usr/bin/env bash\n' >"${AUDIT_DIR}/run-check.sh"
  chmod 755 "${AUDIT_DIR}/run-check.sh"
}

@test "file_permission_audit shows help" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"--path"* ]]
}

@test "file_permission_audit rejects missing path" {
  run bash "$SCRIPT"

  [ "$status" -eq 2 ]
  [[ "$output" == *"--path is required"* ]]
}

@test "file_permission_audit rejects invalid max depth" {
  run bash "$SCRIPT" --path "$AUDIT_DIR" --max-depth not-a-number

  [ "$status" -eq 2 ]
  [[ "$output" == *"--max-depth must be a non-negative number"* ]]
}

@test "file_permission_audit reports risky permissions without changing them" {
  before_mode="$(stat -c '%a' "${AUDIT_DIR}/debug.conf")"

  run bash "$SCRIPT" --path "$AUDIT_DIR" --max-depth 1

  after_mode="$(stat -c '%a' "${AUDIT_DIR}/debug.conf")"

  [ "$status" -eq 0 ]
  [[ "$output" == *"World-Writable Files and Directories"* ]]
  [[ "$output" == *"debug.conf"* ]]
  [[ "$output" == *"Recommendation"* ]]
  [ "$before_mode" = "$after_mode" ]
}
