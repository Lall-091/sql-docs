---
title: "sys.sp_change_feed_reseed_db_init (Transact-SQL)"
description: "The sys.sp_change_feed_reseed_db_init system internal stored procedure executes a database reseed."
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: imotiwala, ajayj, randolphwest
ms.date: 08/18/2025
ms.service: fabric
ms.subservice: system-objects
ms.topic: "reference"
ms.custom:
  - ignite-2025
f1_keywords:
  - "sys.sp_change_feed_reseed_db_init_TSQL"
  - "sys.sp_change_feed_reseed_db_init"
  - "sp_change_feed_reseed_db_init_TSQL"
  - "sp_change_feed_reseed_db_init"
helpviewer_keywords:
  - "sp_change_feed_reseed_db_init"
dev_langs:
  - "TSQL"
monikerRange: ">=sql-server-ver17 || =azuresqldb-current || =azuresqldb-mi-current || =fabric || =fabric-sqldb"
---
# sys.sp_change_feed_reseed_db_init (Transact-SQL)

[!INCLUDE [sqlserver2025-asdb-asdbmi-fabricmirroredsqldb-fabricsqldb](../../includes/applies-to-version/sqlserver2025-asdb-asdbmi-fabricmirroredsqldb-fabricsqldb.md)]

Executes a database reseed.

> [!CAUTION]  
> This system stored procedure is used internally and isn't recommended for direct administrative use. Use the Fabric portal instead. Using this procedure could introduce inconsistency.

This system stored procedure is used for [Microsoft Fabric mirrored databases](/fabric/database/mirrored-database/overview) and [SQL database in Microsoft Fabric](/fabric/database/sql/overview).

## Syntax

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

```syntaxsql
sys.sp_change_feed_reseed_db_init
    @is_init_needed tinyint
```

## Arguments

#### is_init_needed

Internal use only.

## Returns

`0` (success) or non-zero (failure).

## Remarks

A reseed stops the current mirrored database and reinitializes the mirroring. This involves generating a new initial snapshot of the tables configured for mirroring and then incremental changes are replicated. During reseed, the old mirrored database item in Microsoft Fabric is still available but does not receive incremental changes. 

## Permissions

A user with [CONTROL database permissions](../security/permissions-database-engine.md), **db_owner** database role membership, or **sysadmin** server role membership can execute this procedure.

## Examples

### A. Initiate manual reseed event

As a best practice, test manual reseed for a specific database to understand the impact before turning on the automatic reseed functionality.

```sql
USE <Mirrored database name>
GO
EXECUTE sp_change_feed_reseed_db_init @is_init_needed = 1;
```

## Related content

- [sys.sp_help_change_feed (Transact-SQL)](sp-help-change-feed.md)
- [sys.sp_help_change_feed_table (Transact-SQL)](sp-help-change-feed-table.md)
- [sys.sp_help_change_feed_table_groups (Transact-SQL)](sp-help-change-feed-table-groups.md)
- [sys.sp_help_change_feed_settings (Transact-SQL)](sp-help-change-feed-settings.md)
- [sys.sp_change_feed_configure_parameters (Transact-SQL)](sp-change-feed-configure-parameters.md)
- [sys.dm_change_feed_log_scan_sessions (Transact-SQL)](../system-dynamic-management-views/sys-dm-change-feed-log-scan-sessions.md)
- [sys.dm_change_feed_errors (Transact-SQL)](../system-dynamic-management-views/sys-dm-change-feed-errors.md)
- [What is Mirroring in Fabric?](/fabric/database/mirrored-database/overview)
- [Monitor Fabric mirrored database replication](/fabric/database/mirrored-database/monitor)
- [Explore data in your mirrored database using Microsoft Fabric](/fabric/database/mirrored-database/explore)
