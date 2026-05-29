# File Permission Audit

## Role

Linux Admin / Support Engineer / Cloud Support

## Real-World Use Case

Use this script during local security review, support triage, or pre-handoff checks to identify permissions that deserve closer review under a target directory.

## Prerequisites

- Bash.
- Standard Linux `find` and `wc` commands.
- Read access to the target directory.

## Usage

```bash
./file_permission_audit.sh --path <directory>
./file_permission_audit.sh --path <directory> --max-depth 2
./file_permission_audit.sh --help
```

## Example Commands

```bash
bash file_permission_audit.sh --path /opt/myapp --max-depth 3
bash file_permission_audit.sh --path ./sample-configs --max-depth 2
```

## Example Output

```text
File Permission Audit
Path: ./sample-configs
Max depth: 2
Mode: read-only audit

World-Writable Files and Directories
------------------------------
-rw-rw-rw- app:app ./sample-configs/debug.conf
Recommendation: review whether these paths need world-writable permissions.

Summary Recommendation
------------------------------
Review findings with the application owner before changing permissions. This script made no changes.
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Audit completed successfully.
- `2` - Invalid input.

## Troubleshooting

- If the path is rejected, confirm it exists and is a directory.
- If permission errors appear, run with an approved account that can read the target directory.
- If findings are noisy, reduce `--max-depth` or audit a more specific directory.

## Safety Notes

This script is read-only. It does not run `chmod`, `chown`, `setfacl`, delete files, or apply automatic fixes.

## Interview Explanation

This script demonstrates a safe local security audit: identify world-writable paths, privileged executable bits, and executable files that may deserve review while providing recommendations instead of making changes.
