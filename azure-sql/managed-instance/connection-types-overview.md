---
title: Connection types
titleSuffix: Azure SQL Managed Instance
description: Learn about Azure SQL Managed Instance connection types
author: zoran-rilak-msft
ms.author: zoranrilak
ms.reviewer: vanto, mathoma
ms.date: 07/09/2025
ms.service: azure-sql-managed-instance
ms.subservice: connect
ms.topic: conceptual
ms.custom: devx-track-azurepowershell
---

# Azure SQL Managed Instance connection types
[!INCLUDE[appliesto-sqlmi](../includes/appliesto-sqlmi.md)]

This article explains how clients connect to the VNet-local endpoint of Azure SQL Managed Instance based on the connection type, how to change connection types, and considerations for changing the default connectivity settings.

## Connection types

The VNet-local endpoint of Azure SQL Managed Instance supports two connection types: *redirect* (recommended) and *proxy* (default). 

> [!IMPORTANT]
> **Using the redirect connection policy is highly recommended** for all SQL managed instances, except when SQL clients do not support TDS redirects.

### Redirect connection type (recommended)

Redirect is the preferred way for SQL clients to connect to Azure SQL Managed Instance. With redirect, clients establish connections directly to the node that hosts the database. The redirect connection type has better latency and throughput performance compared to proxy. Redirect also minimizes the impact of planned maintenance events of the gateway component, since redirect connections, once established, have no dependency on the gateway.

To use the redirect connection type, you need the following two prerequisites:
- The network security group (NSG) rules in the subnet of the SQL managed instance, and any firewalls on the route from your SQL client to the SQL managed instance, must permit inbound access on port 1433 and port range 11000-11999 to the entire IP address range assigned to the subnet of the SQL managed instance.
- Connecting clients must support Tabular Data Stream (TDS) version 7.4 or newer. TDS 7.4 was first published with Microsoft SQL Server 2012, so any SQL drivers compliant with that version use the redirect connection type. For a list of recommended TDS drivers, see [Recommended versions of drivers and tools](connect-application-instance.md#recommended-versions-of-drivers-and-tools).

> [!NOTE]
> Azure SQL Managed Instance is slowly rolling out an improvement to the redirect mechanism that conducts all traffic using port 1433. **The prerequisites regarding ports 11000-11999 remain authoritative and no changes to your existing NSG and RT are required until further notice**

In the redirect connection type, after the TCP session is established to the SQL Database Engine, the client session obtains the destination virtual IP of the virtual cluster node from the load balancer. Subsequent packets flow directly to the virtual cluster node, bypassing the gateway. The following diagram illustrates this traffic flow:

:::image type="content" source="media/connection-types-overview/redirect.png" alt-text="Diagram showing an on-premises network with redirect-find-db connected to a gateway in an Azure virtual network and a redirect-query connected to a database primary node in the virtual network.":::

### Proxy connection type (default)

The proxy is the default connectivity mechanism to support compatibility with SQL drivers that implement TDS versions older than 7.4. This connection type proxies the incoming connections through an internal gateway, which only requires port 1433 to be open for inbound traffic. Because the internal gateway forwards the connection, proxy connections can create connectivity bottlenecks, severely degrading latency and lowering the throughput compared to the redirect connection type. Additionally, the proxy connection type generates more disconnect events due to planned maintenance events of the gateway component.

The following diagram illustrates the proxy TCP flow via the gateway: 
![Diagram showing an on-premises network with a proxy connected to a gateway in an Azure virtual network, connect next to a database primary node in the virtual network.](./media/connection-types-overview/proxy.png)

## Change the connection type

- **Using the Azure portal:**
To change the connection type by using the Azure portal, open the [Virtual Network](https://portal.azure.com/#view/HubsExtension/AssetMenuBlade/~/virtualnetworks/assetName/NetworkFoundation/extensionName/Microsoft_Azure_Network) page for your SQL managed instance and use the **Connection type** setting to change the connection type and save the changes.

- **Script to change connection type settings using PowerShell:**

The following PowerShell script shows how to change the connection type for a SQL managed instance to `Redirect`.

```powershell
Install-Module -Name Az
Import-Module Az.Accounts
Import-Module Az.Sql

Connect-AzAccount
# Get your SubscriptionId from the Get-AzSubscription command
Get-AzSubscription
# Use your SubscriptionId in place of {subscription-id}
Select-AzSubscription -SubscriptionId {subscription-id}
# Replace {rg-name} with the resource group for your SQL managed instance, and replace {mi-name} with the name of your SQL managed instance
$mi = Get-AzSqlInstance -ResourceGroupName {rg-name} -Name {mi-name}
$mi = $mi | Set-AzSqlInstance -ProxyOverride "Redirect" -force
```

## Related content

- [Restore a database to SQL Managed Instance](restore-sample-database-quickstart.md)
- Learn how to [configure a public endpoint on SQL Managed Instance](public-endpoint-configure.md)
- Learn about [SQL Managed Instance connectivity architecture](connectivity-architecture-overview.md)
