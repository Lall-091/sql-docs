---
title: Configure change event streaming
description: "Describes how to configure change event streaming."
author: sasapopo
ms.author: sasapopo
ms.reviewer: mathoma, mikeray
ms.date: 06/19/2025
ms.service: sql
ms.topic: how-to
monikerRange: " = sql-server-ver17 || = sql-server-linux-ver17 "
ms.custom:
  - build-2025
---

# Configure change event streaming

[!INCLUDE [sqlserver2025](../../../includes/applies-to-version/sqlserver2025.md)]

This article describes how to configure [change event streaming (CES)](overview.md) feature introduced in [!INCLUDE [sssql25-md](../../../includes/sssql25-md.md)].

> [!NOTE]
> Change event streaming is currently in **preview** for SQL Server 2025. 

## Overview

To configure and use change event streaming, follow this sequence of steps:

1. Use an existing or create a new [Azure Event Hubs](/azure/event-hubs/event-hubs-about) namespace and Event Hubs instance. Event Hubs instance receives events.
1. Enable change event streaming for a user database.
1. Create an event stream group. With this group, configure the destination, credentials, message size limits, and partitioning schema.
1. Add one or more tables to the event stream group.

Each step is described in detail in the following sections of this article.

## Prerequisites

To configure change event streaming, you need the following:

