#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly DEFAULT_OUTPUT_DIR="./diagnostic-bundles"

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--output-dir <path>] [--help]

Collect basic read-only system diagnostics into a timestamped support bundle.

Options:
  --output-dir <path>  Directory where bundles should be created.
                       Default: ${DEFAULT_OUTPUT_DIR}
  --help, -h           Show this help message.

Collected information:
  - hostname
  - date
  - uptime
  - disk usage
  - memory summary
  - top processes
  - network interfaces, if available

Safety:
  Does not collect secrets, private SSH keys, or full environment variables.
USAGE
}

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'Error: missing required command: %s\n' "$command_name" >&2
    return 2
  fi
}

write_command_output() {
  local output_file="$1"
  shift

  {
    printf '$'
    printf ' %q' "$@"
    printf '\n\n'
    "$@"
  } > "$output_file" 2>&1
}

write_memory_report() {
  local output_file="$1"

  if command -v free >/dev/null 2>&1; then
    write_command_output "$output_file" free -h
  elif [[ -r /proc/meminfo ]]; then
    {
      printf '$ cat /proc/meminfo\n\n'
      cat /proc/meminfo
    } > "$output_file"
  else
    printf 'Memory information is not available on this system.\n' > "$output_file"
  fi
}

write_network_report() {
  local output_file="$1"

  if command -v ip >/dev/null 2>&1; then
    write_command_output "$output_file" ip addr show
  elif command -v ifconfig >/dev/null 2>&1; then
    write_command_output "$output_file" ifconfig -a
  else
    printf 'Network interface command not available. Checked for ip and ifconfig.\n' > "$output_file"
  fi
}

write_top_processes_report() {
  local output_file="$1"

  {
    printf '$ ps --cols 120 -eo pid,ppid,user,comm,%%cpu,%%mem --sort=-%%cpu | head -n 11\n\n'
    ps --cols 120 -eo pid,ppid,user,comm,%cpu,%mem --sort=-%cpu \
      2> >(grep -v 'screen size is bogus' >&2) \
      | head -n 11
  } > "$output_file"
}

main() {
  local output_dir="$DEFAULT_OUTPUT_DIR"
  local timestamp
  local hostname_value
  local bundle_name
  local bundle_dir
  local bundle_archive

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --output-dir)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --output-dir requires a path.\n\n' >&2
          usage >&2
          return 2
        fi
        output_dir="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  if [[ -z "$output_dir" ]]; then
    printf 'Error: output directory cannot be empty.\n' >&2
    return 2
  fi

  require_command hostname
  require_command date
  require_command uptime
  require_command df
  require_command ps
  require_command head
  require_command tar
  require_command grep

  timestamp="$(date +%Y%m%d-%H%M%S)"
  hostname_value="$(hostname | tr -cd '[:alnum:]._-')"
  if [[ -z "$hostname_value" ]]; then
    hostname_value="unknown-host"
  fi

  bundle_name="diagnostic-bundle-${hostname_value}-${timestamp}"
  bundle_dir="${output_dir}/${bundle_name}"
  bundle_archive="${output_dir}/${bundle_name}.tar.gz"

  mkdir -p "$bundle_dir"

  write_command_output "${bundle_dir}/hostname.txt" hostname
  write_command_output "${bundle_dir}/date.txt" date -u
  write_command_output "${bundle_dir}/uptime.txt" uptime
  write_command_output "${bundle_dir}/disk-usage.txt" df -hP
  write_memory_report "${bundle_dir}/memory.txt"
  write_top_processes_report "${bundle_dir}/top-processes.txt"
  write_network_report "${bundle_dir}/network-interfaces.txt"

  {
    printf 'Diagnostic Bundle Summary\n'
    printf 'Created: %s UTC\n' "$(date -u '+%Y-%m-%d %H:%M:%S')"
    printf 'Host: %s\n' "$hostname_value"
    printf 'Safety: no secrets, private SSH keys, or full environment variables collected.\n'
  } > "${bundle_dir}/README.txt"

  tar -czf "$bundle_archive" -C "$output_dir" "$bundle_name"

  printf 'Diagnostic Bundle Collector\n'
  printf 'Bundle folder: %s\n' "$bundle_dir"
  printf 'Compressed bundle: %s\n' "$bundle_archive"
}

main "$@"
