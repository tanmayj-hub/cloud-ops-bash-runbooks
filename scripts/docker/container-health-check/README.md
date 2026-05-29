# Docker Container Health Check

## Role

DevOps Engineer / Linux Admin / Cloud Support

## Real-World Use Case

Use this script during container troubleshooting to quickly see which containers are running and whether Docker reports any containers as unhealthy.

## Prerequisites

- Bash.
- Docker CLI.
- Reachable Docker daemon.
- Permission to run read-only Docker inspection commands.

## Usage

```bash
./docker_container_health_check.sh
./docker_container_health_check.sh --help
```

## Example Commands

```bash
bash docker_container_health_check.sh
```

## Example Output

```text
Docker Container Health Check

Running Containers
------------------------------
CONTAINER ID   NAMES     IMAGE          STATUS                  PORTS
abc123def456   web       nginx:latest   Up 2 hours (healthy)    0.0.0.0:8080->80/tcp

Unhealthy Containers
------------------------------
No unhealthy containers found.
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Docker summary completed successfully.
- `2` - Docker CLI missing, daemon unreachable, or invalid input.

## Troubleshooting

- If Docker CLI is missing, install Docker through your normal workstation or server setup process.
- If the daemon is unreachable, confirm Docker is running and your user has permission to access it.
- If no health status appears, the container image may not define a Docker healthcheck.

## Safety Notes

This script is read-only. It does not start, stop, restart, remove, exec into, or modify containers.

## Interview Explanation

This script demonstrates safe Docker troubleshooting: verify tooling, confirm daemon access, list running containers, and highlight unhealthy containers without changing runtime state.
