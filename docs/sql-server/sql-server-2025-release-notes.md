---
title: "SQL Server 2025 release notes"
description: Find information about SQL Server 2025 (17.x) limitations, known issues, help resources, and other release notes.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: randolphwest
ms.date: 06/12/2025
ms.service: sql
ms.subservice: release-landing
ms.topic: release-notes
monikerRange: ">= sql-server-2016"
ms.custom:
  - build-2025
---

# SQL Server 2025 Preview release notes

[!INCLUDE[sqlserver2025](../includes/applies-to-version/sqlserver2025.md)]

This article describes requirements, limitations, and known issues for [!INCLUDE[sssql25-md](../includes/sssql25-md.md)].

This article is updated for community technology preview (CTP 2.1).

## Hardware and software requirements

For hardware and software requirements, see [SQL Server 2025: Hardware and software requirements](install/hardware-and-software-requirements-for-installing-sql-server-2025.md).

## Known issues

### SQL Server fails to start after installation

**Issue**: SQL Server instances on Windows might fail to start after the installation if the machine has more than 64 logical cores per NUMA node.

For more information, see [Limit number of logical cores per NUMA node to 64](compute-capacity-limits-by-edition-of-sql-server.md#limit-number-of-logical-cores-per-numa-node-to-64).

### Upgrade in place

[!INCLUDE [sssql25-md](../includes/sssql25-md.md)] doesn't support in place upgrades from previous versions of [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)], including SQL Server 2025 CTP releases.

### Setting the backup compression algorithm to ZSTD

There's a known issue when attempting to set the [backup compression algorithm](../database-engine/configure-windows/view-or-configure-the-backup-compression-algorithm-server-configuration-option.md) to ZSTD. 

When specifying the ZSTD algorithm (`backup compression algorithm = 3`), the following error message returns:

```console
Msg 15129, Level 16, State 1,  Procedure sp_configure `3` is not a valid value for configuration option 'backup compression algorithm'. 
```

Use the new compression algorithm directly in the [BACKUP](../t-sql/statements/backup-transact-sql.md#-compression---algorithm---ms_xpress--zstd--accelerator_algorithm---level---low--medium--high------no_compression-) Transact-SQL command instead of setting the server configuration option.

### Incorrect behavior of SESSION_CONTEXT in parallel plans

Queries that use the built-in `SESSION_CONTEXT` function may return incorrect results or trigger access violation (AV) dumps when executed in parallel query plans. This issue stems from the way `SESSION_CONTEXT` interacts with parallel execution threads, particularly when the session is reset for reuse.

For more information, see the [Known issues](../t-sql/functions/session-context-transact-sql.md#known-issues) section in `SESSION_CONTEXT`.

### Access violation exception occurs under certain conditions

When the Optional parameter plan optimization feature encounters a predicate that is based on a LOB column, an access violation exception can occur. A fix has been identified and will be part of the next preview release of SQL Server 2025.

Large object (LOB) data types in the Database Engine can store data that exceeds 8,000 bytes. These data types store data on a [row-overflow](../relational-databases/pages-and-extents-architecture-guide.md#row-overflow-considerations) data page. A LOB also encompasses data types that store data on dedicated LOB page structures, which use a text or image pointer of in-row references to LOB data pages. For more information about data storage, see [Pages and extents architecture guide](../relational-databases/pages-and-extents-architecture-guide.md).

## Build number

| Build | Version number | Date |
| --- | --- | --- |
| Preview (CTP 2.1) | 17.0.800.3 | June 21, 2025 |
| Preview (CTP 2.0) | 17.0.700.9 | May 19, 2025 |

## Related content

- [What's new in SQL Server 2025 Preview](what-s-new-in-sql-server-2025.md)
