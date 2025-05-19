---
title: Release Notes for SQL Server 2025 Preview on Linux
description: This article contains the release notes and supported features for SQL Server 2025 Preview running on Linux. Release notes include the most recent release and several previous releases.
author: rwestMSFT
ms.author: randolphwest
ms.reviewer: amitkh, vanto
ms.date: 05/19/2025
ms.service: sql
ms.subservice: linux
ms.topic: release-notes
ms.custom:
  - linux-related-content
---
# Release notes for SQL Server 2025 Preview on Linux

[!INCLUDE [sqlserver2025-linux](../includes/applies-to-version/sqlserver2025-linux.md)]

The following release notes apply to [!INCLUDE [ssSQL25](../includes/sssql25-md.md)] running on Linux. This article is broken into sections for each release. For detailed supportability and known issues, see [SQL Server on Linux: Known issues](sql-server-linux-known-issues.md). Each release links to a support article describing the changes, in addition to the Linux package downloads.

These release notes are specifically for [!INCLUDE [ssSQL25](../includes/sssql25-md.md)] releases. For release notes on other editions, see the following articles:

- [Release notes for SQL Server 2017 on Linux](sql-server-linux-release-notes-2017.md?view=sql-server-ver14&preserve-view=true)
- [Release notes for SQL Server 2019 on Linux](sql-server-linux-release-notes-2019.md?view=sql-server-ver15&preserve-view=true)
- [Release notes for SQL Server 2022 on Linux](sql-server-linux-release-notes-2022.md?view=sql-server-ver16&preserve-view=true)

[!INCLUDE [support-policy](includes/support-policy.md)]

## Supported platforms

[!INCLUDE [linux-supported-platforms-2025](includes/linux-supported-platforms-2025.md)]

## Tools

Most existing client tools that target [!INCLUDE [ssNoVersion](../includes/ssnoversion-md.md)] can seamlessly target [!INCLUDE [ssNoVersion](../includes/ssnoversion-md.md)] running on Linux. Some tools might have a specific version requirement to work well with Linux. For a full list of [!INCLUDE [ssNoVersion](../includes/ssnoversion-md.md)] tools, see [SQL tools overview](../tools/overview-sql-tools.md).

## Latest versions for all packages

This section lists the latest versions of each package per distribution, for [!INCLUDE [ssSQL25](../includes/sssql25-md.md)]. The following table shows the most recent release, which is **CTP 2.0**. For full release history, see [Release history for [!INCLUDE [ssNoVersion](../includes/ssnoversion-md.md)] 2025 Preview](/troubleshoot/sql/linux/release-history-2025).

| Version | Release | Date | Build | KB article |
| --- | --- | --- | --- | --- |
| [!INCLUDE [ssSQL25](../includes/sssql25-md.md)] | CTP 2.0 | 2025-05-19 | 17.0.700.9 | |

> [!IMPORTANT]  
> In [!INCLUDE [ssSQL25](../includes/sssql25-md.md)] on Linux, the CPU time for a query (for example, returned by set statistics time, or captured via Extended Events or SQL Server Profiler traces) can currently display inaccurately. This amount can often show significantly more than the actual execution time, even when the query isn't running in parallel. This is a known issue, and we're actively working on a resolution. This issue affects [!INCLUDE [ssSQL25](../includes/sssql25-md.md)] on Linux deployed on traditional VMs, physical machines, and container-based environments.

- The **mssql-server-is** package isn't supported on SUSE in this release. For more information, see [SQL Server on Linux: Known issues](sql-server-linux-known-issues.md#sql-server-integration-services-ssis).

