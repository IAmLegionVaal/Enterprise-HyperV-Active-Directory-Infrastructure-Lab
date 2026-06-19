#requires -Version 5.1
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Owner = 'IAmLegionVaal'
$ProjectNumber = 2
$RepoName = 'Enterprise-HyperV-Active-Directory-Infrastructure-Lab'
$RepoFullName = "$Owner/$RepoName"
$RepoPath = Join-Path $HOME "Documents\GitHub\$RepoName"

function Need([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "$Name is not installed or is not in PATH."
    }
}

function Slug([string]$Text) {
    $s = $Text.ToLowerInvariant() -replace '[^a-z0-9]+','-'
    return $s.Trim('-')
}

function Get-Area([string]$Title) {
    if ($Title -match '^\[(.+?)\]') { return $Matches[1] }
    switch -Regex ($Title) {
        'Hyper-V|virtual switch|virtual machine|VM' { 'Hyper-V'; break }
        'Active Directory|domain controller|DC01|DC02|OU|FSMO|user|group' { 'Active Directory'; break }
        'DNS' { 'DNS'; break }
        'DHCP' { 'DHCP'; break }
        'Group Policy|GPO|LAPS|BitLocker' { 'Group Policy'; break }
        'File|share|NTFS|DFS|quota|Previous Versions' { 'File Services'; break }
        'Security|audit|Defender|certificate|privileged' { 'Security'; break }
        'Monitor|dashboard|health|report' { 'Monitoring'; break }
        'Automation|script|PowerShell|bulk' { 'Automation'; break }
        'Troubleshoot|simulate|failure|lockout|incident' { 'Troubleshooting'; break }
        'Recovery|restore|backup|Recycle' { 'Disaster Recovery'; break }
        'README|documentation|diagram|guide|runbook|inventory' { 'Documentation'; break }
        'Portfolio|resume|video|interview|screenshot|evidence' { 'Portfolio'; break }
        'Validation|validate|final' { 'Validation'; break }
        default { 'Planning' }
    }
}

