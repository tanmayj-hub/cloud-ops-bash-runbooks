# cloud-ops-bash-runbooks

Professional, beginner-friendly Bash runbooks for Cloud, DevOps, Linux Admin, Support, and Junior SRE workflows.

## Project Overview

`cloud-ops-bash-runbooks` is a practical Bash scripting repository built around real operational tasks: checking Linux systems, reviewing logs, validating deployments, collecting diagnostics, inspecting Docker and Kubernetes resources, and running safe cloud/security checks.

Version 1 contains 20 scripts across eight job-focused categories. Each script is designed to be safe, documented, testable, and useful in portfolio or interview discussion.

## Why This Project Exists

Many entry-level cloud and operations roles expect comfort with Bash, Linux commands, troubleshooting, and safe automation. This repo exists to turn those skills into concrete examples that are easy to run, explain, test, and improve.

The focus is not clever shell tricks. The focus is practical operational work:

- Validate inputs before acting.
- Prefer read-only inspection.
- Avoid secrets and private data.
- Use clear output and exit codes.
- Document real-world use cases.
- Add tests and CI checks.

## Who It Is For

- Cloud Engineer learners building operational confidence.
- DevOps learners practicing deployment and automation workflows.
- Linux Admin candidates preparing hands-on examples.
- Support Engineers who troubleshoot logs, services, hosts, and containers.
- Junior SRE candidates learning safe checks, signals, and runbooks.
- Interview candidates building a practical Bash portfolio.

## Script Categories

| Category | Focus | Example Workflows |
| --- | --- | --- |
| Linux Admin | Host inspection and local administration | Disk checks, process review, user/group audit |
| Support Troubleshooting | First-response diagnostics | Connectivity checks, log summaries, support bundles |
| Monitoring | Lightweight health reporting | Service checks, CPU/memory reports, disk alerts |
| Deployment | Pre-deploy safety and service operations | Env validation, backups, guarded restarts |
| Docker | Container inspection and cleanup planning | Container health, dry-run cleanup review |
| Kubernetes | Namespace and pod visibility | Pod status, deployments, services, events |
| AWS | Read-only cloud inventory and checks | EC2 status, S3 public access block checks |
| Security | Local security review | SSH failures, risky file permissions |

## Version 1 Script Catalog

| # | Category | Script | Purpose |
| --- | --- | --- | --- |
| 1 | Linux Admin | `scripts/linux-admin/disk-usage-check/disk_usage_check.sh` | Check mounted filesystem disk usage against a threshold. |
| 2 | Linux Admin | `scripts/linux-admin/top-processes-report/top_processes_report.sh` | Show top CPU and memory consuming processes. |
| 3 | Linux Admin | `scripts/linux-admin/user-group-audit/user_group_audit.sh` | Report local users, login shells, and groups. |
| 4 | Support Troubleshooting | `scripts/support-troubleshooting/port-connectivity-check/port_connectivity_check.sh` | Check host and port reachability. |
| 5 | Support Troubleshooting | `scripts/support-troubleshooting/log-error-summary/log_error_summary.sh` | Summarize important log severity lines. |
| 6 | Support Troubleshooting | `scripts/support-troubleshooting/diagnostic-bundle-collector/diagnostic_bundle_collector.sh` | Collect safe read-only diagnostics into a bundle. |
| 7 | Monitoring | `scripts/monitoring/service-health-check/service_health_check.sh` | Check whether a systemd service is active. |
| 8 | Monitoring | `scripts/monitoring/cpu-memory-report/cpu_memory_report.sh` | Print load average, memory usage, and top processes. |
| 9 | Monitoring | `scripts/monitoring/disk-threshold-alert/disk_threshold_alert.sh` | Print cron-friendly disk usage alerts. |
| 10 | Deployment | `scripts/deployment/validate-env-vars/validate_env_vars.sh` | Validate required deployment environment variables without printing values. |
| 11 | Deployment | `scripts/deployment/backup-before-deploy/backup_before_deploy.sh` | Create a timestamped tar.gz backup before deployment. |
| 12 | Deployment | `scripts/deployment/app-restart-helper/app_restart_helper.sh` | Restart a service with status checks, dry-run, and confirmation. |
| 13 | Docker | `scripts/docker/container-health-check/docker_container_health_check.sh` | Show Docker container status and unhealthy containers. |
| 14 | Docker | `scripts/docker/cleanup-dry-run/docker_cleanup_dry_run.sh` | Show cleanup candidates without deleting Docker resources. |
| 15 | Kubernetes | `scripts/kubernetes/pod-status-summary/k8s_pod_status_summary.sh` | Show pods not Running or Completed in a namespace. |
| 16 | Kubernetes | `scripts/kubernetes/namespace-resource-check/k8s_namespace_resource_check.sh` | Show deployments, pods, services, and events. |
| 17 | AWS | `scripts/aws/ec2-status-report/aws_ec2_status_report.sh` | Generate a read-only EC2 instance status report. |
| 18 | AWS | `scripts/aws/s3-public-access-check/aws_s3_public_access_check.sh` | Check S3 public access block configuration as one part of a broader public exposure review. |
| 19 | Security | `scripts/security/failed-ssh-login-summary/failed_ssh_login_summary.sh` | Summarize failed SSH login attempts from auth logs. |
| 20 | Security | `scripts/security/file-permission-audit/file_permission_audit.sh` | Report risky file permissions without changing them. |