- Azure Event Hubs namespace
- Azure Event Hubs instance
- Azure Event Hubs host name
- Policy with **Send** access level
- A login in the [db_owner](../../security/authentication-access/database-level-roles.md#fixed-database-roles) role or that has [CONTROL DATABASE](../../security/permissions-database-engine.md#permissions-database-engine) permission for the database where you intend to enable CES.

## Configure Azure Event Hubs

To learn how to create Azure Event Hubs, review [Create an event hub using the Azure portal](/azure/event-hubs/event-hubs-create).

To configure streaming to Azure Event Hubs with AMQP protocol (default, native Azure Event Hubs protocol), generate a SAS token for your Azure Event Hubs namespace and instance name. You can do that programmatically with any programming or scripting language. The example in this article demonstrates how to generate a SAS token from a new or existing policy by using a PowerShell script.

### Install required modules

To manage Azure Event Hubs resources with PowerShell scripts, you need to have the following modules:

- Az PowerShell module
- Az.EventHub PowerShell module

The following script installs the required modules: 

```powershell
Install-Module -Name Az -AllowClobber -Scope CurrentUser -Repository PSGallery -Force
Install-Module -Name Az.EventHub -Scope CurrentUser -Force
```

If you already have the required modules, and want to update them to the latest version, run the following script: 

```powershell
Update-Module -Name Az -Force
Update-Module -Name Az.EventHub -Force
```

### Connect to Azure

You can either use Azure Cloud Shell or login and set your subscription context.

To run with Azure Cloud Shell, review [Sign in to Azure](/powershell/azure/get-started-azureps#sign-in-to-azure).

### Define a policy

To create the SAS token, you need a policy. You can either:

- Create a new policy with the specific rights.

  Or

- Use an existing policy with the correct rights.

#### Create SAS token for a new or existing policy

> [!NOTE]
> For improved security, SAS token authentication is strongly recommended over key-based authentication whenever possible. Best practices for SAS tokens include: define an appropriate access scope, set an expiration date, and rotate the SAS key regularly. For key-based authentication, ensure keys are rotated periodically. Store all secrets securely using Azure Key Vault or a similar service.

When creating a new policy, ensure it has the **Send** right. If you use an existing policy, verify that it has the **Send** right.

The following script will create a new policy, or get an existing one, and then generates from it a full SAS token in an HTTP authorization header format.

Replace values in angle brackets (`<value>`) with values for your environment.

```powershell
function Generate-SasToken {
$subscriptionId = "<Azure-Subscription-ID>"
$resourceGroupName = "<Resource-group-name>"
$namespaceName = "<Azure-Event-Hub-Namespace-name>"
$eventHubName = "<Azure-Event-Hubs-instance-name>"
$policyName = "<Policy-name>"

# Modifying the rest of the script is not necessary.

# Login to Azure and set Azure Subscription.
Connect-AzAccount

# Get current context and check subscription
$currentContext = Get-AzContext
if ($currentContext.Subscription.Id -ne $subscriptionId) {
    Write-Host "Current subscription is $($currentContext.Subscription.Id), switching to $subscriptionId..."
    Set-AzContext -SubscriptionId $subscriptionId | Out-Null
} else {
    Write-Host "Already using subscription $subscriptionId."
}

# Try to get the authorization policy (it should have Send rights)
$rights = @("Send")
$policy = Get-AzEventHubAuthorizationRule -ResourceGroupName $resourceGroupName -NamespaceName $namespaceName -EventHubName $eventHubName -AuthorizationRuleName $policyName -ErrorAction SilentlyContinue

# If the policy does not exist, create it
if (-not $policy) {
    Write-Output "Policy '$policyName' does not exist. Creating it now..."

    # Create a new policy with the Manage, Send and Listen rights
    $policy = New-AzEventHubAuthorizationRule -ResourceGroupName $resourceGroupName -NamespaceName $namespaceName -EventHubName $eventHubName -AuthorizationRuleName $policyName -Rights $rights
    if (-not $policy) {
        throw "Error. Policy was not created."
    }
    Write-Output "Policy '$policyName' created successfully."
} else {
    Write-Output "Policy '$policyName' already exists."
}

if ("Send" -in $policy.Rights) {
    Write-Host "Authorization rule has required right: Send."
} else {
    throw "Authorization rule is missing Send right."
}

$keys = Get-AzEventHubKey -ResourceGroupName $resourceGroupName -NamespaceName $namespaceName -EventHubName $eventHubName -AuthorizationRuleName $policyName

if (-not $keys) {
    throw "Could not obtain Azure Event Hub Key. Script failed and will end now."
}
if (-not $keys.PrimaryKey) {
    throw "Could not obtain Primary Key. Script failed and will end now."
}

# Get the Primary Key of the Shared Access Policy
$primaryKey = ($keys.PrimaryKey) 
Write-Host $primaryKey

## Check that the primary key is not empty.

# Define a function to create a SAS token (similar to the C# code provided)
function Create-SasToken {
    param (
        [string]$resourceUri, [string]$keyName, [string]$key
    )

$sinceEpoch = [datetime]::UtcNow - [datetime]"1970-01-01"
    $expiry = [int]$sinceEpoch.TotalSeconds + (60 * 60 * 24 * 31 * 6)  # 6 months
    $stringToSign = [System.Web.HttpUtility]::UrlEncode($resourceUri) + "`n" + $expiry
    $hmac = New-Object System.Security.Cryptography.HMACSHA256
    $hmac.Key = [Text.Encoding]::UTF8.GetBytes($key)
    $signature = [Convert]::ToBase64String($hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($stringToSign)))
    $sasToken = "SharedAccessSignature sr=$([System.Web.HttpUtility]::UrlEncode($resourceUri))&sig=$([System.Web.HttpUtility]::UrlEncode($signature))&se=$expiry&skn=$keyName"
    return $sasToken
}

# Construct the resource URI for the SAS token
$resourceUri = "https://$namespaceName.servicebus.windows.net/$eventHubName"

# Generate the SAS token using the primary key from the new policy
$sasToken = Create-SasToken -resourceUri $resourceUri -keyName $policyName -key $primaryKey

# Output the SAS token
Write-Output @"
-- Generated SAS Token --
$sasToken
-- End of generated SAS Token --
"@
}

