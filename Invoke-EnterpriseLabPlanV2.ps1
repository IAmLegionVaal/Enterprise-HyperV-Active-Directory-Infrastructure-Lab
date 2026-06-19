[CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
param(
    [ValidateSet('Plan','HostReadiness','Provision')]
    [string]$Mode = 'Plan',
    [string]$ConfigurationPath = (Join-Path $PSScriptRoot 'config\lab.synthetic.json'),
    [string]$OutputPath = (Join-Path $PSScriptRoot 'artifacts\latest-validation'),
    [string]$VhdRoot = (Join-Path $env:PUBLIC 'Documents\Hyper-V\Virtual Hard Disks\EnterpriseLab'),
    [string]$SwitchName = 'EnterpriseLab-Internal',
    [ValidateRange(20,500)][int]$VhdSizeGB = 80,
    [switch]$Apply,
    [switch]$Force,
    [switch]$OpenReport
)

$modulePath = Join-Path $PSScriptRoot 'modules\EnterpriseLab\EnterpriseLab.psd1'
Import-Module $modulePath -Force -ErrorAction Stop
New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null

switch ($Mode) {
    'HostReadiness' {
        $readiness = Get-EhlHostReadiness
        $readiness | ConvertTo-Json -Depth 8 | Set-Content -Path (Join-Path $OutputPath 'host-readiness.json') -Encoding UTF8
        $readiness | Format-List
    }

    'Provision' {
        $configuration = Import-EhlConfiguration -Path $ConfigurationPath
        $validation = Test-EhlPlan -Configuration $configuration -OutputPath $OutputPath
        $validation.Summary | Format-List
        $validation.Findings | Format-Table Severity,Confidence,Check,Title -AutoSize

        $whatIfProvisioning = -not $Apply -or [bool]$WhatIfPreference
        if (-not $Apply) {
            Write-Warning 'Provisioning is running in preview mode. Use -Apply after reviewing the plan and validation report.'
        }

        $provisioned = Invoke-EhlProvisioning `
            -Configuration $configuration `
            -VhdRoot $VhdRoot `
            -SwitchName $SwitchName `
            -VhdSizeGB $VhdSizeGB `
            -Force:$Force `
            -WhatIf:$whatIfProvisioning

        $provisioned | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $OutputPath 'provisioning-result.json') -Encoding UTF8
        $provisioned | Format-Table Name,Status,VhdPath -AutoSize
    }

    default {
        $configuration = Import-EhlConfiguration -Path $ConfigurationPath
        $result = Test-EhlPlan -Configuration $configuration -OutputPath $OutputPath
        $result.Summary | Format-List
        $result.Findings | Format-Table Severity,Confidence,Check,Title -AutoSize
    }
}

$reportPath = Join-Path $OutputPath 'report.html'
if ($OpenReport -and (Test-Path $reportPath)) {
    Start-Process $reportPath
}
