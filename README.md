# Enterprise Hyper-V and Active Directory Infrastructure Lab

Created by **Dewald Pretorius**

## Purpose

Employer-facing lab demonstrating Hyper-V, Windows Server, Active Directory, DNS, DHCP, Group Policy, file services, security, PowerShell automation, troubleshooting, monitoring, and disaster recovery.

## Planned environment

| VM | Role | Address |
|---|---|---:|
| LAB-DC01 | Primary domain controller and DNS | 10.10.10.10 |
| LAB-DC02 | Secondary domain controller and DNS | 10.10.10.11 |
| LAB-DHCP01 | DHCP | 10.10.10.20 |
| LAB-FS01 | File and DFS server | 10.10.10.30 |
| LAB-MGMT01 | Management workstation | 10.10.10.40 |
| LAB-CA01 | Certificate authority | 10.10.10.50 |
| LAB-WEC01 | Event collector | 10.10.10.60 |
| LAB-CLIENT01 | Finance client | DHCP |
| LAB-CLIENT02 | HR client | DHCP |
| LAB-CLIENT03 | IT client | DHCP |

Domain: `corp.pretoriuslab.local`  
NetBIOS: `PRETORIUSLAB`  
Subnet: `10.10.10.0/24`

## Completion standard

A task is complete only after implementation, validation, sanitized evidence, security review, rollback notes, and lessons learned.

## Current status

Repository, Project board, roadmap, architecture, documentation structure, and starter automation are prepared. Technical infrastructure tasks remain open until built and validated.