Generate-SasToken
```

## Enable and configure change event streaming

To enable and configure change event streaming, change the database context to the user database and then follow these steps: 

1. If it's not already configured, set the database to the [full recovery model](../../backup-restore/recovery-models-sql-server.md#recovery-model-overview).
1. Create a master key and a database scoped credential.
1. Enable event streaming.
1. Create the event stream group.
1. Add one or more tables to the event stream group.

The examples in this section demonstrate how to enable CES for the AMQP protocol and the Apache Kafka protocol.

The following are sample parameter values for the examples in this section:

- `@stream_group_name = N'myStreamGroup'`
- `@destination_location = N'myEventHubsNamespace.servicebus.windows.net/myEventHubsInstance'`
- `@partition_key_scheme =   N'None'`
- Primary or secondary key value: `Secret = 'BVFnT3baC/K6I8xNZzio4AeoFt6nHeK0i+ZErNGsxiw='`
- `EXEC sys.sp_add_object_to_event_stream_group N'myStreamGroup', N'dbo.myTable'`

### Example: Stream to Azure Event Hubs via AMQP protocol (SAS token auth)

Replace values in angle brackets (`<value>`) with values for your environment. 

```sql
USE <database name>

-- Create the Master Key with a password.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<Password>'

CREATE DATABASE SCOPED CREDENTIAL <CredentialName>
    WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
    SECRET = '<Generated SAS Token>'

EXEC sys.sp_enable_event_stream

EXEC sys.sp_create_event_stream_group
    @stream_group_name =      N'<EventStreamGroupName>',
    @destination_type =       N'AzureEventHubsAmqp',
    @destination_location =   N'<AzureEventHubsHostName>/<EventHubsInstance>',
    @destination_credential = <CredentialName>,
    @max_message_size_kb =    <MaxMessageSize>, 
    @partition_key_scheme =   N'<PartitionKeyScheme>'

EXEC sys.sp_add_object_to_event_stream_group
    N'<EventStreamGroupName>',
    N'<SchemaName>.<TableName>'
```

### Example: Stream to Azure Event Hubs via AMQP protocol (Key value auth)

Replace values in angle brackets (`<value>`) with values for your environment.

```sql
USE <database name>

-- Create the Master Key with a password.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<Password>'

CREATE DATABASE SCOPED CREDENTIAL <CredentialName>
    WITH IDENTITY = '<Azure Event Hubs SAS Policy name>',
    SECRET = '<Primary or Secondary key value>'

EXEC sys.sp_enable_event_stream

EXEC sys.sp_create_event_stream_group
    @stream_group_name =      N'<EventStreamGroupName>',
    @destination_type =       N'AzureEventHubsAmqp',
    @destination_location =   N'<AzureEventHubsHostName>/<EventHubsInstance>',
    @destination_credential = <CredentialName>,
    @max_message_size_kb =    <MaxMessageSize>,
    @partition_key_scheme =   N'<PatitionKeyScheme>'

EXEC sys.sp_add_object_to_event_stream_group
    N'<EventStreamGroupName>',
    N'<SchemaName>.<TableName>'
```

### Example: Stream to Azure Event Hubs via Apache Kafka protocol (Connection string auth)

Replace values in angle brackets (`<value>`) with values for your environment. 

```sql
USE <database name>

-- Create the Master Key with a password.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<Password>'

CREATE DATABASE SCOPED CREDENTIAL credential1
    WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
    SECRET = '<Event Hubs Namespace – Primary or Secondary connection string>'

EXEC sys.sp_enable_event_stream

EXEC sys.sp_create_event_stream_group
    @stream_group_name =      N'<EventStreamGroupName>',
    @destination_type =       N'AzureEventHubsApacheKafka',
    @destination_location =   N'<AzureEventHubsHostName>:<port>/<EventHubsInstance>',
    @destination_credential = <CredentialName>,
    @max_message_size_kb =    <MaxMessageSize>,
    @partition_key_scheme =   N'<PatitionKeyScheme>'

EXEC sys.sp_add_object_to_event_stream_group
    N'<EventStreamGroupName>',
    N'<SchemaName>.<TableName>'
```

### Example: Stream to Azure Event Hubs via Apache Kafka protocol (Key value auth)

Replace values in angle brackets (`<value>`) with values for your environment.

```sql
USE <database name>

