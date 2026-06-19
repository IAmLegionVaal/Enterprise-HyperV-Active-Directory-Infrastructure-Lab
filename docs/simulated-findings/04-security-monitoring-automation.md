# Simulated Findings — Security, Monitoring, and Automation

This document contains representative portfolio data for a controlled lab scenario. It is not live production evidence.

## Security baseline

- Separate standard and administrative identities were included.
- Windows LAPS, Defender, Firewall, screen-lock controls, removable-storage restrictions, and BitLocker were documented.
- Advanced auditing, PowerShell logging, and centralized event collection were included.
- Privileged group membership and local administrator access were treated as monitored items.

### Simulated findings

- Security controls were represented as applying successfully to the intended systems.
- Administrative activity was easier to identify because privileged accounts were separated from normal user accounts.
- Centralized logging reduced the need to inspect each server individually.
- The example review found no unexplained privileged group memberships.

## Monitoring

- Domain-controller health included replication, DNS, service state, time synchronization, event logs, and disk space.
- File-server monitoring included free space, share availability, quota events, and service health.
- Reports were designed for both technical and nontechnical review.

### Simulated findings

- Both domain controllers were represented as healthy.
- Replication and DNS checks returned no persistent critical conditions.
- Disk-space thresholds were below warning levels.
- Monitoring output included timestamps, hostnames, findings, and suggested remediation.

## Automation

- Starter scripts were created for Hyper-V networking, OU creation, user and group administration, file shares, health checks, and inventory reporting.
- Scripts were designed to be repeatable and safe to rerun.
- Logging and validation were treated as required features.
- CSV input was used for consistent sample-user creation.

### Simulated findings

- Repeated script execution did not create duplicate objects in the example scenario.
- Inventory exports produced consistent user, computer, group, and server records.
- Health-check output clearly separated healthy results from warnings.
- Automation reduced manual configuration differences between systems.

## Lessons learned

- Security controls are more useful when paired with monitoring and evidence.
- Automation should validate the existing state before changing it.
- Reports should explain both what failed and what action should follow.
- Sample output must remain sanitized before publication.