---
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.date: 04/02/2026
ms.service: sql
ms.topic: include
---

### [Database administrator (DBA)](#tab/dba)

The **database administrator (DBA)** manages backup and restore, performance tuning, security, and high availability.

Recommended tools:

- **[SQL Server Management Studio (SSMS)](../tools/overview-sql-tools.md#ssms)**: Full-featured management with a graphical user interface
- **[MSSQL extension for Visual Studio Code](../tools/overview-sql-tools.md#mssql)**: Lightweight tasks and scripting
- **[sqlcmd](../tools/overview-sql-tools.md#sqlcmd)**: Lightweight command-line interface (CLI) for deployment and automation
- **[SQL Database Projects extension for Visual Studio Code](../tools/overview-sql-tools.md#projects)**: Manage and develop database schema in projects in source control
- **[SQL Server Migration Assistant (SSMA)](../tools/overview-sql-tools.md#ssma)**: Migrate to SQL Server and Azure SQL from Microsoft Access, Db2, MySQL, Oracle, and Sybase


### [Developer](#tab/dev)

The **database/application developer** writes Transact-SQL queries, debugs stored procedures, and integrates data access in applications.

Recommended tools:

- **[MSSQL extension for Visual Studio Code](../tools/overview-sql-tools.md#mssql)**: Connect, manage database schemas, and run queries directly in Visual Studio Code
- **[SQL Database Projects extension for Visual Studio Code](../tools/overview-sql-tools.md#projects)**: Manage and develop database schema in projects in source control
- **[SQL Server Management Studio (SSMS)](../tools/overview-sql-tools.md#ssms)**: Create objects, run queries, and perform lightweight tasks
- **[SQL Server Data Tools (SSDT)](../tools/overview-sql-tools.md#ssdt)** for Visual Studio: Schema and project-based development
- **[.NET libraries](/azure/azure-sql/database/connect-query-dotnet-core)**: Programmatic access using libraries such as `Microsoft.Data.SqlClient`
- **[Data API builder](/azure/data-api-builder/)**: Connect apps to the database over [automatic REST](/azure/data-api-builder/concept/rest/overview) or [GraphQL endpoints](/azure/data-api-builder/concept/graphql/overview).
- **[SQL MCP Server](/azure/data-api-builder/mcp/overview)**: Connect custom and [Foundry agents](/azure/data-api-builder/mcp/quickstart-azure-ai-foundry) to the database with a secure MCP Server.

### [Data analyst](#tab/analyst)

The **data analyst** runs queries and generates reports.

Recommended tools:

- **[SQL Server Management Studio (SSMS)](../tools/overview-sql-tools.md#ssms)**: Run queries and perform lightweight tasks
- **[sqlcmd](../tools/overview-sql-tools.md#sqlcmd)**: Lightweight CLI for automation
- **[MSSQL extension for Visual Studio Code](../tools/overview-sql-tools.md#mssql)**: Lightweight tasks and scripting

### [Data engineer](#tab/engineer)

The **data engineer** manages extract-transform-load (ETL) or extract-load-transform (ELT) pipelines, bulk data imports, and data flows.

Recommended tools:

- **[bcp](../tools/overview-sql-tools.md#bcp)**: Bulk copy data
- **[SqlPackage](../tools/overview-sql-tools.md#sqlpackage)**: Deploy DACPACs

---
