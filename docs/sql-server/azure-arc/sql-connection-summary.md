---
title: SQL Server Connection Summary
description: Learn how you can see a summary of client connections made to an instance of SQL Server enabled by Azure Arc in the Azure portal by using the SQL Server Connections view. 
author: ajithkr-ms
ms.author: ajithkr
ms.reviewer: nhebbar, randolphwest
ms.date: 03/26/2025
ms.topic: how-to
ms.custom:
---

# Client connection summary for SQL Server enabled by Azure Arc (preview)

[!INCLUDE [sqlserver](../../includes/applies-to-version/sqlserver.md)]

This article teaches you how to see a summary of client connections to [!INCLUDE [ssazurearc](../../includes/ssazurearc.md)] by using the SQL Server Connections view in the Azure portal. 

> [!NOTE]
> The SQL Server Connections view in the Azure portal is currently in preview. 

## View SQL Server connections

To view a summary of all client connections to the SQL Server instance, follow these steps:

1. Select an instance of [!INCLUDE [ssazurearc](../../includes/ssazurearc.md)] in the [Azure portal](https://portal.azure.com).
1. Under **Monitoring**, select **SQL Server Connections**.
1. (Optionally) Use the time range to view connections during a preferred window within the last 30 days.

Review the summarized data in the view: 

:::image type="content" source="media/sql-connection-summary/sql-connection-summary.png" alt-text="Screenshot of the SQL Client Connections view for SQL Server enabled by Azure Arc." lightbox="media/sql-connection-summary/sql-connection-summary.png":::

## How is the data collected?

By default, the SQL Server Connections view is available to all SQL Server instances enabled by Azure Arc. Data collection starts as soon as the instance is connected to Azure. Azure Connected Machine agent automatically polls [sys.dm_exec_sessions](../../relational-databases/system-dynamic-management-views/sys-dm-exec-sessions-transact-sql.md) hourly. The portal displays the data collection time. The service maintains the data for 30 days.

The connection data within the time range chosen on the portal dictates the client connection data summarized and presented as a table in the view.

## Disable connections view

Since the SQL Server connections view is enabled by default, you can choose to disable it and stop data collection. You can disable the SQL Server connections view by using the Azure portal, or the Azure CLI. 

### [Azure portal](#tab/azure-portal)

To disable the SQL Server Connections view, follow these steps:

1. On the **Overview** page for [!INCLUDE [ssazurearc](../../includes/ssazurearc.md)] in the [Azure portal](https://portal.azure.com), select **SQL Server Connections** to open the **SQL Server Connections** pane.
1. On the **SQL Server Connections** pane, select **Disable** from the command bar. Select **Yes** on the **Disable SQL client connections** information box: 

   :::image type="content" source="media/sql-connection-summary/sql-connection-disable.png" alt-text="Screenshot of disable option in SQL Client Connections view for SQL Server enabled by Azure Arc." lightbox="media/sql-connection-summary/sql-connection-disable.png":::

### [Azure CLI](#tab/azure-cli)

To disable the SQL Server Connections view, replace placeholder values and then run the following Azure CLI command: 

```azurecli
az sql server-arc extension feature-flag set --name ClientConnections --enable false --resource-group <resource_group>" --machine-name <server_name>
```

---


## Enable connections view

If SQL Server Connections view and data collection has been disabled, you can enable it again by using the Azure portal, or the Azure CLI. 

### [Azure portal](#tab/azure-portal)

To disable the SQL Server Connections view, follow these steps:

1. On the **Overview** pane for [!INCLUDE [ssazurearc](../../includes/ssazurearc.md)], select **SQL Server Connections** to open the **SQL Server Connections** page.
1. On the **SQL Server Connections** pane, either select **Enable** from the command bar, or the **Enable Sql Connections** button to enable the SQL Server connections feature. 

   :::image type="content" source="media/sql-connection-summary/sql-connection-enable.png" alt-text="Screenshot of enable option in SQL Client Connections view for SQL Server enabled by Azure Arc." lightbox="media/sql-connection-summary/sql-connection-enable.png":::

### [Azure CLI](#tab/azure-cli)

To enable the SQL Server Connections view, replace placeholder values and then run the following Azure CLI command: 

```azurecli
az sql server-arc extension feature-flag set  --name ClientConnections --enable true --resource-group <resource_group>" --machine-name <server_name>
```

---

## Related content

- [Use performance dashboard to monitor SQL Server enabled by Azure Arc](sql-monitoring.md)
- [System dynamic management views](../../relational-databases/system-dynamic-management-views/system-dynamic-management-views.md)
