---
title: SQL Database Projects Extension
description: Install and use the SQL Database Projects extension for Visual Studio Code to work with data in SQL.
author: dzsquared
ms.author: drskwier
ms.reviewer: randolphwest, maghan
ms.date: 10/10/2025
ms.service: sql
ms.subservice: sql-database-projects
ms.topic: concept-article
ms.collection:
  - data-tools
ms.custom:
  - ignite-2025
---

# SQL Database Projects extension

[!INCLUDE [azure-data-studio-deprecation](../../../includes/azure-data-studio-deprecation.md)]

The SQL Database Projects extension is a Visual Studio Code extension for developing SQL databases in a project-based development environment. Compatible databases include SQL Server, Azure SQL Database, Azure SQL Managed Instance, Warehouse in Fabric, and SQL database in Fabric. A SQL project is a local representation of SQL objects that comprise the schema for a single database, such as tables, stored procedures, or functions. When a SQL Database project is built, the output artifact is a `.dacpac` file. New and existing databases can be updated to match the contents of the `.dacpac` by publishing the SQL Database project with the SQL Database Projects extension or by publishing the `.dacpac` with the [SqlPackage](../../sqlpackage/sqlpackage-publish.md) command line interface.

:::image type="content" source="media/sql-database-projects-extension/sql-project-summary.png" border="true" alt-text="Screenshot of Summary of SQL Database Projects containing predeployment and post-deployment scripts as well as database objects." lightbox="media/sql-database-projects-extension/sql-project-summary.png":::

For more information about SQL projects concepts, see [What are SQL database projects?](../../sql-database-projects/sql-database-projects.md)

## Extension features

The SQL Database Projects extension provides the following features:

- Create a new blank Microsoft.Build.Sql project.
- Create a new project from a connected database.
- Open a project previously created in [Visual Studio Code](getting-started-sql-database-projects-extension.md), or in [SQL Server Data Tools](../../../ssdt/sql-server-data-tools.md).
- Edit a project by adding or removing objects (tables, views, stored procedures) or custom scripts in the project.
- Organize files/scripts in folders.
- Add references to system databases or a user dacpac.
- Build a single project.
- Deploy a single project.
- Load connection details (SQL Windows authentication) and SQLCMD variables from deployment profile.

## Install

You can install the SQL Database Project extension in Visual Studio Code.

The SQL Database Projects extension is installed with the [mssql](/sql/tools/visual-studio-code/sql-server-develop-use-vscode) extension for Visual Studio Code.

## Dependencies

The SQL Database Projects extension has a dependency on the .NET SDK (required) and AutoRest.Sql (optional).

### .NET SDK

The .NET SDK is required for project build functionality and you're prompted to install the .NET SDK if a supported version can't be detected by the extension. The .NET SDK can be downloaded and installed for [Windows, macOS, and Linux](https://aka.ms/sqlprojects-dotnet).

If you would like to [check currently installed versions](/dotnet/core/install/how-to-detect-installed-versions) of the dotnet SDK, open a terminal and run the following command:

```dotnetcli
dotnet --list-sdks
```

After installing the .NET SDK, your environment is ready to use the SQL Database Projects extension.

#### Common issues

**Nuget.org missing from the list of sources may result in error messages such as:**

- `error MSB4236: The SDK 'Microsoft.Build.Sql/0.1.9-preview' specified could not be found.`
- `Unable to find package Microsoft.Build.Sql. No packages exist with this id in source(s): Microsoft Visual Studio Offline Packages`

To check if nuget.org is registered as a source, run `dotnet nuget list source` from the command line and review the results for an `[Enabled]` item referencing nuget.org. If nuget.org isn't registered as a source, run `dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org`.

**Unsupported .NET SDK versions may result in error messages such as:**

- `error MSB4018: The "SqlBuildTask" task failed unexpectedly.`
- `error MSB4018: System.TypeInitializationException: The type initializer for 'SqlSchemaModelStaticState' threw an exception. ---> System.IO.FileNotFoundException: Could not load file or assembly 'System.Runtime, Version=4.2.2.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. The system cannot find the file specified. [c:\Users\ .sqlproj]_` (where the linked nonexisting file has an unmatched closing square bracket).

To force the SQL Database Projects extension to use the v6.x version of the .NET SDK when multiple versions are installed, add a [global.json](/dotnet/core/tools/global-json) file to the folder that contains the SQL project.

More information on troubleshooting SQL projects build can be found in [Troubleshoot SQL project build](../../sql-database-projects/howto/troubleshoot-sql-project-build.md).

## SQLCLR

SQLCLR objects in database projects aren't supported in Visual Studio Code because they rely on .NET Framework and the SQL Database Projects extension uses .NET to build projects.

## Workspace

SQL database projects are contained within a logical workspace (folder) in Visual Studio Code. **All SQL projects within the folders open in the current workspace are available in the SQL Database Projects view by default.**

You can manually add and remove projects from a workspace through the interface in the **Projects** pane. The settings for a workspace can be manually edited in the `.code-workspace` file, if necessary.

In the following example `.code-workspace` file, the `folders` array lists all folders included in the Explorer pane and the `dataworkspace.excludedProjects` array within `settings` lists all the SQL projects excluded from the **Projects** pane.

```json
{
  "folders": [
    {
      "path": "."
    },
    {
      "name": "WideWorldImportersDW",
      "path": "..\\WideWorldImportersDW"
    }
  ],
  "settings": {
    "dataworkspace.excludedProjects": [
      "AdventureWorksLT.sqlproj"
    ]
  }
}
```

## Related content

- [What are SQL database projects?](../../sql-database-projects/sql-database-projects.md)
- [Getting started with the SQL Database Projects extension](getting-started-sql-database-projects-extension.md)
- [Get help with the SQL Database Projects extension](https://github.com/microsoft/azuredatastudio/issues)
