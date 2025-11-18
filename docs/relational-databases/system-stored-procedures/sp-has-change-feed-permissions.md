---
title: "sys.sp_has_change_feed_permissions (Transact-SQL)"
description: "The internal sys.sp_has_change_feed_permissions system stored procedure checks for permissions when enabling change feed publishing."
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: imotiwala, ajayj, randolphwest
ms.date: 06/23/2025
ms.service: fabric
ms.subservice: system-objects
ms.topic: "reference"
ms.custom:
  - ignite-2025
f1_keywords:
  - "sys.sp_has_change_feed_permissions_TSQL"
  - "sys.sp_has_change_feed_permissions"
  - "sp_has_change_feed_permissions_TSQL"
  - "sp_has_change_feed_permissions"
helpviewer_keywords:
  - "sp_has_change_feed_permissions"
dev_langs:
  - "TSQL"
monikerRange: ">=sql-server-ver16 || =azuresqldb-current || =azuresqldb-mi-current || =fabric || =fabric-sqldb || =azure-sqldw-latest"
---
# sys.sp_has_change_feed_permissions (Transact-SQL)

[!INCLUDE [sqlserver2022-asdb-asdbmi-asa-fabricmirroredsqldb-fabricsqldb](../../includes/applies-to-version/sqlserver2022-asdb-asdbmi-asa-fabricmirroredsqldb-fabricsqldb.md)]

Internal procedure that checks for permissions when enabling change feed publishing.

> [!CAUTION]  
> This system stored procedure is used internally and isn't recommended for direct administrative use. Use Synapse Studio or the Fabric portal instead.

This system stored procedure is used for:

- [SQL database in Microsoft Fabric](/fabric/database/sql/overview)
- [Microsoft Fabric mirrored databases](/fabric/database/mirrored-database/overview)
- [Azure Synapse Link](../../sql-server/synapse-link/synapse-link-sql-server-change-feed-manage.md)

## Syntax

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

```syntaxsql
sys.sp_has_change_feed_permissions
    @destination_type int
```

## Arguments

#### destination_type

Int. `0` = Azure Synapse Link. `2` = Fabric mirroring. Default is `2`.

## Result set

`0` (success) or `1` (failure). `22740` if *destination_type* is invalid. Error message `22702` indicates permissions are insufficient.

## Permissions

Only **public** role membership is required to execute this procedure.

## Related content

- [sys.sp_help_change_feed (Transact-SQL)](sp-help-change-feed.md)
- [sys.sp_help_change_feed_table (Transact-SQL)](sp-help-change-feed-table.md)
- [sys.sp_change_feed_configure_parameters (Transact-SQL)](sp-change-feed-configure-parameters.md)
- [sys.dm_change_feed_log_scan_sessions (Transact-SQL)](../system-dynamic-management-views/sys-dm-change-feed-log-scan-sessions.md)
- [sys.dm_change_feed_errors (Transact-SQL)](../system-dynamic-management-views/sys-dm-change-feed-errors.md)
