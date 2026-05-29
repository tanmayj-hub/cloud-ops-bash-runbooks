# AGENTS.md

Instructions for future Codex work in this repository.

## Project Direction

This is a role-based Bash scripting repository for Cloud, DevOps, Linux Admin, and Support workflows. Keep work practical, job-focused, beginner-friendly, and suitable for portfolio or interview discussion.

## Bash Standards

- Use Bash for scripts.
- Use `#!/usr/bin/env bash`.
- Use `set -euo pipefail` where appropriate.
- Every script must support `--help`.
- Every script must include input validation where relevant.
- Prefer clear functions, readable variable names, and simple control flow.
- Scripts should pass ShellCheck.
- Add Bats tests where behavior can be tested safely.

## Safety Rules

- Do not hardcode secrets.
- Do not commit tokens, private keys, real AWS account IDs, private IP inventories, customer logs, or private data.
- Do not add destructive commands unless protected by `--dry-run` and explicit confirmation.
- Prefer read-only commands for troubleshooting, audit, and reporting scripts.
- Use sample logs, sample configs, and sample outputs only.
- Never assume production access or elevated privileges.

## Documentation Rules

Every script folder needs a `README.md`.

Every script's documentation must include:

- Role.
- Use case.
- Requirements.
- Usage.
- Example output.
- Troubleshooting.
- Safety notes.
- Testing or validation notes.

## Repository Scope

Do not create actual Version 1 scripts until the script plan is approved. Templates are allowed. Documentation, folder READMEs, sample files, and test scaffolding are allowed when they do not imply unsafe behavior.

## Review Checklist

Before finishing any script-related change:

- Confirm no secrets or private data were added.
- Confirm no unsafe destructive default behavior exists.
- Confirm `--help` works.
- Confirm input validation is present.
- Confirm documentation explains the role and use case.
- Confirm ShellCheck passes or document why it could not be run.
