# Security Policy

## Supported Status

This repository is in Version 1 development. Scripts are not production-ready unless clearly documented as reviewed and tested.

## Reporting Security Issues

If you find a security concern, open a private report through the repository security reporting feature if available. If private reporting is not available, open an issue without including secrets, exploit details, private logs, or sensitive infrastructure data.

## Data Rules

Do not add:

- Secrets or tokens.
- Private keys.
- Real AWS account IDs.
- Customer data.
- Internal host inventories.
- Private logs.
- Production credentials.

Use sample data in `examples/` for documentation and tests.

## Script Safety Expectations

- Prefer read-only operations.
- Validate all inputs.
- Document required permissions.
- Avoid destructive commands.
- Require `--dry-run` and confirmation for any future state-changing action.
- Make script behavior clear from `--help` output and README documentation.

## Cloud Safety

Cloud scripts should use safe, read-only CLI operations unless a state-changing workflow has been reviewed. Examples must use placeholders such as `123456789012` only when clearly marked as fake sample data.
