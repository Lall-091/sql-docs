---
title: Migrate to Azure SQL Managed Instance (preview)
description: Migrate your SQL Server enabled by Azure Arc instance to Azure SQL Managed Instance by using the Azure portal.
author: danimir
ms.author: danil
ms.reviewer: mikeray, randolphwest, mathoma
ms.date: 07/16/2025
ms.topic: how-to
---

# Migrate to Azure SQL Managed Instance (preview) - SQL Server enabled by Azure Arc

[!INCLUDE [sqlserver](../../includes/applies-to-version/sqlserver.md)]

This article teaches you how to migrate your SQL Server instance enabled by Azure Arc to [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview) by using Database migration (preview) in the Azure portal. 

> [!NOTE]
> Database migration to Azure SQL Managed Instance through the Azure portal is currently in preview.

## Overview 

Azure SQL Managed Instance is a fully managed lift and shift Platform-as-a-service (PaaS) target to run your SQL Server workloads in the Azure cloud. After you enable your SQL Server instance with Azure Arc, you can assess your SQL Server data estate to identify an optimal SQL Managed Instance configuration, and then migrate your SQL Server databases to Azure SQL Managed Instance directly from the Azure portal.

When your SQL Server instance is enabled with Azure Arc, you can: 
- Evaluate and assess how ready your SQL Server instance is to migrate to Azure SQL Managed Instance. 
- Identify potential migration risks, and learn how to mitigate them.
- Optimize for performance and cost with guidance around service tiers, configuration, and sizing.

Discovery of SQL Server instances and generation of readiness reports happen instantly, automatically and continuously, with no extra configuration or setup required. After you've chosen an appropriate SQL Managed Instance target, and prepared your environment, you can migrate your SQL Server databases to Azure SQL Managed Instance directly from the Azure portal through a fully managed and automated process. 

Database migration (preview) is available by default for all SQL Server instances enabled by Azure Arc, starting with [!INCLUDE [sssql11-md](../../includes/sssql11-md.md)]. 

## Choose integrated migration method 

You can choose the migration method that best fits your needs on the Database migration (preview) page. After some initial configuration, migration is automated for you based on your selection. 

The following methods are built into the migration process:

- [Managed Instance link](/azure/azure-sql/managed-instance/managed-instance-link-feature-overview): Migrate using real-time replication with a distributed availability group (online)
- [Log replay service (LRS)](/azure/azure-sql/managed-instance/log-replay-service-overview): Migrate using log shipping (online)

Review [Compare the MI link with LRS migration methods](/azure/azure-sql/managed-instance/log-replay-service-compare-mi-link) to understand the differences between the two migration options. Choose the option that best suits your needs on the **Migrate data** step of the **Database migration (preview)** page in the Azure portal.

## Prerequisites 

