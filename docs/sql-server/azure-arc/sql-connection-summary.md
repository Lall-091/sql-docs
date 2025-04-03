---
title: SQL Server Connection Summary
description: Learn how you can view client connections to an instance of SQL Server enabled by Azure Arc. 
author: ajithkr-ms
ms.author: ajithkr
ms.reviewer: nhebbar, randolphwest
ms.date: 03/26/2025
ms.topic: how-to
ms.custom:
---

# Client connection summary for SQL Server enabled by Azure Arc (preview)

[!INCLUDE [sqlserver](../../includes/applies-to-version/sqlserver.md)]

This article teaches you how to view client connections to [!INCLUDE [ssazurearc](../../includes/ssazurearc.md)] in Azure portal. 

> [!NOTE]
> The SQL Server Connections view in the Azure portal is currently in preview. 

## View SQL Server connections

To view a summary of all client connections to the SQL Server instance, follow these steps:

1. Select an instance of [!INCLUDE [ssazurearc](../../includes/ssazurearc.md)] in the [Azure portal](https://portal.azure.com).
1. Under **Monitoring**, select **SQL Server Connections**.
1. (Optionally) Use the time range to view connections during a preferred window within the last 30 days.

:::image type="content" source="media/sql-connection-summary/sql-connection-summary.png" alt-text="Screenshot of the SQL Client Connections view for SQL Server enabled by Azure Arc." lightbox="media/sql-connection-summary/sql-connection-summary.png":::

### Review the summarized data in the view:

| Column name | Description and version-specific information |
| --- | --- |
| **Program Name** | Name of client program that initiated the session.|
| **Client Interface Name** | Name of library/driver being used by the client to communicate with the server. |
| **Database Name** | Name of the current database for the session in the hourly snapshots. |
| **Request End Time** | Last request end time from the hourly snapshots. Indicator of how recently the client program connected used the database. |
| **Total Writes** | Aggregated number of writes from the client program to the database as seen in the hourly snapshots. |
| **Total Reads** | Aggregated number of reads from the client program to the database as seen in the hourly snapshots. |
| **Elapsed Time** | Aggregated connection duration (in milliseconds) from the client program as seen in the hourly snapshots. |
| **Count** | Count of unique sessions as seen in the hourly snapshots. The distinct sessions are identified using the login time. |

## How is the data collected?

By default, the SQL Server Connections view is available to all SQL Server instances enabled by Azure Arc. Data collection starts as soon as the instance is connected to Azure. Azure Connected Machine agent automatically polls [sys.dm_exec_sessions](../../relational-databases/system-dynamic-management-views/sys-dm-exec-sessions-transact-sql.md) hourly. The portal displays the data collection time. The service maintains the data for 30 days.

The connection data within the time range chosen on the portal dictates the client connection data summarized and presented as a table in the view.

## Disable the connections view

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


## Enable the connections view

If SQL Server Connections view and data collection is disabled, you can enable it again by using the Azure portal, or the Azure CLI. 

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
