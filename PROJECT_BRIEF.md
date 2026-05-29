# Project Brief

## Project Purpose

`cloud-ops-bash-runbooks` is a professional Bash scripting repository for practical Cloud, DevOps, Linux Admin, Support, and Junior SRE workflows.

The project helps learners and junior engineers practice real operational tasks while building scripts that are safe, documented, testable, and suitable for portfolio and interview discussion.

## Target Users

- Beginner to intermediate Cloud and DevOps learners.
- Linux Admin and Support candidates preparing for technical interviews.
- Junior SRE candidates learning operational runbooks.
- Junior engineers who want practical automation examples.
- Teams looking for starter patterns for shell-based operational scripts.

## Version 1 Scope

Version 1 contains 20 scripts across eight categories:

1. `scripts/linux-admin/disk-usage-check/disk_usage_check.sh`
2. `scripts/linux-admin/top-processes-report/top_processes_report.sh`
3. `scripts/linux-admin/user-group-audit/user_group_audit.sh`
4. `scripts/support-troubleshooting/port-connectivity-check/port_connectivity_check.sh`
5. `scripts/support-troubleshooting/log-error-summary/log_error_summary.sh`
6. `scripts/support-troubleshooting/diagnostic-bundle-collector/diagnostic_bundle_collector.sh`
7. `scripts/monitoring/service-health-check/service_health_check.sh`
8. `scripts/monitoring/cpu-memory-report/cpu_memory_report.sh`
9. `scripts/monitoring/disk-threshold-alert/disk_threshold_alert.sh`
10. `scripts/deployment/validate-env-vars/validate_env_vars.sh`
11. `scripts/deployment/backup-before-deploy/backup_before_deploy.sh`
12. `scripts/deployment/app-restart-helper/app_restart_helper.sh`
13. `scripts/docker/container-health-check/docker_container_health_check.sh`
14. `scripts/docker/cleanup-dry-run/docker_cleanup_dry_run.sh`
15. `scripts/kubernetes/pod-status-summary/k8s_pod_status_summary.sh`
16. `scripts/kubernetes/namespace-resource-check/k8s_namespace_resource_check.sh`
17. `scripts/aws/ec2-status-report/aws_ec2_status_report.sh`
18. `scripts/aws/s3-public-access-check/aws_s3_public_access_check.sh`
19. `scripts/security/failed-ssh-login-summary/failed_ssh_login_summary.sh`
20. `scripts/security/file-permission-audit/file_permission_audit.sh`

## Quality Standards

- Use Bash for all scripts unless a documented exception is approved.
- Start scripts with `#!/usr/bin/env bash`.
- Use `set -euo pipefail` where appropriate.
- Prefer readable functions over long unstructured command sequences.
- Include `--help` output in every script.
- Validate user input and required dependencies.
- Use clear exit codes and error messages.
- Keep scripts small enough to understand and explain.
- Add tests for behavior that can be tested safely.
- Pass ShellCheck before merging.
- Keep formatting consistent with shfmt.

## Safety Standards

- Do not include secrets, tokens, private keys, real AWS account IDs, ARNs, or private data.
- Prefer read-only commands for audit, reporting, and troubleshooting scripts.
- Do not add destructive commands by default.
- Any state-changing command must be protected with `--dry-run` and explicit confirmation.
- Document required permissions before a script is used.
- Avoid commands that delete, overwrite, restart services, or modify resources unless the safety behavior is reviewed and documented.
- Use sample data in `examples/` instead of real production data.

## Documentation Standards

Each script folder should include a `README.md`.

Each script should document:

- Role or job function.
- Real-world use case.
- Requirements and dependencies.
- Usage examples.
- Example output.
- Input options.
- Exit codes.
- Troubleshooting notes.
- Safety notes.
- Interview explanation.

Documentation should be practical, job-focused, and beginner-friendly.

## Version 1 Readiness

Version 1 is suitable for portfolio and interview sharing after final review, because it includes:

- 20 job-focused Bash scripts.
- Per-script documentation and example output.
- ShellCheck workflow.
- shfmt workflow.
- Bats test workflow.
- Local tests for important safe scripts.
- Safety guidance for secrets, destructive commands, cloud access, and private data.
