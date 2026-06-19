# Controlled Live Validation

Run on an authorized Windows host. Host-readiness collection is read-only. Provisioning defaults to preview mode and requires `-Apply` before changes are made.

## Host readiness

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Invoke-EnterpriseLabPlanV2.ps1 `
  -Mode HostReadiness `
  -OutputPath .\artifacts\host-readiness
```

## Validate the lab plan

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Invoke-EnterpriseLabPlanV2.ps1 `
  -Mode Plan `
  -ConfigurationPath .\config\lab.synthetic.json `
  -OutputPath .\artifacts\plan-validation `
  -OpenReport
```

## Preview provisioning

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Invoke-EnterpriseLabPlanV2.ps1 `
  -Mode Provision `
  -ConfigurationPath .\config\lab.synthetic.json `
  -VhdRoot 'D:\Hyper-V\EnterpriseLab' `
  -OutputPath .\artifacts\provisioning-preview
```

The command above uses preview behavior because `-Apply` is absent.

## Apply provisioning

After correcting all Critical and High plan findings and reviewing the preview:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Invoke-EnterpriseLabPlanV2.ps1 `
  -Mode Provision `
  -ConfigurationPath .\config\lab.production.json `
  -VhdRoot 'D:\Hyper-V\EnterpriseLab' `
  -Apply
```

## Safety

- Provisioning uses `SupportsShouldProcess`.
- Existing VMs are not recreated.
- Critical and High plan findings block provisioning unless `-Force` is explicitly supplied.
- `-Force` should only be used after documented technical review.
