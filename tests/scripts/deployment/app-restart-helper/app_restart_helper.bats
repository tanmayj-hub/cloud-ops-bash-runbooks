#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../../../" && pwd)"
  SCRIPT="${REPO_ROOT}/scripts/deployment/app-restart-helper/app_restart_helper.sh"
  MOCK_ROOT="${BATS_TEST_TMPDIR}/app-restart-helper"
  MOCK_BIN="${MOCK_ROOT}/mock-bin"
  RESTART_LOG="${MOCK_ROOT}/restart.log"
  mkdir -p "$MOCK_BIN"
}

write_systemctl_mock() {
  cat >"${MOCK_BIN}/systemctl" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

command_name=""
service_name=""

for arg in "$@"; do
  case "$arg" in
    --no-pager|--lines=5)
      ;;
    show-environment|status|restart|is-active)
      command_name="$arg"
      ;;
    *)
      if [[ -n "$command_name" && -z "$service_name" && "$command_name" != "show-environment" ]]; then
        service_name="$arg"
      fi
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
  status)
    printf '* %s.service - Sample service\n' "$service_name"
    printf '   Active: %s\n' "${MOCK_SERVICE_STATE:-active}"
    exit 0
    ;;
  restart)
    printf '%s\n' "$service_name" >> "${MOCK_RESTART_LOG}"
    if [[ "${MOCK_RESTART_SHOULD_FAIL:-no}" == "yes" ]]; then
      exit 1
    fi
    exit 0
    ;;
  is-active)
    printf '%s\n' "${MOCK_SERVICE_STATE:-active}"
    if [[ "${MOCK_SERVICE_STATE:-active}" == "active" ]]; then
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
  export MOCK_RESTART_LOG="$RESTART_LOG"
}

@test "app_restart_helper shows help" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"--service"* ]]
  [[ "$output" == *"--dry-run"* ]]
}

@test "app_restart_helper returns 2 when systemctl exists but systemd is unavailable" {
  write_systemctl_mock

  run env MOCK_SYSTEMD_AVAILABLE="no" MOCK_RESTART_LOG="$RESTART_LOG" bash "$SCRIPT" --service nginx --dry-run

  [ "$status" -eq 2 ]
  [[ "$output" == *"systemd is not available on this system"* ]]
  [[ "$output" == *"WSL, containers, or CI runners"* ]]
}

@test "app_restart_helper dry-run shows status and does not restart" {
  write_systemctl_mock

  run env \
    MOCK_SYSTEMD_AVAILABLE="yes" \
    MOCK_SERVICE_STATE="active" \
    MOCK_RESTART_LOG="$RESTART_LOG" \
    bash "$SCRIPT" --service nginx --dry-run

  [ "$status" -eq 0 ]
  [[ "$output" == *"Current status:"* ]]
  [[ "$output" == *"DRY RUN: would run: systemctl restart nginx"* ]]
  [[ "$output" == *"No restart was performed."* ]]
  [ ! -f "$RESTART_LOG" ]
}
