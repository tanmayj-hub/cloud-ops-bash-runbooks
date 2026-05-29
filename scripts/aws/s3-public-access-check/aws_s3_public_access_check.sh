#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_NAME

usage() {
  cat <<USAGE
Usage: ${SCRIPT_NAME} --bucket <bucket-name> [--help]

Check S3 bucket public access block configuration in read-only mode.

Required:
  --bucket <bucket-name>  S3 bucket name to inspect.

Options:
  --help, -h              Show this help message.

Exit codes:
  0  Public access block report completed successfully.
  1  Access denied or AWS CLI request failed.
  2  Invalid input or AWS CLI missing.

Safety:
  Read-only only. Does not modify bucket policies or public access settings.
USAGE
}

check_aws_cli() {
  if ! command -v aws >/dev/null 2>&1; then
    printf 'Error: AWS CLI is not installed or not in PATH.\n' >&2
    return 2
  fi
}

main() {
  local bucket_name=""
  local error_file
  local command_status

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help|-h)
        usage
        return 0
        ;;
      --bucket)
        if [[ $# -lt 2 ]]; then
          printf 'Error: --bucket requires a bucket name.\n\n' >&2
          usage >&2
          return 2
        fi
        bucket_name="$2"
        shift 2
        ;;
      *)
        printf 'Error: unknown option: %s\n\n' "$1" >&2
        usage >&2
        return 2
        ;;
    esac
  done

  if [[ -z "$bucket_name" ]]; then
    printf 'Error: --bucket is required.\n\n' >&2
    usage >&2
    return 2
  fi

  check_aws_cli

  error_file="$(mktemp)"
  trap 'rm -f "$error_file"' EXIT

  printf 'AWS S3 Public Access Check\n'
  printf 'Bucket: %s\n\n' "$bucket_name"

  set +e
  aws s3api get-public-access-block \
    --bucket "$bucket_name" \
    --query 'PublicAccessBlockConfiguration' \
    --output table \
    2> "$error_file"
  command_status=$?
  set -e

  if [[ "$command_status" -eq 0 ]]; then
    printf '\nOK: public access block configuration was read successfully.\n'
    return 0
  fi

  if grep -qi 'AccessDenied' "$error_file"; then
    printf 'ACCESS DENIED: unable to read public access block configuration for bucket %s.\n' "$bucket_name" >&2
    printf 'Confirm read-only IAM permissions for s3:GetBucketPublicAccessBlock.\n' >&2
    return 1
  fi

  if grep -qi 'NoSuchPublicAccessBlockConfiguration' "$error_file"; then
    printf 'INFO: no bucket-level public access block configuration was found for bucket %s.\n' "$bucket_name"
    printf 'This script did not modify the bucket.\n'
    return 0
  fi

  printf 'Error: unable to read public access block configuration for bucket %s.\n' "$bucket_name" >&2
  printf 'AWS CLI message: %s\n' "$(head -n 1 "$error_file")" >&2
  return 1
}

main "$@"
