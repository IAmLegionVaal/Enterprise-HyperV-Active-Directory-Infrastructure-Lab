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

function Get-EhlHostReadiness {
    [CmdletBinding()]
    param()

    $hyperVCmdletsAvailable = [bool](Get-Command Get-VMHost -ErrorAction SilentlyContinue)
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
    $processor = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop | Select-Object -First 1
    $hostInfo = $null
    $existingVms = @()
    $switches = @()

    if ($hyperVCmdletsAvailable) {
        $hostInfo = Get-VMHost -ErrorAction Stop
        $existingVms = @(Get-VM -ErrorAction SilentlyContinue | Select-Object Name,State,Generation,MemoryStartup,ProcessorCount)
        $switches = @(Get-VMSwitch -ErrorAction SilentlyContinue | Select-Object Name,SwitchType)
    }

    [PSCustomObject]@{
        Classification          = 'LIVE READ-ONLY HOST READINESS DATA'
        ComputerName            = $env:COMPUTERNAME
        HyperVCmdletsAvailable  = $hyperVCmdletsAvailable
        TotalMemoryGB           = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 1)
        LogicalProcessorCount   = [int]$computerSystem.NumberOfLogicalProcessors
        ProcessorName           = $processor.Name
        VirtualizationFirmwareEnabled = [bool]$processor.VirtualizationFirmwareEnabled
        HostConfiguration       = $hostInfo
        ExistingVirtualMachines = $existingVms
        VirtualSwitches         = $switches
        CollectedAtUtc          = [datetime]::UtcNow
    }
}

function New-EhlHtmlReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][psobject]$Result,
        [Parameter(Mandatory)][string]$Path
    )

    $summaryRows = @(
        [PSCustomObject]@{ Metric = 'Lab'; Value = $Result.Summary.LabName },
        [PSCustomObject]@{ Metric = 'Virtual Machines'; Value = $Result.Summary.VirtualMachines },
        [PSCustomObject]@{ Metric = 'Requested Memory GB'; Value = $Result.Summary.RequestedMemoryGB },
        [PSCustomObject]@{ Metric = 'Usable Host Memory GB'; Value = $Result.Summary.UsableHostMemoryGB },
        [PSCustomObject]@{ Metric = 'Critical'; Value = $Result.Summary.Critical },
        [PSCustomObject]@{ Metric = 'High'; Value = $Result.Summary.High },
        [PSCustomObject]@{ Metric = 'Medium'; Value = $Result.Summary.Medium },
        [PSCustomObject]@{ Metric = 'Low'; Value = $Result.Summary.Low }
    )
    $summaryHtml = $summaryRows | ConvertTo-Html -Fragment
    $findingRows = foreach ($finding in @($Result.Findings)) {
        [PSCustomObject]@{
            Severity       = $finding.Severity
            Confidence     = $finding.Confidence
            Check          = $finding.Check
            Title          = $finding.Title
            Evidence       = $finding.Evidence
            Impact         = $finding.Impact
            Recommendation = $finding.Recommendation
        }
    }
    $findingsHtml = $findingRows | ConvertTo-Html -Fragment
    $style = '<style>body{font-family:Segoe UI,Arial;margin:32px;background:#f8fafc;color:#1f2937}table{border-collapse:collapse;width:100%;background:white;margin:12px 0 28px}th,td{border:1px solid #cbd5e1;padding:8px;text-align:left;vertical-align:top}th{background:#e2e8f0}h1,h2{color:#0f172a}.meta{color:#475569}</style>'
    $classification = if ($Result.Configuration.Classification) { $Result.Configuration.Classification } else { 'UNCLASSIFIED LAB CONFIGURATION' }
    $html = "<!doctype html><html><head><meta charset='utf-8'><title>Enterprise Lab Plan Validation</title>$style</head><body><h1>Enterprise Lab Plan Validation</h1><p class='meta'>Generated $([datetime]::UtcNow.ToString('u')) UTC | Classification: $classification</p><h2>Summary</h2>$summaryHtml<h2>Findings</h2>$findingsHtml</body></html>"
    Set-Content -Path $Path -Value $html -Encoding UTF8
    Get-Item -Path $Path
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
            LabName           = $Configuration.LabName
            VirtualMachines   = $vms.Count
            RequestedMemoryGB = $requestedMemory
            UsableHostMemoryGB = $usableMemory
            FindingCount      = $sorted.Count
            Critical          = @($sorted | Where-Object Severity -eq 'Critical').Count
            High              = @($sorted | Where-Object Severity -eq 'High').Count
            Medium            = @($sorted | Where-Object Severity -eq 'Medium').Count
            Low               = @($sorted | Where-Object Severity -eq 'Low').Count
            ValidatedAtUtc     = [datetime]::UtcNow
        }
        Findings      = $sorted
        Configuration = $Configuration
    }

    if ($OutputPath) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        $result | ConvertTo-Json -Depth 10 | Set-Content -Path (Join-Path $OutputPath 'lab-plan-validation.json') -Encoding UTF8
        $sorted | Export-Csv -Path (Join-Path $OutputPath 'findings.csv') -NoTypeInformation -Encoding UTF8
        New-EhlHtmlReport -Result $result -Path (Join-Path $OutputPath 'report.html') | Out-Null
    }

    $result
}

