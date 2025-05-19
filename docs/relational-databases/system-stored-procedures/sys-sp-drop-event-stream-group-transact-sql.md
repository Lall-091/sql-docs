---
title: "sys.sp_drop_event_stream_group (Transact-SQL)"
description: "Drops an event stream group for the change event streaming feature introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] by using Transact-SQL (T-SQL)."
author: sasapopo
ms.author: sasapopo
ms.reviewer: mathoma, mikeray
ms.date: 05/19/2025
ms.service: sql
ms.subservice: system-objects
ms.topic: "reference"
f1_keywords:
  - "sys_sp_drop_event_stream_group_TSQL"
  - "sys_sp_drop_event_stream_group"
helpviewer_keywords:
  - "sys_sp_drop_event_stream_group"
dev_langs:
  - "TSQL"
monikerRange: " = sql-server-ver17 || = sql-server-linux-ver17 "

---
# sys.sp_drop_event_stream_group (Transact-SQL)

[!INCLUDE [sqlserver2025](../../includes/applies-to-version/sqlserver2025.md)]

Drops a stream event group for the [change event streaming (CES)](../track-changes/change-event-streaming/overview.md) feature introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)]. 

> [!NOTE]
> Change event streaming is currently in **preview** for SQL Server 2025. 

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

## Syntax

```syntaxsql
sys.sp_drop_event_stream_group
[ @stream_group_name = ] N'stream_group_name'
```

## Arguments

### [ @stream_group_name = ] N'stream_group_name' 

Specifies the name of the event stream group you want to drop. *@stream_group_name* is **sysname**, and can't be `NULL`.

## Permissions

A user with [CONTROL database permissions](../security/permissions-database-engine.md), **db_owner** database role membership, or **sysadmin** server role membership can execute this procedure.

## Related content

- [What is change event streaming?](../track-changes/change-event-streaming/overview.md)
- [Configure change event streaming](../track-changes/change-event-streaming/configure.md)