---
title: Block T-SQL Commands to Create or Modify Azure SQL Resources
description: This article details a feature allowing Azure administrators to block T-SQL commands to create or modify Azure SQL resources
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: wiassaf, mathoma
ms.date: 06/13/2025
ms.service: azure-sql-database
ms.subservice: security
ms.topic: how-to
ROBOTS: NOINDEX
monikerRange: "=azuresql || =azuresql-db "
ms.custom: sfi-image-nochange
---

# What is Block T-SQL CRUD feature?

[!INCLUDE[appliesto-sqldb](../includes/appliesto-sqldb.md)]

This feature allows Azure administrators to block the creation or modification of Azure SQL Database resources through T-SQL. This is enforced at the subscription level to block T-SQL commands from affecting Azure SQL Database resources.

## Overview

To block creation or modification of resources through T-SQL and enforce resource management through an Azure Resource Manager template (ARM template) for a given subscription, the subscription level preview features in Azure portal can be used. This is particularly useful when you are using [Azure Policies](/azure/governance/policy/overview) to enforce organizational standards through ARM templates. Since T-SQL does not adhere to Azure Policies, a block on T-SQL create or modify operations can be applied. The syntax blocked includes CRUD (create, update, delete) operations for databases in Azure SQL Database.

T-SQL CRUD operations can be blocked via Azure portal, [PowerShell](/powershell/module/az.resources/register-azproviderfeature), or [Azure CLI](/cli/azure/feature#az-feature-register).

## Blocked statements

The following T-SQL statements are blocked when this feature is enabled:

1. `CREATE DATABASE` statements
1. `DROP DATABASE` statements
1. A subset of `ALTER DATABASE` statements, as follows:
    - `ALTER DATABASE ... ADD SECONDARY ON SERVER`
    - `ALTER DATABASE ... REMOVE SECONDARY ON SERVER`
    - `ALTER DATABASE ... FAILOVER`
    - `ALTER DATABASE ... MODIFY NAME ...`
    - `ALTER DATABASE ... MODIFY (MAXSIZE | EDITION | SERVICE_OBJECTIVE ...)`
    - `ALTER DATABASE ... MODIFY BACKUP_STORAGE_REDUNDANCY ...`
    - `ALTER DATABASE ... SET ENCRYPTION ...`

## Permissions

In order to register or remove this feature, the Azure user must be a member of the Owner or Contributor role of the subscription.

## Examples

The following section describes how you can register or unregister a preview feature with Microsoft.Sql resource provider in Azure portal: 

### Register Block T-SQL CRUD

1. Go to your subscription on Azure portal.
1. Select the **Preview Features** tab. 
1. Select **Block T-SQL CRUD**.
1. After you select **Block T-SQL CRUD**, a new window will open, select **Register**, to register this block with Microsoft.Sql resource provider.

:::image type="content" source="media/block-crud-tsql/block-tsql-crud.png" alt-text="Screenshot of the Azure portal showing how to select 'Block T-SQL CRUD' in the list of Preview Features." lightbox="media/block-crud-tsql/block-tsql-crud.png":::

:::image type="content" source="media/block-crud-tsql/block-tsql-crud-register.png" alt-text="With 'Block T-SQL CRUD' checked, select Register." lightbox="media/block-crud-tsql/block-tsql-crud-register.png":::

### Re-register Microsoft.Sql resource provider

After you register the block of T-SQL CRUD with Microsoft.Sql resource provider, you must re-register the Microsoft.Sql resource provider for the changes to take effect. To re-register the Microsoft.Sql resource provider:

1. Go to your subscription on Azure portal.
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
