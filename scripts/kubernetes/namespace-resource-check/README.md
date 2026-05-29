# Kubernetes Namespace Resource Check

## Role

DevOps Engineer / Cloud Support / Kubernetes Support

## Real-World Use Case

Use this script when reviewing a Kubernetes namespace during deployment validation, incident triage, or support escalation. It gathers the basic resource view most engineers ask for first: deployments, pods, services, and events.

## Prerequisites

- Bash.
- `kubectl`.
- A configured current Kubernetes context.
- Read access to deployments, pods, services, and events in the target namespace.

## Usage

```bash
./k8s_namespace_resource_check.sh
./k8s_namespace_resource_check.sh --namespace production
./k8s_namespace_resource_check.sh --help
```

## Example Commands

```bash
bash k8s_namespace_resource_check.sh
bash k8s_namespace_resource_check.sh --namespace staging
```

## Example Output

```text
Kubernetes Namespace Resource Check
Context: dev-cluster
Namespace: staging

Deployments
------------------------------
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
api    3/3     3            3           2d

Pods
------------------------------
NAME                 READY   STATUS    RESTARTS   AGE   IP
api-abc123           1/1     Running   0          2h    10.1.0.12

Services
------------------------------
NAME   TYPE        CLUSTER-IP     PORT(S)
api    ClusterIP   10.96.10.20    80/TCP
```

See `examples/example-output.txt` for a sample report.

## Exit Codes

- `0` - Namespace resource report completed successfully.
- `2` - Invalid input, `kubectl` missing, or Kubernetes context unavailable.

## Troubleshooting

- If `kubectl` is missing, install it through the approved workstation setup process.
- If no context is available, run `kubectl config get-contexts` and select the correct context.
- If a resource section cannot be read, confirm RBAC permissions and namespace existence.

## Safety Notes

This script is read-only. It does not create, delete, patch, scale, restart, or modify Kubernetes resources.

## Interview Explanation

This script demonstrates namespace-level Kubernetes troubleshooting: collect the core workload, service, and event view safely using read-only `kubectl get` commands.
