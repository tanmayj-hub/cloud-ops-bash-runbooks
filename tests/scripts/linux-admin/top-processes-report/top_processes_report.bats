#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../../../" && pwd)"
  SCRIPT="${REPO_ROOT}/scripts/linux-admin/top-processes-report/top_processes_report.sh"
}

@test "top_processes_report shows help" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"--limit"* ]]
}

@test "top_processes_report rejects invalid limit" {
  run bash "$SCRIPT" --limit 0

  [ "$status" -eq 2 ]
  [[ "$output" == *"limit must be a positive number"* ]]
}

@test "top_processes_report prints CPU and memory sections" {
  run bash "$SCRIPT" --limit 1

  [ "$status" -eq 0 ]
  [[ "$output" == *"Top Processes Report"* ]]
  [[ "$output" == *"Top CPU Processes"* ]]
  [[ "$output" == *"Top Memory Processes"* ]]
}
