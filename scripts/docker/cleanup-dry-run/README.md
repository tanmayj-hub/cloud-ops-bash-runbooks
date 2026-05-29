# Docker Cleanup Dry Run

## Role

DevOps Engineer / Linux Admin / Cloud Support

## Real-World Use Case

Use this script when disk usage is high or Docker hosts need review. It shows stopped containers, dangling images, and unused volumes that may be cleanup candidates without deleting anything.

## Prerequisites

- Bash.
- Docker CLI.
- Reachable Docker daemon.
- Permission to run read-only Docker listing commands.

## Usage

```bash
./docker_cleanup_dry_run.sh
./docker_cleanup_dry_run.sh --help
```

## Example Commands

```bash
bash docker_cleanup_dry_run.sh
```

## Example Output

```text
Docker Cleanup Dry Run
Informational only: no Docker resources will be deleted.

Stopped Containers
------------------------------
CONTAINER ID   NAMES       IMAGE          STATUS
def456abc123   old-web     nginx:latest   Exited (0) 3 days ago

Dangling Images
------------------------------
IMAGE ID       REPOSITORY   TAG       SIZE
aaa111bbb222   <none>       <none>    120MB

Unused Volumes
------------------------------
DRIVER    VOLUME NAME
local     old_app_data
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Dry-run report completed successfully.
- `2` - Docker CLI missing, daemon unreachable, or invalid input.

## Troubleshooting

- If Docker CLI is missing, install Docker through the normal system setup process.
- If the daemon is unreachable, confirm Docker is running and the user has permission.
- If the report is empty, there may be no stopped containers, dangling images, or unused volumes.

## Safety Notes

This script is informational only. It does not run `docker rm`, `docker rmi`, `docker volume rm`, `docker system prune`, or any delete/prune command.

## Interview Explanation

This script demonstrates safe cleanup planning: identify cleanup candidates, make no changes, and clearly separate inspection from deletion.
