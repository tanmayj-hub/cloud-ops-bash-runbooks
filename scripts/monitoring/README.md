# Monitoring Scripts

Scripts for service health checks, resource reporting, threshold alerts, and lightweight status monitoring.

Scripts in this folder should clearly document thresholds, dependencies, and expected output.

## Available Scripts

| Folder | Purpose |
| --- | --- |
| `service-health-check/` | Check whether a Linux service is active using `systemctl`. |
| `cpu-memory-report/` | Print load average, memory usage, and top process summaries. |
| `disk-threshold-alert/` | Print cron-friendly disk threshold alerts. |
