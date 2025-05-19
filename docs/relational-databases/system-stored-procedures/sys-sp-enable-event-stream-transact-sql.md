---
title: "sys.sp_enable_event_stream (Transact-SQL)"
description: "Enables change event streaming, a feature introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] by using Transact-SQL (T-SQL)."
author: sasapopo
ms.author: sasapopo
ms.reviewer: mathoma, mikeray
ms.date: 05/19/2025
ms.service: sql
ms.subservice: system-objects
ms.topic: "reference"
f1_keywords:
  - "sys_sp_enable_event_stream_TSQL"
  - "sys_sp_enable_event_stream"
helpviewer_keywords:
  - "sys_sp_enable_event_stream"
dev_langs:
  - "TSQL"
monikerRange: " = sql-server-ver17 || = sql-server-linux-ver17 "

---
# sys.sp_enable_event_stream (Transact-SQL)

[!INCLUDE [sqlserver2025](../../includes/applies-to-version/sqlserver2025.md)]

Enables change event streaming at the database level for the current database context. [Change event streaming (CES)](../track-changes/change-event-streaming/overview.md) was introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)]. 

> [!NOTE]
> Change event streaming is currently in **preview** for SQL Server 2025. 

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

## Syntax

```syntaxsql
sp_enable_event_stream
```

## Return code values

`0` (success) or `1` (failure).

## Permissions

A user with [CONTROL database permissions](../security/permissions-database-engine.md), **db_owner** database role membership, or **sysadmin** server role membership can execute this procedure.

## Related content

- [What is change event streaming?](../track-changes/change-event-streaming/overview.md)
- [Configure change event streaming](../track-changes/change-event-streaming/configure.md)