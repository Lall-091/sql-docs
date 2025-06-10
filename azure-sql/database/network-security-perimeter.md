---
title: Network Security Perimeter
titleSuffix: Azure SQL Database & Azure Synapse Analytics
description: Overview of Network Security Perimeter for Azure SQL Database
author: VanMSFT
ms.author: vanto
ms.reviewer: wiassaf, vanto, mathoma
ms.date: 04/09/2025
ms.service: azure-sql-database
ms.subservice: security
ms.topic: how-to
---

# Network Security Perimeter for Azure SQL Database and Azure Synapse Analytics

[!INCLUDE [appliesto-sqldb](../includes/appliesto-sqldb.md)]

Network Security Perimeter (preview) secures both inbound and outbound network traffic between Azure SQL Database and other Platform as a Service (PaaS) resources (for example, Azure Storage and Azure Key Vault). Any attempts made to communicate with Azure resources that aren't inside the perimeter is blocked.

> [!IMPORTANT]  
> - This article applies to both Azure SQL Database and [dedicated SQL pool (formerly SQL DW)](/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) in Azure Synapse Analytics. These settings apply to all SQL Database and dedicated SQL pool (formerly SQL DW) databases associated with the server. For simplicity, the term 'database' refers to both databases in Azure SQL Database and Azure Synapse Analytics. Likewise, any references to 'server' is referring to the [logical SQL server](logical-servers.md) that hosts Azure SQL Database and dedicated SQL pool (formerly SQL DW) in Azure Synapse Analytics. This article does *not* apply to Azure SQL Managed Instance or dedicated SQL pools in Azure Synapse Analytics workspaces.

## Getting Started

1. In the Azure portal, search for **Network Security Perimeter** in the resource list and then select **Create**.

   :::image type="content" source="media/network-security-perimeter/associate-sql-network-security-perimeter.png" alt-text="Screenshot of creating a network security perimeter in the Azure portal.":::

1. Provide a **Name** and **Region** and choose the subscription.
1. Under the **Resources** section, select the **Add** button and navigate to the SQL Database you want to associate with the perimeter.
1. Add an Inbound access rule. The source type can be either an IP address, a subscription, or other network security perimeters.
1. Add an Outbound access rule to allow resources inside the perimeter to connect to resources outside the perimeter

If you already have an existing Azure SQL Database and are looking to add security perimeter, use the following steps:

1. In the Azure portal, search for the existing Network Security Perimeter.
1. Select **Associated Resources** from the **Settings** menu.
1. Select the **Add** button and select **Associate resources with an existing profile**.

   :::image type="content" source="media/network-security-perimeter/associated-resources-sql-network-security-perimeter.png" alt-text="Screenshot of associated resources for network security perimeter in the Azure portal.":::

1. Select your **Profile** from the dropdown and select **Add**.

   :::image type="content" source="media/network-security-perimeter/select-associated-resources-sql-network-security-perimeter.png" alt-text="Screenshot of adding an associated resource for network security perimeter in the Azure portal.":::

1. **Search** for your SQL Database resource, **Select** the required resource, and select **Associate**.


## Using SQL Database with a Network Security Perimeter

By default, Network Security Perimeter uses [Learning Mode](/azure/private-link/network-security-perimeter-concepts#access-modes-in-network-security-perimeter), which can be used to log all traffic to and from SQL Database. The network traffic can be logged to a Log Analytics Workspace or Azure Storage account using [Diagnostic logging for Azure Network Security Perimeter](/azure/private-link/network-security-perimeter-diagnostic-logs). Finally, Network Security Perimeter can be switched to **Enforced** mode. In **Enforced** mode, any access denied shows the following error:

```output
Error 42118
Login failed because the network security perimeter denied inbound access.
```

## Related content

- [What is a network security perimeter?](/azure/private-link/network-security-perimeter-concepts)
- [Quickstart: Create a network security perimeter - Azure portal](/azure/private-link/create-network-security-perimeter-portal)
- [Quickstart: Create a network security perimeter - Azure PowerShell](/azure/private-link/create-network-security-perimeter-powershell)
- [Quickstart: Create a network security perimeter - Azure CLI](/azure/private-link/create-network-security-perimeter-cli)
- [Azure SQL Connectivity Architecture](connectivity-architecture.md)
