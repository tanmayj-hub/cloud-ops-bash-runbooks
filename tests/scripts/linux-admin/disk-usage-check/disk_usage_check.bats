#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../../../" && pwd)"
  SCRIPT="${REPO_ROOT}/scripts/linux-admin/disk-usage-check/disk_usage_check.sh"
}

@test "disk_usage_check shows help" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"--threshold"* ]]
}

@test "disk_usage_check rejects invalid threshold" {
  run bash "$SCRIPT" --threshold not-a-number

  [ "$status" -eq 2 ]
  [[ "$output" == *"threshold must be a number"* ]]
}

@test "disk_usage_check succeeds when threshold is 100" {
  run bash "$SCRIPT" --threshold 100

  [ "$status" -eq 0 ]
  [[ "$output" == *"Disk Usage Check"* ]]
  [[ "$output" == *"OK:"* ]]
}