-- Create the Master Key with a password.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<Password>'

CREATE DATABASE SCOPED CREDENTIAL credential1
    WITH IDENTITY = '<Azure Event Hubs SAS Policy name>',
    SECRET = '<Primary or Secondary key value>' -- BVFnT3baC/K6I8xNZzio4AeoFt6nHeK0i+ZErNGsxiw=

EXEC sys.sp_enable_event_stream

EXEC sys.sp_create_event_stream_group
    @stream_group_name =      N'<EventStreamGroupName>',  -- myStreamGroup
    @destination_type =       N'AzureEventHubsApacheKafka',
    @destination_location =   N'<AzureEventHubsHostName>:<port>/<EventHubsInstance>', -- myEventHubsNamespace.servicebus.windows.net:9093/myEventHubsInstance
    @destination_credential = <CredentialName>,
    @max_message_size_kb =    <MaxMessageSize>,       -- 1024
    @partition_key_scheme =   N'<PatitionKeyScheme>'  -- N'None'

EXEC sys.sp_add_object_to_event_stream_group
    N'<EventStreamGroupName>',
    N'<SchemaName>.<TableName>' -- dbo.myTable
```

## View CES configuration and function

In [sys.databases](../../system-catalog-views/sys-databases-transact-sql.md),  `is_event_stream_enabled = 1` indicates that change event streaming is enabled for the database. 

The following query returns all databases with change event streaming enabled: 

```sql
SELECT * FROM sys.databases WHERE is_event_stream_enabled = 1
```

In [sys.tables](../../system-catalog-views/sys-tables-transact-sql.md), `is_replicated = 1` indicates a table is streamed, and [sp_help_change_feed_table](../../system-stored-procedures/sp-help-change-feed-table.md) provides information about the table group and table metadata for change event streaming.

The following query returns all tables with change event streaming enabled, and provides metadata information: 

```sql
SELECT name, is_replicated FROM sys.tables

