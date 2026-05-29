# Getting Started

This guide helps you run and understand the Version 1 Bash runbooks.

## Recommended Setup

Install the tools needed for the scripts you plan to run:

- Bash 4 or newer.
- Git.
- ShellCheck for linting.
- shfmt for formatting.
- Bats for tests.
- Docker CLI for Docker scripts.
- `kubectl` for Kubernetes scripts.
- AWS CLI for AWS scripts.

You do not need every tool to use the repository. For example, Linux Admin scripts can run without AWS, Docker, or Kubernetes access.

## Repository Tour

- `scripts/` contains the operational Bash scripts grouped by category.
- `docs/` contains project guidance, role mapping, standards, troubleshooting, and interview notes.
- `tests/` contains Bats tests that mirror selected script folders.
- `examples/` contains safe sample data folders.
- `templates/` contains starter templates for future scripts and tests.
- `.github/workflows/` contains CI workflows for ShellCheck, shfmt, and Bats.

## First Script To Try

Start with a safe local script:

```bash
bash scripts/linux-admin/disk-usage-check/disk_usage_check.sh --help
bash scripts/linux-admin/disk-usage-check/disk_usage_check.sh --threshold 80
```

Then try a support script with a sample log:

```bash
printf '%s\n' \
  'INFO service started' \
  'WARN cache response time exceeded threshold' \
  'ERROR database connection failed' > /tmp/sample-app.log

bash scripts/support-troubleshooting/log-error-summary/log_error_summary.sh --file /tmp/sample-app.log
```

## Running Quality Checks

Run ShellCheck:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shellcheck
```

Check formatting:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shfmt -d -i 2 -ci
```

Run tests:

```bash
bats tests
```

## Working Safely

Before running any script:

- Read the script README.
- Run the script with `--help`.
- Confirm required tools are installed.
- Use `--dry-run` when available.
- Avoid using real secrets, private data, or production-only examples.

## Adding a Future Script

1. Pick the correct category under `scripts/`.
2. Copy `templates/script-template.sh`.
3. Keep the script focused on one practical use case.
4. Add or update the script folder `README.md`.
5. Add Bats tests when the behavior can be tested safely.
6. Run ShellCheck, shfmt, and tests.
7. Confirm the script does not expose secrets or perform unsafe default actions.

## Version 1 Status

Version 1 includes 20 practical scripts across Linux Admin, Support Troubleshooting, Monitoring, Deployment, Docker, Kubernetes, AWS, and Security categories.
