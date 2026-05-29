#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} [--region <aws-region>] [--help]

Generate a read-only EC2 instance status report.

Options:
  --region <aws-region>  AWS region to query. If omitted, the AWS CLI default
                         region or environment configuration is used.
  --help, -h             Show this help message.

Exit codes:
  0  EC2 report completed successfully.
  1  AWS CLI request failed.
  2  Invalid input, AWS CLI missing, or AWS credentials/config unavailable.

Safety:
  Read-only only. Does not start, stop, terminate, tag, or modify instances.
USAGE
}

check_aws_cli() {
  if ! command -v aws >/dev/null 2>&1; then
    printf 'Error: AWS CLI is not installed or not in PATH.\n' >&2
    return 2
  fi
}

check_aws_credentials() {
  if ! aws sts get-caller-identity "$@" >/dev/null 2>&1; then
    printf 'Error: AWS credentials or configuration are unavailable or invalid.\n' >&2
    return 2
  fi
}

main() {
  local region=""
  local -a aws_args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --region)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --region requires a value.\n\n' >&2
          usage >&2
          return 2
        fi
        region="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  if [[ -n "$region" ]]; then
    aws_args+=(--region "$region")
  fi

  check_aws_cli
  check_aws_credentials "${aws_args[@]}"

  printf 'AWS EC2 Status Report\n'
  if [[ -n "$region" ]]; then
    printf 'Region: %s\n' "$region"
  else
    printf 'Region: AWS CLI default\n'
  fi
  printf '\n'

  if ! aws ec2 describe-instances "${aws_args[@]}" \
    --query "Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,Type:InstanceType,PrivateIp:PrivateIpAddress,PublicIp:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value}" \
    --output table; then
    printf 'Error: unable to describe EC2 instances. Check region, credentials, and IAM permissions.\n' >&2
    return 1
  fi
}

main "$@"
