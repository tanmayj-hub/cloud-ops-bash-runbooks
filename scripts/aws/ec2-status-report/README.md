# AWS EC2 Status Report

## Role

Cloud Engineer / DevOps Engineer / Cloud Support

## Real-World Use Case

Use this script during cloud support triage or inventory review to list EC2 instance state, type, IP visibility, and friendly Name tags in a selected region.

## Prerequisites

- Bash.
- AWS CLI.
- AWS credentials and region configuration, or pass `--region`.
- Network access to AWS APIs.

## Required IAM Permissions

Read-only permissions:

- `sts:GetCallerIdentity`
- `ec2:DescribeInstances`

## Usage

```bash
./aws_ec2_status_report.sh
./aws_ec2_status_report.sh --region us-east-1
./aws_ec2_status_report.sh --help
```

## Example Commands

```bash
bash aws_ec2_status_report.sh --region us-east-1
```

## Example Output

```text
AWS EC2 Status Report
Region: us-east-1

---------------------------------------------------------------
|                      DescribeInstances                      |
+---------------------+----------+-------------+--------+------+
| InstanceId          | Name     | PrivateIp   | PublicIp | State |
+---------------------+----------+-------------+--------+------+
| i-012345example     | web-app  | 10.0.1.10   | None   | running |
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - EC2 report completed successfully.
- `1` - AWS CLI request failed.
- `2` - Invalid input, AWS CLI missing, or AWS credentials/config unavailable.

## Troubleshooting

- If credentials are unavailable, run `aws configure` or use your approved SSO/profile setup.
- If the region is wrong, pass `--region <aws-region>`.
- If access is denied, confirm the read-only IAM permissions listed above.

## Safety Notes

This script only uses read-only AWS CLI commands. It does not start, stop, terminate, tag, resize, reboot, or modify EC2 instances.

Do not paste real account IDs, ARNs, secrets, or private data into examples or issues.

## Interview Explanation

This script demonstrates safe cloud inventory collection: validate AWS CLI access, use read-only EC2 APIs, and produce a concise status report for support or operations review.
