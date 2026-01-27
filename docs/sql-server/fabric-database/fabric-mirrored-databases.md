---
title: "Microsoft Fabric mirrored databases"
description: Learn about the mirrored databases in Microsoft Fabric from SQL Server, Azure SQL Database and Azure SQL Managed Instance.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: imotiwala
ms.date: 10/31/2025
ms.service: fabric
ms.topic: concept-article
ms.custom:
  - ignite-2025
monikerRange: "=azuresqldb-current || =azuresqldb-mi-current || =fabric-sqldb || >=sql-server-ver17"
---
# Microsoft Fabric mirrored databases

[!INCLUDE [sqlserver2016-asdb-asdbmi-fabricsqldb](../../includes/applies-to-version/sqlserver2016-asdb-asdbmi-fabricsqldb.md)]

You can mirror databases from SQL Server (2016-2025), Azure SQL Database, and Azure SQL Managed Instance to Microsoft Fabric. You can continuously replicate your existing data estate directly into Fabric's OneLake.

For more information and tutorials, see:

 - [Mirroring Azure SQL Database](/fabric/database/mirrored-database/azure-sql-database)
 - [Mirroring Azure SQL Managed Instance](/fabric/database/mirrored-database/azure-sql-managed-instance)
 - [Mirroring SQL Server](/fabric/database/mirrored-database/sql-server)

For more information, see:

- [Microsoft Fabric mirrored databases](/fabric/database/mirrored-database/overview)
- [Microsoft Fabric mirrored databases monitoring](/fabric/database/mirrored-database/monitor)
- [Explore data in your mirrored database using Microsoft Fabric](/fabric/database/mirrored-database/explore)

## What are Fabric mirrored databases?

Mirroring in Fabric provides an easy experience to speed the time-to-value for insights and decisions, and to break down data silos between technology solutions, without developing expensive Extract, Transform, and Load (ETL) processes to move data.

With the most up-to-date data in a queryable format in OneLake, you can now use all the different services in Fabric, such as running analytics with Spark, executing notebooks, data engineering, visualizing through Power BI Reports, and more.

With Mirroring in Fabric, you don't need to piece together different services from multiple vendors. Instead, you can enjoy a highly integrated, end-to-end, and easy-to-use product that is designed to simplify your analytics needs, and built for openness and collaboration between technology solutions that can read the open-source Delta Lake table format.

## Fabric mirrored databases technology

The Fabric mirrored database feature uses similar change feed technology as the Azure Synapse Link, and shares some system objects.

Enabling Mirroring via the Fabric portal will create a `changefeed` database user, a `changefeed` schema, and several tables within the `changefeed` schema in your source database. Do not alter any of these system-managed objects.

## SQL database in Microsoft Fabric

You can also create a [SQL database in Microsoft Fabric](sql-database-in-fabric.md). A [SQL database in Microsoft Fabric is distinct from an Azure SQL Database](/fabric/database/sql/decision-guide) or a mirrored database from Azure SQL Database, and each use similar mirroring technology to replicate data into Microsoft Fabric's OneLake. 

With [SQL database in Fabric](/fabric/database/sql/overview), your data is automatically accessible from other Fabric experiences. SQL database in Microsoft Fabric, which uses the same SQL Database Engine as Microsoft SQL Server and is similar to Azure SQL Database, inherits most of the Fabric mirroring capabilities from Azure SQL Database. Your SQL database in Fabric is automatically mirrored to OneLake and presented in a read-only, queryable format. You can use all the different services in Fabric, such as running analytics with Spark, executing notebooks, data engineering, visualizing through Power BI Reports, and more.

## Related content

- [What is Microsoft Fabric?](/fabric/get-started/microsoft-fabric-overview)
- [Microsoft Fabric mirrored databases](/fabric/database/mirrored-database/overview)
