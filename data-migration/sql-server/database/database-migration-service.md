---
title: "Tutorial: Migrate SQL Server to Azure SQL Database (Offline)"
titleSuffix: Azure Database Migration Service
description: Learn how to migrate on-premises SQL Server to Azure SQL Database offline by using Azure Database Migration Service.
author: abhims14
ms.author: abhishekum
ms.reviewer: randolphwest, mathoma
ms.date: 08/01/2025
ms.service: azure-database-migration-service
ms.topic: tutorial
ms.collection:
  - sql-migration-content
  - migration
  - onprem-to-azure
ms.custom: sfi-image-nochange
---

# Tutorial: Migrate SQL Server to Azure SQL Database (offline)

You can use Azure Database Migration Service via the Azure SQL migration extension for Azure Data Studio, or the Azure portal, to migrate databases from an on-premises instance of SQL Server to Azure SQL Database (offline).

In this tutorial, learn how to migrate the sample `AdventureWorks2022` database from an on-premises instance of SQL Server to Azure SQL Database, by using Database Migration Service. This tutorial uses offline migration mode, which considers an acceptable downtime during the migration process.

In this tutorial, you learn how to:
> [!div class="checklist"]
> - Open the Migrate to Azure SQL wizard in Azure Data Studio
> - Run an assessment of your source SQL Server databases
> - Collect performance data from your source SQL Server instance
> - Get a recommendation of the Azure SQL Database SKU that will work best for your workload
> - Create an instance of Azure Database Migration Service
> - Start your migration and monitor progress to completion

> [!IMPORTANT]  
> Currently, *online* migrations for Azure SQL Database targets aren't available with Azure Database Migration Service. In an *offline* migration, application downtime starts when the migration starts. Testing an offline migration is recommended to determine whether the downtime is acceptable.

## Migration options

The following section describes how to use Azure Database Migration Service with the Azure SQL migration extension, or in the Azure portal.

## [Migrate using Azure SQL migration extension](#tab/azure-data-studio)

### Prerequisites

To complete this tutorial, you need the following prerequisites:

