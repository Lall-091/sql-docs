---
title: "Azure SQL Decision Tree"
description: "Explore a decision tree of different options within the Azure SQL family of services: Azure SQL Database, Azure SQL Managed Instance, and SQL Server on Azure VM."
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: ivujic
ms.date: 12/18/2025
ms.service: azure-sql
ms.subservice: service-overview
ms.topic: article
monikerRange: "=azuresql||=azuresql-db||=azuresql-mi"
# http://aka.ms/AzureSQLdecisionTree
---
# Azure SQL decision tree

[!INCLUDE [appliesto-sqldb-sqlmi-sqlvm](includes/appliesto-sqldb-sqlmi-sqlvm.md)]

The Azure portal includes a decision tree in the [Azure SQL hub at aka.ms/azuresqlhub](https://aka.ms/azuresqlhub) to help you **Find the right option** for your application architecture in Azure SQL.

## Decision tree diagram

The following decision tree diagram shows each high-level decision step. 

:::image type="content" source="media/azure-sql-decision-tree/azure-sql-decision-tree.svg" alt-text="Decision tree diagram for Azure SQL. Each decision point is explained in this article." lightbox="media/azure-sql-decision-tree/azure-sql-decision-tree.png":::

### Decision tree explained

The following explanation covers each high-level decision point. Your application architecture might involve other factors and decision points.

#### Are you building a new application?

   - **Yes:** Consider Azure SQL Database and Azure SQL Database Hyperscale.

      - **If you're building a new SaaS (Software-as-a-Service) solution for hundreds of customers or more**, consider Azure SQL Database, using elastic pools to provide cost-effective and predictable resource costs to many distinct customer databases.

      - **If you're building other types of applications,** consider Azure SQL Database Hyperscale. You could also consider Azure SQL Database Hyperscale elastic pools to provide cost-effective and predictable resource costs to many databases.

   - **No:** The best platform choice depends on other factors, like whether you're migrating an existing workload and other features. Keep reading.

#### Are you migrating an existing database?

   - **No:** Consider Azure SQL Database and Azure SQL Database Hyperscale.

      - **If you're building a new SaaS (Software-as-a-Service) solution for hundreds of customers or more**, consider Azure SQL Database, using elastic pools to provide cost-effective and predictable resource costs to many distinct customer databases.

      - **If you're building other types of applications,** consider Azure SQL Database Hyperscale. You could also consider Azure SQL Database Hyperscale elastic pools to provide cost-effective and predictable resource costs to many databases.

   - **Yes:** Consider what system requirements you have from the existing database platform. Keep reading.

#### Do you need operating system-level control, file system access, or a specific SQL Server version?

   - **Yes:** The best solution for on-premises migrations that require operating system-level and file system access, perhaps for integration with other applications that must be installed locally to the SQL Server instance, is SQL Server on Azure Virtual Machines. 
   
      If you must run a specific version of SQL Server that isn't the latest version and won't be automatically kept up to date, use SQL Server on Azure Virtual Machines.

   - **No:** Consider what feature requirements you have from the existing database platform. A platform as a service (PaaS) database that manages the SQL Server instance and operating system patching for you is easier and simpler to operate. Keep reading for more options.

#### Does your workload require transactional replication, .NET CLR, SQL Agent, cross-database queries, or linked server?

   - **Yes:** Choose Azure SQL Managed Instance. These SQL Server and Windows features are available with Azure SQL Managed Instance, even as other aspects of the instance and operating system are managed for you, such as patching, high availability, and backups.

   - **No:** If you don't need those features, other Azure SQL options are available that simplify your database administration. Keep reading.

#### Do you need, or does company policy require, the ability to move the database back to on-premises or cross-cloud?

   - **Yes:** Choose Azure SQL Managed Instance, which provides migration and reverse migration, as well as on-prem-to-cloud synchronization through availability groups.

   - **No:** Other options remain available for your scenario. Keep reading.

#### Do you expect the database to stay under 4 TB?

   - **Yes:** Choose Azure SQL Database. Further, if you're considering a new SaaS (software-as-a-service) solution for hundreds of customers or more, configure Azure SQL Database with elastic pools to provide cost-effective and predictable resource costs to many distinct customer databases. You could consider a database architecture that separates each customer into its own database using elastic pools, each expected to stay under 4 TB.

   - **No:** Azure SQL Managed Instance and Azure SQL Database Hyperscale provide much higher total database size limitations. Keep reading.

#### Do you expect your database to stay under 32 TB?

Both Azure SQL Managed Instance and Azure SQL Database Hyperscale could work for your solution, but Azure SQL Managed Instance has a current cap of 32 TB. Azure SQL Database Hyperscale has a current cap of 128 TB.

   - **If you're building a new SaaS (software-as-a-service) solution for hundreds of customers or more**, consider Azure SQL Database Hyperscale elastic pools or Azure SQL Managed Instance pools to provide cost-effective and predictable resource costs to many distinct customer databases.

## Related content

- [Migrate to Azure SQL](migration-guides/index.yml)
- [What is Azure SQL Database?](database/sql-database-paas-overview.md)
- [What is Azure SQL Managed Instance?](managed-instance/sql-managed-instance-paas-overview.md)
- [What is SQL Server on Azure Windows Virtual Machines?](virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview.md)
