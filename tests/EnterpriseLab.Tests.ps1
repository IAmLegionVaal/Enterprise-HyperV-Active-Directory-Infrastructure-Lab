BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..\modules\EnterpriseLab\EnterpriseLab.psd1'
    Import-Module $modulePath -Force
    $configurationPath = Join-Path $PSScriptRoot '..\config\lab.synthetic.json'
    $script:Configuration = Import-EhlConfiguration -Path $configurationPath
}

Describe 'EnterpriseLab module' {
    It 'imports successfully' {
        Get-Module EnterpriseLab | Should -Not -BeNullOrEmpty
    }

    It 'creates normalized findings' {
        $finding = New-EhlFinding -Check Test -Title 'Synthetic plan issue' -Severity Medium -Confidence 80 -Evidence Evidence -Impact Impact -Recommendation Recommendation
        $finding.SeverityRank | Should -Be 3
        $finding.FindingId | Should -Not -BeNullOrEmpty
    }

    It 'detects expected synthetic design issues' {
        $result = Test-EhlPlan -Configuration $script:Configuration
        $result.Summary.FindingCount | Should -Be 3
        $result.Summary.High | Should -Be 1
        $result.Summary.Medium | Should -Be 2
        $result.Summary.RequestedMemoryGB | Should -Be 24
        $result.Findings.Title | Should -Contain 'Duplicate IPv4 address: 10.10.0.11'
        $result.Findings.Title | Should -Contain 'DNS server is not a planned domain controller: 8.8.8.8'
        $result.Findings.Title | Should -Contain 'Generation 1 VM planned: FILE01'
    }

    It 'exports JSON and CSV validation evidence' {
        $outputPath = Join-Path $TestDrive 'validation'
        Test-EhlPlan -Configuration $script:Configuration -OutputPath $outputPath | Out-Null
        Test-Path (Join-Path $outputPath 'lab-plan-validation.json') | Should -BeTrue
        Test-Path (Join-Path $outputPath 'findings.csv') | Should -BeTrue
    }
}