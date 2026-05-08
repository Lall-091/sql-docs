---
title: "Server Properties (Connections page)"
description: Get acquainted with connection settings in SQL Server. Learn about options that determine deferred constraint checking, NULL handling, and other behavior.
author: rwestMSFT
ms.author: randolphwest
ms.date: 08/26/2025
ms.service: sql
ms.subservice: configuration
ms.topic: concept-article
f1_keywords:
  - "sql13.swb.serverproperties.connections.f1"
---
# Server Properties (Connections page)

[!INCLUDE [SQL Server](../../includes/applies-to-version/sqlserver.md)]

Use this page to view or modify your connection options.

## Connections

#### Maximum number of concurrent connections (0 = unlimited)

If set to a value other than zero, limits the number of connections that [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] will allow.

> [!CAUTION]  
> Setting this to a small value, such as 1 or 2, can prevent administrators from connecting to administer the server; however, the Dedicated Admin Connection can always connect.

## Default Connection Options

#### Default connection options

Specifies the default connection options, as described in the following table.

| Configuration option | Description |
| --- | --- |
| `disable deferred constraint checking` | Controls interim or deferred constraint checking. |
| `implicit transactions` | Controls whether a transaction is started implicitly when a statement is run. |
| `cursor close on commit` | Controls behavior of cursors after a commit operation has been performed. |
| `ansi warnings` | Controls truncation and `NULL` in aggregate warnings. |
| `ansi padding` | Controls padding of fixed-length variables. |
| `ansi nulls` | Controls `NULL` handling when using equality operators. |
| `arithmetic abort` | Terminates a query when an overflow or divide-by-zero error occurs during query execution. |
| `arithmetic ignore` | Returns `NULL` when an overflow or divide-by-zero error occurs during a query. |
| `quoted identifier` | Differentiates between single and double quotation marks when evaluating an expression. |
| `no count` | Turns off the message returned at the end of each statement that states how many rows were affected. |
| `ansi null default on` | Alters the session's behavior to use ANSI compatibility for nullability. New columns defined without explicit nullability are defined to allow nulls. |
| `ansi null default off` | Alters the session's behavior not to use ANSI compatibility for nullability. New columns defined without explicit nullability are defined not to allow nulls. |
| `concat null yields null` | Returns `NULL` when concatenating a `NULL` value with a string. |
| `numeric round abort` | Generates an error when a loss of precision occurs in an expression. |
| `xact abort` | Rolls back a transaction if a Transact-SQL statement raises a run-time error. |

For more information on connection options, search Books Online for the specific option.

## Remote server connections

#### Allow remote connections to this server

Controls the execution of stored procedures from remote servers running instances of [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)]. Selecting this check box has the same effect as setting the **sp_configureremote access** option to 1. Clearing it prevents execution of stored procedures from a remote server.

#### Remote query timeout (in seconds, 0 = no timeout)

Specifies how long (in seconds) a remote operation might take before [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] times out. The default is 600 seconds, or a 10-minute wait.

#### Require distributed transactions for server-to-server communication

Protects the actions of a server-to-server procedure through a [!INCLUDE [msCoName](../../includes/msconame-md.md)] Distributed Transaction Coordinator (MS DTC) transaction. For more information, see [Server configuration: remote proc trans](configure-the-remote-proc-trans-server-configuration-option.md).

## Property Page Display options

#### Configured Values

Displays the configured values for the options on this pane. If you change these values, select **Running Values** to see whether the changes have taken effect. If they haven't, the instance of [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] must be restarted first.

#### Running Values

View the currently running values for the options on this pane. These values are read-only.

## Related content

- [Options (Query Execution: SQL Server: Advanced Page)](/ssms/f1-help/database-engine-query-editor-sql-server-management-studio)
- [Server configuration options](server-configuration-options-sql-server.md)
