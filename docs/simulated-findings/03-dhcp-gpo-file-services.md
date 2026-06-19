# Simulated Findings — DHCP, Group Policy, and File Services

This document contains representative portfolio data for a controlled lab scenario. It is not live production evidence.

## DHCP

- The planned client scope covered 10.10.10.100 through 10.10.10.199.
- Infrastructure addresses were excluded from dynamic allocation.
- Scope options included the lab gateway, both internal DNS servers, and the domain suffix.
- Reservations were documented for infrastructure devices requiring predictable addressing.
- Lease renewal, gateway reachability, and DNS registration were included in validation.

### Simulated findings

- Test clients received addresses from the correct scope.
- No overlap existed between static and dynamic address ranges.
- Client records were represented as registering correctly in DNS.
- Scope utilization remained below the documented warning threshold.

## Group Policy

- Policies were separated by purpose instead of combined into one large object.
- Planned controls included Windows Defender, Firewall, Windows LAPS, PowerShell logging, screen lock, BitLocker, mapped drives, printers, and Windows Update.
- Security filtering and a test OU were included to reduce unintended impact.
- Policy validation was documented through resultant policy reporting and event logs.

### Simulated findings

- Workstation security settings applied to the intended test OU.
- Departmental drive mappings were represented as appearing only for matching users.
- Windows LAPS was documented as rotating local administrator credentials.
- PowerShell logging was represented as producing the expected operational records.

## File Services

- Department shares were documented for Finance, Human Resources, Sales, IT, Management, and Public data.
- Global role groups were nested into domain-local resource groups.
- Access-based enumeration, quotas, file screening, and Previous Versions were included.
- Direct user permissions were avoided.

### Simulated findings

- Authorized department users received the expected modify access.
- Users outside a department were represented as denied access.
- Hidden folders were not shown to users without permission.
- Quota warnings and file-screening events were included in sample results.
- Previous Versions was documented as restoring a deleted test file.

## Lessons learned

- Address planning should be finalized before DHCP activation.
- Group Policy should be tested in a narrow scope before wider deployment.
- File permissions are easier to audit when access is granted through groups rather than directly to users.