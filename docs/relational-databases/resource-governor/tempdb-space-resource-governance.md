---
title: Tempdb Space Resource Governance
description: Use Resource Governor to prevent runaway workloads from consuming a large amount of space in tempdb.
author: dimitri-furman
ms.author: dfurman
ms.service: sql
ms.topic: concept-article
ms.date: 06/16/2025
monikerRange: " >= sql-server-ver17 || >= sql-server-linux-ver17 "
ms.custom:
  - build-2025
---

# Tempdb space resource governance

[!INCLUDE [sqlserver2025-and-later](../../includes/applies-to-version/sqlserver2025-and-later.md)]

When you enable `tempdb` space resource governance, you improve reliability and avoid outages by preventing runaway queries or workloads from consuming a large amount of space in `tempdb`.

Starting with [!INCLUDE [sql-server-2025](../../includes/sssql25-md.md)], you can use resource governor to enforce a limit on the total amount of `tempdb` space consumed by a workload group. A workload group can be associated with an application, a user, a group of users, etc. When a request (a query) attempts to exceed the limit, resource governor aborts it with a distinct error indicating that the workload group limit has been enforced.

In effect, you can partition the shared `tempdb` space among different workloads. For example, you can set a higher limit for a workload group used by a mission-critical application, and set a lower limit for the `default` workload group used by all other workloads.

For step-by-step configuration examples, see [Tutorial: Examples to configure tempdb space resource governance](tempdb-space-resource-governance-walkthrough.md).

## Get started with resource governor

Resource governor provides a flexible framework to set different `tempdb` space limits for different applications, users, user groups, etc. You can set limits based on custom logic as well.

If you are new to resource governor in [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)], see [resource governor](resource-governor.md) to learn about its concepts and capabilities.

For a resource governor configuration walkthrough and best practices, see [Tutorial: Resource governor configuration examples and best practices](resource-governor-walkthrough.md).

## Set limits on tempdb space consumption

You can limit `tempdb` space consumption by a workload group in one of two ways:

- Set a **fixed limit** using the `GROUP_MAX_TEMPDB_DATA_MB` argument.

    The fixed limit is useful when the workload `tempdb` usage requirements are known in advance, or when `tempdb` size doesn't change.
- Set a **percent limit** using the `GROUP_MAX_TEMPDB_DATA_PERCENT` argument.

    The percent limit is useful when you might change the maximum size of `tempdb` over time and you want the `tempdb` space available to each workload group to change proportionally without reconfiguring resource governor. For example, if you scale up an Azure VM running [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] and increase the maximum `tempdb` size, the `tempdb` space available to each workload group with a percent limit increases as well.

For more information about the `GROUP_MAX_TEMPDB_DATA_MB` and `GROUP_MAX_TEMPDB_DATA_PERCENT` arguments, see [CREATE WORKLOAD GROUP](../../t-sql/statements/create-workload-group-transact-sql.md#group_max_tempdb_data_mb--value) or [ALTER WORKLOAD GROUP](../../t-sql/statements/alter-workload-group-transact-sql.md#group_max_tempdb_data_mb--value).

If both fixed and percent limits are specified for the same workload group, the fixed limit takes precedence over the percent limit.

On a given [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] instance, you can have a mix of workload groups with fixed limits, percent limits, or no limits on `tempdb` space consumption.

### Percent limit configuration

The percent limits are in effect only when the `tempdb` data file configuration meets the requirements summarized in the following table:

| Configuration | Description | Tempdb maximum size (100%) | Percent limit in effect |
| --- | --- | --- | --- |
| - `GROUP_MAX_TEMPDB_DATA_MB` is not set<br />- For all data files, `MAXSIZE` is not `UNLIMITED`<br />- For all data files, `FILEGROWTH` is not zero | `tempdb` data files can autogrow up to their maximum size | The sum of `MAXSIZE` values for all data files | Yes |
| - `GROUP_MAX_TEMPDB_DATA_MB` is not set<br />- For all data files, `MAXSIZE` is `UNLIMITED`<br />- For all data files, `FILEGROWTH` is zero | `tempdb` data files are pregrown to their intended sizes and cannot grow further | The sum of `SIZE` values for all data files | Yes |
| All other configurations | | | No |

The following query lets you see the current `tempdb` data file configuration:

```sql
SELECT file_id,
       name,
       size * 8. / 1024 AS size_mb,
       IIF(max_size = -1, NULL, max_size * 8. / 1024) AS maxsize_mb,
       IIF(is_percent_growth = 0, growth * 8. / 1024, NULL) AS filegrowth_mb,
       IIF(is_percent_growth = 1, growth, NULL) AS filegrowth_percent
FROM sys.master_files
WHERE database_id = 2
      AND
      type_desc = 'ROWS';
```

For a given file in the result set:

- If the `maxsize_mb` column is `NULL`, then `MAXSIZE` is `UNLIMITED`.
- When either `filegrowth_mb` or `filegrowth_percent` is zero, then `FILEGROWTH` is zero.

If you set `GROUP_MAX_TEMPDB_DATA_PERCENT` and execute the [ALTER RESOURCE GOVERNOR RECONFIGURE](../../t-sql/statements/alter-resource-governor-transact-sql.md) statement, but the data file configuration doesn't meet the requirements, the statement completes successfully and the percent limits are stored, but they aren't enforced. In this case, you receive warning message 10989, severity 10, *GROUP_MAX_TEMPDB_DATA_PERCENT is not in effect because tempdb configuration requirements aren't met.* The message is also logged in the error log.

To make the percent limits effective, reconfigure `tempdb` data files to meet the requirements and execute `ALTER RESOURCE GOVERNOR RECONFIGURE` again. For more information about configuring `SIZE`, `FILEGROWTH`, and `MAXSIZE`, see [ALTER DATABASE File and Filegroup Options](../../t-sql/statements/alter-database-transact-sql-file-and-filegroup-options.md).

> [!NOTE]
> For a new instance of [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)], data file `MAXSIZE` is `UNLIMITED` and `FILEGROWTH` is greater than zero, which means that percent limits aren't effective. To use percent limits, you must either:
> - Pregrow `tempdb` data files to their intended sizes and set `FILEGROWTH` to zero.
> - Set the `MAXSIZE` of each data file to a limited value.
>   - For each `tempdb` data file volume, make sure that the sum of `MAXSIZE` values for files on the volume is less than or equal to the available disk space on the volume.
>     
>     For example, if a volume has 100 GB of free space and has two `tempdb` data files, make the `MAXSIZE` of each file 50 GB or less.

