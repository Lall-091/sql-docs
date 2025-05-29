---
title: Tempdb Space Resource Governance
description: Use Resource Governor to prevent runaway workloads from consuming a large amount of space in tempdb.
author: dimitri-furman
ms.author: dfurman
ms.service: sql
ms.topic: concept-article
ms.date: 05/19/2025
monikerRange: " >= sql-server-ver17 || >= sql-server-linux-ver17 "
---

# Tempdb space resource governance

[!INCLUDE [sqlserver2025-and-later.md](../../includes/applies-to-version/sqlserver2025-and-later.md)]

When you enable `tempdb` space resource governance, you improve reliability and avoid outages by preventing runaway queries or workloads from consuming a large amount of space in `tempdb`.

Starting with [!INCLUDE [sql-server-2025](../../includes/sssql25-md.md)], you can use resource governor to enforce a limit on the total amount of `tempdb` space consumed by an application or user workload. When a request (a query) attempts to exceed the limit, resource governor aborts it with a distinct error indicating that the workload group limit has been enforced.

In effect, you can partition the shared `tempdb` space among different workloads. For example, you can set a higher limit for a workload group used by a mission-critical application, and set a lower limit for the `default` workload group used by all other workloads.

## Get started with resource governor

Resource governor provides a flexible framework to set different `tempdb` space limits for different applications, users, user groups, etc. You can set limits based on custom logic as well.

If you are new to resource governor in [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)], see [resource governor](resource-governor.md) to learn about its concepts and capabilities.

For a resource governor configuration walkthrough and best practices, see [Tutorial: Resource governor configuration examples and best practices](resource-governor-walkthrough.md).

## Configure a limit on tempdb space consumption

Examples in this section show how you can set limits on `tempdb` space consumption and view the consumption of `tempdb` space by each workload group.

These examples assume that resource governor isn't enabled initially and that its configuration hasn't been changed from the default.

### Set a limit for the `default` workload group

This example limits the total `tempdb` space consumption by the requests (queries) in the `default` workload group to 20 gigabytes.

1. Modify the `default` workload group to configure a limit on the `tempdb` space consumption.
    ```sql
    ALTER WORKLOAD GROUP [default]
    WITH (GROUP_MAX_TEMPDB_DATA_MB = 20480);
    ```
1. Enable resource governor to make this configuration effective.
    ```sql
    ALTER RESOURCE GOVERNOR RECONFIGURE;
    ```
1. View the limit on `tempdb` space consumption.
    ```sql
    SELECT group_id,
           name,
           group_max_tempdb_data_mb
    FROM sys.resource_governor_workload_groups
    WHERE name = 'default';
    ```
1. Check the current `tempdb` space consumption by the `default` workload group, add data in `tempdb` by creating a temporary table and inserting one row, and then check the space consumption again to see the increase.
    ```sql
    SELECT group_id,
           name,
           tempdb_data_space_kb
    FROM sys.dm_resource_governor_workload_groups
    WHERE name = 'default';

    SELECT REPLICATE('A', 1000) AS c
    INTO #t;

    SELECT group_id,
           name,
           tempdb_data_space_kb
    FROM sys.dm_resource_governor_workload_groups
    WHERE name = 'default';
    ```
1. Optionally, remove the limit for the `default` group and disable resource governor to revert to nongoverned space consumption in `tempdb`:
    ```sql
    ALTER WORKLOAD GROUP [default]
    WITH (GROUP_MAX_TEMPDB_DATA_MB = NULL);

    ALTER RESOURCE GOVERNOR DISABLE;
    ```

### Set a limit for a user-defined workload group

This example creates a new workload group, and then creates a classifier function to assign sessions with a specific application name to this workload group.

For the purposes of this example, the limit on the `tempdb` space consumption for the workload group is set to a small value of 1 megabyte. The example then shows that an attempt to allocate space in `tempdb` that exceeds the limit is aborted.

1. Create a workload group and limit its `tempdb` space consumption to 1 MB.

    ```sql
    CREATE WORKLOAD GROUP limited_tempdb_space_group
    WITH (GROUP_MAX_TEMPDB_DATA_MB = 1);
    ```

1. Create the classifier function in the `master` database. The classifier uses the built-in [APP_NAME()](../../t-sql/functions/app-name-transact-sql.md) function to determine the application name specified in the client connection string. If the application name is set to `limited_tempdb_application`, the function returns `limited_tempdb_space_group` as the name of the workload group to use. Otherwise, the function returns `default` as the workload group name.
    ```sql
    USE master;
    GO

    CREATE FUNCTION dbo.rg_classifier()
    RETURNS sysname
    WITH SCHEMABINDING
    AS
    BEGIN

    DECLARE @WorkloadGroupName sysname = N'default';

    IF APP_NAME() = N'limited_tempdb_application'
        SELECT @WorkloadGroupName = N'limited_tempdb_space_group';

    RETURN @WorkloadGroupName;

    END;
    GO
    ```

