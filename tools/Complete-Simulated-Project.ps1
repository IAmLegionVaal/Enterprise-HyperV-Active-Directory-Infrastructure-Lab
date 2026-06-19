#requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Owner = 'IAmLegionVaal'
$ProjectNumber = 2
$Repo = 'IAmLegionVaal/Enterprise-HyperV-Active-Directory-Infrastructure-Lab'
$FindingsUrl = 'https://github.com/IAmLegionVaal/Enterprise-HyperV-Active-Directory-Infrastructure-Lab/tree/main/docs/simulated-findings'

function Get-Area([string]$Title) {
    if ($Title -match '^\[(.+?)\]') { return $Matches[1] }
    switch -Regex ($Title) {
        'Hyper-V|virtual switch|virtual machine|VM' { return 'Hyper-V' }
        'Active Directory|domain controller|DC01|DC02|OU|FSMO|user|group' { return 'Active Directory' }
        'DNS' { return 'DNS' }
        'DHCP' { return 'DHCP' }
        'Group Policy|GPO|LAPS|BitLocker' { return 'Group Policy' }
        'File|share|NTFS|DFS|quota|Previous Versions' { return 'File Services' }
        'Security|audit|Defender|certificate|privileged' { return 'Security' }
        'Monitor|dashboard|health|report' { return 'Monitoring' }
        'Automation|script|PowerShell|bulk' { return 'Automation' }
        'Troubleshoot|simulate|failure|lockout|incident' { return 'Troubleshooting' }
        'Recovery|restore|backup|Recycle' { return 'Disaster Recovery' }
        'README|documentation|diagram|guide|runbook|inventory' { return 'Documentation' }
        'Portfolio|resume|video|interview|screenshot|evidence' { return 'Portfolio' }
        'Validation|validate|final' { return 'Validation' }
        default { return 'Planning' }
    }
}

function Get-Finding([string]$Area) {
    switch ($Area) {
        'Hyper-V' { return 'The representative design used Generation 2 VMs, an isolated internal switch, NAT, role-based resource allocation, and separate VM storage locations. Connectivity and host resource checks were documented as successful in the simulated scenario.' }
        'Active Directory' { return 'The simulated environment used two domain controllers, a structured OU model, AGDLP permissions, documented FSMO ownership, and healthy representative replication results.' }
        'DNS' { return 'The simulated findings show internal forward and reverse zones, secure dynamic updates, domain-service records, and working forwarders while clients remained configured for internal DNS only.' }
        'DHCP' { return 'The representative client scope used 10.10.10.100 through 10.10.10.199, excluded server addresses, and supplied gateway, DNS, and suffix options successfully.' }
        'Group Policy' { return 'The simulated scenario applied purpose-specific policies for security, LAPS, logging, drive mappings, printers, screen lock, BitLocker, and updates to controlled test targets.' }
        'File Services' { return 'The representative findings show departmental shares secured through AGDLP, access-based enumeration, quotas, file screening, and successful Previous Versions recovery.' }
        'Security' { return 'The simulated baseline included least privilege, Defender, Firewall, LAPS, advanced auditing, PowerShell logging, event forwarding, and privileged-access review.' }
        'Monitoring' { return 'Representative monitoring results showed healthy replication, DNS, services, time synchronization, and disk capacity, with reports containing timestamps and remediation guidance.' }
        'Automation' { return 'The simulated automation was documented as repeatable, validation-aware, and safe to rerun, with CSV-driven provisioning, inventory, and health-report output.' }
        'Troubleshooting' { return 'The representative incident process captured symptoms, evidence, root cause, minimum-change resolution, validation, and prevention for realistic enterprise faults.' }
        'Disaster Recovery' { return 'The simulated recovery exercises covered directory object restoration, controller outage continuity, policy restoration, file recovery, and post-recovery validation.' }
        'Documentation' { return 'The repository contains structured architecture, build, security, troubleshooting, recovery, and simulated findings documentation intended for employer review.' }
        'Portfolio' { return 'The representative portfolio package highlights architecture, automation, security, troubleshooting, recovery, and measurable technical outcomes with clear simulation disclosure.' }
        'Validation' { return 'The simulated final matrix recorded representative pass results across Hyper-V, directory services, DNS, DHCP, policy, file access, security, monitoring, automation, and recovery.' }
        default { return 'The representative planning findings document scope, addressing, naming, resources, dependencies, risks, validation criteria, and recovery considerations.' }
    }
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw 'GitHub CLI is not installed.' }
gh auth status
if ($LASTEXITCODE -ne 0) { throw 'Run gh auth login first.' }

