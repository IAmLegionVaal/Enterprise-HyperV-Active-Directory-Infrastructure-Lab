#requires -Version 5.1
[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
$Owner='IAmLegionVaal'
$ProjectNumber=2
$RepoName='Enterprise-HyperV-Active-Directory-Infrastructure-Lab'
$Repo="$Owner/$RepoName"
$Root=Join-Path $HOME 'Documents\GitHub'
$Path=Join-Path $Root $RepoName

function Need($Name){if(-not(Get-Command $Name -ErrorAction SilentlyContinue)){throw "$Name is not installed or not in PATH."}}
function Put($Relative,$Text){$Full=Join-Path $Path $Relative;$Parent=Split-Path $Full -Parent;if($Parent){New-Item $Parent -ItemType Directory -Force|Out-Null};[IO.File]::WriteAllText($Full,$Text,[Text.UTF8Encoding]::new($false))}

Need gh;Need git
gh auth status;if($LASTEXITCODE-ne 0){throw 'Run gh auth login first.'}
gh project view $ProjectNumber --owner $Owner *> $null;if($LASTEXITCODE-ne 0){throw 'Run gh auth refresh -s project, then rerun.'}
gh repo view $Repo *> $null;if($LASTEXITCODE-ne 0){throw "Repository $Repo was not found."}
New-Item $Root -ItemType Directory -Force|Out-Null
if(Test-Path (Join-Path $Path '.git')){git -C $Path pull --ff-only}else{gh repo clone $Repo $Path}

@('architecture','build-guides','scripts','security','troubleshooting-scenarios','disaster-recovery','evidence','screenshots','sample-reports')|ForEach-Object{New-Item (Join-Path $Path $_) -ItemType Directory -Force|Out-Null}

Put 'README.md' @'
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
'@

Put 'architecture\architecture-overview.md' @'
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
'@

Put 'architecture\ip-address-plan.md' @'
# IP Address Plan

| Setting | Value |
|---|---|
| Network | 10.10.10.0/24 |
| Gateway | 10.10.10.1 |
| DNS 1 | 10.10.10.10 |
| DNS 2 | 10.10.10.11 |
| DHCP range | 10.10.10.100-10.10.10.199 |
| Static range | 10.10.10.10-10.10.10.99 |
'@

Put 'build-guides\01-core-build-guide.md' @'
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
'@

Put 'security\security-baseline.md' @'
# Security Baseline

- Separate standard and administrative accounts
- Windows LAPS
- Fine-grained password policies
- Defender and Firewall enabled
- BitLocker and screen-lock policies
- Advanced Audit Policy
- PowerShell logging and transcription
- Windows Event Forwarding
- AGDLP permissions
- No direct user permissions on file shares
'@

Put 'troubleshooting-scenarios\runbook.md' @'
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
'@

Put 'disaster-recovery\runbook.md' @'
# Disaster Recovery Runbook

Recovery priority: authentication, DNS, DHCP, file services, certificates, monitoring.

```powershell
Enable-ADOptionalFeature -Identity "Recycle Bin Feature" -Scope ForestOrConfigurationSet -Target "corp.pretoriuslab.local"
Get-ADObject -Filter 'isDeleted -eq $true' -IncludeDeletedObjects
```

After recovery validate with `dcdiag`, `repadmin /replsummary`, `repadmin /showrepl`, and `dcdiag /test:dns`.
'@

Put 'scripts\01-Create-HyperV-Network.ps1' @'
#requires -RunAsAdministrator
#requires -Version 5.1
<# Created by Dewald Pretorius #>
[CmdletBinding()]param([string]$SwitchName='PretoriusLab-Internal',[string]$NatName='PretoriusLab-NAT')
$ErrorActionPreference='Stop'
if(-not(Get-VMSwitch $SwitchName -ErrorAction SilentlyContinue)){New-VMSwitch -Name $SwitchName -SwitchType Internal}
$Adapter="vEthernet ($SwitchName)"
if(-not(Get-NetIPAddress -InterfaceAlias $Adapter -IPAddress 10.10.10.1 -ErrorAction SilentlyContinue)){New-NetIPAddress -InterfaceAlias $Adapter -IPAddress 10.10.10.1 -PrefixLength 24}
if(-not(Get-NetNat $NatName -ErrorAction SilentlyContinue)){New-NetNat -Name $NatName -InternalIPInterfaceAddressPrefix '10.10.10.0/24'}
Get-VMSwitch $SwitchName;Get-NetIPAddress -InterfaceAlias $Adapter;Get-NetNat $NatName
'@

Put 'scripts\02-Create-AD-Structure.ps1' @'
#requires -RunAsAdministrator
#requires -Modules ActiveDirectory
#requires -Version 5.1
<# Created by Dewald Pretorius #>
[CmdletBinding()]param([string]$DomainDn='DC=corp,DC=pretoriuslab,DC=local')
$ErrorActionPreference='Stop'
$Roots='Admin','Departments','Computers','Groups','Disabled Objects'
foreach($Ou in $Roots){if(-not(Get-ADOrganizationalUnit -LDAPFilter "(ou=$Ou)" -SearchBase $DomainDn -SearchScope OneLevel -ErrorAction SilentlyContinue)){New-ADOrganizationalUnit -Name $Ou -Path $DomainDn -ProtectedFromAccidentalDeletion $true}}
$Base="OU=Departments,$DomainDn"
foreach($Ou in 'Finance','Human Resources','Sales','Information Technology','Management'){if(-not(Get-ADOrganizationalUnit -LDAPFilter "(ou=$Ou)" -SearchBase $Base -SearchScope OneLevel -ErrorAction SilentlyContinue)){New-ADOrganizationalUnit -Name $Ou -Path $Base -ProtectedFromAccidentalDeletion $true}}
'@

Put 'scripts\03-AD-Health-Check.ps1' @'
#requires -Modules ActiveDirectory
#requires -Version 5.1
<# Created by Dewald Pretorius #>
[CmdletBinding()]param([string]$OutputDirectory="$env:USERPROFILE\Desktop\AD-Health-Reports")
$ErrorActionPreference='SilentlyContinue';New-Item $OutputDirectory -ItemType Directory -Force|Out-Null
$Path=Join-Path $OutputDirectory ("AD-Health_{0}.txt" -f (Get-Date -Format yyyyMMdd_HHmmss))
@('ENTERPRISE ACTIVE DIRECTORY HEALTH REPORT','Created by Dewald Pretorius',"Generated: $(Get-Date)",'DOMAIN',(Get-ADDomain|Format-List|Out-String -Width 240),'FOREST',(Get-ADForest|Format-List|Out-String -Width 240),'DOMAIN CONTROLLERS',(Get-ADDomainController -Filter *|Format-Table HostName,Site,IPv4Address,IsGlobalCatalog -AutoSize|Out-String -Width 240),'REPADMIN',(repadmin /replsummary|Out-String),'DCDIAG',(dcdiag|Out-String),'DNS',(dcdiag /test:dns|Out-String))|Set-Content $Path -Encoding UTF8
Write-Host "Report created: $Path" -ForegroundColor Green
'@

Put 'screenshots\.gitkeep' ''
Put 'sample-reports\.gitkeep' ''
Put 'evidence\.gitkeep' ''

git -C $Path add .
if(git -C $Path status --porcelain){git -C $Path commit -m 'Populate enterprise Hyper-V and Active Directory lab';git -C $Path push origin main}else{Write-Host 'Repository content already current.' -ForegroundColor Yellow}

$Items=(gh project item-list $ProjectNumber --owner $Owner --limit 500 --format json|ConvertFrom-Json).items
foreach($Item in $Items){
 if(-not $Item.id -or -not $Item.title){continue}
 $Body=@"
# $($Item.title)

## Objective

Implement and validate this activity in the Enterprise Hyper-V and Active Directory Infrastructure Lab.

## Required work

1. Capture the current state.
2. Implement the configuration in the isolated lab.
3. Use PowerShell where practical.
4. Apply least privilege.
5. Validate with commands, logs, or user testing.
6. Save sanitized evidence in the repository.
7. Document rollback and lessons learned.

## Completion checklist

- [ ] Configuration implemented
- [ ] Functional validation passed
- [ ] Event logs reviewed
- [ ] Command output saved
- [ ] Screenshots sanitized
- [ ] Security impact reviewed
- [ ] Recovery documented
- [ ] Repository documentation updated

Do not move this item to Done until the technical work and evidence are complete.
"@
 gh project item-edit --id $Item.id --body $Body *> $null
}
Write-Host 'Repository and Project documentation populated successfully.' -ForegroundColor Green
gh project view $ProjectNumber --owner $Owner --web