1. Modify resource governor to use the classifier function, and enable resource governor with the new configuration.
    ```sql
    ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION = dbo.rg_classifier);
    ALTER RESOURCE GOVERNOR RECONFIGURE;
    ```

1. Open a new session that is classified into the `limited_tempdb_space_group` workload group.
    1. In [!INCLUDE[ssManStudioFull](../../includes/ssmanstudiofull-md.md)] (SSMS), select **File** on the main menu, **New**, **Database Engine Query**.
    1. In the **Connect to Database Engine** dialog, specify the same [!INCLUDE[ssde-md](../../includes/ssde-md.md)] instance where you created the workload group and the classifier function in the previous steps.

        Select the **Additional Connection Parameters** tab, and enter `App=limited_tempdb_application`. This makes SSMS use `limited_tempdb_application` as the application name when connecting to the instance. The `APP_NAME()` function in the classifier returns this value as well.
    1. Select **Connect** to open a new session.

1. Execute the following statement in the query window opened in the previous step. The output should show that your session is classified into the `limited_tempdb_space_group` workload group.
    ```sql
    SELECT wg.name AS workload_group_name
    FROM sys.dm_exec_sessions AS s
    INNER JOIN sys.dm_resource_governor_workload_groups AS wg
    ON s.group_id = wg.group_id
    WHERE s.session_id = @@SPID;
    ```

1. Execute the following statement in the same query window.
    ```sql
    SELECT REPLICATE('S', 100) AS c
    INTO #t1;
    ```
    The statement completes successfully. Execute the following statement in the same query window:
    ```SQL
    SELECT REPLICATE(CAST('F' AS nvarchar(max)), 1000000) AS c
    INTO #t2;
    ```
    The statement is aborted with error 1138 because it attempts to exceed the 1 MB `tempdb` space consumption limit for the workload group.

1. See the current and peak `tempdb` space consumption by the `limited_tempdb_space_group` workload group.
    ```sql
    SELECT group_id,
           name,
           tempdb_data_space_kb,
           peak_tempdb_data_space_kb,
           total_tempdb_data_limit_violation_count
    FROM sys.dm_resource_governor_workload_groups
    WHERE name = 'limited_tempdb_space_group';
    ```

    The value in the `total_tempdb_data_limit_violation_count` column is 1, showing that one request in this workload group was aborted because its `tempdb` space consumption was limited by resource governor.

1. Optionally, to revert to the initial configuration of this example, disconnect all sessions using the `limited_tempdb_space_group` workload group, and execute the following T-SQL script:
    ```sql
    /* Disable resource governor so that the classifier function can be dropped. */
    ALTER RESOURCE GOVERNOR DISABLE;
    ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION = NULL);
    DROP FUNCTION IF EXISTS dbo.rg_classifier;

    /* Drop the workload group. This requires that no sessions are using this workload group. */
    DROP WORKLOAD GROUP limited_tempdb_space_group;

    /* Reconfigure resource governor to reload the effective configuration without the classifier function and the workload group. This enables resource governor. */
    ALTER RESOURCE GOVERNOR RECONFIGURE;

    /* Disable resource governor to revert to the initial configuration. */
    ALTER RESOURCE GOVERNOR DISABLE;
    ```
    Because SSMS retains connection parameters in the **Additional Connection Parameters** tab, make sure to remove the `App` parameter the next time you connect to the same [!INCLUDE[ssde-md](../../includes/ssde-md.md)] instance. This avoids your connections getting classified into the `limited_tempdb_space_group` workload group if it exists.

## How it works

This section describes the details of `tempdb` space resource governance.

- As data pages in `tempdb` are allocated and deallocated, resource governor keeps the accounting of the `tempdb` space consumed by each workload group.

    If resource governor is enabled and the `tempdb` space consumption limit is set for a workload group, and a request (a query) running in the workload group attempts to bring the total `tempdb` space consumption by the group above the limit, the request is aborted with error 1138, severity 17, *Could not allocate a new page for database 'tempdb' because that would exceed the limit set for workload group 'workload-group-name'*.

    When a request is aborted with error 1138, the value in the `total_tempdb_data_limit_violation_count` column of the `sys.dm_resource_governor_workload_groups` dynamic management view (DMV) is incremented by one, and the `tempdb_data_workload_group_limit_reached` extended event fires.
- Resource governor keeps track of all `tempdb` usage that can be attributed to a workload group, including temporary tables, variables (including table variables), table-valued parameters, nontemporary tables, cursors, and `tempdb` usage during query processing, such as spools, spills, worktables, and workfiles.

    Space consumption for global temporary tables and nontemporary tables in `tempdb` is accounted under the workload group that inserts the first row into the table, even if sessions in other workload groups add, modify, or remove rows in the same table.
