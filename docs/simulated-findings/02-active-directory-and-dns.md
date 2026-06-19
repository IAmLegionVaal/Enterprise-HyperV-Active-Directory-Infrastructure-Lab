# Simulated Findings — Active Directory and DNS

This document contains representative portfolio data for a controlled lab scenario. It is not live production evidence.

## Domain controllers

- LAB-DC01 was documented as the first domain controller at 10.10.10.10.
- LAB-DC02 was documented as the secondary domain controller at 10.10.10.11.
- Replication was represented as healthy after normal convergence.
- Authentication continuity was included in the simulated DC01 outage test.

## Directory structure

- Separate OUs were planned for Admin, Departments, Computers, Groups, and Disabled Objects.
- Department OUs covered Finance, Human Resources, Sales, Information Technology, and Management.
- Critical OUs were documented as protected from accidental deletion.
- Administrative identities were separated from standard user identities.

## Groups and permissions

- Global role groups were nested into domain-local resource groups.
- Direct user permissions were avoided.
- Naming conventions made group purpose easier to understand and audit.

## DNS

- The internal zone was documented with secure dynamic updates.
- Forward and reverse records were included.
- Domain service records were represented as available from both domain controllers.
- External queries were handled through forwarders while clients continued using internal DNS.

## Simulated findings

- Directory and DNS services were represented as available from both servers.
- No persistent replication failures were recorded in the example results.
- The design supported controller redundancy and clearer troubleshooting.
- Internal DNS configuration remained a critical dependency for domain joins and sign-in.

## Lessons learned

- Directory health, DNS health, time synchronization, and replication should be reviewed together.
- Clients should use internal DNS servers only.
- Every controller change should be followed by replication and DNS validation.