- [Download and install Azure Data Studio](/azure-data-studio/download-azure-data-studio).
- [Install the Azure SQL migration extension](/azure-data-studio/extensions/azure-sql-migration-extension) from Azure Data Studio Marketplace.
- Make sure that the [**Microsoft.DataMigration** resource provider is registered in your subscription](/azure/dms/quickstart-create-data-migration-service-portal#register-the-resource-provider).
- Have an Azure account that's assigned to one of the following built-in roles:

  - Contributor for the target Azure SQL Database
  - Reader role for the Azure resource group that contains the target Azure SQL Database
  - Owner or Contributor role for the Azure subscription (required if you create a new instance of Azure Database Migration Service)

  As an alternative to using one of these built-in roles, you can [assign a custom role](custom-roles.md).

  > [!IMPORTANT]  
  > An Azure account is required only when you configure the migration steps. An Azure account isn't required for the assessment or to view Azure recommendations in the migration wizard in Azure Data Studio.

- Create a target [Azure SQL Database](/azure/azure-sql/database/single-database-create-quickstart).

- Make sure that the SQL Server login that connects to the source SQL Server instance is a member of the **db_datareader** role and that the login for the target SQL Server instance is a member of the **db_owner** role.

- To migrate the database schema from the source to the target Azure SQL Database by using the Database Migration Service, the minimum supported [SHIR version](https://www.microsoft.com/download/details.aspx?id=39717) required is 5.37 or above.

- For schema migration, minimum permissions on the source SQL Server is **db_owner** to access the database and on the target Azure SQL Database, the user should be member of the all the **server level roles** in the following table:

| Roles | Description |
| --- | --- |
| **##MS_DatabaseManager##** | Members of the **##MS_DatabaseManager##** fixed server role can create and delete databases. A member of the **##MS_DatabaseManager##** role that creates a database becomes the owner of that database, which allows that user to connect to that database as the dbo user. The dbo user has all database permissions in the database. Members of the **##MS_DatabaseManager##** role don't necessarily have permission to access databases that they don't own. It's recommended to use this server role over the **dbmanager** database level role that exists in the `master` database. |
| **##MS_DatabaseConnector##** | Members of the **##MS_DatabaseConnector##** fixed server role can connect to any database without requiring a user account in the database to connect with. |
| **##MS_DefinitionReader##** | Members of the **##MS_DefinitionReader##** fixed server role can read all catalog views that are covered by `VIEW ANY DEFINITION` on any database on which the member of this role has a user account. |
| **##MS_LoginManager##** | Members of the **##MS_LoginManager##** fixed server role can create and delete logins. It's recommended to use this server role over the **loginmanager** database level role that exists in the `master` database. |

### Prepare the target Azure SQL Database

To create the login and user on the target Azure SQL Database, run the following script on the `master` database:

```sql
CREATE LOGIN testuser WITH PASSWORD = '<password>';

ALTER SERVER ROLE ##MS_DefinitionReader## ADD MEMBER [testuser];
GO

ALTER SERVER ROLE ##MS_DatabaseConnector## ADD MEMBER [testuser];
GO

ALTER SERVER ROLE ##MS_DatabaseManager## ADD MEMBER [testuser];
GO

ALTER SERVER ROLE ##MS_LoginManager## ADD MEMBER [testuser];
GO

CREATE USER testuser FOR LOGIN testuser;
EXECUTE sp_addRoleMember 'dbmanager', 'testuser';
EXECUTE sp_addRoleMember 'loginmanager', 'testuser';
```

Now, you can migrate both the database schema and data using Database Migration Service. You can also use other tools such as the [SQL Server dacpac extension](/azure-data-studio/extensions/sql-server-dacpac-extension) or the [SQL Database Projects extension](/azure-data-studio/extensions/sql-database-project-extension) in Azure Data Studio to migrate the schema before selecting the list of tables to migrate.

> [!NOTE]  
> If no tables exist on the Azure SQL Database target, or no tables are selected before starting the migration, the **Next** button isn't available to initiate the migration. If no table exists on the target, then you must select the schema migration option to move forward.

### Open the Migrate to Azure SQL wizard in Azure Data Studio

To open the Migrate to Azure SQL wizard:

1. In Azure Data Studio, go to **Connections**. Select and connect to your on-premises instance of SQL Server. You also can connect to SQL Server on an Azure virtual machine.

1. Right-click the server connection and select **Manage**:

   :::image type="content" source="media/database-migration-service/azure-data-studio-manage-panel.png" alt-text="Screenshot that shows a server connection and the Manage option in Azure Data Studio.":::

1. In the server menu under **General**, select **Azure SQL Migration**.

   :::image type="content" source="media/database-migration-service/launch-migrate-to-azure-sql-wizard-1.png" alt-text="Screenshot that shows the Azure Data Studio server menu." lightbox="media/database-migration-service/launch-migrate-to-azure-sql-wizard-1.png":::

1. In the Azure SQL Migration dashboard, select **Migrate to Azure SQL** to open the migration wizard.

   :::image type="content" source="media/database-migration-service/launch-migrate-to-azure-sql-wizard-2.png" alt-text="Screenshot that shows the Migrate to Azure SQL wizard." lightbox="media/database-migration-service/launch-migrate-to-azure-sql-wizard-2.png":::

1. On the first page of the wizard, start a new session or resume a previously saved session.

### Run database assessment, collect performance data, and get Azure recommendations

1. In **Step 1: Databases for assessment** in the Migrate to Azure SQL wizard, select the databases you want to assess. Then, select **Next**.

   :::image type="content" source="media/database-migration-service/assessment-database-selection.png" alt-text="Screenshot that shows selecting a database for assessment." lightbox="media/database-migration-service/assessment-database-selection.png":::

1. In **Step 2: Assessment results and recommendations**, complete the following steps:

   1. In **Choose your Azure SQL target**, select **Azure SQL Database**.

      :::image type="content" source="media/database-migration-service/assessment-target-selection.png" alt-text="Screenshot that shows selecting the Azure SQL Database target." lightbox="media/database-migration-service/assessment-target-selection.png":::

   1. Select **View/Select** to view the assessment results.

      :::image type="content" source="media/database-migration-service/assessment.png" alt-text="Screenshot that shows view/select assessment results." lightbox="media/database-migration-service/assessment.png":::

   1. In the assessment results, select the database, and then review the assessment report to make sure there are no issues found.

      :::image type="content" source="media/database-migration-service/assessment-issues-details.png" alt-text="Screenshot that shows the assessment report.":::

   1. Select **Get Azure recommendation** to open the recommendations pane.

      :::image type="content" source="media/database-migration-service/get-azure-recommendation.png" alt-text="Screenshot that shows Azure recommendations." lightbox="media/database-migration-service/get-azure-recommendation.png":::

   1. Select **Collect performance data now**. Select a folder on your local computer to store the performance logs, and then select **Start**.

      :::image type="content" source="media/database-migration-service/get-azure-recommendation-zoom.png" alt-text="Screenshot that shows performance data collection.":::

      Azure Data Studio collects performance data until you either stop data collection or you close Azure Data Studio.

      After 10 minutes, Azure Data Studio indicates that a recommendation is available for Azure SQL Database. After the first recommendation is generated, you can select **Restart data collection** to continue the data collection process and refine the SKU recommendation. An extended assessment is especially helpful if your usage patterns vary over time.

      :::image type="content" source="media/database-migration-service/get-azure-recommendation-collected.png" alt-text="Screenshot that shows performance data collected." lightbox="media/database-migration-service/get-azure-recommendation-collected.png":::

   1. In the selected **Azure SQL Database** target, select **View details** to open the detailed SKU recommendation report:

      :::image type="content" source="media/database-migration-service/get-azure-recommendation-view-details.png" alt-text="Screenshot that shows the View details link for the target database recommendations." lightbox="media/database-migration-service/get-azure-recommendation-view-details.png":::

   1. On **Azure SQL Database Recommendations**, review the recommendation. To save a copy of the recommendation, select **Save recommendation report**.

      :::image type="content" source="media/database-migration-service/azure-sku-recommendation-zoom.png" alt-text="Screenshot that shows SKU recommendation details.":::

1. Select **Close** to close the recommendations pane.

1. Select **Next** to continue your database migration in the wizard.

### Configure migration settings

1. In **Step 3: Azure SQL target** in the Migrate to Azure SQL wizard, complete the following steps for your target Azure SQL Database instance:

   1. Select your Azure account, Azure subscription, the Azure region or location, and the resource group that contains the Azure SQL Database deployment.

      :::image type="content" source="media/database-migration-service/configuration-azure-target-account.png" alt-text="Screenshot that shows Azure account details." lightbox="media/database-migration-service/configuration-azure-target-account.png":::

   1. Under **Azure SQL Database Server**, select the target logical Azure SQL Database server. Enter a username and password for the target database deployment. Then, select **Connect**. Enter the credentials to verify connectivity to the target database.

      :::image type="content" source="media/database-migration-service/configuration-azure-target-database.png" alt-text="Screenshot that shows Azure SQL Database details." lightbox="media/database-migration-service/configuration-azure-target-database.png":::

   1. Next, map the source database and the target database for the migration. For **Target database**, select the Azure SQL Database target. Then, select **Next** to move to the next step in the migration wizard.

      :::image type="content" source="media/database-migration-service/configuration-azure-target-map.png" alt-text="Screenshot that shows source and target mapping." lightbox="media/database-migration-service/configuration-azure-target-map.png":::

1. In **Step 4: Migration mode**, select **Offline migration**, and then select **Next**.

   :::image type="content" source="media/database-migration-service/migration-mode.png" alt-text="Screenshot that shows offline migrations selection.":::

1. In **Step 5: Data source configuration**, complete the following steps:

   1. Under **Source credentials**, enter the source SQL Server credentials.

   1. Under **Select tables**, select the **Edit** pencil icon.

      :::image type="content" source="media/database-migration-service/migration-source-credentials.png" alt-text="Screenshot that shows source SQL Server credentials." lightbox="media/database-migration-service/migration-source-credentials.png":::

   1. In **Select tables for \<database-name\>**, select the tables to migrate to the target. The **Has rows** column indicates whether the target table has rows in the target database. You can select one or more tables. Then, select **Update**.

      You can update the list of selected tables anytime before you start the migration.

      In the following example, a text filter is applied to select tables that contain the word `Employee`. Select a list of tables based on your migration needs.

      :::image type="content" source="media/database-migration-service/migration-source-tables.png" alt-text="Screenshot that shows the table selection.":::

1. Review your table selections, and then select **Next** to move to the next step in the migration wizard.

   :::image type="content" source="media/database-migration-service/migration-target-tables.png" alt-text="Screenshot that shows selected tables to migrate." lightbox="media/database-migration-service/migration-target-tables.png":::

> [!NOTE]  
> If no tables are selected or if a username and password aren't entered, the **Next** button isn't available to select.

Now, you can migrate database Schema and data both using Database Migration Service. Also, you can use tools like the [SQL Server dacpac extension](/azure-data-studio/extensions/sql-server-dacpac-extension) or the [SQL Database Projects extension](/azure-data-studio/extensions/sql-database-project-extension) in Azure Data Studio to migrate Schema before selecting the list of tables to migrate.

### Create a Database Migration Service instance

In **Step 6: Azure Database Migration Service** in the Migrate to Azure SQL wizard, create a new instance of Database Migration Service, or reuse an existing instance that you created earlier.

> [!NOTE]  
> If you previously created a Database Migration Service instance by using the Azure portal, you can't reuse the instance in the migration wizard in Azure Data Studio. You can reuse an instance only if you created the instance by using Azure Data Studio.

#### Use an existing instance of Database Migration Service

To use an existing instance of Database Migration Service:

1. In **Resource group**, select the resource group that contains an existing instance of Database Migration Service.

1. In **Azure Database Migration Service**, select an existing instance of Database Migration Service that's in the selected resource group.

1. Select **Next**.

   :::image type="content" source="media/database-migration-service/create-dms.png" alt-text="Screenshot that shows Database Migration Service selection." lightbox="media/database-migration-service/create-dms.png":::

#### Create a new instance of Database Migration Service

To create a new instance of Database Migration Service:

1. In **Resource group**, create a new resource group to contain a new instance of Database Migration Service.

1. Under **Azure Database Migration Service**, select **Create new**.

1. In **Create Azure Database Migration Service**, enter a name for your Database Migration Service instance, and then select **Create**.

1. Under **Set up integration runtime**, complete the following steps:

   1. Select the **Download and install integration runtime** link to open the download link in a web browser. Download the integration runtime, and then install it on a computer that meets the prerequisites for connecting to the source SQL Server instance.

      :::image type="content" source="media/database-migration-service/create-dms-integration-runtime-download.png" alt-text="Screenshot that shows the Download and install integration runtime link.":::

      When installation is finished, Microsoft Integration Runtime Configuration Manager automatically opens to begin the registration process.

   1. In the **Authentication key** table, copy one of the authentication keys that are provided in the wizard and paste it in Azure Data Studio.

      :::image type="content" source="media/database-migration-service/create-dms-integration-runtime-authentication-key.png" alt-text="Screenshot that highlights the authentication key table in the wizard." lightbox="media/database-migration-service/create-dms-integration-runtime-authentication-key.png":::

      If the authentication key is valid, a green check icon appears in Integration Runtime Configuration Manager. A green check indicates that you can continue to **Register**.

      After you register the self-hosted integration runtime, close Microsoft Integration Runtime Configuration Manager.

      > [!NOTE]  
      > For more information about the self-hosted integration runtime, see [Create and configure a self-hosted integration runtime](/azure/data-factory/create-self-hosted-integration-runtime).

1. In **Create Azure Database Migration Service** in Azure Data Studio, select **Test connection** to validate that the newly created Database Migration Service instance is connected to the newly registered self-hosted integration runtime.

   :::image type="content" source="media/database-migration-service/create-dms-integration-runtime-connected.png" alt-text="Screenshot that shows IR connectivity test." lightbox="media/database-migration-service/create-dms-integration-runtime-connected.png":::

1. Return to the migration wizard in Azure Data Studio.

### Start the database migration

In **Step 7: Summary** in the Migrate to Azure SQL wizard, review the configuration you created, and then select **Start migration** to start the database migration.

:::image type="content" source="media/database-migration-service/summary-start-migration.png" alt-text="Screenshot that shows how to start migration.":::

### Monitor the database migration

1. In Azure Data Studio, in the server menu under **General**, select **Azure SQL Migration** to go to the dashboard for your Azure SQL Database migrations.

   Under **Database migration status**, you can track migrations that are in progress, completed, and failed (if any), or you can view all database migrations.

   :::image type="content" source="media/database-migration-service/monitor-migration-dashboard.png" alt-text="Screenshot that shows monitor migration dashboard." lightbox="media/database-migration-service/monitor-migration-dashboard.png":::

1. Select **Database migrations in progress** to view active migrations.

   To get more information about a specific migration, select the database name.

   :::image type="content" source="media/database-migration-service/monitor-migration-dashboard-details.png" alt-text="Screenshot that shows database migration details." lightbox="media/database-migration-service/monitor-migration-dashboard-details.png":::

   Database Migration Service returns the latest known migration status each time migration status refreshes. The following table describes possible statuses:

   | Status | Description |
   | --- | --- |
   | **Preparing for copy** | The service is disabling autostats, triggers, and indexes in the target table. |
   | **Copying** | Data is being copied from the source database to the target database. |
   | **Copy finished** | Data copy is finished. The service is waiting on other tables to finish copying to begin the final steps to return tables to their original schema. |
   | **Rebuilding indexes** | The service is rebuilding indexes on target tables. |
   | **Succeeded** | All data is copied and the indexes are rebuilt. |

1. Check the migration details page to view the current status for each database.

   Here's an example of the `AdventureWorks2022` database migration with the status **Creating**:

   :::image type="content" source="media/database-migration-service/monitor-migration-dashboard-creating.png" alt-text="Screenshot that shows a creating migration status." lightbox="media/database-migration-service/monitor-migration-dashboard-creating.png":::

1. In the menu bar, select **Refresh** to update the migration status.

   After migration status is refreshed, the updated status for the example `AdventureWorks2022` database migration is **In progress**:

   :::image type="content" source="media/database-migration-service/monitor-migration-dashboard-in-progress.png" alt-text="Screenshot that shows a migration in progress status." lightbox="media/database-migration-service/monitor-migration-dashboard-in-progress.png":::

1. Select a database name to open the table view. In this view, you see the current status of the migration, the number of tables that currently are in that status, and a detailed status of each table.

   :::image type="content" source="media/database-migration-service/monitor-migration-monitoring-panel-in-progress.png" alt-text="Screenshot that shows monitoring table migration." lightbox="media/database-migration-service/monitor-migration-monitoring-panel-in-progress.png":::

   When all table data is migrated to the Azure SQL Database target, Database Migration Service updates the migration status from **In progress** to **Succeeded**.

   :::image type="content" source="media/database-migration-service/monitor-migration-monitoring-panel-succeeded.png" alt-text="Screenshot that shows succeeded migration." lightbox="media/database-migration-service/monitor-migration-monitoring-panel-succeeded.png":::

> [!NOTE]  
> Database Migration Service optimizes migration by skipping tables with no data (0 rows). Tables that don't have data don't appear in the list, even if you select the tables when you create the migration.

You've completed the migration to Azure SQL Database. We encourage you to go through a series of post-migration tasks to ensure that everything functions smoothly and efficiently.

> [!IMPORTANT]  
> Be sure to take advantage of the advanced cloud-based features of Azure SQL Database. The features include [built-in high availability](/azure/azure-sql/database/high-availability-sla), [threat detection](/azure/azure-sql/database/azure-defender-for-sql), and [monitoring and tuning your workload](/azure/azure-sql/database/monitor-tune-overview).

## [Migrate using Azure portal](#tab/portal)

### Prerequisites

Before you begin the tutorial:

- Ensure that you can access the [Azure portal](https://portal.azure.com).
- Make sure that the [**Microsoft.DataMigration** resource provider is registered in your subscription](/azure/dms/quickstart-create-data-migration-service-portal#register-the-resource-provider).

- Have an Azure account that's assigned to one of the following built-in roles:
  - Contributor for the target Azure SQL Database
  - Reader role for the Azure resource group that contains the target Azure SQL Database
  - Owner or Contributor role for the Azure subscription (required if you create a new instance of Azure Database Migration Service)

  As an alternative to using one of these built-in roles, you can [assign a custom role](custom-roles.md).

- Create a target [Azure SQL Database](/azure/azure-sql/database/single-database-create-quickstart).

- Make sure that the SQL Server login that connects to the source SQL Server instance is a member of the **db_datareader** role, and that the login for the target SQL Server instance is a member of the **db_owner** role.

- To migrate the database Schema from the source to the target Azure SQL Database by using the Database Migration Service, the minimum supported [SHIR version](https://www.microsoft.com/download/details.aspx?id=39717) required is 5.37 or above.

- For schema migration, minimum permissions on the source SQL Server is **db_owner** to access the database and on the target Azure SQL Database, the user should be member of the all the **server level roles** in the following table:

| Roles | Description |
| --- | --- |
| **##MS_DatabaseManager##** | Members of the **##MS_DatabaseManager##** fixed server role can create and delete databases. A member of the **##MS_DatabaseManager##** role that creates a database becomes the owner of that database, which allows that user to connect to that database as the dbo user. The dbo user has all database permissions in the database. Members of the **##MS_DatabaseManager##** role don't necessarily have permission to access databases that they don't own. It's recommended to use this server role over the **dbmanager** database level role that exists in the `master` database. |
| **##MS_DatabaseConnector##** | Members of the **##MS_DatabaseConnector##** fixed server role can connect to any database without requiring a user account in the database to connect with. |
| **##MS_DefinitionReader##** | Members of the **##MS_DefinitionReader##** fixed server role can read all catalog views that are covered by `VIEW ANY DEFINITION` on any database on which the member of this role has a user account. |
| **##MS_LoginManager##** | Members of the **##MS_LoginManager##** fixed server role can create and delete logins. It's recommended to use this server role over the **loginmanager** database level role that exists in the `master` database. |

### Prepare the target Azure SQL Database

To create the login and user on the target Azure SQL Database, run the following script on the `master` database:

```sql
CREATE LOGIN testuser WITH PASSWORD = '<password>';

ALTER SERVER ROLE ##MS_DefinitionReader## ADD MEMBER [testuser];
GO

ALTER SERVER ROLE ##MS_DatabaseConnector## ADD MEMBER [testuser];
GO

ALTER SERVER ROLE ##MS_DatabaseManager## ADD MEMBER [testuser];
GO

ALTER SERVER ROLE ##MS_LoginManager## ADD MEMBER [testuser];
GO

CREATE USER testuser FOR LOGIN testuser;
EXECUTE sp_addRoleMember 'dbmanager', 'testuser';
EXECUTE sp_addRoleMember 'loginmanager', 'testuser';
```

Now, you can migrate both the database schema and data using Database Migration Service. You can also use other tools such as the [SQL Server dacpac extension](/azure-data-studio/extensions/sql-server-dacpac-extension) or the [SQL Database Projects extension](/azure-data-studio/extensions/sql-database-project-extension) in Azure Data Studio to migrate the schema before selecting the list of tables to migrate.

> [!NOTE]  
> If no tables exist on the Azure SQL Database target, or no tables are selected before starting the migration, the **Next** button isn't available to initiate the migration. If no table exists on the target, then you must select the schema migration option to move forward.

### Create a Database Migration Service instance

[!INCLUDE [create-database-migration-service-instance](../../includes/create-database-migration-service-instance.md)]

### Start a new migration

1. To start a new migration, go to [Azure Database Migration Service](https://portal.azure.com) in the Azure portal, and either use **+Create** to create a new instance of Database Migration Service, or select an existing instance, and then go to your Azure Database Migration Service instance.

1. On the **Overview** pane of your Azure Database Migration Service instance, select **New migration**:

   :::image type="content" source="media/database-migration-service/dms-portal-sql-database-dashboard-4-new.png" alt-text="Screenshot of Azure Database Migration Dashboard." lightbox="media/database-migration-service/dms-portal-sql-database-dashboard-4-new.png":::

1. Under **Select new migration** scenario, choose your source, target server type, migration mode and choose **Select**.

   :::image type="content" source="media/database-migration-service/dms-portal-sql-database-scenario-new.png" alt-text="Screenshot of select new migration scenario." lightbox="media/database-migration-service/dms-portal-sql-database-scenario-new.png":::

1. On the **Azure SQL Database Offline Migration Wizard**, follow these steps:

   1. On the **Source details** tab, enter details for the source SQL Server instance, and then select **Next: Connect to source SQL Server**:

      :::image type="content" source="media/database-migration-service/dms-portal-sql-database-source-1-new.png" alt-text="Screenshot of Source Tracking." lightbox="media/database-migration-service/dms-portal-sql-database-source-1-new.png":::

   1. On the **Connect to source SQL Server** tab, provide connection details and then select **Next: Select databases for migration**:

      :::image type="content" source="media/database-migration-service/dms-portal-sql-database-source-2-new.png" alt-text="Screenshot of Connect to source." lightbox="media/database-migration-service/dms-portal-sql-database-source-2-new.png":::

   1. On the **Select databases for migration** tab, check the box next to the databases you want to migrate. Populating the list of databases can take some time. Select **Next: Connect to target Azure SQL Database**.

      :::image type="content" source="media/database-migration-service/dms-portal-sql-database-select-db-1-new.png" alt-text="Screenshot of select db." lightbox="media/database-migration-service/dms-portal-sql-database-select-db-1-new.png":::

   1. On the **Connect to target Azure SQL Database** tab, provide connection details and then select **Next: Map source and target databases**:

      :::image type="content" source="media/database-migration-service/dms-portal-sql-database-connect-target-1-new.png" alt-text="Screenshot of connect target." lightbox="media/database-migration-service/dms-portal-sql-database-connect-target-1-new.png":::

   1. On the **Map source and target databases** tab, map the databases between the source and target.

      :::image type="content" source="media/database-migration-service/dms-portal-sql-database-map-db-1-new.png" alt-text="Screenshot of Map databases." lightbox="media/database-migration-service/dms-portal-sql-database-map-db-1-new.png":::

   1. (Optional) Check the box next to **Migrate Missing schema** to deploy missing schema objects from the source to the Azure SQL Database target to migrate the following schema objects with a *single checkbox*:

      - Schemas
      - Tables (selected)
      - Indexes
      - Views
      - Stored procedures (StoredProcedures)
      - Synonyms
      - DDL triggers (DdlTriggers)
      - Defaults
      - Full text catalogs (FullTextCatalogs)
      - Plan guides (PlanGuides)
      - Roles
      - Rules
      - Application roles (ApplicationRoles)
      - User defined aggregates (UserDefinedAggregates)
      - User defined data types (UserDefinedDataTypes)
      - User defined functions (UserDefinedFunctions)
      - User defined table types (UserDefinedTableTypes)
      - User defined types (UserDefinedTypes)
      - Users* (not every user type)
      - XmlSchemaCollections

      > [!NOTE]  
      > - If you select **Migrate Missing Schema**, the Database Migration service performs the schema migration before data is migrated.
      > - DMS proceeds with the data migration phase even if schema migration encounters errors, unless there are issues with table objects.

      Next, either use **Select all tables** to migrate all tables, or use the text entry box to filter the list of tables and select individual tables to migrate. Then select **Next: Database migration summary**.

      :::image type="content" source="media/database-migration-service/dms-portal-sql-database-select-schema-table-new.png" alt-text="Screenshot of select schema and tables." lightbox="media/database-migration-service/dms-portal-sql-database-select-schema-table-new.png":::

   1. On the **Database migration summary** tab, review the details and then select **Start migration**, which starts database migration and automatically takes you back to the Database Migration Service dashboard.

      :::image type="content" source="media/database-migration-service/dms-portal-sql-database-summary-new.png" alt-text="Screenshot of Summary." lightbox="media/database-migration-service/dms-portal-sql-database-summary-new.png":::

      > [!NOTE]  
      > For an offline migration, application downtime starts when the migration starts.

### Monitor the database migration

1. To monitor your database migration, on the **Overview** pane of your Database Migration Service instance, select **Monitor migrations**.

   :::image type="content" source="media/database-migration-service/dms-portal-sql-database-dashboard-4-new.png" alt-text="Screenshot of Azure Database Migration Service overview in the Azure portal." lightbox="media/database-migration-service/dms-portal-sql-database-dashboard-4-new.png":::

1. Under the **Migrations** tab, you can track migrations that are in progress, completed, and failed (if any), or you can view all database migrations. In the menu bar, select **Refresh** to update the migration status.

   :::image type="content" source="media/database-migration-service/dms-portal-sql-database-dashboard-3-new.png" alt-text="Screenshot of DMS dashboard monitoring." lightbox="media/database-migration-service/dms-portal-sql-database-dashboard-3-new.png":::

   Database Migration Service returns the latest known migration status each time migration status refreshes. The following table describes possible statuses:

   | Status | Description |
   | --- | --- |
   | **Creating** | The service is starting the migration. |
   | **Preparing for copy** | The service is disabling autostats, triggers, and indexes in the target table. |
   | **Copying** | Data is being copied from the source database to the target database. |
   | **Copy finished** | Data copy is finished. The service is waiting on other tables to finish copying to begin the final steps to return tables to their original schema. |
   | **Rebuilding indexes** | The service is rebuilding indexes on target tables. |
   | **Succeeded** | All data is copied and the indexes are rebuilt. |

1. Under **Source name**, select a database name to open the table view.. In this detailed view, you see the current status of the migration, the number of tables that currently are in that status, and a detailed status of each table:

   :::image type="content" source="media/database-migration-service/dms-portal-sql-database-monitoring-1-new.png" alt-text="Screenshot of Detailed migration monitoring." lightbox="media/database-migration-service/dms-portal-sql-database-monitoring-1-new.png":::

1. When all table data is migrated to the Azure SQL Database target, Database Migration Service updates the migration status from **In progress** to **Succeeded**.

   :::image type="content" source="media/database-migration-service/dms-portal-sql-database-monitoring-2-new.png" alt-text="Screenshot of Detailed migration success." lightbox="media/database-migration-service/dms-portal-sql-database-monitoring-2-new.png":::

> [!NOTE]  
> Database Migration Service optimizes migration by skipping tables with no data (0 rows). Tables that don't have data don't appear in the list, even if you selected the tables when you created the migration.

You've completed the migration to Azure SQL Database. Go through a series of post-migration tasks to ensure that everything functions smoothly and efficiently.

---

## Limitations

Azure SQL Database offline migration utilizes Azure Data Factory (ADF) pipelines for data movement and thus abides by ADF limitations. A corresponding ADF is created when a database migration service is also created. Thus factory limits apply per service.

- The machine where the SHIR is installed acts as the compute for migration. Make sure this machine can handle the cpu and memory load of the data copy. To learn more, review [Create and configure a self-hosted integration runtime](/azure/data-factory/create-self-hosted-integration-runtime).
- 100,000 table per database limit.
- 10,000 concurrent database migrations per service.
- Migration speed heavily depends on the target Azure SQL Database SKU and the self-hosted Integration Runtime host.
- Azure SQL Database migration scales poorly with table numbers due to ADF overhead in starting activities. If a database has thousands of tables, the startup process of each table might take a couple of seconds, even if they're composed of one row with 1 bit of data.
- Azure SQL Database table names with double-byte characters currently aren't supported for migration. Mitigation is to rename tables before migration; they can be changed back to their original names after successful migration.
- Tables with large blob columns might fail to migrate due to timeout.
- Database names with SQL Server reserved are currently not supported.
- Database names that include semicolons are currently not supported.
- Computed columns don't get migrated.
- Columns in the source database that have default constraints and contain `NULL` values, are migrated with their defined default values on the target Azure SQL database, rather than retaining the NULLs.

## Related content

- [Quickstart: Create a single database - Azure SQL Database](/azure/azure-sql/database/single-database-create-quickstart)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [Azure SQL Database and Azure SQL Managed Instance connect and query articles](/azure/azure-sql/database/connect-query-content-reference-guide)
- [Known issues, limitations, and troubleshooting](/azure/dms/known-issues-azure-sql-migration-azure-data-studio)
