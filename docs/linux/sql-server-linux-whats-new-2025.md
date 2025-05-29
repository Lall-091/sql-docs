---
title: "What's New for SQL Server 2025 Preview on Linux"
description: This article highlights what's new for SQL Server 2025 Preview on Linux.
author: rwestMSFT
ms.author: randolphwest
ms.date: 05/02/2025
ms.service: sql
ms.subservice: linux
ms.topic: whats-new
ms.custom:
  - intro-whats-new
  - linux-related-content
---

# What's new for SQL Server 2025 Preview on Linux

[!INCLUDE [sqlserver2025-linux](../includes/applies-to-version/sqlserver2025-linux.md)]

This article describes the major features and services available for [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] running on Linux. For package downloads and known issues, see the [Release notes](sql-server-linux-release-notes-2025.md).

## Updates

The updates have been made in [!INCLUDE [sssql19-md](../includes/sssql19-md.md)] on Linux:

| New feature or update | Details |
| --- | --- |
| Custom password policy | [Set custom password policy for SQL logins in SQL Server on Linux](sql-server-linux-custom-password-policy.md) |
| tmpfs support for `tempdb` | [Enable and run tempdb on tmpfs for SQL Server 2025 Preview on Linux](sql-server-linux-tmpfs-tempdb.md) |
| Generic ODBC data source support for PolyBase | [Connect to ODBC data sources with PolyBase on SQL Server on Linux](sql-server-linux-polybase.md) |

## Related content

To install [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] on Linux, use one of the following tutorials:

- [Install on Red Hat Enterprise Linux](quickstart-install-connect-red-hat.md?view=sql-server-linux-ver17&preserve-view=true)
- [Install on SUSE Linux Enterprise Server](quickstart-install-connect-suse.md?view=sql-server-linux-ver17&preserve-view=true)
- [Install on Ubuntu](quickstart-install-connect-ubuntu.md?view=sql-server-linux-ver17&preserve-view=true)
- [Run on a Linux container](quickstart-install-connect-docker.md?view=sql-server-linux-ver17&preserve-view=true)
- [Provision a SQL VM in Azure](/azure/azure-sql/virtual-machines/linux/sql-vm-create-portal-quickstart?toc=/sql/toc/toc.json)

For answers to frequently asked questions, see the [SQL Server on Linux FAQ](sql-server-linux-faq.yml). To see other improvements introduced in [!INCLUDE [sssql25-md](../includes/sssql19-md.md)], see [What's new in SQL Server 2025 Preview](../sql-server/what-s-new-in-sql-server-2025.md).

[!INCLUDE[get-help-options](../includes/paragraph-content/get-help-options.md)]