## How To Run a Script

Every script supports `--help` and is committed as executable:

```bash
./scripts/linux-admin/disk-usage-check/disk_usage_check.sh --help
```

Example runs:

```bash
./scripts/linux-admin/disk-usage-check/disk_usage_check.sh --threshold 80
./scripts/support-troubleshooting/log-error-summary/log_error_summary.sh --file examples/sample-logs/app.log --lines 50
./scripts/deployment/backup-before-deploy/backup_before_deploy.sh --source /opt/myapp --dest ./backups --dry-run
```

Some scripts require local tools such as Docker, `kubectl`, AWS CLI, or `systemctl`. Check each script folder README for prerequisites and safety notes.

Sample demo files are included under:

- `examples/sample-logs/`
- `examples/sample-configs/`
- `examples/sample-outputs/`

## Quality Checks

Run ShellCheck:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shellcheck
```

Check formatting with `shfmt`:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shfmt -d -i 2 -ci
```

Apply formatting locally:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shfmt -w -i 2 -ci
```

## Tests

Run the Bats test suite:

```bash
bats tests
```

Run one test file:

```bash
bats tests/scripts/linux-admin/disk-usage-check/disk_usage_check.bats
```

The current tests focus on safe local behavior and do not require real AWS, Docker, or Kubernetes access. GitHub Actions runs ShellCheck and Bats tests in CI.

Before tagging a release, work through [docs/release-checklist.md](docs/release-checklist.md).

## Safety Note

This repository should never include secrets, tokens, private keys, real AWS account IDs, private logs, customer data, or unsafe default behavior.

Most scripts are read-only. Scripts that can create or change something use safeguards such as `--dry-run`, explicit confirmation, and clear documentation. No script should delete resources, change cloud settings, or modify security configuration without deliberate review.

## Roadmap

- Add Bats coverage for the remaining scripts.
- Add mock-based tests for AWS, Docker, Kubernetes, and `systemctl` workflows.
- Add script output examples for common interview scenarios.
- Consider packaging common test helpers once repeated test patterns stabilize.

## Portfolio and Interview Value

This project shows practical Bash automation across the responsibilities expected in junior Cloud, DevOps, Linux Admin, Support, and SRE-style roles.

In an interview, it can demonstrate:

- Comfort with Linux and CLI tools.
- Safe operational thinking.
- Troubleshooting structure.
- Input validation and clear exit codes.
- Documentation discipline.
- CI checks with ShellCheck, shfmt, and Bats.
- Awareness of cloud and container tooling without relying on live production access.
