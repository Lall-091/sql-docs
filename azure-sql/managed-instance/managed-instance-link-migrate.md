---
title: Migrate with the Link
titleSuffix: Azure SQL Managed Instance
description: Learn how to use the Managed Instance link to migrate your SQL Server data to Azure SQL Managed Instance.
author: danimir
ms.author: danil
ms.reviewer: mathoma, randolphwest
ms.date: 02/19/2026
ms.service: azure-sql-managed-instance
ms.subservice: data-movement
ms.topic: how-to
ms.custom:
  - ignite-2023
---

# Migrate with the link - Azure SQL Managed Instance

[!INCLUDE [appliesto-sqlmi](../includes/appliesto-sqlmi.md)]

This article teaches you to migrate your SQL Server database to Azure SQL Managed Instance by using the [Managed Instance link](managed-instance-link-feature-overview.md).

For a detailed migration guide, review [Migrate to Azure SQL Managed Instance](../migration-guides/managed-instance/sql-server-to-managed-instance-guide.md). To compare migration tools, review [Compare LRS with Managed Instance link](log-replay-service-compare-mi-link.md).

> [!NOTE]  
> You can now migrate your SQL Server instance enabled by Azure Arc to Azure SQL Managed Instance directly through the Azure portal. For more information, see [Migrate to Azure SQL Managed Instance](/sql/sql-server/azure-arc/migrate-to-azure-sql-managed-instance).

## Overview

The Managed Instance link enables migration from SQL Server hosted anywhere, to Azure SQL Managed Instance. The link uses Always On availability group technology to replicate changes nearly in real time from the primary SQL Server instance to the secondary SQL Managed Instance. The link provides the only truly online migration option between SQL Server and Azure SQL Managed Instance, since the only downtime is cutting over to the target SQL managed instance.

Migrating with the link gives you:

- The ability to test read only workloads on SQL Managed Instance before you finalize the migration to Azure.
- The ability to keep the link and migration running for as long as you need, weeks and even months at a time.
- Near real-time replication of data that provides the fastest available data replication to Azure.
- The most minimum downtime migration compared to all other solutions available today.
- Instantaneous cutover to the target SQL Managed Instance.
- The ability to migrate anytime you're ready.
- The ability to migrate single or multiple databases from a single or multiple SQL Server instances to the same or multiple SQL managed instances in Azure.
- The only true online migration to the Business Critical service tier.

> [!NOTE]  
> While you can only migrate one database per link, you can establish multiple links from the same SQL Server instance to the same SQL Managed Instance.

## Prerequisites

To use the link with Azure SQL Managed Instance for migration, you need the following prerequisites:

- An active Azure subscription. If you don't have one, [create a free account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- [Supported version of SQL Server](managed-instance-link-feature-overview.md#prerequisites) with the required service update installed.

## Assess and discover

After you've verified that your source environment is supported, start with the pre-migration stage. Discover all of the existing data sources, assess migration feasibility, and identify any blocking issues that might prevent your migration. In the Discover phase, scan the network to identify all SQL Server instances and features used by your organization.

You can use the following tools to discover SQL sources in your environment:

