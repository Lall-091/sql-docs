---
title: "sys.sp_create_event_group_stream (Transact-SQL)"
description: "Creates an event stream group for the change event streaming feature introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] by using Transact-SQL (T-SQL)."
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
  - "sys_sp_create_event_group_stream_TSQL"
  - "sys_sp_create_event_group_stream"
helpviewer_keywords:
  - "sys_sp_create_event_group_stream"
dev_langs:
  - "TSQL"
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17"
---
# sys.sp_create_event_group_stream (Transact-SQL)
[!INCLUDE [sqlserver2025](../../includes/applies-to-version/sqlserver2025-asdb.md)]

Creates an event group stream for the [change event streaming (CES)](../track-changes/change-event-streaming/overview.md) feature introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)].

[!INCLUDE [change-event-streaming-preview](../../includes/change-event-streaming-preview.md)]

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

## Syntax

```syntaxsql
sp_create_event_stream_group
    [ @stream_group_name = ] N'stream_group_name'
    , [ @destination_type = ] N'destination_type'
    , [ @destination_location = ] N'destination_location'
    [ , [ @destination_credential = ] N'destination_credential' ]
    [ , [ @max_message_size_kb = ] max_message_size_kb ]
    [ , [ @partition_key_scheme = ] N'partition_key_scheme' ]
    [ , [ @partition_key_column_name = ] N'partition_key_column_name' ]
    [ , [ @encoding = ] N'encoding' ]
```

## Arguments

### [ @stream_group_name = ] N'*stream_group_name*'

Specifies the name of the event stream group you want to create. *@stream_group_name* is **sysname**, and can't be `NULL`.

### [ @destination_type = ] N'*destination_type*'

Specifies the streaming destination type. *@destination_type* is **sysname**, and can't be `NULL`. Can be one of the following values:
`AzureEventHubsAmqp` or `AzureEventHubsApacheKafka`

### [ @destination_location = ] N'*destination_location*'

Describes the Azure Event Hubs namespace and instance name. *@destination_location* is **nvarchar(4000)**, and can't be `NULL`.

For the Apache Kafka protocol, specify the port.

### [ @destination_credential = ] N'*destination_credential*'

Specifies database scoped credential name to be used. *@destination_credential* is **sysname**, and can't be `NULL`.

### [ @max_message_size_kb = ] max_message_size_kb

If specified, defines the max CES message size in kilobyes. *@max_message_size_kb* is **int**, and can't be `NULL`. The message is split if it exceeds the specified max size. This parameter is optional.

*@max_message_size_kb* has the following characteristics:

- Default value: `256` (corresponds to 256 KB)
- Minimum allowed value: `128` (corresponds to 128 KB)
- Maximum allowed value: `1024` (corresponds to 1 MB)

The *@max_message_size_kb* parameter should align to the limits of the destination. For example, the maximum message size for Azure Event Hubs is 1 MB for the Standard and Premium tiers. To learn more, review [Azure Event Hubs quotas](/azure/event-hubs/event-hubs-quotas#basic-vs-standard-vs-premium-vs-dedicated-tiers).

### [ @partition_key_scheme = ] N'*partition_key_scheme*'

Defines the type of partitioning. *@partition_key_scheme* is **sysname**, and can't be `NULL`.

*@partition_key_scheme* can be one of the following values:

| Value | Description |
| --- | --- |
| `None` (default) | Partitioning isn't specified, so events are assigned to partitions by the [event hub using a round-robin strategy](/azure/event-hubs/event-hubs-features#mapping-of-events-to-partitions). |
| `StreamGroup` | Partitioning is done by stream group so that all tables in the stream group are streamed to the same partition. |
| `Table` | Partitioning is done by table so that each table in the stream group is streamed to a different partition. |
| `Column` | Partitioning is done by column so that each column in the stream group is streamed to a different partition. |

### [ @partition_key_column_name = ] N'*partition_key_column_name*'

Defines which column to use for partitioning when *@partition_key_scheme* is set to `Column`. *@partition_key_column_name* is **sysname**, and can't be `NULL`.

Use a two-part name for the column that includes both the schema name and column name. For example, a valid value is `dbo.Addresses`.

### [ @encoding = ] N'*encoding*'

Specifies the message encoding. *@encoding* is **sysname**, and can't be `NULL`. Can be one of the following values:

- `JSON` (default)
- `Binary`

## Return code values

`0` (success) or `1` (failure).

## Permissions

A user with [CONTROL database permissions](../security/permissions-database-engine.md), **db_owner** database role membership, or **sysadmin** server role membership can execute this procedure.

## Examples

### A. Create event stream group that streams into Azure Event Hubs with AMQP protocol

```sql
EXECUTE sys.sp_create_event_stream_group
    @stream_group_name = N'myStreamGroup',
    @destination_type = N'AzureEventHubsAmqp',
    @destination_location = N'myEventHubsNamespace.servicebus.windows.net/myEventHubsInstance',
    @destination_credential = MyDatabaseScopedCredentialForCes;
```

### B. Create event stream group that streams into Azure Event Hubs with Kafka protocol

```sql
EXECUTE sys.sp_create_event_stream_group
    @stream_group_name = N'myStreamGroup',
    @destination_type = N'AzureEventHubsAmqp',
    @destination_location = N'myEventHubsNamespace.servicebus.windows.net:9093/myEventHubsInstance',
    @destination_credential = MyDatabaseScopedCredentialForCes;
```

## Related content

- [What is change event streaming?](../track-changes/change-event-streaming/overview.md)
- [Configure change event streaming](../track-changes/change-event-streaming/configure.md)
