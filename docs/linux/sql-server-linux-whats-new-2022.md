---
title: "What's New for SQL Server 2022 on Linux"
description: This article highlights what's new for SQL Server 2022 on Linux.
author: rwestMSFT
ms.author: randolphwest
ms.date: 05/02/2025
ms.service: sql
ms.subservice: linux
ms.topic: whats-new
ms.custom:
  - intro-whats-new
  - linux-related-content
  - build-2025
---

# What's new for SQL Server 2022 on Linux

[!INCLUDE [sqlserver2022-linux](../includes/applies-to-version/sqlserver2022-linux.md)]

This article describes the major features and services available for [!INCLUDE [sssql22-md](../includes/sssql22-md.md)] running on Linux. For package downloads and known issues, see the [Release notes](sql-server-linux-release-notes-2022.md).

## Red Hat Enterprise Linux 9 supported

Starting with [!INCLUDE [sssql22-md](../includes/sssql22-md.md)] CU 10, Red Hat Enterprise Linux (RHEL) 9 is now supported. Check out our Quickstart on [Install SQL Server and create a database on Red Hat](quickstart-install-connect-red-hat.md).

## Ubuntu 22.04 supported

Starting with [!INCLUDE [sssql22-md](../includes/sssql22-md.md)] CU 10, Ubuntu 22.04 is now supported. Check out our Quickstart on [Install SQL Server and create a database on Ubuntu](quickstart-install-connect-ubuntu.md).

## SUSE Linux Enterprise Server 15 SP4 supported

Starting with [!INCLUDE [sssql22-md](../includes/sssql22-md.md)] CU 4, SUSE Linux Enterprise Server (SLES) 15 SP4 is now supported. Check out our Quickstart on [Installing SQL Server and creating a database on SUSE Linux Enterprise Server](quickstart-install-connect-suse.md).

## Updates

The updates have been made in [!INCLUDE [sssql19-md](../includes/sssql19-md.md)] on Linux:

| New feature or update | Details |
| --- | --- |
| Microsoft Entra Managed Identity | The Microsoft Entra managed identity for SQL Server on Azure VM isn't supported on Linux. For more information, see [Improvement: Microsoft Entra managed identity support for backup and restore database operations and for EKM with AKV in SQL Server on Azure VMs](/troubleshoot/sql/releases/sqlserver-2022/microsoft-entra-managed-identity-support-for-backup-restore-database-ekm-akv). |

## Related content

To install [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] on Linux, use one of the following tutorials:

- [Install on Red Hat Enterprise Linux](quickstart-install-connect-red-hat.md?view=sql-server-linux-ver16&preserve-view=true)
- [Install on SUSE Linux Enterprise Server](quickstart-install-connect-suse.md?view=sql-server-linux-ver16&preserve-view=true)
- [Install on Ubuntu](quickstart-install-connect-ubuntu.md?view=sql-server-linux-ver16&preserve-view=true)
- [Run on a Linux container](quickstart-install-connect-docker.md?view=sql-server-linux-ver16&preserve-view=true)
- [Provision a SQL VM in Azure](/azure/azure-sql/virtual-machines/linux/sql-vm-create-portal-quickstart?toc=/sql/toc/toc.json)

For answers to frequently asked questions, see the [SQL Server on Linux FAQ](sql-server-linux-faq.yml). To see other improvements introduced in [!INCLUDE [sssql22-md](../includes/sssql22-md.md)], see [What's new in SQL Server 2022](../sql-server/what-s-new-in-sql-server-2022.md).

[!INCLUDE[get-help-options](../includes/paragraph-content/get-help-options.md)]