To migrate your SQL Server instance to Azure SQL Managed Instance through the Azure portal, your instance must meet the following prerequisites: 
- [Enabled by Azure Arc](overview.md) starting with the [July 2025 update](release-notes.md#july-2025) to the Azure Extension for SQL Server (1.1.3106.305). 

Requirements for the source SQL Server instance are determined by the migration method you plan to use. For example: 
- [Managed Instance link](/azure/azure-sql/managed-instance/managed-instance-link-feature-overview) supports SQL Server 2016 and later on any supported edition of Windows Server. 
- [Log replay service (LRS)](/azure/azure-sql/managed-instance/log-replay-service-overview) supports SQL Server 2008 and later on any supported edition of Windows Server. 

## Permissions 

This section details the permissions required to migrate your SQL Server instance to Azure SQL Managed Instance through the Azure portal.

On the source SQL Server instance, you must have the following permissions:
- If you've enabled [least privilege](configure-least-privilege.md), necessary permissions, including `sysadmin`, are [granted](configure-windows-accounts-agent.md#database-migration) as needed during the database migration process.
- If you're not able to use least privilege, then you should have **sysadmin** permissions on the source SQL Server instance.

### [MI link](#tab/mi-link)

To migrate with the Managed Instance link, you must have one of the following permissions on the target SQL Managed Instance:
- Azure SQL Managed Instance Contributor role.
- Subscription-level Contributor or Owner.
- For minimum permissions, see [Custom permissions](/azure/azure-sql/managed-instance/managed-instance-link-preparation#permissions).

> [!NOTE]
> Users with the `SqlServerAvailabilityGroups_CreateManagedInstanceLink`, `SqlServerAvailabilityGroups_failoverMiLink`, and `SqlServerAvailabilityGroups_deleteMiLink` permissions in Azure can perform actions on the Database migration (preview) page during the migration process that elevate the SQL Server permissions of the account used by the extension, including the `sysadmin` role.

### [LRS](#tab/lrs)

To migrate with LRS, you must have the one of following permissions on the target SQL Managed Instance:

- Azure SQL Managed Instance Contributor role.
- A role with the following permission: Microsoft.Sql/managedInstances/databases/*.

You must also be able to [authenticate to the Azure blob storage account](/azure/azure-sql/managed-instance/log-replay-service-migrate#authenticate-to-your-blob-storage-account) where your database backups are stored.

---

## Prepare environment for migration 

To use either the link or LRS to migrate your databases, you must first prepare your environment. 

### [MI link](#tab/mi-link)

To use the MI link, follow these steps: 
1. Your SQL Server database must be in full recovery mode, and you must have a recent full backup of your database. For SQL Server instances that meet the [licensing requirement](overview.md#feature-differentiation), you can enable the [automated backups (preview)](backup-local.md) feature, which automatically determines backup qualifications. SQL Server instances that don't support the automated backup feature can still migrate their database through the Managed Instance link, but must manually validate the database is in full recovery mode and take a current full backup.
1. [Prepare your environment](/azure/azure-sql/managed-instance/managed-instance-link-preparation). 
1. [Establish trust between instances](/azure/azure-sql/managed-instance/managed-instance-link-configure-how-to-scripts#establish-trust-between-instances).

### [LRS](#tab/lrs)

To use LRS, you need to [create a storage account](/azure/azure-sql/managed-instance/log-replay-service-migrate#create-a-storage-account) and [create a blob container](/azure/storage/blobs/storage-quickstart-blobs-portal) inside the storage account. 

The remaining steps, such as authentication, are automated.

--- 


## Migrate to Azure SQL Managed Instance 

The following tiles guide you through the migration of your SQL Server databases to Azure SQL Managed Instance:

1. [Assess source instance](#assess-source-instance): Assess your SQL Server instance to determine its readiness to migrate to Azure SQL Managed Instance.
1. [Select target](#select-target): Select an Azure SQL Managed Instance target for your migration. 
1. [Migrate data](#migrate-data): Migrate your SQL Server databases to Azure SQL Managed Instance.
1. [Monitor and cutover](#monitor-and-cutover): Monitor the migration process and cut over to the target Azure SQL Managed Instance.

The following screenshot shows the tiles on the **Database migration (preview)** page for your SQL Server instance in the Azure portal:

:::image type="content" source="media/migrate-to-azure-sql-managed-instance/migration-home-page.png" alt-text="Screenshot of the migration home page for a SQL Server instance in the Azure portal." lightbox="media/migrate-to-azure-sql-managed-instance/migration-home-page.png":::

### Assess source instance 

To assess the source instance, follow these steps: 

1. Go to your [SQL Server instance](https://portal.azure.com/#view/Microsoft_Azure_ArcCenterUX/ArcCenterMenuBlade/~/sqlServerInstances) in the Azure portal.
1. Under **Migration**, select **Database migration (preview)** to open the **Database migration (preview)** pane. Under **Assess source instance**, select **View report** to open the **Assessments** page: 

   :::image type="content" source="media/migrate-to-azure-sql-managed-instance/database-migration-pane.png" alt-text="Screenshot of the database migration page for the SQL Server instance in the Azure portal, with view report highlighted.":::

1. On the **Assessments** page: 
   - Use **Run assessment** to initiate a new assessment, if one hasn't been run recently.
   - Use **View assessment details** in the Azure SQL MI target box to learn more about your assessment results, including the readiness of your SQL Server instance to migrate to Azure SQL Managed Instance, and the recommended service tier and configuration for your target instance.

### Select target

After you assess your SQL Server instance, select a target Azure SQL Managed Instance: 
1. On the **Assessments** page, use **Create target** to open the **Create or select target** page and identify a migration target.

   :::image type="content" source="media/migrate-to-azure-sql-managed-instance/select-target.png" alt-text="Screenshot of the Assessments page in the Azure portal, with create target highlighted.":::

1. On the **Create or select target** page, choose one of the following options under **Target exists**: 
   1. **Yes, I already created a target**: Select an existing Azure SQL Managed Instance target.
   1. **No, I want to create a new target**: Create a new Azure SQL Managed Instance target. 
   
   :::image type="content" source="media/migrate-to-azure-sql-managed-instance/select-or-create-target.png" alt-text="Screenshot of the select or create target page.":::

1. Fill in the required information for the target Azure SQL Managed Instance, and then use either **Select target** or **Create target** to proceed to the next step based on your **Target exists** selection. 
    1. If you already have an instance as a target, choosing **Select target** takes you to the **Database migration (preview)** page for your SQL Server instance, where the instance name is populated as the selected target. You can then proceed to the **Migrate data** step. 
    1. If you chose to create a new instance, you're guided to **Create Azure SQL Managed Instance** page within the **Database migration (preview)** page to create the target instance. Once finished, you can check the progress of the deployment on the **Database migration (preview)** page for your SQL Server instance, and see the target name populated in the **Target** tile. You can then proceed to the **Migrate data** step. 
    
### Migrate data 

After your target is ready, you can start the migration process by selecting **Migrate data** on the **Database migration (preview)** page to go to the **New data migration** page. 

On the **New data migration** page, choose the migration option that suits your business need and then use **Select** to proceed to the next page: 

   - **Managed Instance link**: Migrate using real-time replication (online)
   - **Log Replay Service (LRS)**: Migrate using log shipping (online)

:::image type="content" source="media/migrate-to-azure-sql-managed-instance/migrate-data.png" alt-text="Screenshot of the migration home page, with migrate data selected.":::

If you're still choosing between the two migration methods, check the [comparison page](/azure/azure-sql/managed-instance/log-replay-service-compare-mi-link) to help you decide. 

On the **Data source** tab, choose the databases you want to migrate. On the **Settings** tab, configure the migration settings based on the method you selected. 

Finally, on the **Review + create** tab, review the settings and select **Start data migration** to start migrating your data to your target Azure SQL Managed Instance.

> [!NOTE]
> Starting the data migration process when using the Managed Instance link grants additional [just-in-time permissions](configure-windows-accounts-agent.md#create-managed-instance-link-migration) until the distributed availability group is created.

### Monitor and cutover

After you've started your migration, you can monitor the progress of your migration by selecting **Monitor migrations** on the **Database migration (preview)** page.

The **Monitor and cutover** page shows useful information about the migration process, such as: 
- Which databases have successfully migrated, as well as those that are still in progress.
- The chosen migration method.
- The target instance and target database. 
- The duration of the current migration of each database. 
- When the migration started. 

You can pause, resume, or cancel the migration from the **Monitor and cutover** page, as well as view logs for details about the migration. Selecting a database takes you to a page with more details about the source and target. 

Once the migration is complete, and the migration status shows **Ready for cutover**, you can cut over to the target Azure SQL Managed Instance by selecting **Cutover** from the: 
- **Monitor and Cutover** page.
- Database details page.

Selecting **Cutover** opens the **Cutover** page, with different options based on the migration method you selected. 

> [!NOTE]
> [Completing the cutover](configure-windows-accounts-agent.md#complete-cutover-of-managed-instance-link-migration), or [canceling the migration](configure-windows-accounts-agent.md#cancel-managed-instance-link-migration) when using the Managed Instance link grants additional just-in-time permissions until the link is removed or the migration is canceled. 

## Limitations

The limitations of [Managed Instance link](/azure/azure-sql/managed-instance/managed-instance-link-feature-overview#limitations) and [Log Replay Service (LRS)](/azure/azure-sql/managed-instance/log-replay-service-migrate#limitations) apply to migrations through the Azure portal. 

Monitoring the migration through the Azure portal is only available to SQL Server instances that meet monitoring [licensing requirements](sql-monitoring.md#prerequisites). 

## Related content

- [Assessment rules for SQL Server to Azure SQL Managed Instance migration](/azure/azure-sql/migration-guides/managed-instance/sql-server-to-sql-managed-instance-assessment-rules)
- [Assessment rules for SQL Server to Azure SQL Database migration](/azure/azure-sql/migration-guides/database/sql-server-to-sql-database-assessment-rules)
- [Migrate SQL Server to Azure SQL](/azure/dms/dms-overview)
- [SQL Server enabled by Azure Arc](overview.md)
- [Deployment options for SQL Server enabled by Azure Arc](deployment-options.md)
