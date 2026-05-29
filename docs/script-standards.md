# Script Standards

## Required Format

Every Bash script should start with:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Use `set -euo pipefail` where appropriate. If a script intentionally avoids one of those options, document why in the script comments and README.

## Required Features

Every script must include:

- `--help` output.
- Input validation where relevant.
- Dependency checks where relevant.
- Clear success and failure messages.
- Safe defaults.
- Documentation in the relevant folder README.

## Style Guidance

- Use lowercase file names with hyphens.
- Keep functions small and focused.
- Prefer `readonly` for constants.
- Quote variables.
- Avoid parsing command output when a structured option is available.
- Use clear exit codes.
- Keep examples fake and safe.

## Safety Guidance

- Prefer read-only operations.
- Do not delete, overwrite, stop, restart, or modify resources by default.
- Use `--dry-run` for planned changes.
- Ask for explicit confirmation before risky actions.
- Never hardcode secrets or real account identifiers.

## Testing Guidance

- Use Bats for command behavior.
- Test `--help`.
- Test missing or invalid input.
- Test expected output using sample data.
- Keep tests independent from production systems.

Run the full Bats suite locally with:

```bash
bats tests
```

Install Bats first if the `bats` command is not available. The GitHub Actions workflow installs Bats automatically before running the suite.

Run a single test file with:

```bash
bats tests/scripts/linux-admin/disk-usage-check/disk_usage_check.bats
```

Tests should use temporary files and directories for local state. Do not require real AWS, Docker, or Kubernetes access in unit-style Bats tests; mock those tools when coverage is added.

## ShellCheck

All Bash scripts under `scripts/` should pass ShellCheck before they are merged. This repo includes a GitHub Actions workflow that runs ShellCheck on every push and pull request.

Run the same check locally with:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shellcheck
```

Treat ShellCheck warnings as useful review feedback. If a warning is intentionally ignored, document the reason near the code.

## Formatting

All Bash scripts under `scripts/` should be formatted with `shfmt`. This repo includes a GitHub Actions workflow that checks formatting on every push and pull request. The workflow only reports formatting differences; it does not auto-commit changes.

Check formatting locally with:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shfmt -d -i 2 -ci
```

Apply formatting locally with:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shfmt -w -i 2 -ci
```

Use two-space indentation and switch-case indentation so scripts stay consistent and easy to review.

## Review Guidance

A script is ready for review when it is safe, documented, testable, and explainable in an interview.
