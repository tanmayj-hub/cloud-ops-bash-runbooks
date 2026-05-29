# Release Checklist

Use this checklist before tagging a new repository release.

## Repository Readiness

- Confirm the Version 1 script count is still 20.
- Confirm script names, README links, and docs references still match.
- Confirm all scripts under `scripts/` are executable in git.
- Confirm sample files are safe and contain no secrets, customer data, or real cloud identifiers.

## Local Validation

Run syntax checks:

```bash
find scripts -name "*.sh" -print0 | xargs -0 bash -n
```

Run ShellCheck:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shellcheck
```

Check formatting:

```bash
find scripts -name "*.sh" -print0 | xargs -0 shfmt -d -i 2 -ci
```

Run the Bats suite:

```bash
bats tests
```

## Documentation Review

- Confirm the main README reflects the current script inventory and workflows.
- Confirm script-level README files still match current behavior and exit codes.
- Confirm `docs/role-mapping.md` and `docs/interview-guide.md` match the actual repo scope.
- Confirm the changelog and release notes describe the current Version 1 state.

## Safety Review

- Confirm no script adds destructive behavior without `--dry-run` and confirmation.
- Confirm no examples include secrets, real AWS account IDs, real bucket names, or private data.
- Confirm scripts that are read-only are still read-only.
- Confirm any state-changing script clearly documents safety notes and exit codes.

## GitHub Actions Review

- Confirm the ShellCheck, shfmt, and Bats workflows still pass on the default branch.
- Confirm there are no new CI failures or stale release-candidate issues.

## Release Steps

1. Update documentation and examples as needed.
2. Commit the final release candidate changes.
3. Push to the default branch.
4. Confirm GitHub Actions is green.
5. Create the release tag and publish release notes.
