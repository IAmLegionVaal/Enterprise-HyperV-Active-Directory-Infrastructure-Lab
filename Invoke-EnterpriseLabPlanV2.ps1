[CmdletBinding()]
param(
    [string]$ConfigurationPath = (Join-Path $PSScriptRoot 'config\lab.synthetic.json'),
    [string]$OutputPath = (Join-Path $PSScriptRoot 'artifacts\latest-validation')
)

$modulePath = Join-Path $PSScriptRoot 'modules\EnterpriseLab\EnterpriseLab.psd1'
Import-Module $modulePath -Force -ErrorAction Stop
$configuration = Import-EhlConfiguration -Path $ConfigurationPath
$result = Test-EhlPlan -Configuration $configuration -OutputPath $OutputPath
$result.Summary | Format-List
$result.Findings | Format-Table Severity,Confidence,Check,Title -AutoSize
