# Diagnostic Bundle Collector

## Role

Support Engineer / Linux Admin / Cloud Support

## Real-World Use Case

Use this script when preparing a clean first-response diagnostic package for escalation. It collects common read-only system information that helps another engineer understand host health without needing immediate shell access.

## Prerequisites

- Bash.
- Standard Linux commands: `hostname`, `date`, `uptime`, `df`, `ps`, `head`, `tar`, and `grep`.
- Optional commands: `free`, `ip`, or `ifconfig`.
- Write access to the selected output directory.

## Usage

```bash
./diagnostic_bundle_collector.sh
./diagnostic_bundle_collector.sh --output-dir ./diagnostic-bundles
./diagnostic_bundle_collector.sh --help
```

## Example Commands

```bash
bash diagnostic_bundle_collector.sh
bash diagnostic_bundle_collector.sh --output-dir /tmp/support-bundles
```

## Example Output

```text
Diagnostic Bundle Collector
Bundle folder: ./diagnostic-bundles/diagnostic-bundle-web01-20260529-143000
Compressed bundle: ./diagnostic-bundles/diagnostic-bundle-web01-20260529-143000.tar.gz
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Bundle created successfully.
- `2` - Invalid input or missing required dependency.

## Troubleshooting

- If bundle creation fails, confirm the output directory can be created or written to.
- If a required command is missing, install it through your normal operating system package process. This script does not install packages automatically.
- If optional network or memory tools are missing, the script writes a note instead of failing.

## Safety Notes

This script collects read-only system diagnostics only. It does not collect secrets, private SSH keys, full environment variables, application config files, browser data, or user home directory contents.

Review generated bundles before sharing them outside your organization.

## Interview Explanation

This script demonstrates a support escalation workflow: gather standard diagnostics, avoid sensitive data, create a timestamped bundle, compress it for handoff, and clearly tell the operator where the artifact was created.
