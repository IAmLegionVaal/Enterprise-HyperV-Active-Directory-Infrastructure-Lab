# Architecture Overview

```text
Internet
   |
Hyper-V NAT
   |
10.10.10.0/24
   +-- LAB-DC01     AD DS and DNS
   +-- LAB-DC02     Secondary AD DS and DNS
   +-- LAB-DHCP01   DHCP
   +-- LAB-FS01     File services and DFS
   +-- LAB-MGMT01   Administration
   +-- LAB-CA01     Certificate services
   +-- LAB-WEC01    Event collection
   +-- LAB-CLIENT01 Finance
   +-- LAB-CLIENT02 Human Resources
   +-- LAB-CLIENT03 IT
```

Design principles: least privilege, redundancy, centralized logging, repeatable automation, evidence-driven troubleshooting, and tested recovery.