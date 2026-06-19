# Simulated Task Matrix — Core Infrastructure and Services

> All entries are representative portfolio data. `Simulated complete` means the documentation scenario is complete, not that live evidence exists.

| Task | Status | Representative result |
|---|---|---|
| Hardware and software requirements | Simulated complete | A 32 GB RAM host and SSD storage were selected as the practical baseline. |
| IP address plan | Simulated complete | Static server, DHCP client, gateway, DNS, and reserved ranges were separated. |
| Server naming standard | Simulated complete | Role-based names improved filtering and troubleshooting. |
| VM resource allocation plan | Simulated complete | Generation 2 VMs and role-based CPU, memory, and disk were documented. |
| VM storage locations | Simulated complete | VM, VHD, ISO, export, and backup folders were separated. |
| Windows Server template | Simulated complete | A generalized baseline reduced repeated installation work. |
| Windows 11 template | Simulated complete | Updates, integration settings, and domain-join readiness were included. |
| Isolated lab network | Simulated complete | An internal switch separated the lab from the physical LAN. |
| NAT internet access | Simulated complete | Controlled internet access was provided without direct exposure. |
| Checkpoint procedures | Simulated complete | Checkpoints were limited to short-term testing and not treated as backups. |
| Deploy DC01 | Simulated complete | LAB-DC01 was documented at 10.10.10.10 as the first controller and DNS server. |
| Deploy DC02 | Simulated complete | LAB-DC02 was documented at 10.10.10.11 for redundancy. |
| FSMO role validation | Simulated complete | Role ownership was documented on LAB-DC01. |
| Sites and Services | Simulated complete | Johannesburg-Lab and 10.10.10.0/24 were associated. |
| Time synchronization | Simulated complete | The PDC Emulator was documented as the authoritative source. |
| OU structure | Simulated complete | Users, computers, servers, groups, admins, and disabled objects were separated. |
| Users and groups | Simulated complete | Department users and role groups followed a consistent standard. |
| Group naming standards | Simulated complete | Global role and domain-local resource prefixes clarified purpose. |
| Fine-grained password policies | Simulated complete | Standard, privileged, and service identities were separated by risk. |
| User onboarding workflow | Simulated complete | CSV-driven creation standardized OU placement and groups. |
| User offboarding workflow | Simulated complete | Disablement, group removal, archival, and audit steps were documented. |
| Managed service account test | Simulated complete | Managed credentials reduced manual service-account handling. |
| DNS forward zone | Simulated complete | Secure dynamic updates and domain-integrated replication were documented. |
| DNS reverse zone | Simulated complete | PTR records improved identification in logs. |
| DNS forwarders | Simulated complete | External queries used forwarders while clients stayed on internal DNS. |
| DNS scavenging | Simulated complete | Conservative cleanup intervals protected static records. |
| DNS diagnostics | Simulated complete | Operational logs were identified for registration and lookup issues. |
| DHCP authorization | Simulated complete | Only the approved domain DHCP server was represented as authorized. |
| DHCP scope | Simulated complete | The client scope covered 10.10.10.100 through 10.10.10.199. |
| DHCP reservations | Simulated complete | Predictable infrastructure addresses were documented. |
| DHCP failover | Simulated complete | Lease continuity and partner-state behavior were included. |
| Windows 11 clients | Simulated complete | Finance, HR, and IT clients were documented with domain membership. |
| Domain security baseline | Simulated complete | Defender, Firewall, auditing, and credential protection were included. |
| Windows LAPS | Simulated complete | Local admin credential rotation and delegated retrieval were documented. |
| PowerShell logging | Simulated complete | Module, script-block, and transcription logging were included. |
| Removable storage restrictions | Simulated complete | Standard users were restricted with documented exceptions. |
| Mapped drives | Simulated complete | Department groups controlled drive mappings. |
| Printer deployment | Simulated complete | Department printers were represented as policy-deployed. |
| Screen-lock policy | Simulated complete | Inactivity and password-protected locking were included. |
| BitLocker policy | Simulated complete | Encryption, TPM use, and recovery-key backup were documented. |
| Windows Update policy | Simulated complete | Maintenance windows, restarts, and notifications were standardized. |
| GPO backup | Simulated complete | Versioned backups were included in the repository design. |
| Department folders | Simulated complete | Finance, HR, Sales, IT, Management, and Public shares were documented. |
| AGDLP permissions | Simulated complete | Role groups were nested into resource groups without direct user ACLs. |
| Access-based enumeration | Simulated complete | Users were represented as seeing only authorized folders. |
| File quotas | Simulated complete | Warning and critical thresholds were documented. |
| File screening | Simulated complete | Prohibited file types were represented as blocked or monitored. |
| Previous Versions | Simulated complete | A deleted test file was represented as restored. |
| DFS Namespace | Simulated complete | Department shares were presented through a domain namespace. |
| DFS Replication | Simulated complete | Synchronization, backlog, and conflict checks were included. |

Live screenshots and command output remain pending until the actual environment is built.