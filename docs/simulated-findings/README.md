# Simulated Findings Documentation Pack

> **Important disclosure:** All findings in this folder are simulated portfolio data for a controlled enterprise-lab scenario. They are not measurements from a live production environment and should not be represented as such.

## Purpose

This pack demonstrates how the Enterprise Hyper-V and Active Directory Infrastructure Lab would be documented after implementation, validation, troubleshooting, and recovery testing.

## Scenario summary

- Domain: `corp.pretoriuslab.local`
- NetBIOS name: `PRETORIUSLAB`
- Site: `Johannesburg-Lab`
- Subnet: `10.10.10.0/24`
- Gateway: `10.10.10.1`
- Primary DNS: `10.10.10.10`
- Secondary DNS: `10.10.10.11`
- DHCP range: `10.10.10.100-10.10.10.199`

## Documentation set

1. [Planning and Hyper-V findings](01-planning-and-hyperv.md)
2. [Active Directory and DNS findings](02-active-directory-and-dns.md)
3. [DHCP, Group Policy, and File Services findings](03-dhcp-gpo-file-services.md)
4. [Security, Monitoring, and Automation findings](04-security-monitoring-automation.md)
5. [Troubleshooting and Disaster Recovery findings](05-troubleshooting-and-disaster-recovery.md)
6. [Portfolio and Final Validation summary](06-portfolio-and-final-validation.md)
7. [Core Infrastructure and Services task matrix](07-task-matrix-core-services.md)
8. [Security, Recovery, and Portfolio task matrix](08-task-matrix-security-recovery-portfolio.md)

## Simulated completion convention

Each task is documented with:

- Objective
- Simulated implementation
- Simulated findings
- Validation evidence
- Risks and security considerations
- Recovery or rollback notes
- Lessons learned

## Evidence note

Screenshots, logs, reports, and command output in this repository are representative examples. Real lab evidence should replace them when the environment is physically built and tested.