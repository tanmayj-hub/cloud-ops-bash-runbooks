# Deployment Scripts

Scripts for deployment prechecks, backups, service restart helpers, release validation, and rollback support.

Scripts in this folder should avoid risky changes by default and must document all state-changing behavior.

## Available Scripts

| Folder | Purpose |
| --- | --- |
| `validate-env-vars/` | Validate required deployment environment variables without printing values. |
| `backup-before-deploy/` | Create timestamped tar.gz backups before deployment. |
| `app-restart-helper/` | Restart an application service with dry-run, confirmation, and status checks. |
