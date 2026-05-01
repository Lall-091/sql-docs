---
author: MikeRayMSFT
ms.author: mikeray
ms.date: 01/24/2024
ms.topic: include
---

## Supported configurations

### SQL Server version

[!INCLUDE [sssql11-md](../../../includes/sssql11-md.md)] and later versions.

> [!NOTE]
> Only 64-bit SQL Server versions are supported.
 
### Operating systems

- Windows 10 and 11
- [!INCLUDE [winserver2012-md](../../../includes/winserver2012-md.md)] and later versions
- Ubuntu 20.04 (x64)
- Red Hat Enterprise Linux (RHEL) 8 (x64)
- SUSE Linux Enterprise Server (SLES) 15 (x64)

> [!IMPORTANT]  
> Windows Server 2012 and Windows Server 2012 R2 support ended on October 10, 2023. For more information, see [SQL Server 2012 and Windows Server 2012/2012 R2 end of support](/lifecycle/announcements/sql-server-2012-windows-server-2012-2012-r2-end-of-support).

### .NET Framework

On Windows, .NET Framework 4.7.2 and later.

This requirement begins with extension version `1.1.2504.99` (November, 14 2023 release). Without this version, the extension might not function as intended. Windows Server 2012 R2 doesn't come with .NET Framework 4.7.2 by default and must be updated accordingly.

### Support on VMware

You can deploy SQL Server enabled by Azure Arc in VMware VMs running:

- On-premises
- In VMware solutions, for example:
  - Azure VMware Solution (AVS)

    [!INCLUDE [azure-vmware](azure-vmware.md)]

  - VMware Cloud on AWS
  - Google Cloud VMware Engine

#### VMware packaging and support scope

SQL Server enabled by Azure Arc supports SQL Server instances running on virtual machines hosted in VMware vSphere–based environments, including Azure VMware Solution.

Support doesn't depend on specific VMware commercial bundles, editions, or packaging. The following requirements determine support:

- The supported guest operating system
- The supported SQL Server version
- Azure Arc Connected Machine agent requirements

VMware (Broadcom) defines VMware packaging, licensing, and lifecycle policies and may change them independently of Azure Arc.
