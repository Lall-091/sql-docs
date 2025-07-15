---
title: "Import and Export Data from SQL Server and Azure SQL Database"
description: You can use Transact-SQL, command-line tools, and wizards to import and export data in SQL Server and Azure SQL Database in various data formats.
author: rwestMSFT
ms.author: randolphwest
ms.date: 07/15/2025
ms.service: sql
ms.subservice: data-movement
ms.topic: conceptual
monikerRange: ">=aps-pdw-2016 || =azuresqldb-current || =azure-sqldw-latest || >=sql-server-2016 || >=sql-server-linux-2017 || =azuresqldb-mi-current"
---
# Import and export data from SQL Server and Azure SQL Database

[!INCLUDE [SQL Server Azure SQL Database Synapse Analytics PDW](../../includes/applies-to-version/sql-asdb-asdbmi-asa-pdw.md)]

You can use various methods to import data to, and export data from, SQL Server and Azure SQL Database. These methods include Transact-SQL statements, command-line tools, and wizards.

You can also import and export data in various data formats. These formats include flat files, Excel, major relational databases, and various cloud services.

## Methods for importing and exporting data

### Use Transact-SQL statements

You can import data with the `BULK INSERT` or the `OPENROWSET(BULK...)` commands. Typically you run these commands in SQL Server Management Studio (SSMS). For more information, see [Use BULK INSERT or OPENROWSET(BULK...) to import data to SQL Server](import-bulk-data-by-using-bulk-insert-or-openrowset-bulk-sql-server.md).

### Use BCP from the command prompt

You can import and export data with the BCP command-line utility. For more information, see [Import and export bulk data using bcp (SQL Server)](import-and-export-bulk-data-by-using-the-bcp-utility-sql-server.md).

### Use the Import Flat File Wizard

If you don't need all the configuration options available in the Import and Export Wizard and other tools, you can import a text file into SQL Server by using the **Import Flat File Wizard** in SQL Server Management Studio (SSMS). For more information, see the following articles:

- [Import Flat File to SQL Wizard](import-flat-file-wizard.md)
- [What's new in SQL Server Management Studio 17.3](https://blogs.technet.microsoft.com/dataplatforminsider/2017/10/10/whats-new-in-sql-server-management-studio-17-3/)

### Use the SQL Server Import and Export Wizard

You can import data to, or export data from, various sources and destinations with the SQL Server Import and Export Wizard. To use the wizard, you must have SQL Server Integration Services (SSIS) or SQL Server Data Tools (SSDT) installed. For more information, see [Import and Export Data with the SQL Server Import and Export Wizard](../../integration-services/import-export-data/import-and-export-data-with-the-sql-server-import-and-export-wizard.md).

### Design your own import or export

If you want to design a custom data import, you can use one of the following features or services:

- [SQL Server Integration Services](../../integration-services/sql-server-integration-services.md)
- [Introduction to Azure Data Factory](/azure/data-factory/data-factory-introduction)

## Data formats for import and export

### Supported formats

You can import data from, and export data to, flat files or various other file formats, relational databases, and cloud services. To learn more about these options for specific tools, see the following articles:

- [Connect to Data Sources with the SQL Server Import and Export Wizard](../../integration-services/import-export-data/connect-to-data-sources-with-the-sql-server-import-and-export-wizard.md)
- [Integration Services (SSIS) Connections](../../integration-services/connection-manager/integration-services-ssis-connections.md)
- [Azure Data Factory Connectors](/azure/data-factory/data-factory-amazon-redshift-connector)

### Commonly used data formats

There are special considerations and examples available for some commonly used data formats. To learn more about these data formats, see the following articles:

- [Import data from Excel to SQL Server or Azure SQL Database](import-data-from-excel-to-sql.md)
- [Import JSON documents into SQL Server](../json/import-json-documents-into-sql-server.md)
- [Examples of bulk import and export of XML documents (SQL Server)](examples-of-bulk-import-and-export-of-xml-documents-sql-server.md)
- [Examples of bulk access to data in Azure Blob Storage](examples-of-bulk-access-to-data-in-azure-blob-storage.md).

## Related content

- [Get started with this simple example of the Import and Export Wizard](../../integration-services/import-export-data/get-started-with-this-simple-example-of-the-import-and-export-wizard.md)
