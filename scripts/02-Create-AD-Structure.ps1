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