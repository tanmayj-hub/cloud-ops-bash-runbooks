# Interview Guide

This guide helps explain the project in practical job terms.

## 60-Second Explanation

"I built `cloud-ops-bash-runbooks` as a Version 1 Bash automation portfolio for Cloud, DevOps, Linux Admin, Support, and Junior SRE workflows. It includes 20 scripts across Linux, troubleshooting, monitoring, deployment, Docker, Kubernetes, AWS, and security categories. The scripts focus on realistic operations tasks like disk checks, log summaries, deployment prechecks, Docker health, Kubernetes namespace visibility, EC2 reporting, and SSH failure review. I designed the scripts to be safe, documented, and testable, with `--help`, input validation, meaningful exit codes, ShellCheck, shfmt, Bats tests, and GitHub Actions CI."

## STAR Answer

**Situation:** I wanted a hands-on project that reflected the kind of scripting used in real cloud and operations roles, not just isolated Bash exercises.

**Task:** I needed to build a professional repository that showed practical troubleshooting, deployment safety, monitoring checks, and cloud/container awareness.

**Action:** I organized the repo into role-based categories, wrote 20 Bash scripts, added per-script documentation, used safe read-only defaults, added dry-run and confirmation where needed, and set up ShellCheck, shfmt, and Bats workflows.

**Result:** The project demonstrates practical automation skills, safe operational thinking, and interview-ready examples that connect directly to Cloud Engineer, DevOps Engineer, Linux Admin, Support Engineer, and Junior SRE responsibilities.

## Interview Questions and Answers

### 1. Why did you build this project?

I built it to practice Bash in the same way it is used on the job: checking systems, validating deployments, reviewing logs, inspecting cloud resources, and collecting troubleshooting evidence. It is meant to show practical skill, not just syntax knowledge.

### 2. What is one script you would discuss in detail?

I would discuss `validate_env_vars.sh`. It solves a common deployment problem: missing required environment variables. It accepts a comma-separated list, validates each variable, prints only names and status, avoids exposing secret values, and returns clear exit codes for automation.

### 3. How did you make the scripts safe?

Most scripts are read-only. Scripts that could affect state use protections such as `--dry-run`, explicit confirmation, and clear documentation. The repo also avoids secrets, real account IDs, private logs, destructive defaults, and automatic fixes.

### 4. How did you test the scripts?

I added Bats tests for important local scripts, including help output, invalid input, secret-safe environment variable behavior, temporary backup creation, log parsing, port checks, and permission audit behavior. I also added GitHub Actions workflows for ShellCheck, shfmt, and Bats.

### 5. How does this project relate to cloud or DevOps work?

The scripts map to common operational tasks: EC2 inventory, S3 public access block checks, Kubernetes namespace visibility, Docker inspection, deployment prechecks, service restarts, support bundles, and monitoring-style health checks. These are the kinds of checks engineers use before escalating, deploying, or troubleshooting.

## Why Bash Was Used

Bash is widely available on Linux systems, CI runners, cloud instances, containers, and admin workstations. It is useful for gluing together standard tools like `df`, `ps`, `grep`, `systemctl`, Docker, `kubectl`, and AWS CLI.

For this project, Bash was a good fit because the tasks are operational and CLI-focused. The goal was to make small, inspectable runbooks that can be run quickly during troubleshooting or explained clearly in an interview.

## How To Explain Safety

Use this framing:

"I treated safety as a core requirement. Most scripts are read-only. Where a script can create or change something, such as backups or service restarts, I added dry-run behavior, confirmation prompts, and clear documentation. I also avoided printing secret values, avoided real cloud identifiers, and used temporary test data."

Good safety examples:

- `validate_env_vars.sh` prints variable status, not values.
- `docker_cleanup_dry_run.sh` never runs prune or delete commands.
- `app_restart_helper.sh` requires confirmation before restart.
- AWS scripts use read-only API calls.
- Security scripts report findings and recommendations without changing files.

## How To Explain Testing

Use this framing:

"I used Bats for behavior tests, ShellCheck for shell linting, shfmt for formatting checks, and GitHub Actions for CI. The tests focus on safe local behavior and avoid requiring real AWS, Docker, or Kubernetes access. For those external tools, the next step would be mock-based tests."

Testing examples:

- `--help` output for important scripts.
- Invalid input handling.
- Temporary directories for backup tests.
- Temporary files for log summary tests.
- Secret-safe output checks for environment variables.
- Permission audit tests that confirm file modes are not changed.

## Portfolio Checklist

- Explain the project purpose in one minute.
- Pick three scripts to explain deeply.
- Mention safety decisions.
- Mention tests and CI.
- Show how scripts map to job roles.
- Be clear about next improvements, especially mock-based tests for AWS, Docker, Kubernetes, and `systemctl`.