- The configured `tempdb` consumption limit for each workload group is exposed in the `sys.resource_governor_workload_groups` catalog view, in the `group_max_tempdb_data_mb` column.

    The current consumption and the peak consumption of `tempdb` space by a workload group are exposed in the `sys.dm_resource_governor_workload_groups` DMV, in the `tempdb_data_space_kb` and `peak_tempdb_data_space_kb` columns respectively.

    > [!TIP]
    > `tempdb_data_space_kb` and `peak_tempdb_data_space_kb` columns in the `sys.dm_resource_governor_workload_groups` DMV are maintained even if no limits on `tempdb` space consumption are set.
    >
    > You can create the classifier function and workload groups without setting any limits initially. Monitor `tempdb` usage by each group over time to establish representative usage patterns, and then set limits as required.

- `Tempdb` usage by the version stores, including the persistent version store (PVS) when [accelerated database recovery (ADR)](../accelerated-database-recovery-concepts.md) is enabled in `tempdb`, isn't governed because row versions might be used by requests in multiple workload groups.
- Space consumption in `tempdb` is accounted as the number of 8-kilobyte data pages used. Even if a page isn't filled with data fully, it adds 8 kilobytes to the `tempdb` consumption by a workload group.
- `Tempdb` space accounting is maintained for the lifetime of a workload group. If a workload group is dropped while global temporary tables or nontemporary tables with the data added by sessions in this workload group remain in `tempdb`, the space used by these tables isn't accounted under any workload group.
- Space resource governance in `tempdb` applies to data files but not the transaction log file. To ensure that the transaction log in `tempdb` doesn't consume a large amount of space, enable ADR in `tempdb`.

### Differences with session-level space tracking

The [sys.dm_db_session_space_usage](../system-dynamic-management-views/sys-dm-db-session-space-usage-transact-sql.md) DMV provides `tempdb` space allocation and deallocation statistics for each session. Even if there is only one session in a workload group, space usage statistics provided by this DMV might not match exactly the statistics provided in the `sys.dm_resource_governor_workload_groups` view, for the following reasons:

- Unlike `sys.dm_resource_governor_workload_groups`, `sys.dm_db_session_space_usage`:
    - Doesn't reflect `tempdb` space usage by the currently running tasks. Statistics in `sys.dm_db_session_space_usage` are updated when a task completes. Statistics in `sys.dm_resource_governor_workload_groups` are updated continuously.
    - Doesn't track index allocation map (IAM) pages. For more information, see [Pages and extents architecture guide](../pages-and-extents-architecture-guide.md).
- After rows are deleted, or when a table, index, or partition is dropped or truncated, data pages might be deallocated by an asynchronous background process. This page deallocation might occur with a delay. `sys.dm_resource_governor_workload_groups` reflects these page deallocations as they occur, even if the session that caused these deallocations has been closed and is no longer present in `sys.dm_db_session_space_usage`.

## Best practices for tempdb space resource governance

When using `tempdb` space resource governance, consider the following best practices:

- Review the general [best practices](resource-governor-walkthrough.md#resource-governor-best-practices) for resource governor.
- For most scenarios, avoid setting the `tempdb` space consumption limit to a small value or zero, particularly for the `default` workload group. If you do so, many common tasks might start failing if they need to allocate space in `tempdb`. For example, if you set the limit to 0 for the `default` workload group, you might not be able to open Object Explorer in SQL Server Management Studio (SSMS).
- Unless you have created custom workload groups and a classifier function that places workloads in their dedicated groups, avoid limiting `tempdb` usage by the `default` workload group. That can abort queries with error 1138 when `tempdb` still has unused space that can't be consumed by any user workload.
- It is allowed for the sum of `GROUP_MAX_TEMPDB_DATA_MB` values for all workload groups to exceed the maximum `tempdb` size. For example, if the maximum `tempdb` size is 100 GB, the `GROUP_MAX_TEMPDB_DATA_MB` limits for workload group *A* and workload group *B* can be 80 GB each.

    This approach prevents each workload group from consuming all space in `tempdb` by leaving 20 GB for other workload groups. At the same time, you avoid unnecessary query aborts when free `tempdb` space is still available because workload groups *A* and *B* aren't likely to consume a large amount of `tempdb` space at the same time.

## Related content

- [Resource governor](resource-governor.md)
- [Tutorial: Resource governor configuration examples and best practices](resource-governor-walkthrough.md)
- [ALTER RESOURCE GOVERNOR](../../t-sql/statements/alter-resource-governor-transact-sql.md)
- [CREATE WORKLOAD GROUP](../../t-sql/statements/create-workload-group-transact-sql.md)
- [ALTER WORKLOAD GROUP](../../t-sql/statements/alter-workload-group-transact-sql.md)
- [DROP WORKLOAD GROUP](../../t-sql/statements/drop-workload-group-transact-sql.md)
