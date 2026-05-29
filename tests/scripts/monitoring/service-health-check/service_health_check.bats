#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../../../" && pwd)"
  SCRIPT="${REPO_ROOT}/scripts/monitoring/service-health-check/service_health_check.sh"
  MOCK_ROOT="${BATS_TEST_TMPDIR}/service-health-check"
  MOCK_BIN="${MOCK_ROOT}/mock-bin"
  mkdir -p "$MOCK_BIN"
}

write_systemctl_mock() {
  cat >"${MOCK_BIN}/systemctl" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

command_name=""

for arg in "$@"; do
  case "$arg" in
    --no-pager|--lines=5)
      ;;
    show-environment|is-active|status|restart)
      command_name="$arg"
      ;;
  esac
done

case "$command_name" in
  show-environment)
    if [[ "${MOCK_SYSTEMD_AVAILABLE:-yes}" == "yes" ]]; then
      exit 0
    fi
    printf '%s\n' "System has not been booted with systemd as init system (PID 1). Can't operate." >&2
    exit 1
    ;;
  is-active)
    printf '%s\n' "${MOCK_SERVICE_STATE:-inactive}"
    if [[ "${MOCK_SERVICE_STATE:-inactive}" == "active" ]]; then
      exit 0
    fi
    exit 3
    ;;
  *)
    printf 'unexpected systemctl arguments: %s\n' "$*" >&2
    exit 1
    ;;
esac
EOF
  chmod +x "${MOCK_BIN}/systemctl"
  export PATH="${MOCK_BIN}:${PATH}"
}

@test "service_health_check shows help" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"--service"* ]]
}

@test "service_health_check rejects missing service" {
  run bash "$SCRIPT"

  [ "$status" -eq 2 ]
  [[ "$output" == *"--service is required"* ]]
}

@test "service_health_check returns 2 when systemctl exists but systemd is unavailable" {
  write_systemctl_mock

  run env MOCK_SYSTEMD_AVAILABLE="no" bash "$SCRIPT" --service nginx

  [ "$status" -eq 2 ]
  [[ "$output" == *"systemd is not available on this system"* ]]
  [[ "$output" == *"WSL, containers, or CI runners"* ]]
}

@test "service_health_check reports an active service when systemd is available" {
  write_systemctl_mock

  run env MOCK_SYSTEMD_AVAILABLE="yes" MOCK_SERVICE_STATE="active" bash "$SCRIPT" --service nginx

  [ "$status" -eq 0 ]
  [[ "$output" == *"Service: nginx"* ]]
  [[ "$output" == *"State: active"* ]]
  [[ "$output" == *"OK: nginx is active/running."* ]]
}
