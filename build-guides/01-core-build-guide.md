# Core Build Guide

## Hyper-V

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
New-VMSwitch -Name "PretoriusLab-Internal" -SwitchType Internal
New-NetIPAddress -InterfaceAlias "vEthernet (PretoriusLab-Internal)" -IPAddress 10.10.10.1 -PrefixLength 24
New-NetNat -Name "PretoriusLab-NAT" -InternalIPInterfaceAddressPrefix "10.10.10.0/24"
```

## DC01

```powershell
Install-WindowsFeature AD-Domain-Services,DNS -IncludeManagementTools
$Dsrm=Read-Host "Enter DSRM password" -AsSecureString
Install-ADDSForest -DomainName "corp.pretoriuslab.local" -DomainNetbiosName "PRETORIUSLAB" -InstallDNS -SafeModeAdministratorPassword $Dsrm
```

## Validation

```powershell
Get-ADDomain
Get-ADForest
Get-ADDomainController
dcdiag
dcdiag /test:dns
repadmin /replsummary
```