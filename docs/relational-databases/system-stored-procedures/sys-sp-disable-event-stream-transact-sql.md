---
title: "sys.sp_disable_event_stream (Transact-SQL)"
description: "Disables change event streaming at the database level for the change event streaming feature introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] by using Transact-SQL (T-SQL)."
author: nzagorac-ms
ms.author: nzagorac
ms.reviewer: mathoma, mikeray, randolphwest
ms.date: 11/18/2025
ms.service: sql
ms.subservice: system-objects
ms.topic: "reference"
ms.custom:
  - ignite-2025
f1_keywords:
  - "sys_sp_disable_event_stream_TSQL"
  - "sys_sp_disable_event_stream"
helpviewer_keywords:
  - "sys_sp_disable_event_stream"
dev_langs:
  - "TSQL"
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17"
---
# sys.sp_disable_event_stream (Transact-SQL)
[!INCLUDE [sqlserver2025](../../includes/applies-to-version/sqlserver2025-asdb.md)]

Disables change event streaming at the database level for the current database context, including all associated tables. [Change event streaming (CES)](../track-changes/change-event-streaming/overview.md) was introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] and Azure SQL Database.

[!INCLUDE [change-event-streaming-preview](../../includes/change-event-streaming-preview.md)]

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

## Syntax

```syntaxsql
sp_disable_event_stream
```

## Permissions

A user with [CONTROL database permissions](../security/permissions-database-engine.md), **db_owner** database role membership, or **sysadmin** server role membership can execute this procedure.

## Related content

- [What is change event streaming?](../track-changes/change-event-streaming/overview.md)
- [Configure change event streaming](../track-changes/change-event-streaming/configure.md)
