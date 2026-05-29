# AWS S3 Public Access Check

## Role

Cloud Engineer / DevOps Engineer / Cloud Support

## Real-World Use Case

Use this script during S3 security review or support triage to confirm whether bucket-level public access block settings are configured.

## Prerequisites

- Bash.
- AWS CLI.
- AWS credentials configured through an approved profile, SSO session, role, or environment.
- Network access to AWS APIs.

## Required IAM Permissions

Read-only permissions:

- `s3:GetBucketPublicAccessBlock`

Some environments may also require identity or bucket discovery permissions through a managed read-only policy.

## Usage

```bash
./aws_s3_public_access_check.sh --bucket example-bucket-name
./aws_s3_public_access_check.sh --help
```

## Example Commands

```bash
bash aws_s3_public_access_check.sh --bucket example-bucket-name
```

## Example Output

```text
AWS S3 Public Access Check
Bucket: example-bucket-name

--------------------------------------------------
|         PublicAccessBlockConfiguration          |
+--------------------------+---------------------+
| BlockPublicAcls          | True                |
| BlockPublicPolicy        | True                |
| IgnorePublicAcls         | True                |
| RestrictPublicBuckets    | True                |
+--------------------------+---------------------+

OK: public access block configuration was read successfully.
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Public access block report completed successfully, or no bucket-level configuration was found.
- `1` - Access denied or AWS CLI request failed.
- `2` - Invalid input or AWS CLI missing.

## Troubleshooting

- If access is denied, confirm `s3:GetBucketPublicAccessBlock` is allowed for the bucket.
- If the bucket name is wrong, verify the exact bucket name with an approved inventory source.
- If credentials are unavailable, use your approved AWS profile, SSO login, or role assumption process.

## Safety Notes

This script only uses read-only AWS CLI commands. It does not modify bucket policies, ACLs, public access block settings, encryption, logging, lifecycle rules, or objects.

Do not include real AWS account IDs, secrets, ARNs, bucket policies, or private data in examples or issues.

## Interview Explanation

This script demonstrates safe cloud security validation: inspect S3 public access block settings, handle access denied clearly, and avoid making any changes to bucket configuration.