| Distribution | Package name | Package version | Download |
| --- | --- | --- | --- |
| **Red Hat Enterprise Linux** | | | |
| RHEL 9 | Database Engine | 17.0.700.9-1 | [Database Engine RPM package](https://packages.microsoft.com/rhel/9/mssql-server-preview/Packages/m/mssql-server-17.0.700.9-1.x86_64.rpm) |
| RHEL 9 | Extensibility | 17.0.700.9-1 | [Extensibility RPM package](https://packages.microsoft.com/rhel/9/mssql-server-preview/Packages/m/mssql-server-extensibility-17.0.700.9-1.x86_64.rpm) |
| RHEL 9 | Full-Text Search | 17.0.700.9-1 | [Full-Text Search RPM package](https://packages.microsoft.com/rhel/9/mssql-server-preview/Packages/m/mssql-server-fts-17.0.700.9-1.x86_64.rpm) |
| RHEL 9 | High Availability | 17.0.700.9-1 | [High Availability RPM package](https://packages.microsoft.com/rhel/9/mssql-server-preview/Packages/m/mssql-server-ha-17.0.700.9-1.x86_64.rpm) |
| RHEL 9 | PolyBase | 17.0.700.9-1 | [PolyBase RPM package](https://packages.microsoft.com/rhel/9/mssql-server-preview/Packages/m/mssql-server-polybase-17.0.700.9-1.x86_64.rpm) |
| **SUSE Linux Enterprise Server** | | | |
| SLES 15 | Database Engine | 17.0.700.9-1 | [Database Engine RPM package](https://packages.microsoft.com/sles/15/mssql-server-preview/Packages/m/mssql-server-17.0.700.9-1.x86_64.rpm) |
| SLES 15 | Extensibility | 17.0.700.9-1 | [Extensibility RPM package](https://packages.microsoft.com/sles/15/mssql-server-preview/Packages/m/mssql-server-extensibility-17.0.700.9-1.x86_64.rpm) |
| SLES 15 | Full-Text Search | 17.0.700.9-1 | [Full-Text Search RPM package](https://packages.microsoft.com/sles/15/mssql-server-preview/Packages/m/mssql-server-fts-17.0.700.9-1.x86_64.rpm) |
| SLES 15 | High Availability | 17.0.700.9-1 | [High Availability RPM package](https://packages.microsoft.com/sles/15/mssql-server-preview/Packages/m/mssql-server-ha-17.0.700.9-1.x86_64.rpm) |
| SLES 15 | PolyBase | 17.0.700.9-1 | [PolyBase RPM package](https://packages.microsoft.com/sles/15/mssql-server-preview/Packages/m/mssql-server-polybase-17.0.700.9-1.x86_64.rpm) |
| **Ubuntu** | | | |
| Ubuntu 22.04 | Database Engine | 17.0.700.9-1 | [Database Engine Debian package](https://packages.microsoft.com/ubuntu/22.04/mssql-server-preview/pool/main/m/mssql-server/mssql-server_17.0.700.9-1_amd64.deb) |
| Ubuntu 22.04 | Extensibility | 17.0.700.9-1 | [Extensibility Debian package](https://packages.microsoft.com/ubuntu/22.04/mssql-server-preview/pool/main/m/mssql-server-extensibility/mssql-server-extensibility_17.0.700.9-1_amd64.deb) |
| Ubuntu 22.04 | Full-Text Search | 17.0.700.9-1 | [Full-Text Search Debian package](https://packages.microsoft.com/ubuntu/22.04/mssql-server-preview/pool/main/m/mssql-server-fts/mssql-server-fts_17.0.700.9-1_amd64.deb) |
| Ubuntu 22.04 | High Availability | 17.0.700.9-1 | [High Availability Debian package](https://packages.microsoft.com/ubuntu/22.04/mssql-server-preview/pool/main/m/mssql-server-ha/mssql-server-ha_17.0.700.9-1_amd64.deb) |
| Ubuntu 22.04 | PolyBase | 17.0.700.9-1 | [PolyBase Debian package](https://packages.microsoft.com/ubuntu/22.04/mssql-server-preview/pool/main/m/mssql-server-polybase/mssql-server-polybase_17.0.700.9-1_amd64.deb) |

## <a id="cuinstall"></a> How to install updates

If you require Docker container images, see official images for [Microsoft SQL Server on Linux for Docker Engine](https://hub.docker.com/_/microsoft-mssql-server). For more information about repository configuration, see [Configure repositories for installing and upgrading SQL Server on Linux](sql-server-linux-change-repo.md).

If you update existing [!INCLUDE [ssNoVersion](../includes/ssnoversion-md.md)] packages, run the appropriate update command for each package to get the latest CU. For specific update instructions for each package, see the following installation guides:

- [Install SQL Server package](sql-server-linux-setup.md#upgrade)
- [Install SQL Server Full-Text Search on Linux](sql-server-linux-setup-full-text-search.md)
- [Install SQL Server Integration Services (SSIS) on Linux](sql-server-linux-setup-ssis.md)
- [Install SQL Server 2019 Machine Learning Services R and Python support on Linux](sql-server-linux-setup-machine-learning.md)
- [Install PolyBase package](../relational-databases/polybase/polybase-linux-setup.md)
- [Enable SQL Server Agent](sql-server-linux-setup-sql-agent.md)

## Release history

The following table lists the release history for [!INCLUDE [ssSQL25](../includes/sssql25-md.md)].

> [!NOTE]  
> Any missing GDRs apply to the Windows version only.

| Release                                                                  | Version       | Release date |
| ------------------------------------------------------------------------ | ------------- | ------------ |
| [CTP 2.0](/troubleshoot/sql/linux/release-history-2025#CTP2.0)           | 17.0.700.9    | 2025-05-19   |

## Known issues

For more information, see [SQL Server on Linux: Known issues](sql-server-linux-known-issues.md).

## Related content

- [SQL Server on Linux FAQ](sql-server-linux-faq.yml)
- [Quickstart: Install SQL Server and create a database on Red Hat](quickstart-install-connect-red-hat.md)
- [Quickstart: Install SQL Server and create a database on SUSE Linux Enterprise Server](quickstart-install-connect-suse.md)
- [Quickstart: Install SQL Server and create a database on Ubuntu](quickstart-install-connect-ubuntu.md)
- [Quickstart: Run SQL Server Linux container images with Docker](quickstart-install-connect-docker.md)
- [Create a SQL VM in Azure](/azure/azure-sql/virtual-machines/linux/sql-vm-create-portal-quickstart)
- [Quickstart: Run SQL Server in the cloud](quickstart-install-connect-clouds.md)