$Project = gh project view $ProjectNumber --owner $Owner --format json | ConvertFrom-Json
$Fields = (gh project field-list $ProjectNumber --owner $Owner --limit 100 --format json | ConvertFrom-Json).fields
$Items = (gh project item-list $ProjectNumber --owner $Owner --limit 500 --format json | ConvertFrom-Json).items

$StatusField = $Fields | Where-Object { $_.name -eq 'Status' } | Select-Object -First 1
if (-not $StatusField) { throw 'The project does not contain a Status field.' }
$DoneOption = $StatusField.options | Where-Object { $_.name -match '^(Done|Completed|Complete)$' } | Select-Object -First 1
if (-not $DoneOption) { throw 'No Done or Completed option was found in the Status field.' }

$EvidenceField = $Fields | Where-Object { $_.name -eq 'Evidence' } | Select-Object -First 1
$NotesField = $Fields | Where-Object { $_.name -eq 'Implementation Notes' } | Select-Object -First 1

$query = @'
query($login:String!,$number:Int!,$after:String){
  user(login:$login){
    projectV2(number:$number){
      items(first:100,after:$after){
        pageInfo{hasNextPage endCursor}
        nodes{
          id
          type
          content{
            ... on DraftIssue{id title body}
            ... on Issue{id number title body repository{nameWithOwner}}
          }
        }
      }
    }
  }
}
'@

$Nodes = @()
$After = $null
do {
    $Args = @('api','graphql','-f',"query=$query",'-F',"login=$Owner",'-F',"number=$ProjectNumber")
    if ($After) { $Args += @('-F',"after=$After") }
    $Page = & gh @Args | ConvertFrom-Json
    $Connection = $Page.data.user.projectV2.items
    $Nodes += $Connection.nodes
    $After = $Connection.pageInfo.endCursor
} while ($Connection.pageInfo.hasNextPage)

$UpdateDraft = @'
mutation($id:ID!,$body:String!){
  updateProjectV2DraftIssue(input:{draftIssueId:$id,body:$body}){
    draftIssue{id}
  }
}
'@

foreach ($Item in $Items) {
    if (-not $Item.id -or -not $Item.title) { continue }
    $Area = Get-Area ([string]$Item.title)
    $Finding = Get-Finding $Area
    $Body = @"
# $($Item.title)

## Simulation status

**Simulated complete**

> This card contains representative portfolio data for a controlled enterprise-lab scenario. It is not live production evidence.

## Area

$Area

## Representative implementation

The task was documented using the planned `corp.pretoriuslab.local` environment, the `10.10.10.0/24` lab network, role-based server design, least privilege, PowerShell automation, and evidence-driven validation.

## Simulated findings

$Finding

## Representative validation

- Configuration reviewed against the architecture and build guides
- Expected services and dependencies documented
- Positive and negative test conditions recorded
- Security impact and least-privilege considerations reviewed
- Rollback or recovery process documented
- Lessons learned recorded

## Evidence

$FindingsUrl

## Completion note

This item is marked complete for the simulated documentation exercise. Real screenshots, command output, and logs should replace representative evidence after the physical lab is built.
"@

    $Node = $Nodes | Where-Object { $_.id -eq $Item.id } | Select-Object -First 1
    if ($Node -and $Node.type -eq 'DRAFT_ISSUE' -and $Node.content.id) {
        gh api graphql -f "query=$UpdateDraft" -F "id=$($Node.content.id)" -f "body=$Body" *> $null
    }
    elseif ($Node -and $Node.type -eq 'ISSUE' -and $Node.content.number -and $Node.content.repository.nameWithOwner) {
        $Temp = Join-Path $env:TEMP ("simulated-project-item-{0}.md" -f $Node.content.number)
        [IO.File]::WriteAllText($Temp,$Body,[Text.UTF8Encoding]::new($false))
        gh issue edit $Node.content.number --repo $Node.content.repository.nameWithOwner --body-file $Temp *> $null
        Remove-Item $Temp -Force -ErrorAction SilentlyContinue
    }

    gh project item-edit --id $Item.id --project-id $Project.id --field-id $StatusField.id --single-select-option-id $DoneOption.id *> $null

    if ($EvidenceField) {
        gh project item-edit --id $Item.id --project-id $Project.id --field-id $EvidenceField.id --text $FindingsUrl *> $null
    }
    if ($NotesField) {
        gh project item-edit --id $Item.id --project-id $Project.id --field-id $NotesField.id --text 'Simulated documentation exercise completed. Live validation evidence remains to be substituted after the physical lab build.' *> $null
    }

    Write-Host "Completed: $($Item.title)" -ForegroundColor Green
}

Write-Host "All $($Items.Count) project items were populated with simulated completion data and marked Done." -ForegroundColor Cyan
gh project view $ProjectNumber --owner $Owner --web
