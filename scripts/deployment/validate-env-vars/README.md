# Validate Environment Variables

## Role

DevOps Engineer / Linux Admin / Cloud Support

## Real-World Use Case

Use this script before a deployment to confirm required configuration variables exist without exposing secret values in logs or terminals.

## Prerequisites

- Bash.
- Required environment variables exported in the current shell or deployment environment.

## Usage

```bash
./validate_env_vars.sh --vars "APP_ENV,DATABASE_URL,API_TOKEN"
./validate_env_vars.sh --help
```

## Example Commands

```bash
APP_ENV=prod DATABASE_URL=placeholder-db-url API_TOKEN=placeholder-token-value \
  bash validate_env_vars.sh --vars "APP_ENV,DATABASE_URL,API_TOKEN"
```

## Example Output

```text
Deployment Environment Variable Validation
Variable                         Status
--------                         ------
APP_ENV                          SET
DATABASE_URL                     SET
API_TOKEN                        SET

OK: all required environment variables are set and non-empty.
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - All required variables are set and non-empty.
- `1` - One or more required variables are missing or empty.
- `2` - Invalid input.

## Troubleshooting

- If a variable shows `MISSING`, confirm it is exported in the same shell or deployment process.
- If a variable name is rejected, use standard shell variable naming such as `APP_ENV`.
- Do not debug by printing secret values into logs.

## Safety Notes

This script does not print environment variable values. It only prints variable names and whether each one is set.

## Interview Explanation

This script demonstrates a deployment precheck that validates required configuration while protecting secrets from accidental exposure.
