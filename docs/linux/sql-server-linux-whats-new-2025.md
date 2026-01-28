---
title: "What's New for SQL Server 2025 on Linux"
description: In this article, learn about the major features and services available for SQL Server 2025 running on Linux.
author: rwestMSFT
ms.author: randolphwest
ms.date: 01/27/2026
ms.service: sql
ms.subservice: linux
ms.topic: whats-new
ms.custom:
  - intro-whats-new
  - linux-related-content
  - ignite-2025
---

# What's new for SQL Server 2025 on Linux

[!INCLUDE [sqlserver2025-linux](../includes/applies-to-version/sqlserver2025-linux.md)]

This article describes the major features and services available for [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] running on Linux. For package downloads and known issues, see the [Release notes](sql-server-linux-release-notes-2025.md).

## Updates

This section describes updates for each release of [!INCLUDE [sssql25-md](../includes/sssql25-md.md)].

- [Cumulative Update 1](#cumulative-update-1)
- [GA release](#general-availability)

### Cumulative Update 1

The following updates apply to [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] Cumulative Update (CU) 1.

- **Red Hat Enterprise Linux 10 support**. [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] is fully supported on Red Hat Enterprise Linux (RHEL) 10. For more information, see [Quickstart: Install SQL Server and create a database on Red Hat](quickstart-install-connect-red-hat.md?view=sql-server-ver17&tabs=rhel8%2C2025rhel10&preserve-view=true).

- **Ubuntu 24.04 support**. [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] is fully supported on Ubuntu 24.04. For more information, see [Quickstart: Install SQL Server and create a database on Ubuntu](quickstart-install-connect-ubuntu.md?view=sql-server-ver17&tabs=ubuntu2004%2C2505ubuntu2404%2Codbc-ubuntu-2404&preserve-view=true).

- **Contained availability groups (AGs)**. Enable database create and restore operations directly through the contained AG listener. This improvement eliminates the need to connect to the physical replica, simplifying high availability automation on Linux.

  For more information, see [Enable database creation or restoration in contained availability group sessions](../database-engine/availability-groups/windows/contained-availability-groups-overview.md#enable-database-creation-or-restoration-in-contained-availability-group-sessions).

- **New dynamic management views**. Four new Linux‑specific dynamic management views (DMVs) provide insights into host and virtual memory resource utilization, aiding performance troubleshooting and diagnostics.

  - [sys.dm_os_linux_cpu_stats](../relational-databases/system-dynamic-management-views/sys-dm-os-linux-cpu-stats-transact-sql.md)
  - [sys.dm_os_linux_disk_stats](../relational-databases/system-dynamic-management-views/sys-dm-os-linux-disk-stats-transact-sql.md)
  - [sys.dm_os_linux_net_stats](../relational-databases/system-dynamic-management-views/sys-dm-os-linux-net-stats-transact-sql.md)
  - [sys.dm_os_linux_vm_stats](../relational-databases/system-dynamic-management-views/sys-dm-os-linux-vm-stats-transact-sql.md)

- **Support for the adutil tool on Ubuntu 24.04 and Red Hat Enterprise Linux 10**. The **adutil** tool is available on Ubuntu 24.04 and Red Hat Enterprise Linux (RHEL) 10, expanding support for Active Directory authentication scenarios on Linux.

  For more information, see [Introduction to adutil - Active Directory utility](sql-server-linux-ad-auth-adutil-introduction.md).

### General availability

The following updates are available in [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] on Linux:

| New feature or update | Details |
| --- | --- |
| TLS 1.3 enabled by default | [Encrypt connections to SQL Server on Linux](sql-server-linux-encrypted-connections.md) |
| Custom password policy | [Set custom password policy for SQL logins in SQL Server on Linux](sql-server-linux-custom-password-policy.md) |
| tmpfs support for `tempdb` | [Enable and run tempdb on tmpfs for SQL Server 2025 on Linux](sql-server-linux-tmpfs-tempdb.md) |
| Generic ODBC data source support for PolyBase | [Connect to ODBC data sources with PolyBase on SQL Server on Linux](sql-server-linux-polybase.md) |

## Related content

- [Quickstart: Install SQL Server and create a database on Red Hat](quickstart-install-connect-red-hat.md?view=sql-server-linux-ver17&preserve-view=true)
- [Quickstart: Install SQL Server and create a database on SUSE Linux Enterprise Server](quickstart-install-connect-suse.md?view=sql-server-linux-ver17&preserve-view=true)
- [Quickstart: Install SQL Server and create a database on Ubuntu](quickstart-install-connect-ubuntu.md?view=sql-server-linux-ver17&preserve-view=true)
- [Quickstart: Run SQL Server Linux container images with Docker](quickstart-install-connect-docker.md?view=sql-server-linux-ver17&preserve-view=true)
- [Provision a Linux virtual machine running SQL Server in the Azure portal](/azure/azure-sql/virtual-machines/linux/sql-vm-create-portal-quickstart?toc=/sql/toc/toc.json)
- [SQL Server on Linux FAQ](sql-server-linux-faq.yml)
- [What's new in SQL Server 2025](../sql-server/what-s-new-in-sql-server-2025.md)

[!INCLUDE [get-help-options](../includes/paragraph-content/get-help-options.md)]
