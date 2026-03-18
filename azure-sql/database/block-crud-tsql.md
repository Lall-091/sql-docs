---
title: Block T-SQL Commands To Create Or Modify Azure SQL Resources
description: This article details features allowing Azure administrators to block T-SQL commands to create or modify Azure SQL Database and Azure SQL Managed Instance resources.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: wiassaf, mathoma
ms.date: 03/10/2026
ms.service: azure-sql
ms.subservice: security
ms.topic: how-to
ROBOTS: NOINDEX
monikerRange: "=azuresql || =azuresql-db "
ms.custom: sfi-image-nochange
---

# What is Block T-SQL CRUD?

[!INCLUDE[appliesto-sqldb-sqlmi](../includes/appliesto-sqldb-sqlmi.md)]

The Block T-SQL CRUD features allow Azure administrators to block the creation or modification of Azure SQL resources through T-SQL. Two separate subscription-level preview feature flags are available:

| Preview feature flag | Scope |
| --- | --- |
| **Block T-SQL CRUD for logical servers** (`block-tsql-crud`) | Azure SQL Database (logical server) |
| **Block T-SQL CRUD for managed instances** (`block-tsql-mi-crud`) | Azure SQL Managed Instance |

Each flag is registered independently per subscription. You can enable one or both depending on which Azure SQL services you need to govern.

## Overview

To block creation or modification of resources through T-SQL and enforce resource management through an Azure Resource Manager template (ARM template) for a given subscription, the subscription-level preview features in the Azure portal can be used. This is particularly useful when you are using [Azure Policies](/azure/governance/policy/overview) to enforce organizational standards through ARM templates. Since T-SQL does not adhere to Azure Policies, a block on T-SQL create or modify operations can be applied.

T-SQL CRUD operations can be blocked via the Azure portal, [PowerShell](/powershell/module/az.resources/register-azproviderfeature), or [Azure CLI](/cli/azure/feature#az-feature-register).

## Blocked statements for Azure SQL Database

When the **Block T-SQL CRUD for logical servers** (`block-tsql-crud`) preview feature is registered, the following T-SQL statements are blocked for Azure SQL Database resources:

1. `CREATE DATABASE`
1. `DROP DATABASE`
1. `CREATE DATABASE ... AS COPY OF`
1. `ALTER DATABASE` (edition, service objective, max size, etc.)
1. `ALTER DATABASE ... ADD SECONDARY ON SERVER`
1. `ALTER DATABASE ... REMOVE SECONDARY ON SERVER`
1. `ALTER DATABASE ... FAILOVER`

## Blocked statements for Azure SQL Managed Instance

When the **Block T-SQL CRUD for managed instances** (`block-tsql-mi-crud`) preview feature is registered, the following T-SQL statements are blocked for Azure SQL Managed Instance resources:

1. `CREATE DATABASE`
1. `DROP DATABASE`
1. Cancel in-progress `CREATE DATABASE`
1. `RESTORE DATABASE ... FROM URL`
1. `ALTER DATABASE ... ADD FILE`
1. `ALTER DATABASE ... MODIFY FILE`
1. `ALTER DATABASE ... REMOVE FILE` (on geo-replicated file)
1. `ALTER DATABASE tempdb ADD FILE`
1. `ALTER DATABASE tempdb MODIFY FILE`
1. `ALTER DATABASE tempdb REMOVE FILE`
1. `ALTER DATABASE ... SET` (compatibility level, collation, etc.)
1. `ALTER DATABASE ... SET ENCRYPTION ON/OFF`
1. `ALTER AVAILABILITY GROUP ... FAILOVER` (MI Link / Failover Group)
1. Failover stored procedure configuration
1. `DBCC TRACEON` / `DBCC TRACEOFF` (global trace flags)
1. `sp_configure` (SQL Agent enable/disable)
1. `sp_configure` / MSDTC transition to primary
1. MSDTC network settings (XA, LU, inbound/outbound)
1. Vulnerability Assessment scan trigger via T-SQL

## Permissions

In order to register or remove either feature, the Azure user must be a member of the Owner or Contributor role of the subscription.

## Examples

The following section describes how you can register or unregister a preview feature with the Microsoft.Sql resource provider in the Azure portal.

### Register a Block T-SQL CRUD feature

1. Go to your subscription in the Azure portal.
1. Select the **Preview Features** tab.
1. Select the feature flag you want to enable:
   - **Block T-SQL CRUD for logical servers** — for Azure SQL Database
   - **Block T-SQL CRUD for managed instances** — for Azure SQL Managed Instance
1. In the window that opens, select **Register** to register this block with the Microsoft.Sql resource provider.

:::image type="content" source="media/block-crud-tsql/block-tsql-crud-register.png" alt-text="With 'Block T-SQL CRUD' checked, select Register." lightbox="media/block-crud-tsql/block-tsql-crud-register.png":::

### Re-register Microsoft.Sql resource provider

After you register either block feature with the Microsoft.Sql resource provider, you must re-register the Microsoft.Sql resource provider for the changes to take effect. To re-register the Microsoft.Sql resource provider:

1. Go to your subscription in the Azure portal.
1. Select the **Resource Providers** tab.
1. Search and select **Microsoft.Sql** resource provider.
1. Select **Re-register**.

> [!NOTE]
> The re-registration step is mandatory for the T-SQL block to be applied to your subscription.

:::image type="content" source="media/block-crud-tsql/block-tsql-crud-re-register.png" alt-text="Screenshot of the Azure portal showing how to re-register the Microsoft.Sql resource provider." lightbox="media/block-crud-tsql/block-tsql-crud-re-register.png":::

<a id="removing-block-t-sql-crud"></a>

### Remove Block T-SQL CRUD

To remove the block on T-SQL create or modify operations from your subscription, first unregister the previously registered T-SQL block. Then, re-register the Microsoft.Sql resource provider as shown above for the removal of T-SQL block to take effect. 

## Related content

- [An overview of Azure SQL Database and SQL Managed Instance security capabilities](security-overview.md)
- [Playbook for addressing common security requirements with Azure SQL Database and Azure SQL Managed Instance](security-best-practice.md)
