---
title: Migrate to Azure SQL Managed Instance (preview)
description: Migrate your SQL Server instance enabled by Azure Arc to Azure SQL Managed Instance by using the Azure portal.
author: danimir
ms.author: danil
ms.reviewer: mikeray, randolphwest, mathoma
ms.date: 07/16/2025
ms.topic: how-to
---

# Migrate to Azure SQL Managed Instance (preview) - SQL Server enabled by Azure Arc

[!INCLUDE [sqlserver](../../includes/applies-to-version/sqlserver.md)]

This article demonstrates how to migrate your SQL Server instance enabled by Azure Arc to [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview) in the Azure portal.

> [!NOTE]
> Database migration to Azure SQL Managed Instance through the Azure portal is currently in preview.

## Overview
SQL Managed Instance is a fully managed lift-and-shift, platform as a service (PaaS) target to run your SQL Server workloads in the Azure cloud platform. After your SQL Server instance is enabled by Azure Arc, you can assess your SQL Server data estate to identify an optimal SQL Managed Instance configuration. Then you can migrate your SQL Server databases to SQL Managed Instance directly from the Azure portal.

When your SQL Server instance is enabled by Azure Arc, you can:

- Evaluate and assess whether your SQL Server instance is ready to migrate to SQL Managed Instance.
- Identify potential migration risks, and learn how to mitigate them.
- Optimize for performance and cost with guidance around service tiers, configuration, and sizing.

Discovery of SQL Server instances and generation of readiness reports happen instantly, automatically, and continuously. No extra configuration or setup is required. First, you choose an appropriate SQL Managed Instance target and prepare your environment. Then, you can migrate your SQL Server databases to SQL Managed Instance directly from the Azure portal through a fully managed and automated process.

Database migration (preview) is available by default for all SQL Server instances enabled by Azure Arc, starting with [!INCLUDE [sssql11-md](../../includes/sssql11-md.md)].

## Choose the integrated migration method

You can choose the migration method that best fits your needs on the **Database migration (preview)** pane. After some initial configuration, migration is automated for you based on your selection.

The following methods are built into the migration process:

- [Managed Instance link](/azure/azure-sql/managed-instance/managed-instance-link-feature-overview): Migrate by using real-time replication with a distributed availability group (online).
- [Log Replay Service (LRS)](/azure/azure-sql/managed-instance/log-replay-service-overview): Migrate by using log shipping (online).

To understand the differences between the two migration options, see [Compare the Managed Instance link with LRS for migration](/azure/azure-sql/managed-instance/log-replay-service-compare-mi-link). On the **Database migration (preview)** pane in the Azure portal, you can choose the option that best suits your needs in the **Migrate data** step.

## Prerequisites

To migrate your SQL Server instance to SQL Managed Instance through the Azure portal, your instance must meet the following prerequisites:

- [Be enabled by Azure Arc](overview.md).
- Have Azure extension for SQL Server version 1.1.3106.305 or later.

The requirements for the source SQL Server instance depend on the migration method that you plan to use. For example:

- The [Managed Instance link](/azure/azure-sql/managed-instance/managed-instance-link-feature-overview) supports SQL Server 2016 and later on any supported edition of Windows Server.
- [LRS](/azure/azure-sql/managed-instance/log-replay-service-overview) supports SQL Server 2008 and later on any supported edition of Windows Server.

## Permissions

This section describes the permissions that you need to migrate your SQL Server instance to SQL Managed Instance through the Azure portal.

On the source SQL Server instance, you need the following permissions:

- If you enable [least privilege](configure-least-privilege.md), necessary permissions such as `sysadmin` are [granted](configure-windows-accounts-agent.md#database-migration) as needed during the database migration process.
- If you can't use least privilege, you need `sysadmin` permissions on the source SQL Server instance.

### [Managed Instance link](#tab/mi-link)

To migrate with the Managed Instance link, you need one of the following permissions on the SQL Managed Instance target:

- SQL Managed Instance Contributor role
- Subscription-level Contributor or Owner role

For minimum permissions, see [Custom permissions](/azure/azure-sql/managed-instance/managed-instance-link-preparation#permissions).

> [!NOTE]
> Users with the `SqlServerAvailabilityGroups_CreateManagedInstanceLink`, `SqlServerAvailabilityGroups_failoverMiLink`, and `SqlServerAvailabilityGroups_deleteMiLink` permissions in Azure can perform actions on the **Database migration (preview)** pane during the migration process that elevate the SQL Server permissions of the account used by the extension, including the `sysadmin` role.

### [LRS](#tab/lrs)

To migrate with LRS, you need one of the following permissions on the SQL Managed Instance target:

- SQL Managed Instance Contributor role
- A role with the following permission: `Microsoft.Sql/managedInstances/databases/*`

You also need to be able to [authenticate to the Azure Blob Storage account](/azure/azure-sql/managed-instance/log-replay-service-migrate#authenticate-to-your-blob-storage-account) where you store your database backups.

---

## Prepare the environment for migration

To migrate your databases by using either the Managed Instance link or LRS, first prepare your environment.

### [Managed Instance link](#tab/mi-link)

To use the Managed Instance link, follow these steps:

1. Set your SQL Server database to full recovery mode, and perform a recent full backup of your database. For SQL Server instances that meet the [licensing requirement](overview.md#feature-differentiation), you can enable the [automated backups (preview)](backup-local.md) feature, which automatically determines backup qualifications. SQL Server instances that don't support the automated backup feature can still migrate their database through the Managed Instance link. You must manually validate that the database is in full recovery mode and perform a current full backup.
1. [Prepare your environment](/azure/azure-sql/managed-instance/managed-instance-link-preparation).
1. [Establish trust between instances](/azure/azure-sql/managed-instance/managed-instance-link-configure-how-to-scripts#establish-trust-between-instances).

### [LRS](#tab/lrs)

To use LRS, you need to [create a storage account](/azure/azure-sql/managed-instance/log-replay-service-migrate#create-a-storage-account) and [create a blob container](/azure/storage/blobs/storage-quickstart-blobs-portal) inside the storage account.

The remaining steps, such as authentication, are automated.

--- 

## Migrate to SQL Managed Instance

The following tiles guide you through the migration of your SQL Server databases to SQL Managed Instance:

1. [Assess source instance](#assess-source-instance): Assess your SQL Server instance to determine its readiness to migrate to SQL Managed Instance.
1. [Select target](#select-target): Select a SQL Managed Instance target for your migration.
1. [Migrate data](#migrate-data): Migrate your SQL Server databases to SQL Managed Instance.
1. [Monitor and cutover](#monitor-and-cutover): Monitor the migration process and cut over to the SQL Managed Instance target.

The following screenshot shows the tiles on the **Database migration (preview)** pane for your SQL Server instance in the Azure portal:

:::image type="content" source="media/migrate-to-azure-sql-managed-instance/migration-home-page.png" alt-text="Screenshot that shows the migration home page for a SQL Server instance in the Azure portal." lightbox="media/migrate-to-azure-sql-managed-instance/migration-home-page.png":::

### Assess source instance

To assess the source instance, follow these steps:

1. Go to your [SQL Server instance](https://portal.azure.com/#view/Microsoft_Azure_ArcCenterUX/ArcCenterMenuBlade/~/sqlServerInstances) in the Azure portal.
1. Under **Migration**, select **Database migration (preview)** to open the **Database migration (preview)** pane. Under **Assess source instance**, select **View report** to open the **Assessments** pane.

   :::image type="content" source="media/migrate-to-azure-sql-managed-instance/database-migration-pane.png" alt-text="Screenshot that shows the Database migration pane for the SQL Server instance in the Azure portal, with View report highlighted.":::

1. On the **Assessments** pane:

   - Use **Run assessment** to initiate a new assessment if one wasn't run recently.
   - Use **View assessment details** in the **Azure SQL MI Recommended Target** box to learn more about your assessment results, including the readiness of your SQL Server instance to migrate to SQL Managed Instance. You also learn about the recommended service tier and configuration for your target instance.

### Select target

After you assess your SQL Server instance, select a SQL Managed Instance target.

1. On the **Assessments** pane, select **Create target** to open the **Create or select target** pane and identify a migration target.

   :::image type="content" source="media/migrate-to-azure-sql-managed-instance/select-target.png" alt-text="Screenshot that shows the Assessments pane in the Azure portal, with Create target highlighted.":::

1. On the **Create or select target** pane, under **Target exists**, select one of the following options:

   - **Yes, I have already created a target**: Select an existing SQL Managed Instance target.
   - **No, I want to create a new target**: Create a new SQL Managed Instance target.

   :::image type="content" source="media/migrate-to-azure-sql-managed-instance/select-or-create-target.png" alt-text="Screenshot that shows the Create or select target pane.":::

1. Fill in the required information for the SQL Managed Instance target. Then use either **Select target** or **Create target** to proceed to the next step based on your **Target exists** selection.
    1. If you already have an instance as a target, choosing **Select target** takes you to the **Database migration (preview)** pane for your SQL Server instance. The instance name is populated as the selected target. Then you can proceed to the **Migrate data** step.
    1. If you chose to create a new instance, you're guided to the **Create Azure SQL Managed Instance** pane on the **Database migration (preview)** pane to create the target instance. After you finish, check the progress of the deployment on the **Database migration (preview)** pane for your SQL Server instance. The target name populates in the **Target** tile. Then you can proceed to the **Migrate data** step.

### Migrate data

After your target is ready, start the migration process.

1. On the **Database migration (preview)** pane, select **Migrate data**.

1. On the **New data migration** pane, choose the migration option that suits your business needs, and then use **Select** to proceed to the next pane:

   - **Managed Instance link**: Use **Migrate using real-time replication (online)**
   - **LRS**: Use **Migrate using log shipping (online)**

   :::image type="content" source="media/migrate-to-azure-sql-managed-instance/migrate-data.png" alt-text="Screenshot that shows the migration home page, with migrate data selected.":::

   If you're still choosing between the two migration methods, check the [comparison page](/azure/azure-sql/managed-instance/log-replay-service-compare-mi-link) to help you decide.

1. On the **Data source** tab, choose the databases that you want to migrate.
1. On the **Settings** tab, configure the migration settings based on the method that you selected.

1. On the **Review + create** tab, review the settings. Select **Start data migration** to migrate your data to your SQL Managed Instance target.

> [!NOTE]
> Starting the data migration process when you use the Managed Instance link grants more [just-in-time permissions](configure-windows-accounts-agent.md#create-managed-instance-link-migration) until the distributed availability group is created.

### Monitor and cutover

After you start your migration, you can monitor the progress. On the **Database migration (preview)** pane, select **Monitor migrations**.

The **Monitor and cutover** pane shows useful information about the migration process, such as:

- The databases that successfully migrated and the databases that are still in progress.
- The chosen migration method.
- The target instance and target database.
- The duration of the current migration of each database.
- The time when the migration started.

You can pause, resume, or cancel the migration from the **Monitor and cutover** pane. You can also view logs for information about the migration. Selecting a database takes you to a pane with more details about the source and target.

After the migration has finished, the migration status shows **Ready for cutover**. To cut over to the SQL Managed Instance target, select **Cutover** on the **Monitor and cutover** pane. You can also use the database details pane.

Select **Cutover** to open the **Cutover** pane and see different options based on the migration method that you selected.

> [!NOTE]
> [Completing the cutover](configure-windows-accounts-agent.md#complete-cutover-of-managed-instance-link-migration) or [canceling the migration](configure-windows-accounts-agent.md#cancel-managed-instance-link-migration) when you use the Managed Instance link grants more just-in-time permissions until the link is removed or the migration is canceled.

## Limitations

The limitations of the [Managed Instance link](/azure/azure-sql/managed-instance/managed-instance-link-feature-overview#limitations) and [LRS](/azure/azure-sql/managed-instance/log-replay-service-migrate#limitations) apply to migrations through the Azure portal.

Monitoring the migration through the Azure portal is available only to SQL Server instances that meet monitoring [licensing requirements](sql-monitoring.md#prerequisites).

## Related content

- [Assessment rules for SQL Server to Azure SQL Managed Instance migration](/azure/azure-sql/migration-guides/managed-instance/sql-server-to-sql-managed-instance-assessment-rules)
- [Assessment rules for SQL Server to Azure SQL Database migration](/azure/azure-sql/migration-guides/database/sql-server-to-sql-database-assessment-rules)
- [Migrate SQL Server to Azure SQL](/azure/dms/dms-overview)
- [SQL Server enabled by Azure Arc](overview.md)
- [Deployment options for SQL Server enabled by Azure Arc](deployment-options.md)