function Invoke-EhlProvisioning {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory)][psobject]$Configuration,
        [Parameter(Mandatory)][string]$VhdRoot,
        [string]$SwitchName = 'EnterpriseLab-Internal',
        [ValidateRange(20,500)][int]$VhdSizeGB = 80,
        [switch]$Force
    )

    if (-not (Get-Command New-VM -ErrorAction SilentlyContinue)) {
        throw 'Hyper-V PowerShell cmdlets are required for provisioning.'
    }

    $validation = Test-EhlPlan -Configuration $Configuration
    $blocking = @($validation.Findings | Where-Object Severity -in @('Critical','High'))
    if ($blocking.Count -gt 0 -and -not $Force) {
        throw "Provisioning blocked by $($blocking.Count) Critical or High plan finding(s). Correct the plan or use -Force after review."
    }

    New-Item -ItemType Directory -Path $VhdRoot -Force | Out-Null
    if (-not (Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue)) {
        if ($PSCmdlet.ShouldProcess($SwitchName, 'Create internal Hyper-V virtual switch')) {
            New-VMSwitch -Name $SwitchName -SwitchType Internal -ErrorAction Stop | Out-Null
        }
    }

    $created = [System.Collections.Generic.List[object]]::new()
    foreach ($vm in @($Configuration.VirtualMachines)) {
        if (Get-VM -Name $vm.Name -ErrorAction SilentlyContinue) {
            $created.Add([PSCustomObject]@{ Name = $vm.Name; Status = 'Existing'; VhdPath = $null })
            continue
        }

        $vhdPath = Join-Path $VhdRoot ("{0}.vhdx" -f $vm.Name)
        $memoryBytes = [int64]$vm.StartupMemoryGB * 1GB
        if ($PSCmdlet.ShouldProcess($vm.Name, 'Create Hyper-V virtual machine and dynamic VHDX')) {
            New-VM -Name $vm.Name -Generation ([int]$vm.Generation) -MemoryStartupBytes $memoryBytes -NewVHDPath $vhdPath -NewVHDSizeBytes ([int64]$VhdSizeGB * 1GB) -SwitchName $SwitchName -ErrorAction Stop | Out-Null
            Set-VMProcessor -VMName $vm.Name -Count 2 -ErrorAction Stop
            Set-VMMemory -VMName $vm.Name -DynamicMemoryEnabled $true -MinimumBytes 1GB -StartupBytes $memoryBytes -MaximumBytes ($memoryBytes * 2) -ErrorAction Stop
            $created.Add([PSCustomObject]@{ Name = $vm.Name; Status = 'Created'; VhdPath = $vhdPath })
        }
    }

    @($created)
}

Export-ModuleMember -Function Get-EhlSeverityRank,New-EhlFinding,Import-EhlConfiguration,Get-EhlHostReadiness,New-EhlHtmlReport,Test-EhlPlan,Invoke-EhlProvisioning
