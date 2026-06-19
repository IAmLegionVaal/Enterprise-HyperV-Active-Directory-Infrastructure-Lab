# Simulated Findings — Portfolio and Final Validation

This document contains representative portfolio data for a controlled lab scenario. It is not live production evidence.

## Portfolio summary

The project was documented to demonstrate:

- Hyper-V infrastructure planning
- Windows Server deployment
- Active Directory design
- DNS and DHCP configuration
- Group Policy administration
- File-service permissions
- Security controls
- Monitoring and reporting
- PowerShell automation
- Troubleshooting
- Disaster recovery

## Simulated final validation matrix

| Area | Simulated result | Notes |
|---|---|---|
| Hyper-V host | Pass | Internal switch, NAT, storage layout, and VM inventory documented |
| Domain controllers | Pass | Two-controller design represented as available |
| Directory replication | Pass | No persistent replication failures in the example findings |
| DNS | Pass | Forward, reverse, and domain service records represented as available |
| DHCP | Pass | Test clients represented as receiving addresses from the correct scope |
| Group Policy | Pass | Security and user-environment policies represented as applying to test targets |
| File services | Pass | Department access and denial tests documented |
| Security | Pass with review items | Ongoing privileged-access review retained as a recurring control |
| Monitoring | Pass | Health and inventory reports documented |
| Automation | Pass | Repeatable starter scripts and sample outputs included |
| Troubleshooting | Pass | Multiple simulated incidents documented with root cause and resolution |
| Disaster recovery | Pass | Deleted-object and controller-outage exercises documented |
| Repository review | Pass | Documentation structure and simulated findings pack added |

## Simulated employer-facing outcomes

- Designed a multi-server Microsoft enterprise lab with redundant directory and DNS services.
- Documented a structured OU, group, and access-control model using role and resource groups.
- Produced reusable PowerShell starter scripts for infrastructure deployment, inventory, and health reporting.
- Documented realistic troubleshooting cases involving DNS, trust, account lockout, DHCP, policy, and file access.
- Included recovery exercises for deleted directory objects and domain-controller outage scenarios.

## Evidence register

| Evidence type | Repository location |
|---|---|
| Architecture | `architecture/` |
| Build guides | `build-guides/` |
| Scripts | `scripts/` |
| Security baseline | `security/` |
| Troubleshooting | `troubleshooting-scenarios/` |
| Disaster recovery | `disaster-recovery/` |
| Simulated findings | `docs/simulated-findings/` |
| Future screenshots | `screenshots/` |
| Future reports | `sample-reports/` |

## Remaining real-lab work

The simulated findings pack is complete as a documentation exercise. The following evidence should replace the representative results after the actual lab is built:

- Hyper-V Manager screenshots
- Domain-controller health output
- DNS and DHCP validation output
- Group Policy resultant reports
- File-access test evidence
- Security event records
- PowerShell reports
- Recovery test screenshots

## Final disclosure

This portfolio pack intentionally labels simulated data as simulated. It may be used to show planning, documentation, and troubleshooting methodology, but it should not be described as live production evidence.