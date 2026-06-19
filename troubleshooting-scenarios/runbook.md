# Troubleshooting Runbook

1. Confirm the symptom and business impact.
2. Identify affected users, devices, and services.
3. Capture logs before changes.
4. Test the lowest-risk hypothesis first.
5. Apply the minimum correction.
6. Validate service restoration.
7. Document root cause and prevention.

Useful commands:

```powershell
dcdiag
repadmin /replsummary
repadmin /showrepl
Resolve-DnsName corp.pretoriuslab.local -Type SRV
gpupdate /force
gpresult /h C:\Temp\GPResult.html
Test-ComputerSecureChannel -Verbose
```