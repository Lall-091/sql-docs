---
title: "Data-Tier Applications (DAC) Overview"
description: "Data-tier applications, or dacpacs, represent a database model."
author: dzsquared
ms.author: drskwier
ms.reviewer: wiassaf, randolphwest, maghan
ms.date: 03/11/2025
ms.service: sql
ms.subservice: sql-database-projects
ms.topic: concept-article
f1_keywords:
  - "sql.data.tools.DacTableChooser"
  - "sql.data.tools.DacPublishDialog"
  - "sql.data.tools.DacPropertiesDialog"
  - "sql.data.tools.DacExtractDialog"
helpviewer_keywords:
  - "designing DACs"
  - "How to [DAC]"
  - "data-tier application [SQL Server], designing"
  - "wizard [DAC]"
monikerRange: "=azuresqldb-current || >=sql-server-2016 || >=sql-server-linux-2017 || =azuresqldb-mi-current || =fabric"
---

# Data-tier applications (DAC) overview

[!INCLUDE [SQL Server Azure SQL Database Azure SQL Managed Instance FabricSQLDB](../../../../includes/applies-to-version/sql-asdb-asdbmi-fabricsqldb.md)]

A data-tier application (DAC) is a logical database entity that defines all of the [!INCLUDE [ssNoVersion](../../../../includes/ssnoversion-md.md)] objects - such as tables, views, and instance objects, including logins - associated with a user's database. A data-tier application is a self-contained unit of the entire database model and is portable in both `.dacpac` and `.bacpac` packages. [Tooling support](#data-tier-application-tools) for data-tier applications enable developers and database administrators to apply `.dacpac` and `.bacpac` files to new or existing databases or generate new files from existing databases.

## Operations

### BACPAC operations

The `.bacpac` file format is a related artifact that by default encapsulates the database schema and the data stored in the database. Objects in the `.bacpac` database model are limited to the surface area of Azure SQL Database. The primary use case for a `.bacpac` is to move a database from one server to another - or to [migrate a database from a local server to the cloud](/azure/azure-sql/database/migrate-to-database-from-sql-server) - and archiving an existing database in an open format.

- **Export** - the user can export a database to a `.bacpac` file. For more information, see [SqlPackage export](../../../sqlpackage/sqlpackage-export.md) and [Export a Database to a BACPAC File](export-bacpac-file.md).
- **Import** - the user can import a `.bacpac` file into a new database. For more information, see [SqlPackage import](../../../sqlpackage/sqlpackage-import.md) and [Import a BACPAC File to a Database](import-bacpac-file-create-new-database.md).

Learn more about database portability from the [SqlPackage portability documentation](../../../sqlpackage/sqlpackage.md#portability).

### DACPAC operations

The `.dacpac` data-tier application package is the build artifact from [SQL database projects](../../sql-database-projects.md) and can be used as part of a comprehensive database lifecycle management and DevOps strategy. Data isn't included in a `.dacpac` by default, but you can choose to include data from user tables when you extract a `.dacpac` from a live SQL Server or Azure SQL Database. As an integral part of the SQL database project workflow and database development lifecycle, `.dacpac` files are used in several operations. The primary operations are:

- **Extract** - the user can extract a database into a `.dacpac`. For more information, see [SqlPackage extract](../../../sqlpackage/sqlpackage-extract.md) and [Extract a DAC From a Database](extract-dacpac-from-database.md).
- **Deploy**/**Publish** - the user can deploy a `.dacpac` to a host server. When the deployment is done to an existing database, the difference between the database and the DAC is dynamically calculated and applied as an incremental update. The term "publish" is often used interchangeably with "deploy." For more information, see [SqlPackage publish](../../../sqlpackage/sqlpackage-publish.md) and [Deploy a Data-tier Application](deploy-data-tier-application.md).

These capabilities can be found in the SqlPackage CLI, SQL Server Management Studio, Azure Data Studio, and SQL Server Data Tools.

In addition to publish and extract, you can also track the database model in the system metadata by utilizing the *dac registration* functionality:

- **Register** - the user can register a database as a data-tier application. Register stores a representation of the current state of the database schema in system metadata.
- **Unregister** - a database previously registered as a DAC can be unregistered.
- **Upgrade** - a database can be upgraded using a `.dacpac`.

## Data-tier application tools

Tooling support for data-tier applications enables developers and database administrators to work with `.dacpac` and `.bacpac` files from both graphical and command line interfaces. In addition to released tools, data-tier application APIs are available in the [Data-tier Application Framework (DACFx)](https://www.nuget.org/packages/Microsoft.SqlServer.DacFx/) for .NET development and database lifecycle customization.

### DACPAC and BACPAC packages

The following tools support the `.dacpac` and `.bacpac` formats:

- [SqlPackage CLI](../../../sqlpackage/sqlpackage.md)
- [SQL Server Management Studio](/ssms/sql-server-management-studio-ssms)
- [Azure Data Studio](/azure-data-studio/what-is-azure-data-studio)

In these tools, a database can be extracted to a `.dacpac` or exported to a `.bacpac`. Conversely, a `.bacpac` can be imported into a new database or a `.dacpac` can be published to a new or existing database.

### DACPAC and SQL projects

The following tools support the `.dacpac` file format in addition to providing editing of SQL database projects:

- [SQL Server Data Tools in Visual Studio](../../../../ssdt/sql-server-data-tools.md)
- [SQL Database Projects extension](/azure-data-studio/extensions/sql-database-project-extension)

In these tools, developers can design a database in an unconnected, client-side development environment. Learn more in the [SQL projects tools](../../sql-projects-tools.md) article.

## Related content

- [SqlPackage](../../../sqlpackage/sqlpackage.md)
