#requires -Modules ActiveDirectory
#requires -Version 5.1
<# Created by Dewald Pretorius #>
[CmdletBinding()]param([string]$OutputDirectory="$env:USERPROFILE\Desktop\AD-Health-Reports")
$ErrorActionPreference='SilentlyContinue';New-Item $OutputDirectory -ItemType Directory -Force|Out-Null
$Path=Join-Path $OutputDirectory ("AD-Health_{0}.txt" -f (Get-Date -Format yyyyMMdd_HHmmss))
@('ENTERPRISE ACTIVE DIRECTORY HEALTH REPORT','Created by Dewald Pretorius',"Generated: $(Get-Date)",'DOMAIN',(Get-ADDomain|Format-List|Out-String -Width 240),'FOREST',(Get-ADForest|Format-List|Out-String -Width 240),'DOMAIN CONTROLLERS',(Get-ADDomainController -Filter *|Format-Table HostName,Site,IPv4Address,IsGlobalCatalog -AutoSize|Out-String -Width 240),'REPADMIN',(repadmin /replsummary|Out-String),'DCDIAG',(dcdiag|Out-String),'DNS',(dcdiag /test:dns|Out-String))|Set-Content $Path -Encoding UTF8
Write-Host "Report created: $Path" -ForegroundColor Green