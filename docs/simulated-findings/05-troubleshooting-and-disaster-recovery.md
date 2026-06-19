# Simulated Findings — Troubleshooting and Disaster Recovery

This document contains representative portfolio data for a controlled lab scenario. It is not live production evidence.

## DNS registration failure

### Simulated symptom

A domain client could sign in with cached credentials but could not locate domain services reliably.

### Simulated root cause

The client was documented as using an external DNS resolver instead of the internal domain DNS servers.

### Simulated resolution

The adapter DNS settings were corrected, the local resolver cache was refreshed, and domain records were registered again.

### Simulated outcome

The client resolved domain service records and contacted a domain controller successfully.

---

## Broken secure channel

### Simulated symptom

A workstation displayed a trust relationship error during domain sign-in.

### Simulated root cause

The computer account password and local secure-channel state were represented as out of sync.

### Simulated resolution

The secure channel was repaired from an administrative session and then validated.

### Simulated outcome

Domain sign-in and policy processing returned to normal.

---

## Account lockout

### Simulated symptom

A test user repeatedly locked shortly after the account was unlocked.

### Simulated root cause

An old saved credential was documented in a scheduled task on a client device.

### Simulated resolution

The saved credential was updated and the task was tested again.

### Simulated outcome

No additional lockout events appeared during the observation period.

---

## DHCP failure

### Simulated symptom

A client received an automatic private address instead of an address from the lab scope.

### Simulated root cause

The DHCP service was represented as stopped during the exercise.

### Simulated resolution

The service was started and the client lease was renewed.

### Simulated outcome

The client received an address from the expected range and registered in DNS.

---

## Group Policy filtering problem

### Simulated symptom

A workstation security policy did not apply to the intended test computer.

### Simulated root cause

The computer account was missing from the group used for policy filtering.

### Simulated resolution

The filtering group membership was corrected and policy was refreshed.

### Simulated outcome

The resultant policy report included the expected settings.

---

## File-access incident

### Simulated symptom

A Finance user could see the department share but could not modify files.

### Simulated root cause

The user belonged to the role group, but the role group was not nested into the correct resource group.

### Simulated resolution

The group nesting was corrected and the user session token was refreshed.

### Simulated outcome

Modify access worked as designed while unauthorized users remained denied.

---

## Deleted user recovery

### Simulated exercise

A test user was deleted and restored through the documented directory recovery process.

### Simulated findings

- The object was represented as recoverable because directory object recovery had been enabled.
- Core attributes and group membership were documented as restored.
- Authentication and resource access were revalidated after recovery.

---

## Domain-controller outage

### Simulated exercise

`LAB-DC01` was treated as unavailable while `LAB-DC02` remained online.

### Simulated findings

- Existing clients continued to locate a domain controller.
- Internal name resolution remained available through the secondary DNS server.
- The event reinforced the need for clients to list both internal DNS servers.
- Recovery validation included replication, name resolution, and authentication checks.

## Lessons learned

- Capture evidence before applying a fix.
- Correct the smallest confirmed cause first.
- Validate from the affected user or client perspective.
- Recovery is incomplete until authentication, DNS, replication, and resource access have been tested.