---
title: Upgrade to the Latest Version of SQL Server
description: Step-by-step guidance for modernizing your data assets
author: ajithkr-ms
ms.author: ajithkr
ms.reviewer: randolphwest
ms.date: 06/16/2025
ms.service: sql
ms.subservice: migration-guide
ms.topic: how-to
ms.custom: sfi-image-nochange
---

# Upgrade SQL Server to the latest version

In this guide, you learn how to upgrade your user databases from previous versions of [!INCLUDE [ssnoversion-md](../../../includes/ssnoversion-md.md)] to [!INCLUDE [sssql22-md](../../../includes/sssql22-md.md)] by using the SQL Server migration component in SQL Server Management Studio (SSMS).

For other migration guides, see [Azure Database Migration](/data-migration/).

## Prerequisites

Before beginning your migration project, it's important to address the associated prerequisites.
Learn about the supported versions and considerations for [upgrading SQL Server](../../../database-engine/install-windows/upgrade-sql-server.md).

To prepare for the migration, use the [SQL Server migration component in SSMS](/ssms/migrate-sql-server-component).

## Premigration

After you confirm the source environment is supported and any prerequisites are addressed, you can start the Premigration stage. The process involves conducting an inventory of the databases that you need to migrate. Next, assess the databases for potential migration issues or blockers, and then resolving any items you might have uncovered. The following two sections cover the premigration steps of discover, assess.

### Discover

The [Azure Migrate: Discovery and assessment tool](/azure/migrate/migrate-services-overview#azure-migrate-discovery-and-assessment-tool) discovers and assesses on-premises VMware VMs, Hyper-V VMs, and physical servers for migration to Azure.

You can use this tool for the following steps:

- **Azure readiness**: Assesses whether on-premises servers, [!INCLUDE [ssnoversion-md](../../../includes/ssnoversion-md.md)] instances, and web apps are ready for migration to Azure.
- **Azure sizing**: Estimates the size of Azure VMs/Azure SQL configuration/number of Azure VMware Solution nodes after migration.
- **Azure cost estimation**: Estimates costs for running on-premises servers in Azure.
- **Dependency analysis**: Identifies cross-server dependencies and optimization strategies for moving interdependent servers to Azure. Learn more about Discovery and assessment with [dependency analysis](/azure/migrate/concepts-dependency-visualization).

The Discovery and assessment tool uses a lightweight [Azure Migrate appliance](/azure/migrate/migrate-appliance) that you deploy on-premises.

- The appliance runs on a VM or physical server. You can install it easily using a downloaded template.
- The appliance discovers on-premises servers. It also continually sends server metadata and performance data to Azure Migrate.
- Appliance discovery is agentless. Nothing is installed on discovered servers.
- After appliance discovery, you can gather discovered servers into groups and run assessments for each group.

## Assess and convert

After you identify the data sources, the next step is to assess the on-premises [!INCLUDE [ssnoversion-md](../../../includes/ssnoversion-md.md)] instances. Use the [SQL migration component in SQL Server Management Studio](/ssms/migrate-sql-server-component) to assess your source database before upgrading your [!INCLUDE [ssnoversion-md](../../../includes/ssnoversion-md.md)] instance.

After all database assessments are complete, select **Save report** to export the results to a JSON file for analyzing the data at your own convenience.

### Convert

After assessing one or more source database instances you're migrating, for heterogenous migrations, you need to convert the schema to work in the target environment. Since upgrading to a newer version of [!INCLUDE [ssnoversion-md](../../../includes/ssnoversion-md.md)] would be considered a homogeneous migration, the Convert step is unnecessary.

## Migration overview

After you have the necessary prerequisites in place, and complete the tasks associated with the **Pre-migration** stage, you're ready to complete the schema and data migration. A successful migration and upgrade means you addressed all the issues discovered from the premigration stage.

Review the compatibility issues discovered with the [SQL Server migration component in SQL Server Management Studio](/ssms/migrate-sql-server-component).

Preserve backup logs, maintenance plans, and other automated tasks, including jobs by creating a backup of the system [database msdb](../../../relational-databases/backup-restore/back-up-and-restore-of-system-databases-sql-server.md).

View [linked servers](../../../relational-databases/linked-servers/linked-servers-database-engine.md) by using SQL Server Management Studio. In the Object Explorer, right-click server objects to expand list.

Additional considerations might be needed based on the complexity of your data and environment.

- [Troubleshoot orphaned users (SQL Server)](../../failover-clusters/troubleshoot-orphaned-users-sql-server.md)
- [Migrating Triggers](../../../relational-databases/in-memory-oltp/migrating-triggers.md)
- [Generate and Publish Scripts Wizard](../../../ssms/scripting/generate-and-publish-scripts-wizard.md)
- [Mirrored Backup Media Sets (SQL Server)](../../../relational-databases/backup-restore/mirrored-backup-media-sets-sql-server.md)
- [Backup overview (SQL Server)](../../../relational-databases/backup-restore/backup-overview-sql-server.md)
- [Editions and supported features of SQL Server 2022](../../editions-and-components-of-sql-server-2022.md)

### Migrate schema and data

After you assess your databases, the next step is to begin the process of migrating the schema and database by using the [SQL Server migration component in SQL Server Management Studio](/ssms/migrate-sql-server-component).

### Migrate schema and data sync

1. Use the SQL Server migration component to [assess your environment](/ssms/migrate-sql-server-component#assess-your-environment).

1. Once you have an assessment report, you can [migrate your database](/ssms/migrate-sql-server-component#migrate-your-database).

### Data sync and cutover

For minimal-downtime migrations, the source you're migrating continues to change after the one-time migration occurs, data and schema might be different from the target.
During this process, you need to ensure every change in the source are captured and applied to the target in near real time. After you verify changes in source are applied to the target, cutover from the source to the target environment.

Support for minimal-downtime migrations isn't yet available for this scenario, so the Data sync and Cutover plans aren't currently applicable.

## Post migration

After you successfully complete the **Migration** stage, you need to go through a series of post-migration tasks to ensure that everything is functioning as smoothly and efficiently as possible. The post-migration is crucial for reconciling any data accuracy issues and verifying completeness, and addressing performance issues with the workload.

For more information about these issues, specific steps to mitigate them, and after the migration
see the [Post-migration Validation and Optimization Guide](../../../relational-databases/post-migration-validation-and-optimization-guide.md).

#### Verify applications

After the data is migrated to the target environment, all the applications that formerly consumed the source need to start consuming the target. Accomplishing this requires changes to the applications in some cases. Test against the databases to verify that the applications work as expected after the migration.

## Related content

- [Services and tools for data migration](/azure/dms/dms-tools-matrix)
- [Azure Database Migration Guide](/data-migration/)
