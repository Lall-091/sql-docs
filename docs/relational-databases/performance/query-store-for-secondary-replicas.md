---
title: "Query Store for Secondary Replicas"
description: Query Store can be configured to monitor and tuning workloads on secondary read-only replicas.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: randolphwest
ms.date: 05/05/2025
ms.service: sql
ms.subservice: performance
ms.topic: concept-article
helpviewer_keywords:
  - "Query Store secondary replicas"
monikerRange: ">=sql-server-ver16"
ms.custom:
  - build-2025
---
# Query Store for readable secondaries

[!INCLUDE [SQL Server 2022](../../includes/applies-to-version/_ss2022.md)]

The Query Store for readable secondaries feature enables the same Query Store functionality on secondary replica workloads that is available for primary replicas. When Query Store for secondary replicas is enabled, replicas send the query execution information that would normally be stored in the Query Store back to the primary replica. The primary replica then persists the data to disk within its own Query Store. In essence, there's one Query Store shared between the primary and all secondary replicas. The Query Store exists on the primary replica and stores data for all replicas together. Currently, Query Store for secondary replicas is available with [!INCLUDE [sql-server-2022](../../includes/sssql22-md.md)] instances configured in availability groups.

## Remarks

Query Store for readable secondaries is a *preview* feature. It isn't intended for production deployments. For more information, see [SQL Server 2022 release notes](../../sql-server/sql-server-2022-release-notes.md).

You must enable Trace Flag 12606 before you can enable Query Store for readable secondaries. To enable the [trace flags](../../t-sql/database-console-commands/dbcc-traceon-trace-flags-transact-sql.md):

1. In Windows, launch [SQL Server Configuration Manager](../../relational-databases/sql-server-configuration-manager.md).

1. In the list of **SQL Server Services**, right-click on the **SQL Server** instance service for your [!INCLUDE [sssql22-md](../../includes/sssql22-md.md)] instance. Select **Properties**.

1. Select the **Start Parameters** tab. In the **Specify a startup parameter:** field, add the values: `-T12606` and select **Add**.

1. The SQL Server instance service must be restarted before the changes will take effect.

> [!NOTE]  
> Beginning with [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)], Query Store for readable secondaries isn't in preview, and is enabled by default. Trace flag 12606 is no longer required to use the Query Store for readable secondaries feature. Enabling Trace Flag 12606 in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] disables the Query Store for readable secondaries feature.

## Enable Query Store for readable secondaries

Before using Query Store for readable secondaries on a SQL Server instance, you need to have an [Always On availability group](../../database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server.md). Then, enable Query Store for readable secondaries using [ALTER DATABASE SET options](../../t-sql/statements/alter-database-transact-sql-set-options.md).

If Query Store isn't already enabled and in `READ_WRITE` mode on the primary replica, you must enable it before proceeding. Execute the following for each desired database on the primary replica:

```sql
ALTER DATABASE [Database_Name] SET QUERY_STORE = ON;
GO
ALTER DATABASE [Database_Name] SET QUERY_STORE
( OPERATION_MODE = READ_WRITE );
```

To enable the Query Store on all readable secondaries, connect to the primary replica and execute the following for each desired database. Currently, when the Query Store for readable secondaries is enabled, it is enabled for all secondary replicas.

```sql
ALTER DATABASE [Database_Name]
FOR SECONDARY SET QUERY_STORE = ON (OPERATION_MODE = READ_WRITE );
GO
```

To disable the Query Store on all secondary replicas, connect to the primary replica and execute the following for each desired database:

```sql
ALTER DATABASE [Database_Name]
FOR SECONDARY SET QUERY_STORE = OFF;
GO
```

You can validate that Query Store is enabled on a secondary replica by connecting to the database on the secondary replica and executing the following:

```sql
SELECT desired_state,
       desired_state_desc,
       actual_state,
       actual_state_desc,
       readonly_reason
FROM sys.database_query_store_options;
GO
```

The following sample results from querying [sys.database_query_store_options](../system-catalog-views/sys-database-query-store-options-transact-sql.md) indicate that the Query Store is in a READ_CAPTURE_SECONDARY state for the secondary. The `readonly_reason` of `8` indicates that the query was run against a secondary replica. These results indicate that Query Store has been enabled successfully on the secondary replica.

| desired_state | desired_state_desc | actual_state | actual_state_desc | readonly_reason |
| --- | --- | --- | --- | --- |
| 4 | READ_CAPTURE_SECONDARY | 4 | READ_CAPTURE_SECONDARY | 8 |

Once enabled, you can use [sys.query_store_replicas](../system-catalog-views/sys-query-store-replicas.md) to verify the health of the Query Store on the secondary replica.

To disable Query Store for readable secondaries, connect to the database on the primary replica and run the following code:

```sql
ALTER DATABASE CURRENT
FOR SECONDARY SET QUERY_STORE = OFF;
GO
```

### Replica sets

Currently, when the Query Store for readable secondaries is enabled, it is enabled for all secondary replicas.

A **replica set** is defined as being all unnamed replicas that share a role (primary, secondary, geo secondary, geo primary), or as being an individual named replica. The data stored about queries can be analyzed as workloads on a replica set basis. Query Store for replicas provides the ability to monitor and adjust the performance of any unique, read-only workloads that might be executing against secondary replicas.

### Performance considerations for Query Store for readable secondaries

The channel used by secondary replicas to send query information back to the primary replica is the same channel used to keep secondary replicas up to date. Data is stored in the same tables on the primary replica that Query Store uses for queries executed on the primary replica, which causes the size of Query Store to grow.

Thus, when a system is under significant load, you might notice some slowdown because of the channel being overloaded. Further, the same ad hoc query capture issues that exist for Query Store today will continue for workloads run on secondary replicas. Learn more about how to [Keep the most relevant data in Query Store](best-practice-with-the-query-store.md#keep-the-most-relevant-data-in-query-store).

## Related content

- [ALTER DATABASE SET options (Transact-SQL)](../../t-sql/statements/alter-database-transact-sql-set-options.md)
- [sys.database_query_store_options (Transact-SQL)](../system-catalog-views/sys-database-query-store-options-transact-sql.md)
- [sys.query_store_replicas](../system-catalog-views/sys-query-store-replicas.md)
- [sys.query_store_plan_forcing_locations (Transact-SQL)](../system-catalog-views/sys-query-store-plan-forcing-locations-transact-sql.md)
- [sys.sp_query_store_force_plan (Transact-SQL)](../system-stored-procedures/sp-query-store-force-plan-transact-sql.md)
- [What is an Always On availability group?](../../database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server.md)
- [Best practices for monitoring workloads with Query Store](best-practice-with-the-query-store.md)
- [Best practices for managing the Query Store](manage-the-query-store.md)
- [Tune performance with the Query Store](tune-performance-with-the-query-store.md)
- [Query Store hints](query-store-hints.md)
- [Query Store Usage Scenarios](query-store-usage-scenarios.md)
- [Open Activity Monitor in SQL Server Management Studio (SSMS)](../performance-monitor/open-activity-monitor-sql-server-management-studio.md)
