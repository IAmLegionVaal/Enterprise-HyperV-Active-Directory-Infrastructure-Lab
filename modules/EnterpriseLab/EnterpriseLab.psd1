@{
    RootModule        = 'EnterpriseLab.psm1'
    ModuleVersion     = '2.1.0'
    GUID              = '52275ab5-ae6e-41c8-8509-57027f816451'
    Author            = 'Dewald Pretorius'
    CompanyName       = 'Community'
    Copyright         = '(c) 2026 Dewald Pretorius. All rights reserved.'
    Description       = 'Enterprise Hyper-V and Active Directory lab planning, readiness, validation, and controlled provisioning framework.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'New-EhlFinding',
        'Get-EhlSeverityRank',
        'Import-EhlConfiguration',
        'Get-EhlHostReadiness',
        'New-EhlHtmlReport',
        'Test-EhlPlan',
        'Invoke-EhlProvisioning'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('HyperV','ActiveDirectory','Lab','Infrastructure','PowerShell')
            ProjectUri = 'https://github.com/IAmLegionVaal/Enterprise-HyperV-Active-Directory-Infrastructure-Lab'
        }
    }
}
