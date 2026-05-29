#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../../../" && pwd)"
  SCRIPT="${REPO_ROOT}/scripts/deployment/validate-env-vars/validate_env_vars.sh"
}

@test "validate_env_vars shows help" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"--vars"* ]]
}

@test "validate_env_vars rejects missing vars argument" {
  run bash "$SCRIPT"

  [ "$status" -eq 2 ]
  [[ "$output" == *"--vars is required"* ]]
}

@test "validate_env_vars reports missing variables" {
  run bash "$SCRIPT" --vars "THIS_VAR_SHOULD_NOT_EXIST_FOR_TESTS"

  [ "$status" -eq 1 ]
  [[ "$output" == *"THIS_VAR_SHOULD_NOT_EXIST_FOR_TESTS"* ]]
  [[ "$output" == *"MISSING"* ]]
}

@test "validate_env_vars succeeds without printing values" {
  run env APP_ENV="test" API_TOKEN="super-secret-test-value" bash "$SCRIPT" --vars "APP_ENV,API_TOKEN"

  [ "$status" -eq 0 ]
  [[ "$output" == *"APP_ENV"* ]]
  [[ "$output" == *"API_TOKEN"* ]]
  [[ "$output" == *"SET"* ]]
  [[ "$output" != *"super-secret-test-value"* ]]
}
