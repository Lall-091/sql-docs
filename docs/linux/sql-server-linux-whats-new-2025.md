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

The following updates are available in [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] on Linux:

| New feature or update | Details |
| --- | --- |
| TLS 1.3 enabled by default | [Encrypt connections to SQL Server on Linux](sql-server-linux-encrypted-connections.md) |
| Red Hat 10 support <sup>1</sup> | [Quickstart: Install SQL Server and create a database on Red Hat](quickstart-install-connect-red-hat.md?view=sql-server-ver17&tabs=rhel8%2C2025rhel10&preserve-view=true) |
| Ubuntu 24.04 support <sup>1</sup> | [Quickstart: Install SQL Server and create a database on Ubuntu](quickstart-install-connect-ubuntu.md?view=sql-server-ver17&tabs=ubuntu2004%2C2505ubuntu2404%2Codbc-ubuntu-2404&preserve-view=true) |
| Custom password policy | [Set custom password policy for SQL logins in SQL Server on Linux](sql-server-linux-custom-password-policy.md) |
| tmpfs support for `tempdb` | [Enable and run tempdb on tmpfs for SQL Server 2025 on Linux](sql-server-linux-tmpfs-tempdb.md) |
| Generic ODBC data source support for PolyBase | [Connect to ODBC data sources with PolyBase on SQL Server on Linux](sql-server-linux-polybase.md) |

<sup>1</sup> Starting in [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] CU 1.

## Related content

- [Quickstart: Install SQL Server and create a database on Red Hat](quickstart-install-connect-red-hat.md?view=sql-server-linux-ver17&preserve-view=true)
- [Quickstart: Install SQL Server and create a database on SUSE Linux Enterprise Server](quickstart-install-connect-suse.md?view=sql-server-linux-ver17&preserve-view=true)
- [Quickstart: Install SQL Server and create a database on Ubuntu](quickstart-install-connect-ubuntu.md?view=sql-server-linux-ver17&preserve-view=true)
- [Quickstart: Run SQL Server Linux container images with Docker](quickstart-install-connect-docker.md?view=sql-server-linux-ver17&preserve-view=true)
- [Provision a Linux virtual machine running SQL Server in the Azure portal](/azure/azure-sql/virtual-machines/linux/sql-vm-create-portal-quickstart?toc=/sql/toc/toc.json)
- [SQL Server on Linux FAQ](sql-server-linux-faq.yml)
- [What's new in SQL Server 2025](../sql-server/what-s-new-in-sql-server-2025.md)

[!INCLUDE [get-help-options](../includes/paragraph-content/get-help-options.md)]
