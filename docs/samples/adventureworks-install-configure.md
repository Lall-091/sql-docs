---
title: AdventureWorks Sample Databases
description: Follow these instructions to download and install AdventureWorks sample databases to SQL Server.
author: MashaMSFT
ms.author: mathoma
ms.reviewer: randolphwest
ms.date: 08/25/2025
ms.service: sql
ms.subservice: samples
ms.topic: concept-article
---

# AdventureWorks sample databases

[!INCLUDE [SQL Server Azure SQL Database Synapse Analytics PDW](../includes/applies-to-version/sql-asdb-asdbmi-asa-pdw.md)]

This article provides direct links for downloading `AdventureWorks` sample databases and instructions for restoring them to SQL Server, Azure SQL Database, and Azure SQL Managed Instance.

For more information about samples, see the [Samples GitHub repository](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases).

## Prerequisites

- [SQL Server](https://www.microsoft.com/evalcenter/evaluate-sql-server-2022) or [Azure SQL Database](https://azure.microsoft.com/services/sql-database/)
- [SQL Server Management Studio](../ssms/download-sql-server-management-studio-ssms.md) (SSMS) or [Azure Data Studio](/azure-data-studio/download-azure-data-studio)

## Download backup files

Use these links to download the appropriate sample database for your scenario.

- **OLTP** data is for most typical online transaction processing workloads.
- **Data Warehouse (DW)** data is for data warehousing workloads.
- **Lightweight (LT)** data is a lightweight and pared down version of the **OLTP** sample.

If you're not sure what you need, start with the OLTP version that matches your SQL Server version.

| OLTP | Data Warehouse | Lightweight |
| --- | --- | --- |
| [AdventureWorks2022.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak) | [AdventureWorksDW2022.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2022.bak) | [AdventureWorksLT2022.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2022.bak) |
| [AdventureWorks2019.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak) | [AdventureWorksDW2019.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2019.bak) | [AdventureWorksLT2019.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2019.bak) |
| [AdventureWorks2017.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak) | [AdventureWorksDW2017.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2017.bak) | [AdventureWorksLT2017.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2017.bak) |
| [AdventureWorks2016.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2016.bak) | [AdventureWorksDW2016.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2016.bak) | [AdventureWorksLT2016.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2016.bak) |
| [AdventureWorks2016_EXT.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2016_EXT.bak) | [AdventureWorksDW2016_EXT.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2016_EXT.bak) | N/A |
| [AdventureWorks2014.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2014.bak) | [AdventureWorksDW2014.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2014.bak) | [AdventureWorksLT2014.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2014.bak) |
| [AdventureWorks2012.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2012.bak) | [AdventureWorksDW2012.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2012.bak) | [AdventureWorksLT2012.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksLT2012.bak) |
| [AdventureWorks2008R2.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks2008r2/adventure-works-2008r2-oltp.bak) | [AdventureWorksDW2008R2.bak](https://github.com/microsoft/sql-server-samples/releases/download/adventureworks2008r2/adventure-works-2008r2-dw.bak) | N/A |

You can find additional files on GitHub:

- [SQL Server 2014 - 2022](https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks)
- [SQL Server 2012](https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks2012)
- [SQL Server 2008 and 2008 R2](https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks2008r2)

## Restore to SQL Server

You can use the `.bak` file to restore your sample database to your [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] instance. You can do so by using the [RESTORE statements](../t-sql/statements/restore-statements-transact-sql.md) command or by using the graphical interface (GUI) in [SSMS](../ssms/download-sql-server-management-studio-ssms.md) or [Azure Data Studio](/azure-data-studio/download-azure-data-studio).

# [SSMS](#tab/ssms)

If you're not familiar with using SSMS, you can review [Connect and query using SSMS](../ssms/quickstarts/ssms-connect-query-sql-server.md) to get started.

To restore your database in SSMS, follow these steps:

1. Download the appropriate `.bak` file from one of links provided in the [Download backup files](#download-backup-files) section of this article.
1. Move the `.bak` file to your [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] backup location. This location varies depending on your installation location, instance name, and version of [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)]. For example, the default location for a default instance of [!INCLUDE [sssql22-md](../includes/sssql22-md.md)] is:

   ```output
   C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup
   ```

1. Open SSMS and connect to your [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] instance.
1. Right-click **Databases** in **Object Explorer** and then select **Restore Database...** to start the **Restore Database** wizard.

   :::image type="content" source="media/adventureworks-install-configure/restore-db-ssms.png" alt-text="Screenshot showing the steps for starting the Restore Database wizard.":::

1. Select **Device**, and then select the ellipsis (**...**) to choose a device.
1. Select **Add**, and then choose the `.bak` file you recently moved to the backup location. If you moved your file to this location but you don't see it in the wizard, [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] or the user signed into [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] doesn't have permission to this file in this folder.
1. Select **OK** to confirm your database backup selection and close the **Select backup devices** window.
1. Check the **Files** tab to confirm that the **Restore as** location and file names match your intended location and file names in the **Restore Database** wizard.
1. Select **OK** to restore your database.

   :::image type="content" source="media/adventureworks-install-configure/restore-db-wizard-ssms.png" alt-text="Screenshot showing the Restore Database window. The backup set to restore and the OK option are highlighted." lightbox="media/adventureworks-install-configure/restore-db-wizard-ssms.png":::

For more information on restoring a [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] database, see [Restore a database backup using SSMS](../relational-databases/backup-restore/restore-a-database-backup-using-ssms.md).

# [Transact-SQL (T-SQL)](#tab/tsql)

You can restore your sample database by using T-SQL. The following example restores [!INCLUDE [sssampledbobject-md](../includes/sssampledbobject-md.md)], but the database name and installation file path can vary depending on your environment.

To restore [!INCLUDE [sssampledbobject-md](../includes/sssampledbobject-md.md)] on Windows, modify values as appropriate to your environment and then run the following T-SQL command:

```sql
USE [master];
GO
RESTORE DATABASE [AdventureWorks2022]
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\AdventureWorks2022.bak'
WITH
    FILE = 1,
    NOUNLOAD,
    STATS = 5;
GO
```

To restore [!INCLUDE [sssampledbobject-md](../includes/sssampledbobject-md.md)] on Linux, change the Windows filesystem path to Linux, and then run the following T-SQL command:

```sql
USE [master];
GO
RESTORE DATABASE [AdventureWorks2022]
FROM DISK = '/var/opt/mssql/backup/AdventureWorks2022.bak'
WITH
    MOVE 'AdventureWorks2022' TO '/var/opt/mssql/data/AdventureWorks2022_Data.mdf',
    MOVE 'AdventureWorks2022_log' TO '/var/opt/mssql/data/AdventureWorks2022_log.ldf',
    FILE = 1,
    NOUNLOAD,
    STATS = 5;
GO
```

# [Azure Data Studio](#tab/data-studio)

If you're not familiar with using [Azure Data Studio](/azure-data-studio/download-azure-data-studio), see [Use Azure Data Studio to connect and query](/azure-data-studio/quickstart-sql-server) to get started.

To restore your database in Azure Data Studio, follow these steps:

1. Download the appropriate `.bak` file from one of links provided in the [Download backup files](#download-backup-files) section of this article.
1. Move the `.bak` file to your [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] backup location. This location varies depending on your installation location, instance name, and version of [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)]. For example, the default location for a default instance of [!INCLUDE [sssql22-md](../includes/sssql22-md.md)] is:

   ```output
   C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup
   ```

1. Open Azure Data Studio and connect to your [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] instance.
1. Right-click your server and select **Manage**.

   :::image type="content" source="media/adventureworks-install-configure/ads-manage.png" alt-text="Screenshot showing Azure Data Studio. The Manage option is highlighted." lightbox="media/adventureworks-install-configure/ads-manage.png":::

1. Select **Restore**

   :::image type="content" source="media/adventureworks-install-configure/ads-restore-database.png" alt-text="Screenshot that shows the Restore button in the top menu." lightbox="media/adventureworks-install-configure/ads-restore-database.png":::

1. On the **General** tab, provide values under **Source**:
   1. In **Restore from**, select **Backup file**.
   1. In **Backup file path**, select the location where you stored the .bak file.

   :::image type="content" source="media/adventureworks-install-configure/ads-source.png" alt-text="Screenshot of selecting your backup file path." lightbox="media/adventureworks-install-configure/ads-source.png":::

   This step autopopulates the rest of the fields, such as **Database**, **Target database**, and **Restore to**.

   :::image type="content" source="media/adventureworks-install-configure/ads-destination-restore-plan.png" alt-text="Screenshot that shows autopopulated fields." lightbox="media/adventureworks-install-configure/ads-destination-restore-plan.png":::

1. Select **Restore** to restore your database.

   :::image type="content" source="media/adventureworks-install-configure/ads-restore.png" alt-text="Screenshot that shows the Restore button.":::

---

## Deploy to Azure SQL Database

You have two options for viewing sample SQL Database data. You can use a sample when you create a new database, or you can deploy a database from [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] directly to Azure by using SSMS.

To get sample data for SQL Managed Instance instead, see [Restore World Wide Importers to SQL Managed Instance](/azure/azure-sql/managed-instance/restore-sample-database-quickstart).

### Deploy a new sample database

When you create a new database in SQL Database, you can create a blank database, restore from a backup, or select sample data to populate your new database.

Follow these steps to add sample data to your new database:

1. Connect to the Azure portal.
1. Select **Create a resource** at the top of the left pane.
1. Select **Databases**, and then select **SQL Database**.
1. Supply the requested information to create your database.
1. On the **Additional settings** tab, select **Sample** under **Use existing data**:

   :::image type="content" source="media/adventureworks-install-configure/deploy-sample-to-azure.png" alt-text="Screenshot that shows the Sample option under Use existing data." lightbox="media/adventureworks-install-configure/deploy-sample-to-azure.png":::

1. Select **Create** to create your new database, which is the restored copy of the `AdventureWorksLT` database.

### Deploy a database from SQL Server

SSMS allows you to deploy a database directly to SQL Database. This method doesn't currently provide data validation, so it's intended for development and testing and shouldn't be used for production.

To deploy a sample database from [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] to SQL Database, follow these steps:

1. Connect to your [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] in SSMS.
1. If you haven't already done so, [restore the sample database to SQL Server](#restore-to-sql-server).
1. Right-click your restored database in **Object Explorer** and then select **Tasks** > **Deploy Database to Microsoft Azure SQL Database**.

   :::image type="content" source="media/adventureworks-install-configure/deploy-db-to-azure.png" alt-text="Screenshot that shows the menu steps for deploying a database to SQL Database.":::

1. Complete the steps in the wizard to connect to SQL Database and deploy your database.

## Scripts for creating a database

Instead of restoring a database, you can use scripts to create the `AdventureWorks` databases, regardless of version.

You can use the following scripts to create the entire `AdventureWorks` database:

- [AdventureWorks OLTP scripts zip](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks-oltp-install-script.zip)
- [AdventureWorks DW scripts zip](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW-data-warehouse-install-script.zip)

You can find additional information about using the scripts on [GitHub](https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks).

## Related content

- [Database Engine tutorials](../relational-databases/database-engine-tutorials.md)
- [Quickstart: Connect and query a SQL Server instance using SSMS](../ssms/quickstarts/ssms-connect-query-sql-server.md)
- [Quickstart: Use Azure Data Studio to connect and query SQL Server](/azure-data-studio/quickstart-sql-server)
