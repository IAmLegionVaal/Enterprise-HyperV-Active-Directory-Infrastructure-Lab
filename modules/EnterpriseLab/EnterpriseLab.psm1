Set-StrictMode -Version Latest

function Get-EhlSeverityRank {
    [CmdletBinding()]
    param([Parameter(Mandatory)][ValidateSet('Critical','High','Medium','Low','Informational')][string]$Severity)
    switch ($Severity) {
        'Critical' { 5 }
        'High' { 4 }
        'Medium' { 3 }
        'Low' { 2 }
        'Informational' { 1 }
    }
}

function New-EhlFinding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Check,
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)][ValidateSet('Critical','High','Medium','Low','Informational')][string]$Severity,
        [Parameter(Mandatory)][ValidateRange(0,100)][int]$Confidence,
        [Parameter(Mandatory)][string]$Evidence,
        [Parameter(Mandatory)][string]$Impact,
        [Parameter(Mandatory)][string]$Recommendation
    )

    [PSCustomObject]@{
        FindingId      = [guid]::NewGuid().Guid
        Check          = $Check
        Title          = $Title
        Severity       = $Severity
        SeverityRank   = Get-EhlSeverityRank -Severity $Severity
        Confidence     = $Confidence
        Evidence       = $Evidence
        Impact         = $Impact
        Recommendation = $Recommendation
        ObservedAtUtc  = [datetime]::UtcNow
    }
}

function Import-EhlConfiguration {
    [CmdletBinding()]
    param([Parameter(Mandatory)][ValidateScript({ Test-Path $_ -PathType Leaf })][string]$Path)
    Get-Content -Path $Path -Raw -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
}

function Test-EhlPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][psobject]$Configuration,
        [string]$OutputPath
    )

    $findings = [System.Collections.Generic.List[object]]::new()
    $vms = @($Configuration.VirtualMachines)

    $duplicateNames = @($vms | Group-Object Name | Where-Object Count -gt 1)
    foreach ($group in $duplicateNames) {
        $findings.Add((New-EhlFinding -Check 'VirtualMachineNames' -Title "Duplicate virtual machine name: $($group.Name)" -Severity High -Confidence 99 -Evidence "$($group.Count) definitions use the same name" -Impact 'Automation may overwrite, update, or target the wrong virtual machine.' -Recommendation 'Assign a unique, documented name to every VM definition.'))
    }

    $duplicateIps = @($vms | Group-Object IPv4Address | Where-Object { $_.Name -and $_.Count -gt 1 })
    foreach ($group in $duplicateIps) {
        $findings.Add((New-EhlFinding -Check 'AddressPlan' -Title "Duplicate IPv4 address: $($group.Name)" -Severity High -Confidence 99 -Evidence "$($group.Count) VM definitions use $($group.Name)" -Impact 'Address conflicts can disrupt domain, DNS, DHCP, management, and application traffic.' -Recommendation 'Correct the address plan and reserve each static address once.'))
    }

    $usableMemory = [int]$Configuration.Host.TotalMemoryGB - [int]$Configuration.Host.ReservedMemoryGB
    $requestedMemory = ($vms | Measure-Object -Property StartupMemoryGB -Sum).Sum
    if ($requestedMemory -gt $usableMemory) {
        $findings.Add((New-EhlFinding -Check 'HostCapacity' -Title 'Planned VM startup memory exceeds host capacity' -Severity Critical -Confidence 98 -Evidence "RequestedGB=$requestedMemory; UsableGB=$usableMemory" -Impact 'The host may fail to start all VMs or experience severe memory pressure.' -Recommendation 'Reduce startup allocations, add capacity, or distribute workloads across hosts.'))
    }

    $domainControllers = @($vms | Where-Object { $_.Roles -contains 'DomainController' })
    if ($domainControllers.Count -lt 2) {
        $findings.Add((New-EhlFinding -Check 'DirectoryResilience' -Title 'Fewer than two domain controllers planned' -Severity High -Confidence 97 -Evidence "DomainControllerCount=$($domainControllers.Count)" -Impact 'A single controller failure may interrupt authentication, DNS, and directory services.' -Recommendation 'Plan at least two appropriately placed domain controllers for the lab design.'))
    }

    $domainControllerIps = @($domainControllers | ForEach-Object IPv4Address)
    foreach ($dnsServer in @($Configuration.Network.DnsServers)) {
        if ($dnsServer -notin $domainControllerIps) {
            $findings.Add((New-EhlFinding -Check 'DnsDesign' -Title "DNS server is not a planned domain controller: $dnsServer" -Severity Medium -Confidence 92 -Evidence "ConfiguredDnsServer=$dnsServer" -Impact 'Domain members may bypass AD-integrated DNS and fail service discovery.' -Recommendation 'Use the planned domain controllers as DNS resolvers and document approved exceptions.'))
        }
    }

    foreach ($vm in $vms) {
        if ([int]$vm.Generation -ne 2) {
            $findings.Add((New-EhlFinding -Check 'VirtualMachineStandard' -Title "Generation 1 VM planned: $($vm.Name)" -Severity Medium -Confidence 95 -Evidence "Generation=$($vm.Generation)" -Impact 'The VM cannot use the full Generation 2 security and firmware feature set.' -Recommendation 'Use Generation 2 unless a documented compatibility requirement exists.'))
        }
    }

    $sortProperties = @(
        @{ Expression = 'SeverityRank'; Descending = $true },
        @{ Expression = 'Confidence'; Descending = $true }
    )
    $sorted = @($findings | Sort-Object -Property $sortProperties)

    $result = [PSCustomObject]@{
        Summary = [PSCustomObject]@{
            LabName          = $Configuration.LabName
            VirtualMachines  = $vms.Count
            RequestedMemoryGB = $requestedMemory
            UsableHostMemoryGB = $usableMemory
            FindingCount     = $sorted.Count
            Critical         = @($sorted | Where-Object Severity -eq 'Critical').Count
            High             = @($sorted | Where-Object Severity -eq 'High').Count
            Medium           = @($sorted | Where-Object Severity -eq 'Medium').Count
            Low              = @($sorted | Where-Object Severity -eq 'Low').Count
            ValidatedAtUtc    = [datetime]::UtcNow
        }
        Findings      = $sorted
        Configuration = $Configuration
    }

    if ($OutputPath) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        $result | ConvertTo-Json -Depth 10 | Set-Content -Path (Join-Path $OutputPath 'lab-plan-validation.json') -Encoding UTF8
        $sorted | Export-Csv -Path (Join-Path $OutputPath 'findings.csv') -NoTypeInformation -Encoding UTF8
    }

    $result
}

Export-ModuleMember -Function Get-EhlSeverityRank,New-EhlFinding,Import-EhlConfiguration,Test-EhlPlan
