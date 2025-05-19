---
title: "SQL Server 2025 release notes"
description: Find information about SQL Server 2025 (17.x) limitations, known issues, help resources, and other release notes.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: randolphwest
ms.date: 04/20/2025
ms.service: sql
ms.subservice: release-landing
ms.topic: release-notes
monikerRange: ">= sql-server-2016"
---

# SQL Server 2025 Preview release notes

[!INCLUDE[sqlserver2025](../includes/applies-to-version/sqlserver2025.md)]

This article describes requirements, limitations and known issues for [!INCLUDE[sssql25-md](../includes/sssql25-md.md)].

## Hardware and software requirements

For hardware and software requirements, see [SQL Server 2025: Hardware and software requirements](install/hardware-and-software-requirements-for-installing-sql-server-2025.md).

## Known issues

### SQL Server fails to start after installation

**Issue**: SQL Server instances on Windows might fail to start after the installation if the machine has more than 64 logical cores per NUMA node.

For more information, see [Limit number of logical cores per NUMA node to 64](compute-capacity-limits-by-edition-of-sql-server.md#limit-number-of-logical-cores-per-numa-node-to-64).

### Upgrade in place

[!INCLUDE [sssql25-md](../includes/sssql25-md.md)] doesn't support in place upgrades from previous versions of [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)], including SQL Server 2025 CTP releases.

## Build number

| Build | Version number | Date |
| :-- | :-- | :-- |
| Preview | 17.0.700.9 | May 19, 2025 |

## Related content

- [What's new in SQL Server 2025 Preview](what-s-new-in-sql-server-2025.md)
