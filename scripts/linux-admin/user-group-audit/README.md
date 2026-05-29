# User Group Audit

## Role

Linux Admin / Support Engineer / Cloud Support

## Real-World Use Case

Use this script during access reviews, server handoffs, or basic incident triage to summarize local users, login-capable accounts, and local groups.

## Prerequisites

- Bash.
- Standard Linux `/etc/passwd` and `/etc/group` files.
- Standard Linux `awk` command.
- Permission to read local user and group files.

## Usage

```bash
./user_group_audit.sh
./user_group_audit.sh --help
```

## Example Commands

```bash
bash user_group_audit.sh
```

## Example Output

```text
User and Group Audit Report
Source files: /etc/passwd, /etc/group

Current Local Users
------------------------------
root                     UID=0        GID=0        HOME=/root
appuser                  UID=1001     GID=1001     HOME=/home/appuser

Users With Login Shells
------------------------------
root                     SHELL=/bin/bash
appuser                  SHELL=/bin/bash

Local Groups
------------------------------
root                     GID=0        MEMBERS=-
sudo                     GID=27       MEMBERS=appuser
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Report completed successfully.
- `2` - Invalid usage, invalid input, or required file cannot be read.

## Troubleshooting

- If the script cannot read `/etc/passwd` or `/etc/group`, confirm the host is a Linux-like system and the files exist.
- If login shell results look unexpected, review whether the shell ends with `nologin` or `false`.
- If group membership looks incomplete, remember this script only reports local `/etc/group` data and does not query external identity providers.

## Safety Notes

This script is read-only. It does not create, delete, lock, unlock, or modify users or groups.

## Interview Explanation

This script demonstrates a safe local account audit workflow. It reads standard Linux account files, separates login-capable users from service-style accounts, and summarizes group membership without changing access.
