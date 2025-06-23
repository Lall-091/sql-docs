---
title: "sys.sp_help_change_feed_settings (Transact-SQL)"
description: "The sys.sp_help_change_feed_settings system stored procedure returns state information for Microsoft Fabric Mirroring."
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: imotiwala, ajayj, randolphwest
ms.date: 06/23/2025
ms.service: fabric
ms.subservice: system-objects
ms.topic: "reference"
ms.custom:
  - ignite-2024
  - build-2025
f1_keywords:
  - "sys.sp_help_change_feed_settings_TSQL"
  - "sys.sp_help_change_feed_settings"
  - "sp_help_change_feed_settings_TSQL"
  - "sp_help_change_feed_settings"
helpviewer_keywords:
  - "sp_help_change_feed_settings"
dev_langs:
  - "TSQL"
monikerRange: ">=sql-server-ver16 || =azuresqldb-current || =azuresqldb-mi-current || =fabric || =azure-sqldw-latest"
---
# sys.sp_help_change_feed_settings (Transact-SQL)

[!INCLUDE [sqlserver2022-asdb-asdbmi-asa-fabricmirroredsqldb-fabricsqldb](../../includes/applies-to-version/sqlserver2022-asdb-asdbmi-asa-fabricmirroredsqldb-fabricsqldb.md)]

Provides the provision or deprovision status and information of the [Fabric Mirrored Database](/fabric/database/mirrored-database/overview) feature.

This system stored procedure is used for:

- [SQL database in Microsoft Fabric](/fabric/database/sql/overview)
- [Microsoft Fabric mirrored databases](/fabric/database/mirrored-database/overview)
- [Azure Synapse Link](../../sql-server/synapse-link/synapse-link-sql-server-change-feed-manage.md)
- [Change event streaming (preview)](../track-changes/change-event-streaming/overview.md) introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)].

## Syntax

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

```syntaxsql
EXECUTE sys.sp_help_change_feed_settings;
```

## Arguments

None.

## Result set

| Column name | Data type | Description |
| --- | --- | --- |
| `maxtrans` | **int** | Maximum transactions to process in each cycle. The default is 10000. |
| `seqno` | **binary(10)** | Log Sequence Number (LSN) marker to track the last published LSN (log record). |
| `schema_version` | **int** | Tracks current schema version of database. Determines whether a schema needs to be updated or not on startup. |
| `pollinterval` | **int** | The frequency that the log is scanned for any new changes in seconds. |
| `reseed_state` | **tinyint** | **Applies to:** Fabric Mirrored Database only.<br /><br />`0` = Normal.<br /><br />`1` = The database has started the process of reinitializing to Fabric. Transitionary state.<br /><br />`2` = The database is being reinitialized to Fabric and remains in this state until complete. |
| `destination_type` | **sysname** | Change event streaming destination type.<br /><br />`AzureEventHubsAmqp`<br />`AzureEventHubsKafka`<br /><br />Introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] |
| `partition_scheme` | **tinyint** | Change event streaming partition scheme.<br /><br />`0` = None<br />`1` = Table group.<br />`2` = Table<br />`3` = Column<br /><br />Introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] |
| `encoding` | **tinyint** | Change event streaming message encoding.<br /><br />`0` = JSON<br />`1` = Avro Binary<br /><br />Introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] |

## Permissions

A user with [CONTROL database permissions](../security/permissions-database-engine.md), **db_owner** database role membership, or **sysadmin** server role membership can execute this procedure.

## Remarks

If Fabric Mirroring, the source SQL database transaction log is monitored. If the transaction log is observed to be full and the log reuse reason is `REPLICATION`, the database will automatically be reinitialized to Fabric to allow the transaction log to be truncated. During this special reseed state, a database snapshot is sent to Fabric again, then incremental replication resumes. The `reseed_state` column in `sys.sp_help_change_feed_settings` indicates the reseed state.

## Related content

- [sys.sp_help_change_feed (Transact-SQL)](sp-help-change-feed.md)
- [sys.sp_help_change_feed_table (Transact-SQL)](sp-help-change-feed-table.md)
- [sys.sp_help_change_feed_table_groups (Transact-SQL)](sp-help-change-feed-table-groups.md)
- [sys.sp_change_feed_configure_parameters (Transact-SQL)](sp-change-feed-configure-parameters.md)
- [sys.dm_change_feed_log_scan_sessions (Transact-SQL)](../system-dynamic-management-views/sys-dm-change-feed-log-scan-sessions.md)
- [sys.dm_change_feed_errors (Transact-SQL)](../system-dynamic-management-views/sys-dm-change-feed-errors.md)
