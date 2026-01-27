---
title: Azure Government
description: "Describes features and limitations currently available for SQL Server enabled by Azure Arc on US Government region."
author: AbdullahMSFT
ms.author: amamun
ms.reviewer: mikeray
ms.date: 08/15/2025
ms.topic: feature-availability
#customer intent:Understand the features, limitations, and onboarding process for using SQL Server enabled by Azure Arc in US Government regions, specifically to manage their SQL Server resources securely and compliantly within the Azure Government portal.

---

# SQL Server enabled by Azure Arc in US Government

This article describes features and limitations currently available for SQL Server enabled by Azure Arc on US Government regions. It also:

- Points to instructions how to on board your SQL Server in US Government regions
- Lists known issues and options to work around the issues

You can use SQL Server enabled by Azure Arc to manage SQL Server Azure Arc resources in US Government regions. View these resources in the Azure Government portal just like any Azure resource. The portal provides a single pane of glass to monitor and organize your SQL Server estate in the government cloud.

Currently, these features are only available:

- In the US Government Virginia region
- On Windows operating system

With SQL Server enabled by Azure Arc, U.S. government agencies and organizations can manage SQL Server instances outside of Azure from the Azure Government portal, in a secure and compliant manner.

## Prerequisite

Requires Azure extension for SQL Server version `1.1.3119.307` or later.

The latest updates are available in the [Release notes - SQL Server enabled by Azure Arc](release-notes.md).

## Onboard your SQL Server

To onboard your SQL Server, complete the following steps from the Azure (US Gov) portal.

1. [Connect hybrid machines with Azure Arc-enabled servers](/azure/azure-arc/servers/learn/quick-enable-hybrid-vm)
1. [Connect your SQL Server to Azure Arc on a server already enabled by Azure Arc](connect-already-enabled.md)

## Available features

Currently, in the US Government Virginia region, SQL Server registration provides the following features:

- [Connect your SQL Server to Azure Arc](connect.md) (onboard) a SQL Server instance to Azure Arc.
- [SQL Server inventory](overview.md#manage-your-sql-server-instances-at-scale-from-a-single-point-of-control) which includes the following capabilities in the Azure portal:
  - View SQL Server instances as Azure resources.
  - View databases Azure resources.
  - View the properties for each server. For example, you can view the version, edition, and database for each instance.
- [Subscribe to Extended Security Updates in a production environment](extended-security-updates.md#subscribe-to-extended-security-updates-in-a-production-environment).
- [Manage licensing and billing of SQL Server enabled by Azure Arc](manage-license-billing.md).
- License virtual cores.
- [Failover cluster instances support](support-for-fci.md) - onboard and manage SQL Server failover cluster instances. 

[All other features](overview.md#feature-differentiation) aren't currently available.

## Related content

- [SQL Server enabled by Azure Arc](overview.md)