- [SQL Server enabled by Azure Arc](/sql/sql-server/azure-arc/migration-assessment): SQL Server enabled by Azure Arc automatically produces an assessment for migration to Azure, simplifying the discovery process and readiness assessment for migration.
- [Azure Migrate](/azure/migrate/migrate-services-overview) to assess migration suitability of on-premises servers, perform performance-based sizing, and provide cost estimations for running them in Azure.
- [Microsoft Assessment and Planning Toolkit (the "MAP Toolkit")](https://www.microsoft.com/download/details.aspx?id=7826) to assess your current IT infrastructure. The toolkit provides a powerful inventory, assessment, and reporting tool to simplify the migration planning process.

After data sources have been discovered, assess any on-premises SQL Server instances that can be migrated to Azure SQL Managed Instance to identify migration blockers or compatibility issues.

You can use the [migration readiness assessment](/sql/sql-server/azure-arc/migration-assessment) to assess your source SQL Server instance.

For detailed guidance, review [pre-migration](../migration-guides/managed-instance/sql-server-to-managed-instance-guide.md).

## Create target instance

After you've assessed your existing environment, and determined the appropriate service tier and hardware configuration for your target SQL managed instance, deploy your target instance by using the [Azure portal](instance-create-quickstart.md), [PowerShell](scripts/create-configure-managed-instance-powershell.md) or the [Azure CLI](scripts/create-configure-managed-instance-cli.md).

## Configure link

After your target SQL managed instance is created, configure a link between the database on your SQL Server instance and Azure SQL Managed Instance. First, [prepare your environment](managed-instance-link-preparation.md) and then configure a link by using [SQL Server Management Studio (SSMS)](managed-instance-link-configure-how-to-ssms.md) or [scripts](managed-instance-link-configure-how-to-scripts.md).

## Data sync and cutover

After your link is established, and you're ready to migrate, follow these steps (typically during a maintenance window):

1. Stop the workload on the primary SQL Server database so the secondary database on SQL Managed Instance catches up.
1. Validate all data has made it over to the secondary database on SQL Managed Instance.
1. [Fail over the link](managed-instance-link-failover-how-to.md) to the secondary SQL managed instance by choosing **Planned failover**.
1. (For SQL Server 2022 migrations) Check the box to **Remove link after successful failover** to ensure that failover is one way, and the link is removed.
1. Cut over the application to connect to the SQL managed instance endpoint.

## Validate migration

After you've cut over to the SQL managed instance target, monitor your application, test performance and remediate any issues.

For details, review [post-migration](../migration-guides/managed-instance/sql-server-to-managed-instance-guide.md#post-migration).

## Reverse a migration

Reverse migration back to SQL Server from Azure SQL Managed Instance might be supported depending on the [update policy](update-policy.md) of your SQL managed instance. For example:

- [SQL Server 2022 update policy](/azure/azure-sql/managed-instance/update-policy#sql-server-2022-update-policy): Databases from instances configured with the **SQL Server 2022** update policy can be restored back to SQL Server 2022 instances.
- [SQL Server 2025 update policy](/azure/azure-sql/managed-instance/update-policy#sql-server-2025-update-policy): Databases from instances configured with the **SQL Server 2025** update policy can be restored back to SQL Server 2025 instances.
- [Always-up-to-date update policy](/azure/azure-sql/managed-instance/update-policy#always-up-to-date-update-policy): Databases from instances configured with the **Always-up-to-date** update policy can't be restored back to SQL Server.

If your source SQL Server version is earlier than SQL Server 2022, reverse migration isn't possible. When your database is migrated to SQL Managed Instance, it undergoes an internal upgrade to a newer database version that isn't compatible with earlier SQL Server versions. Reverse migration database compatibility is only available when SQL Managed instance is configured with the corresponding update policy.

## Related content

To use the link:

- [Prepare your environment for a link](managed-instance-link-preparation.md)
- [Configure link with SSMS](managed-instance-link-configure-how-to-ssms.md)
- [Configure link with scripts](managed-instance-link-configure-how-to-scripts.md)
- [Fail over link](managed-instance-link-failover-how-to.md)
- [Managed Instance link best practices](managed-instance-link-best-practices.md)

To learn more about the link:

- [Overview of the Managed Instance link](managed-instance-link-feature-overview.md)
- [Disaster recovery with Managed Instance link](managed-instance-link-disaster-recovery.md)

For other replication and migration scenarios, consider:

- [Transactional replication with Azure SQL Managed Instance](replication-transactional-overview.md)
- [Overview of Log Replay Service with Azure SQL Managed Instance](log-replay-service-overview.md)
- [Compare LRS with Managed Instance link](log-replay-service-compare-mi-link.md)
