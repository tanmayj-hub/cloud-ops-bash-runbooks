#!/usr/bin/env bats

@test "script shows help" {
  run bash path/to/script.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "script rejects unknown option" {
  run bash path/to/script.sh --not-a-real-option
  [ "$status" -ne 0 ]
  [[ "$output" == *"unknown option"* ]]
}
