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