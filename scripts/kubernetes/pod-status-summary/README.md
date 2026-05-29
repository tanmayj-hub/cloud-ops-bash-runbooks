# Kubernetes Pod Status Summary

## Role

DevOps Engineer / Cloud Support / Kubernetes Support

## Real-World Use Case

Use this script during Kubernetes incident triage to quickly summarize pod state in a namespace and highlight pods that are not `Running` or `Completed`.

## Prerequisites

- Bash.
- `kubectl`.
- A configured current Kubernetes context.
- Read access to pods in the target namespace.

## Usage

```bash
./k8s_pod_status_summary.sh
./k8s_pod_status_summary.sh --namespace production
./k8s_pod_status_summary.sh --help
```

## Example Commands

```bash
bash k8s_pod_status_summary.sh
bash k8s_pod_status_summary.sh --namespace staging
```

## Example Output

```text
Kubernetes Pod Status Summary
Context: dev-cluster
Namespace: staging

All Pods
------------------------------
NAME                      READY   STATUS             RESTARTS   AGE   IP
api-6d8f7c8d9f-abc12      1/1     Running            0          2h    10.1.0.12
worker-7f9c8b7d6d-def34   0/1     CrashLoopBackOff   4          12m   10.1.0.18

Pods Not Running or Completed
------------------------------
worker-7f9c8b7d6d-def34   0/1     CrashLoopBackOff   4          12m
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Pod status summary completed successfully.
- `2` - Invalid input, `kubectl` missing, context unavailable, or namespace read failed.

## Troubleshooting

- If `kubectl` is missing, install it through the approved workstation setup process.
- If no context is available, run `kubectl config get-contexts` and select the correct context.
- If namespace access fails, confirm the namespace exists and your Kubernetes RBAC permissions allow pod reads.

## Safety Notes

This script is read-only. It does not create, delete, patch, scale, restart, or modify Kubernetes resources.

## Interview Explanation

This script demonstrates a Kubernetes support workflow: validate tooling and context, inspect a namespace, and highlight problematic pod states without changing the cluster.
