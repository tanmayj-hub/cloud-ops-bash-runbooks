# Backup Before Deploy

## Role

DevOps Engineer / Linux Admin / Cloud Support

## Real-World Use Case

Use this script before deploying application files to create a timestamped archive of the current directory state. It provides a simple rollback reference without deleting or changing the source directory.

## Prerequisites

- Bash.
- Standard Linux `date`, `basename`, `dirname`, `mkdir`, and `tar` commands.
- Read access to the source directory.
- Write access to the destination directory.

## Usage

```bash
./backup_before_deploy.sh --source <path>
./backup_before_deploy.sh --source <path> --dest ./backups
./backup_before_deploy.sh --source <path> --dry-run
./backup_before_deploy.sh --help
```

## Example Commands

```bash
bash backup_before_deploy.sh --source /opt/myapp --dest /tmp/deploy-backups --dry-run
bash backup_before_deploy.sh --source /opt/myapp --dest /tmp/deploy-backups
```

## Example Output

```text
Backup Before Deploy
Source: /opt/myapp
Destination directory: /tmp/deploy-backups
Backup path: /tmp/deploy-backups/myapp-20260529-153000-4127.tar.gz
OK: backup created at /tmp/deploy-backups/myapp-20260529-153000-4127.tar.gz
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Backup completed or dry-run completed.
- `2` - Invalid input or backup failure.

## Troubleshooting

- If the source is rejected, confirm it exists and is a directory.
- If backup creation fails, confirm the destination can be created and written to.
- If multiple backups run close together, the script adds process-based collision protection to avoid overwriting an earlier archive.
- If the archive is unexpectedly large, review what is inside the source directory before deploying.

## Safety Notes

This script creates a tar.gz archive only when not in dry-run mode. It does not delete files, remove old backups, modify source files, or perform deployments.

## Interview Explanation

This script demonstrates a deployment safety step: validate inputs, support dry-run, create a unique backup name, and avoid destructive behavior.
