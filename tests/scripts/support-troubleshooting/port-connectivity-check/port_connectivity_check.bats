#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../../../../" && pwd)"
  SCRIPT="${REPO_ROOT}/scripts/support-troubleshooting/port-connectivity-check/port_connectivity_check.sh"
}

@test "port_connectivity_check shows help" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"--host"* ]]
  [[ "$output" == *"--port"* ]]
}

@test "port_connectivity_check rejects invalid port" {
  run bash "$SCRIPT" --host 127.0.0.1 --port 70000

  [ "$status" -eq 2 ]
  [[ "$output" == *"port must be between 1 and 65535"* ]]
}

@test "port_connectivity_check reports unreachable port" {
  run bash "$SCRIPT" --host 127.0.0.1 --port 1

  [ "$status" -eq 1 ]
  [[ "$output" == *"not reachable"* ]]
}

@test "port_connectivity_check succeeds against a local TCP listener" {
  command -v python3 >/dev/null 2>&1 || skip "python3 is required for local TCP listener test"

  port_file="${BATS_TEST_TMPDIR}/tcp-port.txt"
  server_script="${BATS_TEST_TMPDIR}/tcp-server.py"
  cat >"$server_script" <<'PY'
import pathlib
import socket
import sys

port_file = pathlib.Path(sys.argv[1])

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind(("127.0.0.1", 0))
    server.listen(1)
    port_file.write_text(str(server.getsockname()[1]), encoding="utf-8")
    connection, _ = server.accept()
    connection.close()
PY

  python3 "$server_script" "$port_file" &
  server_pid="$!"

  for _ in {1..50}; do
    [[ -s "$port_file" ]] && break
    sleep 0.1
  done

  [[ -s "$port_file" ]] || {
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
    false
  }

  port="$(cat "$port_file")"
  run bash "$SCRIPT" --host 127.0.0.1 --port "$port"

  wait "$server_pid" 2>/dev/null || true

  [ "$status" -eq 0 ]
  [[ "$output" == *"is reachable"* ]]
}
