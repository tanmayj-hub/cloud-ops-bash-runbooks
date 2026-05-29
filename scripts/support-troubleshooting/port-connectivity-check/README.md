# Port Connectivity Check

## Role

Support Engineer / Linux Admin / Cloud Support

## Real-World Use Case

Use this script when an application, API, database, or service endpoint may be unreachable. It helps separate network connectivity issues from application-level issues during first-response troubleshooting.

## Prerequisites

- Bash.
- `nc` if available, or Linux `timeout` with Bash TCP support.
- Permission to initiate a basic TCP connection to the target host and port.

## Usage

```bash
./port_connectivity_check.sh --host <hostname-or-ip> --port <port>
./port_connectivity_check.sh --help
```

## Example Commands

```bash
bash port_connectivity_check.sh --host example.com --port 443
bash port_connectivity_check.sh --host 10.0.0.10 --port 22
```

## Example Output

```text
Port Connectivity Check
Target: example.com:443
Timeout: 5 seconds

SUCCESS: example.com:443 is reachable.
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Target host and port are reachable.
- `1` - Target host and port are not reachable.
- `2` - Invalid input or missing dependency.

## Troubleshooting

- If the script says the port is not reachable, confirm the hostname, port, firewall rules, security groups, and service status.
- If the script reports a missing dependency, install `nc` or confirm the Linux `timeout` command is available.
- If DNS is suspected, test with an IP address and then compare with the hostname.

## Safety Notes

This script performs a basic TCP connection check only. It does not scan port ranges, install packages, change firewall rules, or modify network configuration.

## Interview Explanation

This script demonstrates a common support workflow: validate required inputs, check dependencies, test a specific endpoint safely, and return exit codes that can be used by other automation.
