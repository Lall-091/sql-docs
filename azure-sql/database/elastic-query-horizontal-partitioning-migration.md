---
title: Migration guide from elastic query shard map manager mode
description: Learn about migration options for elastic query with EXTERNAL DATA SOURCE type SHARD_MAP_MANAGER, which is reaching end of support on March 31, 2027.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: bgavrilovic
ms.date: 03/18/2026
ms.service: azure-sql-database
ms.subservice: scale-out
ms.topic: upgrade-and-migration-article
---

# Migration from elastic query shard map manager mode

[!INCLUDE[appliesto-sqldb](../includes/appliesto-sqldb.md)]

Elastic query in shard map manager mode (horizontal partitioning), using `EXTERNAL DATA SOURCE` type `SHARD_MAP_MANAGER`, is reaching end of support on March 31, 2027. After this date, existing workloads will continue to function but will no longer receive support, and creation of new external data sources of type `SHARD_MAP_MANAGER` will no longer be possible. This article contains options to migration from elastic query shared map manager mode.

For customers using elastic query with `EXTERNAL DATA SOURCE` type `SHARD_MAP_MANAGER`, the best alternative depends on the use case for using elastic query and on the overall scenario and architecture. 

This article describes possible alternatives to elastic query shard map manager mode, and key considerations for each.

## Microsoft Fabric

**Best for:** OLAP (online analytical processing) and reporting scenarios.

Microsoft Fabric offers robust capabilities for large-scale analytics and reporting, enabling seamless data integration and advanced analytics workloads. However, migration might require rearchitecting existing solutions and retraining teams on new tools. Evaluate the cost implications and compatibility with your existing data sources.

For more information, see [Microsoft Fabric documentation](/fabric/fundamentals/microsoft-fabric-overview).

## SQL mirroring to Fabric

**Best for:** Reporting and analytics on centralized data.

Mirroring SQL databases to Fabric can simplify reporting and analytics on centralized data. Consider the latency and synchronization requirements between source and mirrored data. Also, assess the complexity involved in setting up mirroring and the impact on ongoing operations.

For more information, see [Microsoft Fabric mirrored databases from Azure SQL Database](/fabric/database/mirrored-database/azure-sql-database).

## ETL-based approach (for example, using Azure Data Factory)

**Best for:** Batch processing and scheduled data movement.

Using ETL pipelines like Azure Data Factory (ADF) provides flexible, scheduled data movement and transformation. This approach works well for batch processing but might introduce delays in data freshness. Consider the maintenance overhead and the scalability of ETL jobs as data volume grows.

For more information, see [Azure Data Factory documentation](/azure/data-factory/) or [Data Factory in Microsoft Fabric](/fabric/data-factory/data-factory-overview).

## Fully migrate data plane to Fabric OneLake

**Best for:** Centralized data management with unified analytics.

When you migrate entirely to Fabric OneLake, you centralize data management and take advantage of unified analytics features. This migration might require significant effort, possible downtime, and refactoring applications. Weigh the long-term benefits against short-term migration challenges, and make sure it fits your business requirements.

For more information, see [OneLake documentation](/fabric/onelake/onelake-overview).

## Azure SQL Database Hyperscale

**Best for:** Workloads where sharding was implemented due to storage limitations that Hyperscale overcomes today.

Azure SQL Database Hyperscale works well for workloads that need high performance, scalability, and rapid growth in data volume. It supports databases of any size, with fast backup and restore, and high concurrency. If you originally implemented sharding because of storage limitations, you can rearchitect your system from a sharded topology to a monolithic database. Migration involves consolidating databases and adapting your application logic for centralized storage. Consider cost, performance, and operational implications, especially if you currently rely on distributed query capabilities.

For more information, see [Azure SQL Database Hyperscale service tier](service-tier-hyperscale.md).

## Elastic jobs

**Best for:** Running queries on individual databases or shards without result aggregation.

If you use elastic query to run queries on individual databases or shards in the fleet without result aggregation, elastic jobs provide the same capability. Elastic jobs are ideal for automating and managing operations across multiple databases. They don't support result aggregation, so they're best suited for scenarios where independent queries suffice. Review the job scheduling features and integration with monitoring tools to ensure operational efficiency.

For more information, see [Elastic jobs in Azure SQL Database](elastic-jobs-overview.md).

## Azure SQL Managed Instance

**Best for:** Point-to-point cross-database queries using three-part names or linked servers.

Azure SQL Managed Instance natively supports three-part name queries and linked servers. If you use elastic query for point-to-point queries, a SQL managed instance is a natural migration target. Consider networking setup, security configurations, and licensing costs. Ensure that your workload fits within the SQL managed instance's performance and scalability limits.

For more information, see [What is Azure SQL Managed Instance?](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)

## Custom fanout query and result aggregation layer

**Best for:** Preserving existing Azure SQL Database architecture with maximum flexibility.

Building a custom fanout and aggregation layer preserves your existing architecture and provides maximum flexibility. The fanout query runs on top of the SQL Database architecture by using a customer-built layer. This approach requires development effort, ongoing maintenance, and robust error handling. Evaluate the complexity of building and supporting this solution, as well as its scalability and reliability for your needs.

## Related content

- [Elastic query overview](elastic-query-overview.md)
- [Reporting across scaled-out cloud databases](elastic-query-horizontal-partitioning.md)
- [Getting started with elastic query for horizontal partitioning (sharding)](elastic-query-getting-started.md)
