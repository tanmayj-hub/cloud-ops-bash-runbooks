# Role Mapping

This project maps Bash scripts to real responsibilities found in Cloud Engineer, DevOps Engineer, Linux Admin, Support Engineer, and Junior SRE roles.

## Cloud Engineer

Cloud Engineers need safe ways to inspect cloud resources, validate access, and support infrastructure operations.

Relevant scripts:

| Script | Why It Matters |
| --- | --- |
| `scripts/aws/ec2-status-report/aws_ec2_status_report.sh` | Produces a read-only EC2 instance status report. |
| `scripts/aws/s3-public-access-check/aws_s3_public_access_check.sh` | Checks S3 public access block settings as one safe step in a broader exposure review. |
| `scripts/kubernetes/namespace-resource-check/k8s_namespace_resource_check.sh` | Reviews namespace resources for cloud-hosted workloads. |
| `scripts/kubernetes/pod-status-summary/k8s_pod_status_summary.sh` | Highlights unhealthy or incomplete Kubernetes workloads. |
| `scripts/support-troubleshooting/port-connectivity-check/port_connectivity_check.sh` | Validates basic application or network reachability. |
| `scripts/security/file-permission-audit/file_permission_audit.sh` | Supports host-level security review for cloud instances. |

## DevOps Engineer

DevOps Engineers focus on deployment safety, service health, automation quality, and repeatable operational workflows.

Relevant scripts:

| Script | Why It Matters |
| --- | --- |
| `scripts/deployment/validate-env-vars/validate_env_vars.sh` | Confirms required deployment config exists without printing values. |
| `scripts/deployment/backup-before-deploy/backup_before_deploy.sh` | Creates a timestamped backup before deployment. |
| `scripts/deployment/app-restart-helper/app_restart_helper.sh` | Restarts services with dry-run, confirmation, and status checks. |
| `scripts/docker/container-health-check/docker_container_health_check.sh` | Reviews container health and status. |
| `scripts/docker/cleanup-dry-run/docker_cleanup_dry_run.sh` | Plans Docker cleanup without deleting resources. |
| `scripts/monitoring/service-health-check/service_health_check.sh` | Checks whether a deployment-related service is active. |

## Linux Admin

Linux Admins need reliable local host inspection, account review, permissions checks, and service troubleshooting.

Relevant scripts:

| Script | Why It Matters |
| --- | --- |
| `scripts/linux-admin/disk-usage-check/disk_usage_check.sh` | Checks mounted filesystem usage against a threshold. |
| `scripts/linux-admin/top-processes-report/top_processes_report.sh` | Shows CPU and memory heavy processes. |
| `scripts/linux-admin/user-group-audit/user_group_audit.sh` | Reports users, login shells, and groups. |
| `scripts/security/failed-ssh-login-summary/failed_ssh_login_summary.sh` | Summarizes failed SSH login attempts. |
| `scripts/security/file-permission-audit/file_permission_audit.sh` | Reports potentially risky file permissions. |
| `scripts/monitoring/cpu-memory-report/cpu_memory_report.sh` | Captures load, memory, and process health. |

## Support Engineer

Support Engineers need scripts that collect evidence, reduce noisy logs, and prepare clear escalation notes.

Relevant scripts:

| Script | Why It Matters |
| --- | --- |
| `scripts/support-troubleshooting/port-connectivity-check/port_connectivity_check.sh` | Checks whether a customer-facing host and port are reachable. |
| `scripts/support-troubleshooting/log-error-summary/log_error_summary.sh` | Summarizes ERROR, WARN, FAILED, and CRITICAL log lines. |
| `scripts/support-troubleshooting/diagnostic-bundle-collector/diagnostic_bundle_collector.sh` | Collects safe read-only diagnostics for escalation. |
| `scripts/monitoring/disk-threshold-alert/disk_threshold_alert.sh` | Produces concise disk alerts for monitoring workflows. |
| `scripts/docker/container-health-check/docker_container_health_check.sh` | Helps inspect local container status. |
| `scripts/kubernetes/pod-status-summary/k8s_pod_status_summary.sh` | Helps triage Kubernetes pod issues. |

## Junior SRE

Junior SREs need safe signals, repeatable checks, and scripts that can fit into lightweight monitoring or incident response.

Relevant scripts:

| Script | Why It Matters |
| --- | --- |
| `scripts/monitoring/service-health-check/service_health_check.sh` | Provides simple service status checks with meaningful exit codes. |
| `scripts/monitoring/cpu-memory-report/cpu_memory_report.sh` | Captures system pressure indicators. |
| `scripts/monitoring/disk-threshold-alert/disk_threshold_alert.sh` | Produces cron-friendly alert output. |
| `scripts/support-troubleshooting/diagnostic-bundle-collector/diagnostic_bundle_collector.sh` | Gathers common diagnostics safely. |
| `scripts/kubernetes/namespace-resource-check/k8s_namespace_resource_check.sh` | Reviews core Kubernetes namespace resources. |
| `scripts/deployment/app-restart-helper/app_restart_helper.sh` | Demonstrates guarded operational change with confirmation. |

## Cross-Role Skills Demonstrated

- Bash scripting and CLI fluency.
- Linux troubleshooting.
- Cloud and container awareness.
- Safe read-only inspection.
- Input validation and exit codes.
- Documentation and runbook writing.
- ShellCheck, shfmt, Bats, and GitHub Actions.
