# Contributing

Thanks for helping improve `cloud-ops-bash-runbooks`.

This project values practical, safe, beginner-friendly Bash examples that connect directly to real Cloud, DevOps, Linux Admin, and Support workflows.

## Contribution Guidelines

- Keep scripts focused on one clear operational use case.
- Use the script template in `templates/script-template.sh`.
- Include documentation for every script.
- Include tests when the behavior can be tested safely.
- Use sample data only.
- Avoid destructive commands.
- Do not include secrets, tokens, private keys, real AWS account IDs, or private data.

## Script Requirements

Every script should:

- Use `#!/usr/bin/env bash`.
- Use `set -euo pipefail` where appropriate.
- Support `--help`.
- Validate inputs.
- Check required dependencies.
- Produce readable output.
- Fail with clear error messages.
- Pass ShellCheck.

## Pull Request Checklist

Before opening a pull request:

- Run ShellCheck against changed scripts.
- Run Bats tests if tests exist.
- Confirm documentation includes role, use case, usage, example output, troubleshooting, and safety notes.
- Confirm no private data or secrets are present.
- Confirm risky actions require `--dry-run` and confirmation.

## Documentation Tone

Write for someone learning the role. Explain what the script helps with, when to use it, what it does not do, and how to discuss it in an interview.
