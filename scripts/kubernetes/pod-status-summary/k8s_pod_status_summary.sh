#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME
readonly DEFAULT_NAMESPACE="default"

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--namespace <name>] [--help]

Summarize pod status in a Kubernetes namespace.

Options:
  --namespace <name>  Kubernetes namespace to inspect.
                      Default: ${DEFAULT_NAMESPACE}
  --help, -h          Show this help message.

Exit codes:
  0  Pod status summary completed successfully.
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

main() {
  local namespace="$DEFAULT_NAMESPACE"
  local context_name
  local non_running_pods

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help | -h)
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

  printf 'Kubernetes Pod Status Summary\n'
  printf 'Context: %s\n' "$context_name"
  printf 'Namespace: %s\n' "$namespace"

  printf '\nAll Pods\n'
  printf '%s\n' '------------------------------'
  if ! kubectl get pods --namespace "$namespace" -o wide; then
    printf 'Error: unable to list pods in namespace: %s\n' "$namespace" >&2
    return 2
  fi

  non_running_pods="$(kubectl get pods --namespace "$namespace" --no-headers 2>/dev/null |
    awk '$3 != "Running" && $3 != "Completed"')"

  printf '\nPods Not Running or Completed\n'
  printf '%s\n' '------------------------------'
  if [[ -z "$non_running_pods" ]]; then
    printf 'No pods found outside Running or Completed status.\n'
  else
    printf '%s\n' "$non_running_pods"
  fi
}

main "$@"
