# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Planned

- Add mock-based tests for AWS, Docker, Kubernetes, and `systemctl` scripts.
- Add more shared sample logs and sample configs.
- Add CI badges after the GitHub remote is configured.

## [1.0.0] - 2026-05-29

### Added

- Version 1 script catalog with 20 Bash scripts across Linux Admin, Support Troubleshooting, Monitoring, Deployment, Docker, Kubernetes, AWS, and Security categories.
- Per-script `README.md` documentation with role, use case, prerequisites, usage, example output, exit codes, troubleshooting, safety notes, and interview explanation.
- Example output files for each script folder.
- ShellCheck GitHub Actions workflow.
- shfmt GitHub Actions workflow.
- Bats test GitHub Actions workflow.
- Bats tests for important local scripts:
  - `disk_usage_check.sh`
  - `top_processes_report.sh`
  - `validate_env_vars.sh`
  - `backup_before_deploy.sh`
  - `port_connectivity_check.sh`
  - `log_error_summary.sh`
  - `file_permission_audit.sh`
- Professional Version 1 documentation for getting started, script standards, role mapping, troubleshooting, and interviews.
- Safety documentation for avoiding secrets, private data, destructive defaults, and unsafe cloud operations.

## [0.1.0] - 2026-05-29

### Added

- Initial repository structure.
- Project brief.
- Contribution and security guidance.
- Script, README, and Bats test templates.