If a percent limit is in effect, and you add, remove, or resize `tempdb` data files, you must execute `ALTER RESOURCE GOVERNOR RECONFIGURE` to update resource governor with the new maximum size of `tempdb` (100%).

## How it works

This section describes `tempdb` space resource governance in detail.

- As data pages in `tempdb` are allocated and deallocated, resource governor keeps the accounting of the `tempdb` space consumed by each workload group.

    If resource governor is enabled and a `tempdb` space consumption limit is set for a workload group, and a request (a query) running in the workload group attempts to bring the total `tempdb` space consumption by the group above the limit, the request is aborted with error 1138, severity 17, *Could not allocate a new page for database 'tempdb' because that would exceed the limit set for workload group 'workload-group-name'*.

    When a request is aborted with error 1138, the value in the `total_tempdb_data_limit_violation_count` column of the [sys.dm_resource_governor_workload_groups](../system-dynamic-management-views/sys-dm-resource-governor-workload-groups-transact-sql.md) dynamic management view (DMV) is incremented by one, and the `tempdb_data_workload_group_limit_reached` extended event fires.
- Resource governor keeps track of all `tempdb` usage that can be attributed to a workload group, including temporary tables, variables (including table variables), table-valued parameters, nontemporary tables, cursors, and `tempdb` usage during query processing, such as spools, spills, worktables, and workfiles.

    Space consumption for global temporary tables and nontemporary tables in `tempdb` is accounted under the workload group that inserts the first row into the table, even if sessions in other workload groups add, modify, or remove rows in the same table.
- The configured `tempdb` consumption limits for each workload group are exposed in the [sys.resource_governor_workload_groups](../system-catalog-views/sys-resource-governor-workload-groups-transact-sql.md) catalog view, in the `group_max_tempdb_data_mb` and `group_max_tempdb_data_percent` columns.

    The current consumption and the peak consumption of `tempdb` space by a workload group are exposed in the [sys.dm_resource_governor_workload_groups](../system-dynamic-management-views/sys-dm-resource-governor-workload-groups-transact-sql.md) DMV, in the `tempdb_data_space_kb` and `peak_tempdb_data_space_kb` columns respectively.

    > [!TIP]
    > `tempdb_data_space_kb` and `peak_tempdb_data_space_kb` columns in [sys.dm_resource_governor_workload_groups](../system-dynamic-management-views/sys-dm-resource-governor-workload-groups-transact-sql.md) are maintained even if no limits on `tempdb` space consumption are set.
    >
    > You can create the classifier function and workload groups without setting any limits initially. Monitor `tempdb` usage by each group over time to establish representative usage patterns, and then set limits as required.

