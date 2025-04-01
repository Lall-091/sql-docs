---
title: "Migrating Oracle Data into SQL Server (OracleToSQL)"
description: Learn how to migrate data from an Oracle database to SQL Server, after you synchronize the converted objects, by using the SSMA for Oracle application.
author: cpichuka
ms.author: cpichuka
ms.reviewer: randolphwest
ms.date: 04/01/2025
ms.service: sql
ms.subservice: ssma
ms.topic: conceptual
ms.collection:
  - sql-migration-content
ms.custom:
  - intro-migration
f1_keywords:
  - "ssma.oracle.migratedata.f1"
helpviewer_keywords:
  - "Oracle Data Migration, Client-Side Migration"
  - "Oracle Data Migration,Server-Side Migration"
---
# Migrating Oracle Data into SQL Server (OracleToSQL)

After you successfully synchronize the converted objects with [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)], you can migrate data from Oracle to [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] using SQL Server Migration Assistant (SSMA) for Oracle.

> [!IMPORTANT]  
> If the engine being used is Server Side Data Migration Engine, then before you can migrate data, you must install the SSMA for Oracle Extension Pack and the Oracle providers on the computer that is running SSMA. The SQL Server Agent service must also be running. For more information about how to install the extension pack, see [Installing SSMA components on SQL Server (OracleToSQL)](installing-ssma-components-on-sql-server-oracletosql.md).

[!INCLUDE [entra-id](../../includes/entra-id-hard-coded.md)]

## Set migration options

Before migrating data to [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)], review the project migration options in the **Project Settings** dialog box.

In this dialog box, you can set options such as migration batch size, table locking, constraint checking, null value handling, and identity value handling. For more information about the Project Migration Settings, see [Project Settings (Migration)](project-settings-migration-oracletosql.md).

The **Migration Engine** in the **Project Settings** dialog box, allows the user to perform the migration process using two types of data migration engines:

- Client Side Data Migration Engine
- Server Side Data Migration Engine

### Client Side Data Migration

To initiate data-migration on the client side, select the **Client Side Data Migration Engine** option in the **Project Settings** dialog box.

In **Project Settings**, the **Client Side Data Migration Engine** option is set.

> [!NOTE]  
> The **Client-Side Data Migration Engine** resides inside the SSMA application and is, therefore, not dependent on the availability of the extension pack.

### Server Side Data Migration

During the Server side data migration, the engine resides on the target database. It's installed through the extension pack. For more information on how to install the extension pack, see [Installing SSMA components on SQL Server](installing-ssma-components-on-sql-server-oracletosql.md)

To initiate migration on the server side, select the **Server Side Data Migration Engine** option in the **Project Settings** dialog box.

## Migrate Data to SQL Server

Migrating data is a bulk-load operation that moves rows of data from Oracle tables into [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] tables in transactions. The number of rows loaded into [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] in each transaction is configured in the project settings.

To view migration messages, make sure that the Output pane is visible. Otherwise, from the **View** menu, select **Output**.

### Migration process

1. Verify the following requirements:

   - The Oracle providers are installed on the computer that is running SSMA.
   - You have synchronized the converted objects with the [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] database.

1. In Oracle Metadata Explorer, select the objects that contain the data that you want to migrate:

   - To migrate data for all schemas, select the check box next to **Schemas**.

   - To migrate data or omit individual tables, first expand the schema, expand **Tables**, and then select or clear the check box next to the table.

1. To migrate data, two cases arise:

   **Client Side Data Migration:**

   - For performing **Client Side Data Migration**, select the **Client Side Data Migration Engine** option in the **Project Settings** dialog box.

   **Server Side Data Migration:**

   - Before performing data migration on the server side, ensure:

     1. The SSMA for Oracle Extension Pack is installed on the instance of [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)].

     1. The SQL Server Agent service is running on the instance of SQL Server.

   - For performing **Server Side Data Migration**, select the **Server Side Data Migration Engine** option in the **Project Settings** dialog box.

1. Right-click **Schemas** in Oracle Metadata Explorer, and then select **Migrate Data**. You can also migrate data for individual objects or categories of objects: Right-click the object or its parent folder; select the **Migrate Data** option.

   If the SSMA for Oracle Extension Pack isn't installed on the instance of [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)], and if **Server Side Data Migration Engine** is selected, then while migrating the data to the target database, you receive the following error:

   ```output
   SSMA Data Migration components were not found on SQL Server, server-side data migration will not be possible. Please check if Extension Pack is installed correctly.
   ```

   Select **Cancel** to terminate the data migration.

1. In the **Connect to Oracle** dialog box, enter the connection credentials, and then select **Connect**. For more information on connecting to Oracle, see [Connect to Oracle](connect-to-oracle-oracletosql.md)

   For connecting to the target database [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)], enter the connection credentials in the **Connect to SQL Server** dialog box, and select **Connect**. For more information on connecting to [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)], see [Connecting to SQL Server](../oracle/connecting-to-sql-server-oracletosql.md).

   Messages appear in the **Output** pane. When the migration is complete, the **Data Migration Report** appears. If any data didn't migrate, select the row that contains the errors, and then select **Details**. When you're finished with the report, select **Close**. For more information on Data Migration Report, see [Data Migration Report](../oracle/data-migration-report-oracletosql.md).

> [!NOTE]  
> When SQL Express edition is used as the target database, only client side data migration is allowed and server side data migration isn't supported.

## Migrate data at scale (preview)

When large data size needs to be migrated within a short duration, at scale offline migration is a suitable option. This feature uses Azure Data Migration Service (DMS) in the backend, and the scalability of cloud to migrate on-premises or external Oracle data source to Azure SQL platform, whether using a virtual machine (IaaS VM) or Azure SQL (PaaS). You can create a new DMS service, or use an existing DMS service to migrate data to Azure SQL PaaS or SQL Server on Azure VM.

1. For large offline migration, select **Migrate data with DMS (preview)**.

1. Provide Microsoft Entra account for authentication. Once you enter the username, select **Connect**.

1. Select the tenant and the subscription that already has the SQL Server on Azure VM, Azure SQL database, or SQL managed instance configured, and select **Next**.

1. In the next step of the migration workflow, you can provide the data source, target database, and associated credentials.

1. When you select your Azure resource, you can use existing resources by selecting the resource group and the data migration service name, or select **New** to create a resource group and Azure migration service for migration.

1. In order to migrate an external data source, an integration runtime is required. Either select new and follow the steps to create the integration runtime or use an existing integration service. To create an integration service, a gateway installation needs to be configured and a key needs to be supplied to configure integration runtime.

1. The Monitor Migrations Wizard automatically opens within a few seconds of initiating the data migration. Select **View** under the activity you wish to monitor, to view a live migration status. You can also view the comprehensive report, which takes you to the Azure portal for more granular monitoring details about the migration activity. You can access the wizard with the **Monitoring** button next to **Migrate data with DMS(preview)**.

## Related content

- [Migrate Oracle Databases to SQL Server (OracleToSQL)](migrating-oracle-databases-to-sql-server-oracletosql.md)
