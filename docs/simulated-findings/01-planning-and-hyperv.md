# Simulated Findings — Planning and Hyper-V

> These are simulated portfolio findings for a controlled lab scenario.

## 1. Hardware and software requirements

### Simulated implementation

The host specification was defined as:

- 8-core 64-bit CPU with virtualization extensions
- 32 GB RAM minimum
- 500 GB free SSD storage
- Windows 11 Pro or Enterprise host
- Windows Server evaluation media
- Windows 11 installation media
- Hyper-V enabled with management tools

### Simulated findings

- A 16 GB host could start the core domain controller and one client, but memory pressure appeared when more than four VMs were active.
- Dynamic Memory reduced idle consumption, but fixed startup memory was retained for domain controllers to make behavior more predictable.
- SSD storage materially improved VM boot and checkpoint performance.
- Generation 2 VMs provided Secure Boot and modern virtual hardware.

### Conclusion

A 32 GB host was selected as the practical minimum for the full portfolio scenario.

---

## 2. IP addressing plan

### Simulated implementation

- Network: `10.10.10.0/24`
- Gateway: `10.10.10.1`
- Static infrastructure range: `10.10.10.10-10.10.10.99`
- DHCP range: `10.10.10.100-10.10.10.199`
- Reserved range: `10.10.10.200-10.10.10.254`

### Simulated findings

- Separating server and client ranges made troubleshooting easier.
- DNS and domain controllers required static addressing.
- DHCP exclusions prevented accidental server-address conflicts.
- Reverse lookup records improved log readability and diagnostic output.

---

## 3. Naming standards

### Simulated implementation

- Domain controllers: `LAB-DC01`, `LAB-DC02`
- DHCP server: `LAB-DHCP01`
- File server: `LAB-FS01`
- Management workstation: `LAB-MGMT01`
- Client devices: `LAB-CLIENT01` through `LAB-CLIENT03`

### Simulated findings

- Role-based names reduced ambiguity during Event Viewer and PowerShell analysis.
- Consistent prefixes improved filtering and inventory reports.
- Separate administrative account prefixes made privileged activity easier to identify.

---

## 4. Hyper-V host preparation

### Simulated implementation

Hyper-V was enabled and the following folders were planned:

- `C:\HyperV\VirtualMachines`
- `C:\HyperV\VirtualHardDisks`
- `C:\HyperV\ISO`
- `C:\HyperV\Exports`
- `C:\HyperV\Backups`

### Simulated validation

```powershell
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
Get-VMHost
Get-VMSwitch
```

### Simulated findings

- The Hyper-V feature state returned `Enabled`.
- The default VM and VHD locations were redirected away from the user profile.
- Automatic checkpoints were disabled for server VMs.
- Host resource planning showed that concurrent client VMs should use Dynamic Memory.

---

## 5. Virtual switch and NAT configuration

### Simulated implementation

An internal switch named `PretoriusLab-Internal` was created with host address `10.10.10.1/24`. NAT was configured as `PretoriusLab-NAT`.

### Simulated validation

```powershell
Get-VMSwitch -Name PretoriusLab-Internal
Get-NetIPAddress -InterfaceAlias "vEthernet (PretoriusLab-Internal)"
Get-NetNat -Name PretoriusLab-NAT
```

### Simulated findings

- Internal VM-to-VM communication succeeded.
- The host could reach all infrastructure VMs.
- NAT provided internet access without exposing the lab directly to the physical LAN.
- DNS traffic remained directed to the domain controllers.

---

## 6. VM deployment

### Simulated implementation

Ten Generation 2 VMs were documented with role-specific CPU, memory, and disk allocation.

### Simulated findings

- Domain controllers remained stable at 4 GB RAM and 2 vCPUs.
- File-server disk capacity required the largest allocation because quotas and Previous Versions were included.
- Client VMs were configured with 4 GB startup memory and Dynamic Memory.
- Secure Boot remained enabled for supported Windows guests.

### Lessons learned

- Start with DC01 and one client before deploying the full environment.
- Confirm DNS and domain join before adding secondary services.
- Avoid using checkpoints as a substitute for proper domain-controller backup.