function Get-SimulatedFinding([string]$Area,[string]$Title) {
    switch ($Area) {
        'Planning' { return @'
- The lab scope was defined as a single-site Windows enterprise environment.
- The domain namespace was set to `corp.pretoriuslab.local` with NetBIOS name `PRETORIUSLAB`.
- The primary subnet was documented as `10.10.10.0/24` with gateway `10.10.10.1`.
- Static addressing was reserved for infrastructure servers and DHCP for client devices.
- The design emphasized least privilege, redundancy, documentation, and recoverability.
'@ }
        'Hyper-V' { return @'
- A Generation 2 VM standard was selected for modern Windows guests.
- The internal switch design used `PretoriusLab-Internal` with NAT on `10.10.10.0/24`.
- Automatic checkpoints were disabled for server workloads to reduce unsafe rollback risk.
- VM resources were planned conservatively so the lab could run on a workstation-class host.
- Validation would include `Get-VMSwitch`, `Get-VM`, `Get-NetNat`, and client connectivity tests.
'@ }
        'Active Directory' { return @'
- The forest design used one domain with two domain controllers for redundancy.
- The OU model separated departments, servers, workstations, administrators, groups, and disabled objects.
- AGDLP was selected for access control to avoid direct user permissions.
- DC health would be validated using `dcdiag`, `repadmin /replsummary`, and `Get-ADReplicationFailure`.
- Privileged administration was separated from standard user activity.
'@ }
        'DNS' { return @'
- AD-integrated forward and reverse lookup zones were included in the design.
- Secure dynamic updates were selected for domain-joined systems.
- Forwarders were planned for external name resolution.
- Validation would include A, PTR, and SRV queries plus `dcdiag /test:dns`.
- DNS client settings were standardized to use domain controllers only.
'@ }
        'DHCP' { return @'
- The client scope was planned for `10.10.10.100-10.10.10.199`.
- Infrastructure addresses were excluded from the dynamic range.
- Scope options included gateway, DNS servers, and DNS suffix.
- Reservations were planned for infrastructure devices that required predictable addressing.
- Validation would include lease renewal, gateway reachability, and DNS registration.
'@ }
        'Group Policy' { return @'
- GPOs were grouped by purpose instead of using one oversized policy.
- Security filtering and test OUs were included to reduce unintended impact.
- Planned controls included Defender, Firewall, LAPS, PowerShell logging, screen lock, BitLocker, and Windows Update.
- Validation would use `gpresult`, Event Viewer, and controlled test accounts.
- Every production-style GPO would be backed up after validation.
'@ }
        'File Services' { return @'
- Departmental shares were mapped to domain-local resource groups.
- Users would receive access through global role groups nested into resource groups.
- Access-based enumeration, quotas, file screening, and Previous Versions were included.
- Direct user ACLs were intentionally avoided.
- Validation would test both allowed and denied access with separate department accounts.
'@ }
        'Security' { return @'
- The baseline prioritized least privilege, logging, Defender, Firewall, LAPS, and privileged-group monitoring.
- Advanced Audit Policy and PowerShell logging were included for traceability.
- Windows Event Forwarding was selected for centralized review.
- Security exceptions would require documented business justification.
- Validation would include expected event IDs, permission checks, and controlled negative tests.
'@ }
        'Monitoring' { return @'
- Health indicators included AD replication, DNS, service state, event logs, time synchronization, and disk space.
- Reports were designed to be readable by both technicians and reviewers.
- Thresholds would distinguish warning from critical conditions.
- Sample reports would be sanitized before publication.
- Monitoring output would include timestamps, hostnames, and clear remediation guidance.
'@ }
        'Automation' { return @'
- Scripts were designed to be repeatable and safe to rerun.
- Validation, error handling, comments, and logging were treated as required features.
- CSV-driven onboarding was selected for consistent user creation.
- Inventory and health-check automation would produce CSV, text, or HTML output.
- Secrets and real company data would never be stored in the repository.
'@ }
        'Troubleshooting' { return @'
- The simulated incident workflow captured symptoms before changes were made.
- Root-cause analysis focused on evidence from logs, configuration, and controlled tests.
- The minimum-change principle was used to reduce risk.
- Resolution was followed by service validation and prevention notes.
- Typical root causes included incorrect DNS, stale credentials, broken secure channels, scope exhaustion, and ACL mistakes.
'@ }
        'Disaster Recovery' { return @'
- Recovery priorities were authentication, DNS, DHCP, file services, certificates, and monitoring.
- Active Directory Recycle Bin was included for object recovery.
- System State backup was selected for domain-controller recovery planning.
- Recovery tests would be followed by replication and DNS validation.
- Every exercise would record recovery steps, estimated recovery time, and lessons learned.
'@ }
        'Documentation' { return @'
- Documentation was structured for employer review rather than only personal notes.
- Each document included purpose, design, implementation, validation, and recovery considerations.
- Architecture, IP planning, naming standards, and runbooks were separated into dedicated files.
- Screenshots and reports would be sanitized before publication.
- The repository was organized so a reviewer could navigate it without prior context.
'@ }
        'Portfolio' { return @'
- Portfolio evidence was selected to show architecture, automation, troubleshooting, and recovery skills.
- The project story emphasized business impact and technical reasoning.
- Resume bullets would focus on measurable scope and implemented technologies.
- Demonstration content would avoid credentials, secrets, and private information.
- The strongest evidence would include diagrams, scripts, reports, and before-and-after validation.
'@ }
        'Validation' { return @'
- Validation covered authentication, DNS, DHCP, GPO application, file access, logging, backups, and client connectivity.
- Both positive and negative tests were included.
- Failed checks would remain open until remediation was documented.
- Final review included repository structure, links, screenshots, reports, and secret scanning.
- Completion required evidence rather than status changes alone.
'@ }
        default { return '- Representative findings were documented for this planned lab activity.' }
    }
}

Need gh
Need git

gh auth status
if ($LASTEXITCODE -ne 0) { throw 'Run gh auth login first.' }

if (-not (Test-Path (Join-Path $RepoPath '.git'))) {
    New-Item (Split-Path $RepoPath -Parent) -ItemType Directory -Force | Out-Null
    gh repo clone $RepoFullName $RepoPath
}

if (-not (git config --global user.name)) { git config --global user.name 'Dewald Pretorius' }
if (-not (git config --global user.email)) { git config --global user.email 'dewaldp84@gmail.com' }

git -C $RepoPath pull --ff-only
$DocsRoot = Join-Path $RepoPath 'docs\simulated-findings'
New-Item $DocsRoot -ItemType Directory -Force | Out-Null

$query = @'
query($login:String!,$number:Int!,$after:String){
  user(login:$login){
    projectV2(number:$number){
      id
      items(first:100,after:$after){
        pageInfo{hasNextPage endCursor}
        nodes{
          id
          type
          content{
            ... on DraftIssue{id title body}
            ... on Issue{id number title body repository{nameWithOwner}}
            ... on PullRequest{id number title body repository{nameWithOwner}}
          }
        }
      }
    }
  }
}
'@

$all = @()
$after = $null
do {
    $args = @('api','graphql','-f',"query=$query",'-F',"login=$Owner",'-F',"number=$ProjectNumber")
    if ($after) { $args += @('-F',"after=$after") }
    $page = & gh @args | ConvertFrom-Json
    $connection = $page.data.user.projectV2.items
    $all += $connection.nodes
    $after = $connection.pageInfo.endCursor
} while ($connection.pageInfo.hasNextPage)

$updateDraft = @'
mutation($id:ID!,$body:String!){
  updateProjectV2DraftIssue(input:{draftIssueId:$id,body:$body}){
    draftIssue{id}
  }
}
'@

foreach ($node in $all) {
    if (-not $node.content -or -not $node.content.title) { continue }
    $title = [string]$node.content.title
    $area = Get-Area $title
    $finding = Get-SimulatedFinding $area $title
    $slug = Slug $title
    $relative = "docs/simulated-findings/$slug.md"
    $url = "https://github.com/$RepoFullName/blob/main/$relative"

    $body = @"
# $title

> **Portfolio simulation notice:** The findings below are representative example results for a planned lab exercise. They are not presented as measurements from a completed production or live lab environment.

## Objective

Document the intended implementation, expected results, validation approach, and evidence requirements for this task.

## Area

$area

## Simulated findings

$finding

## Validation commands and checks

- Confirm the required configuration exists.
- Confirm relevant Windows services are running.
- Review applicable Event Viewer logs.
- Run the area-specific PowerShell or command-line validation.
- Test from an appropriate server or client.
- Record both successful and failed checks.

## Evidence to attach after the real lab test

- Before and after screenshots
- Sanitized command output
- Event-log extracts
- Configuration export or report
- Functional test result
- Security review
- Rollback or recovery notes
- Lessons learned

## Repository document

$url

## Status

**Documented as a simulated portfolio exercise. Not yet validated as a completed live lab task.**
"@

    $docPath = Join-Path $RepoPath ($relative -replace '/','\')
    [IO.File]::WriteAllText($docPath,$body,[Text.UTF8Encoding]::new($false))

    if ($node.type -eq 'DRAFT_ISSUE' -and $node.content.id) {
        gh api graphql -f "query=$updateDraft" -F "id=$($node.content.id)" -f "body=$body" *> $null
        Write-Host "Updated draft: $title" -ForegroundColor Green
    }
    elseif ($node.type -eq 'ISSUE' -and $node.content.number -and $node.content.repository.nameWithOwner) {
        $tmp = Join-Path $env:TEMP ("issue-{0}.md" -f $node.content.number)
        [IO.File]::WriteAllText($tmp,$body,[Text.UTF8Encoding]::new($false))
        gh issue edit $node.content.number --repo $node.content.repository.nameWithOwner --body-file $tmp *> $null
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
        Write-Host "Updated issue: $title" -ForegroundColor Green
    }
}

git -C $RepoPath add docs/simulated-findings
if (git -C $RepoPath status --porcelain) {
    git -C $RepoPath commit -m 'Add simulated findings documentation for project tasks'
    git -C $RepoPath push origin main
}

Write-Host "Completed. Updated $($all.Count) project items with clearly labelled simulated findings." -ForegroundColor Cyan
gh project view $ProjectNumber --owner $Owner --web
