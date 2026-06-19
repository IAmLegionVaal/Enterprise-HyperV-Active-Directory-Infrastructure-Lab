# Release Readiness

## Completed

- Versioned PowerShell module
- Parameterized lab configuration
- Plan validation for capacity, addressing, DNS, directory resilience, and VM standards
- Read-only Hyper-V host-readiness collection
- JSON, CSV, and HTML reporting
- Controlled provisioning with preview-by-default behavior
- `SupportsShouldProcess` and blocking validation gates
- Pester and PSScriptAnalyzer validation
- Windows GitHub Actions artifacts
- Controlled live-validation procedure

## Remaining merge gate

Run host readiness and provisioning preview on an authorized Hyper-V host. Apply provisioning only after the preview and plan findings are reviewed. Guest operating-system installation and post-build AD, DNS, DHCP, policy, and file-service configuration can follow as separate implementation stages.
