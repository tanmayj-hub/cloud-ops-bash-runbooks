#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly DEFAULT_NAMESPACE="default"

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--namespace <name>] [--help]

Show basic workloads and resource visibility in a Kubernetes namespace.

Options:
  --namespace <name>  Kubernetes namespace to inspect.
                      Default: ${DEFAULT_NAMESPACE}
  --help, -h          Show this help message.

Reports:
  - deployments
  - pods
  - services
  - events

Exit codes:
  0  Namespace resource report completed successfully.
  2  Invalid input, kubectl missing, or Kubernetes context unavailable.

Safety:
  Read-only only. Does not modify cluster resources.
USAGE
}

validate_namespace() {
  local namespace="$1"

  if [[ -z "$namespace" ]]; then
    printf 'Error: namespace cannot be empty.\n' >&2
    return 2
  fi
}

check_kubectl() {
  if ! command -v kubectl >/dev/null 2>&1; then
    printf 'Error: kubectl is not installed or not in PATH.\n' >&2
    return 2
  fi
}

check_context() {
  if ! kubectl config current-context >/dev/null 2>&1; then
    printf 'Error: no current Kubernetes context is available.\n' >&2
    return 2
  fi
}

print_resource_section() {
  local title="$1"
  local namespace="$2"
  shift 2

  printf '\n%s\n' "$title"
  printf '%s\n' '------------------------------'
  if ! kubectl get "$@" --namespace "$namespace"; then
    printf 'Unable to read %s in namespace %s.\n' "$title" "$namespace"
  fi
}

main() {
  local namespace="$DEFAULT_NAMESPACE"
  local context_name

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --namespace)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --namespace requires a name.\n\n' >&2
          usage >&2
          return 2
        fi
        namespace="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  validate_namespace "$namespace"
  check_kubectl
  check_context

  context_name="$(kubectl config current-context)"

  printf 'Kubernetes Namespace Resource Check\n'
  printf 'Context: %s\n' "$context_name"
  printf 'Namespace: %s\n' "$namespace"

  print_resource_section 'Deployments' "$namespace" deployments
  print_resource_section 'Pods' "$namespace" pods -o wide
  print_resource_section 'Services' "$namespace" services
  print_resource_section 'Recent Events' "$namespace" events --sort-by=.lastTimestamp
}

main "$@"
