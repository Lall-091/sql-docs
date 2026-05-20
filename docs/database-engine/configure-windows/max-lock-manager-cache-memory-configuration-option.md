---
title: "Server Configuration: max lock manager cache memory (%)"
description: Explains the max lock manager cache memory instance configuration setting.
author: dimitri-furman
ms.author: dfurman
ms.reviewer: randolphwest
ms.date: 05/20/2026
ms.service: sql
ms.subservice: configuration
ms.topic: how-to
helpviewer_keywords:
  - "Max lock manager cache memory"
---

# Server configuration: max lock manager cache memory (%)

[!INCLUDE [sqlserver2025-and-later](../../includes/applies-to-version/sqlserver2025-and-later.md)]

The `max lock manager cache memory (%)` server configuration option limits the amount of memory that the lock manager cache can use, as a percentage of the total SQLOS committed memory. By default, the configuration is set to 20 percent.

## Availability

This configuration option is available in the following SQL platforms and versions:

- [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] Cumulative Update (CU) 5 and later versions

## Remarks

Before [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] CU 5 and in previous versions of [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)], the lock manager cache can use up to 60 percent of the total SQLOS committed memory. In rare cases, a workload can grow the size of the lock manager cache up to the limit, which reduces buffer pool memory. For example, this situation can occur in large concurrent query workloads when lock escalation is disabled for the [!INCLUDE [ssDE](../../includes/ssde-md.md)] instance.

In [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] CU 5 and later versions, the maximum size of lock manager cache is limited to 20 percent by default. Setting this configuration to a larger value isn't recommended, but is supported for backward compatibility. You can set the value in the 20-60 percent range.

You can monitor the memory consumption by the lock manager cache using [sys.dm_os_memory_clerks](../../relational-databases/system-dynamic-management-views/sys-dm-os-memory-clerks-transact-sql.md), with `OBJECTSTORE_LOCK_MANAGER` as the memory clerk type.

## Examples

### A. Set the maximum size of the lock manager cache memory

The following example sets the max lock manager cache memory to 25 percent:

```sql
EXECUTE sp_configure 'show advanced options', 1;
RECONFIGURE;

EXECUTE sp_configure 'max lock manager cache memory (%)', 25;
RECONFIGURE;
```

### B. Monitor the current size of the lock manager cache

The following example shows the current size of the lock manager cache:

```sql
SELECT SUM(pages_kb) / 1024. AS lock_manager_cache_memory_mb
FROM sys.dm_os_memory_clerks
WHERE type = 'OBJECTSTORE_LOCK_MANAGER';
```

## Related content

- [Server configuration options](server-configuration-options-sql-server.md)
- [Transaction locking and row versioning guide](../../relational-databases/sql-server-transaction-locking-and-row-versioning-guide.md)