EXEC sp_help_change_feed_table @source_schema = '<schema name>', @source_name = '<table name>'
```

> [!NOTE]
> Currently, CES isn't supported on database that configured with change data capture (CDC), transactional replication, or [Fabric Mirrored Databases for SQL Server](/fabric/database/mirrored-database/sql-server).

## CES stored procedures, system functions, and DMVs

The following table lists the stored procedures, system functions, and DMVs that are used to configure, disable and monitor change event streaming: 

| System object | Description |
|-----------------|------------|
|<center>**Configure CES**</center>|
|[sys.sp_enable_event_stream](../../system-stored-procedures/sys-sp-enable-event-stream-transact-sql.md) | Enables CES for the current user database.| 
|[sys.sp_create_event_stream_group](../../system-stored-procedures/sys-sp-create-event-stream-group-transact-sql.md) | Creates a stream group, which is a streaming configuration for a group of tables. The stream group also defines the destination and related details (such as authentication, message size, partitioning). The stream_group_id is automatically generated and displayed for the end user when the procedure completes.|
|[sys.sp_add_object_to_event_stream_group](../../system-stored-procedures/sys-sp-add-object-to-event-stream-group-transact-sql.md) | Adds a table to the stream group.|
|<center>**Disable CES**</center>|
|[sys.sp_remove_object_from_event_stream_group](../../system-stored-procedures/sys-sp-remove-object-from-event-stream-group-transact-sql.md) | Removes a table from the stream group.|
|[sys.sp_drop_event_stream_group](../../system-stored-procedures/sys-sp-drop-event-stream-group-transact-sql.md) | Drops the stream group. The stream group must not be in use.|
|[sys.sp_disable_event_stream](../../system-stored-procedures/sys-sp-disable-event-stream-transact-sql.md) | Disables CES for the current user database.|  
|<center>**Monitor CES**</center>| 
|[sys.dm_change_feed_errors](../../system-dynamic-management-views/sys-dm-change-feed-errors.md) | Returns delivery errors. | 
|[sys.dm_change_feed_log_scan_sessions](../../system-dynamic-management-views/sys-dm-change-feed-log-scan-sessions.md)  | Returns information about log scan activity. |
|[sys.sp_help_change_feed_settings](../../system-stored-procedures/sp-help-change-feed-settings.md) |  Provides the status and information of configured change event streaming.|
|[sys.sp_help_change_feed](../../system-stored-procedures/sp-help-change-feed.md) | Monitors the current configuration of the change stream.| 
|[sys.sp_help_change_feed_table_groups](../../system-stored-procedures/sp-help-change-feed-table-groups.md) | Returns metadata that is used to configure change event streaming groups.| 
|[sys.sp_help_change_feed_table](../../system-stored-procedures/sp-help-change-feed-table.md) | Provides the status and information of the streaming group and table metadata for change event streaming. | 

## Limitations

Change event streaming (CES) has the following limitations:

### Server-level and general limitations

- CES isn't supported on SQL Server 2025 on Linux or SQL Server 2025 Express edition.
- CES emits events only for data changes from `INSERT`, `UPDATE`, and `DELETE` DML statements.
- CES doesn't handle schema changes (DDL operations), which means it won't emit events for DDL operations. However, DDL operations aren't blocked, so if executed, the schema of subsequent DML events reflect the updated table structure. Users are expected to gracefully handle events with the updated schema.
- When JSON is the specified output format, large event messages might be split at approximately 25% of the configured maximum message size per stream group. This limitation doesn't apply to the binary output type.
- If a message exceeds the Azure Event Hubs message size limit, the failure is currently only observable via Extended Events.
- Table and column renames are blocked for tables configured for CES. Database renames are allowed.

### Database-level limitations

- CES is only supported on databases configured with the full recovery model. 
- CES isn't supported on databases configured with [Fabric Mirrored Databases for SQL Server](/fabric/database/mirrored-database/sql-server), [transactional replication](../../replication/transactional/transactional-replication.md), [change data capture](../about-change-data-capture-sql-server.md), or [Azure Synapse Link](/azure/synapse-analytics/synapse-link/sql-synapse-link-overview). [Change tracking](../about-change-tracking-sql-server.md) is supported on databases configured with CES.
- CES can only stream from writable primary databases. Secondary databases that are part of Always On availability groups or that use the [Managed Instance Link](/azure/azure-sql/managed-instance/managed-instance-link-feature-overview) can't be configured as streaming sources.
- CES can't be enabled on views or materialized views.

### Table-level limitations

- A table can belong to only one streaming group. Streaming the same table to multiple destinations isn't supported.
- Only user tables can be configured for CES. System tables aren't supported.
- You can configure up to 4,096 stream groups. Each stream group can include up to 40,000 tables.
- While CES is enabled on a table, primary key constraint can't be added to, or dropped from, that table.
- `ALTER TABLE SWITCH PARTITION` isn't supported on tables configured for CES.
- `TRUNCATE TABLE` isn't supported on tables enabled for CES.
- CES doesn't support tables that use any of the following features:
  - Clustered columnstore indexes
  - Temporal history tables or ledger history tables
  - Always Encrypted
  - In-memory OLTP (memory-optimized tables)
  - Graph tables
  - External tables

### Column-level limitations

- The following data types aren't supported by CES. Columns of these types are skipped by streaming:
  - `json`
  - `image`
  - `text` / `ntext`
  - `xml`
  - `rowversion` / `timestamp`
  - `sql_variant`
  - User-defined types (UDT)
  - `geometry`
  - `geography`
  - `vector`

### Permissions in the source database

- For row-level security, CES emits changes from all rows, regardless of user permissions.
- Dynamic data masking doesn't apply to data sent via CES. Data is streamed unmasked, even if masking is configured.
- CES doesn't emit events related to object-level permission changes (for example, granting permissions to specific columns).

## Related content

- [What is change event streaming?](overview.md)
- [Frequently asked questions](frequently-asked-questions-faq.yml)
- [Message format](message-format.md)
