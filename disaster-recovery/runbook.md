# Disaster Recovery Runbook

Recovery priority: authentication, DNS, DHCP, file services, certificates, monitoring.

```powershell
Enable-ADOptionalFeature -Identity "Recycle Bin Feature" -Scope ForestOrConfigurationSet -Target "corp.pretoriuslab.local"
Get-ADObject -Filter 'isDeleted -eq $true' -IncludeDeletedObjects
```

After recovery validate with `dcdiag`, `repadmin /replsummary`, `repadmin /showrepl`, and `dcdiag /test:dns`.