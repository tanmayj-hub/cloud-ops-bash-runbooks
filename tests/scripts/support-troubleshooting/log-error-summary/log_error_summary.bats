#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../../../" && pwd)"
  SCRIPT="${REPO_ROOT}/scripts/support-troubleshooting/log-error-summary/log_error_summary.sh"
  LOG_FILE="${BATS_TEST_TMPDIR}/sample-app.log"
  printf '%s\n' \
    'INFO service started' \
    'WARN cache response time exceeded threshold' \
    'ERROR database connection retry failed' \
    'FAILED worker exited unexpectedly' \
    'CRITICAL queue depth high' \
    'INFO done' > "$LOG_FILE"
}

@test "log_error_summary shows help" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"--file"* ]]
}

@test "log_error_summary rejects missing file" {
  run bash "$SCRIPT" --file "${BATS_TEST_TMPDIR}/missing.log"

  [ "$status" -eq 2 ]
  [[ "$output" == *"file does not exist"* ]]
}

@test "log_error_summary counts and prints recent matching lines" {
  run bash "$SCRIPT" --file "$LOG_FILE" --lines 2

  [ "$status" -eq 0 ]
  [[ "$output" == *"ERROR:    1"* ]]
  [[ "$output" == *"WARN:     1"* ]]
  [[ "$output" == *"FAILED:   1"* ]]
  [[ "$output" == *"CRITICAL: 1"* ]]
  [[ "$output" == *"CRITICAL queue depth high"* ]]
}
