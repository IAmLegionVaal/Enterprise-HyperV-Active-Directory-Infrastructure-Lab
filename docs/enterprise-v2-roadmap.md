# Enterprise Hyper-V and Active Directory Lab — Enterprise v2 Roadmap

## Objective

Turn the documented lab into a reproducible senior-level infrastructure engineering project with automation, validation, security controls, recovery exercises, and clearly labelled simulated versus real evidence.

## v2 architecture

- Parameterized lab configuration
- Hyper-V network and VM automation
- Domain, DNS, DHCP, OU, group, policy, file-service, and monitoring automation
- Validation scripts and health reports
- Recovery and rollback procedures
- Diagram source files and architecture decision records

## Senior-level capabilities

### Hyper-V platform

- Host prerequisite and capacity assessment
- Internal switch, NAT, VLAN, and address-plan automation
- Generation 2 VM standards
- Resource-allocation and storage policies
- VM inventory and dependency mapping

### Active Directory and core services

- Redundant domain-controller design
- Sites, subnets, DNS, time, FSMO, and replication validation
- DHCP scopes, exclusions, options, reservations, and optional failover
- OU, role-group, resource-group, and delegation model
- Privileged account separation and password-policy documentation

### Endpoint and policy engineering

- Domain join and client validation
- Purpose-specific Group Policy structure
- Windows LAPS, Defender, Firewall, auditing, PowerShell logging, BitLocker, updates, drives, and printers
- Policy backup, restore, and change-control evidence

### File, certificate, and monitoring services

- Department shares with AGDLP
- Access-based enumeration, quotas, screening, Previous Versions, and DFS
- Certificate-services lab and auto-enrollment
- Windows Event Forwarding and health dashboards
- Inventory, stale-object, password-expiry, and service-health reports

### Recovery and troubleshooting

- Directory object restoration
- System State backup planning
- Domain-controller outage and rebuild exercises
- Policy and file restoration
- DNS, trust, SYSVOL, DHCP, lockout, policy, permission, and time-skew scenarios

## Evidence model

Every task should include:

- Objective
- Implementation commands or script
- Expected result
- Simulated finding when the live lab is unavailable
- Real validation evidence when tested
- Security impact
- Rollback or recovery steps
- Lessons learned

Evidence must be labelled as simulated portfolio data, sanitized lab evidence, or sanitized production evidence.

## Engineering standards

- PowerShell syntax tests
- Pester tests for reusable functions
- PSScriptAnalyzer
- GitHub Actions on Windows
- JSON configuration schema
- Idempotent automation where practical
- Semantic versioning and changelog
- Security, contribution, and data-handling documentation

## Delivery phases

### Phase 1

- Parameterized configuration
- Hyper-V network and VM deployment modules
- AD structure, DNS, DHCP, and validation modules
- CI, tests, and architecture documentation

### Phase 2

- Group Policy, file services, security, monitoring, and certificate automation
- Synthetic evidence fixtures
- Health and inventory reporting

### Phase 3

- Recovery automation
- Full lab rebuild workflow
- Real screenshots and validation output
- Employer demonstration package

## Completion standard

The upgrade is ready only after automation passes CI, a controlled Windows or Hyper-V lab test succeeds, documentation is navigable, recovery exercises are reviewed, and simulated findings are never presented as live evidence.