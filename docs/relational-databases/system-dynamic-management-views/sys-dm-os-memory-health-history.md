---
title: "sys.dm_os_memory_health_history"
description: sys.dm_os_memory_health_history provides a recent history of memory usage by the database engine.
author: dimitri-furman
ms.author: dfurman
ms.reviewer: wiassaf
ms.date: 06/11/2025
ms.service: azure-sql-database
ms.topic: "reference"
f1_keywords:
  - "sys.dm_os_memory_health_history"
  - "sys.dm_os_memory_health_history_TSQL"
  - "dm_os_memory_health_history"
  - "dm_os_memory_health_history_TSQL"
helpviewer_keywords:
  - "sys.dm_os_memory_health_history"
  - "dm_os_memory_health_history"
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-current || =azuresqldb-mi-current"
---

# sys.dm_os_memory_health_history

[!INCLUDE [sqlserver2025-asdb-asmi-fabricsqldb](../../includes/applies-to-version/sqlserver2025-asdb-asmi-fabricsqldb.md)]

> [!NOTE]
> The `sys.dm_os_memory_health_history` dynamic management view is in preview. Schema and provided data are subject to change.

Provides memory health snapshots for a database engine instance. Each row represents a snapshot of recent memory usage that includes the severity of a memory health issue, if any.

For more information on troubleshooting insufficient memory in [!INCLUDE [ssazure-sqldb](../../includes/ssazure-sqldb.md)], see [Troubleshoot out of memory errors in Azure SQL Database](/azure/azure-sql/database/troubleshoot-memory-errors-issues).

In Azure SQL Managed Instance, this view is available only on instances with the **always-up-to-date** update policy.

| Column Name | Data Type | Description |
|:--|:--|:--|
| `snapshot_time` | **datetime2** | Snapshot time. Nullable. |
| `allocation_potential_memory_mb` | **int** | Memory available to the database engine instance for new allocations, in megabytes. Is not nullable.|
| `external_cache_mb` | **int** | Memory used by reclaimable caches such as the buffer pool and the columnstore object pool, in megabytes. Under memory pressure, the database engine might shrink these caches to use the memory elsewhere. Is not nullable.|
| `top_clerks` | **nvarchar(4000)** | Top memory clerks by memory consumption, including memory usage statistics for each clerk. This information is provided as a JSON value. Nullable.|
| `severity_level` | **tinyint** | A value describing the severity of a memory health issue. Is not nullable.</br></br>1 - `Low`</br>No memory health issue is identified.</br></br>2 - `Medium`</br>There is medium confidence that a memory health issue might be present. Some attempts to allocate memory might fail. Data cache might be shrinking, and disk I/O can increase as the result.</br></br>3 - `High`</br>High confidence that a memory health issue is present. Available memory is likely insufficient, new memory allocation attempts can fail, and disk I/O can increase substantially because the size of the remaining data cache is too small. |

## Permissions

In [!INCLUDE [ssnoversion-md](../../includes/ssnoversion-md.md)] and [!INCLUDE [ssazuremi-md](../../includes/ssazuremi-md.md)], requires the `VIEW SERVER PERFORMANCE STATE` permission.

In SQL Database **Basic**, **S0**, and **S1** service objectives, and for databases in **elastic pools**, the [server admin](/azure/azure-sql/database/logins-create-manage#existing-logins-and-user-accounts-after-creating-a-new-database) account, the [Microsoft Entra admin](/azure/azure-sql/database/authentication-aad-overview#administrator-structure) account, or membership in the `##MS_ServerPerformanceStateReader##` [server role](/azure/azure-sql/database/security-server-roles) is required. In all other SQL Database service objectives, either the `VIEW DATABASE PERFORMANCE STATE` permission on the database, or membership in the `##MS_ServerPerformanceStateReader##` server role is required.

## Remarks

A snapshot is added approximately every 15 seconds, for a total of up to 256 snapshots. Older snapshots are removed as newer snapshots are added. Data in this view is reset when the database engine restarts.

## Examples

### A. Get all available memory health snapshots

This example returns all memory health snapshot rows ordered by snapshot time.

```sql
SELECT snapshot_time,
       severity_level,
       allocation_potential_memory_mb,
       reclaimable_cache_memory_mb,
       top_memory_clerks
FROM sys.dm_os_memory_health_history
ORDER BY snapshot_time DESC;
```

### B. Get top memory clerks in each snapshot

This example expands the JSON data in the `top_memory_clerks` column into individual rows for each snapshot. Each row in the result set represents a top memory clerk in a specific memory health snapshot.

```sql
SELECT snapshot_time,
       severity_level,
       allocation_potential_memory_mb,
       reclaimable_cache_memory_mb,
       clerk_type,
       pages_allocated_kb
FROM sys.dm_os_memory_health_history
CROSS APPLY OPENJSON(top_memory_clerks)
                    WITH (
                         clerk_type sysname '$.clerk_type',
                         pages_allocated_kb bigint '$.pages_allocated_kb'
                         )
ORDER BY snapshot_time DESC, pages_allocated_kb DESC;
```

## Related content

- [sys.dm_os_out_of_memory_events](sys-dm-os-out-of-memory-events.md)
- [sys.resource_stats](../system-catalog-views/sys-resource-stats-azure-sql-database.md)
- [sys.server_resource_stats](../system-catalog-views/sys-server-resource-stats-azure-sql-database.md)
- [sys.dm_db_resource_stats (Azure SQL Database)](sys-dm-db-resource-stats-azure-sql-database.md?view=azuresqldb-current&preserve-view=true)
- [Troubleshoot out of memory errors with Azure SQL Database](/azure/azure-sql/database/troubleshoot-memory-errors-issues)