- `Tempdb` usage by the version stores, including the persistent version store (PVS) when [accelerated database recovery (ADR)](../accelerated-database-recovery-concepts.md) is enabled in `tempdb`, isn't governed because row versions might be used by requests in multiple workload groups.
- Space consumption in `tempdb` is accounted as the number of 8-KB data pages used. Even if a page isn't filled with data fully, it adds 8 KB to the `tempdb` consumption by a workload group.
- `Tempdb` space accounting is maintained for the lifetime of a workload group. If a workload group is dropped while global temporary tables or nontemporary tables with the data accounted to this workload group remain in `tempdb`, the space used by these tables isn't accounted under any other workload group.
- `Tempdb` space resource governance controls the space in `tempdb` data files, but not disk space on the underlying volumes. Unless you pre-grow `tempdb` data files to their intended sizes, the space on the volume(s) where `tempdb` is located might be consumed by other files. If there is no remaining space for `tempdb` data files to grow, then `tempdb` might run out of space before any workload group limit on `tempdb` space consumption is reached.
- Space resource governance in `tempdb` applies to data files but not the transaction log file. To ensure that the transaction log in `tempdb` doesn't consume a large amount of space, enable [ADR](../accelerated-database-recovery-concepts.md) in `tempdb`.

### Differences with session-level space tracking

The [sys.dm_db_session_space_usage](../system-dynamic-management-views/sys-dm-db-session-space-usage-transact-sql.md) DMV provides `tempdb` space allocation and deallocation statistics for each session. Even if there is only one session in a workload group, space usage statistics provided by this DMV might not match exactly the statistics provided in the [sys.dm_resource_governor_workload_groups](../system-dynamic-management-views/sys-dm-resource-governor-workload-groups-transact-sql.md) view, for the following reasons:

- Unlike `sys.dm_resource_governor_workload_groups`, `sys.dm_db_session_space_usage`:
    - Doesn't reflect `tempdb` space usage by the currently running tasks. Statistics in `sys.dm_db_session_space_usage` are updated when a task completes. Statistics in `sys.dm_resource_governor_workload_groups` are updated continuously.
    - Doesn't track index allocation map (IAM) pages. For more information, see [Pages and extents architecture guide](../pages-and-extents-architecture-guide.md).
- After rows are deleted, or when a table, index, or partition is dropped or truncated, data pages might be deallocated by an asynchronous background process. This page deallocation might occur with a delay. `sys.dm_resource_governor_workload_groups` reflects these page deallocations as they occur, even if the session that caused these deallocations was closed and is no longer present in `sys.dm_db_session_space_usage`.

## Best practices for tempdb space resource governance

Before configuring `tempdb` space resource governance, consider the following best practices:

- Review the general [best practices](resource-governor-walkthrough.md#resource-governor-best-practices) for resource governor.
- For most scenarios, avoid setting the `tempdb` space consumption limit to a small value or zero, particularly for the `default` workload group. If you do so, many common tasks might start failing if they need to allocate space in `tempdb`. For example, if you set either the fixed or the percent limit to 0 for the `default` workload group, you might not be able to open Object Explorer in SQL Server Management Studio (SSMS).
- Unless you created custom workload groups and a classifier function that places workloads in their dedicated groups, avoid limiting `tempdb` usage by the `default` workload group. That can abort queries with error 1138 when `tempdb` still has unused space that can't be consumed by any user workload.
- It is allowed for the sum of `GROUP_MAX_TEMPDB_DATA_MB` values for all workload groups to exceed the maximum `tempdb` size. For example, if the maximum `tempdb` size is 100 GB, the `GROUP_MAX_TEMPDB_DATA_MB` limits for workload group *A* and workload group *B* can be 80 GB each.

    This approach still prevents each workload group from consuming all space in `tempdb` by leaving 20 GB for other workload groups. At the same time, you avoid unnecessary query aborts when free `tempdb` space is still available because workload groups *A* and *B* aren't likely to consume a large amount of `tempdb` space at the same time.

    Similarly, the sum of `GROUP_MAX_TEMPDB_DATA_PERCENT` values for all workload groups can exceed 100 percent. You can allocate more `tempdb` space to each group if you know that multiple groups are unlikely to cause high `tempdb` usage at the same time.

## Related content

- [Tutorial: Examples to configure tempdb space resource governance](tempdb-space-resource-governance-walkthrough.md)
- [Resource governor](resource-governor.md)
- [Tutorial: Resource governor configuration examples and best practices](resource-governor-walkthrough.md)
- [ALTER RESOURCE GOVERNOR](../../t-sql/statements/alter-resource-governor-transact-sql.md)
- [CREATE WORKLOAD GROUP](../../t-sql/statements/create-workload-group-transact-sql.md)
- [ALTER WORKLOAD GROUP](../../t-sql/statements/alter-workload-group-transact-sql.md)
- [DROP WORKLOAD GROUP](../../t-sql/statements/drop-workload-group-transact-sql.md)
- [sys.resource_governor_workload_groups](../system-catalog-views/sys-resource-governor-workload-groups-transact-sql.md)
- [sys.dm_resource_governor_workload_groups](../system-dynamic-management-views/sys-dm-resource-governor-workload-groups-transact-sql.md)