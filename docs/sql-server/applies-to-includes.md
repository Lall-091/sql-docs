---
title: "SQL Server Documentation Include Files"
description: Explanation of SQL Server includes files for versioning and applies-to.
author: MashaMSFT
ms.author: mathoma
ms.reviewer: randolphwest
ms.date: 12/15/2025
ms.service: sql
ms.subservice: release-landing
ms.topic: article
monikerRange: ">=aps-pdw-2016 || =azuresqldb-current || =azure-sqldw-latest || >=sql-server-2016 || >=sql-server-linux-2017"
---
# SQL Server include files for versioning and applies-to

References in the documentation can be easily modified without changing the actual text of individual articles by using include files in Markdown. There are three types of include files in the SQL content world: SQL version, applies-to, and referential text. **SQL Server version** include files are used to indicate the version of SQL being discussed, such as SQL Server 2016 or 2017. The **applies-to** include files indicate what SQL products and services the document applies to, such as SQL Server on Linux or Azure SQL Database. **Referential text** include files don't fall in the other two categories, such as the "Get Help" include, a list of links that customers can use to get help with SQL Server.

This article is meant to be used as a reference point for just the first two types of include files. You can browse the complete list of include files in the [sql-docs repository](https://github.com/MicrosoftDocs/sql-docs/tree/live/docs/includes).

## SQL Server version include files

SQL Content writers frequently need to include the name of the product and version of SQL Server. This way, if something changes in the name, the include file is updated instead of manually updating the value in every single article. These include files are used as placeholders for product names but aren't consistently used in all SQL documentation. SQL Server vNext refers to a future release of SQL Server that doesn't yet have a version number, and is the exception to this rule.

| SQL Server version | File name | Markdown example | Text |
| --- | --- | --- | --- |
| SQL Server | ssnoversion-md.md | `[!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)]` | SQL Server |
| SQL Server 2000 | ssversion2000-md.md | `[!INCLUDE [ssversion2000-md](../includes/ssversion2000-md.md)]` | [!INCLUDE [ssversion2000-md](../includes/ssversion2000-md.md)] |
| SQL Server 2005 | ssversion2005-md.md | `[!INCLUDE [ssversion2005-md](../includes/ssversion2005-md.md)]` | [!INCLUDE [ssversion2005-md](../includes/ssversion2005-md.md)] |
| SQL Server 2008 | sql2008-md.md | `[!INCLUDE [sql2008-md](../includes/sql2008-md.md)]` | [!INCLUDE [sql2008-md](../includes/sql2008-md.md)] |
| SQL Server 2008 R2 | sql2008r2-md.md | `[!INCLUDE [sql2008r2-md](../includes/sql2008r2-md.md)]` | [!INCLUDE [sql2008r2-md](../includes/sql2008r2-md.md)] |
| SQL Server 2012 | sssql11-md.md | `[!INCLUDE [sssql11-md](../includes/sssql11-md.md)]` | SQL Server 2012 (11.x) |
| SQL Server 2012 SP1 | sssql11sp1-md.md | `[!INCLUDE [sssql11sp1-md](../includes/sssql11sp1-md.md)]` | [!INCLUDE [sssql11sp1-md](../includes/sssql11sp1-md.md)] |
| SQL Server 2014 | sssql14-md.md | `[!INCLUDE [sssql14-md](../includes/sssql14-md.md)]` | [!INCLUDE [sssql14-md](../includes/sssql14-md.md)] |
| SQL Server 2016 | sssql16-md.md | `[!INCLUDE [sssql16-md](../includes/sssql16-md.md)]` | [!INCLUDE [sssql16-md](../includes/sssql16-md.md)] |
| SQL Server 2017 | sssql17-md.md | `[!INCLUDE [sssql17-md](../includes/sssql17-md.md)]` | [!INCLUDE [sssql17-md](../includes/sssql17-md.md)] |
| SQL Server 2019 | sssql19-md.md | `[!INCLUDE [sssql19-md](../includes/sssql19-md.md)]` | [!INCLUDE [sssql19-md](../includes/sssql19-md.md)] |
| SQL Server 2022 | sssql22-md.md | `[!INCLUDE [sssql22-md](../includes/sssql22-md.md)]` | [!INCLUDE [sssql22-md](../includes/sssql22-md.md)] |
| SQL Server 2025 | sssql25-md.md | `[!INCLUDE [sssql25-md](../includes/sssql25-md.md)]` | [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] |
| SQL Server vNext | sssql22-md.md | `[!INCLUDE [sssql22-md](../includes/sssql22-md.md)]` | [!INCLUDE [sssql22-md](../includes/sssql22-md.md)] |

## SQL Server applies-to (non-version-specific)

These applies-to include files omit the version of SQL Server.

| File name | Markdown example | Image |
| --- | --- | --- |
| applies-to-version/sql-asdbmi.md | `[!INCLUDE [applies-to-version/sql-asdbmi.md](../includes/applies-to-version/sql-asdbmi.md)]` | [!INCLUDE [applies-to-version/sql-asdbmi.md](../includes/applies-to-version/sql-asdbmi.md)] |
| applies-to-version/_ssnoversion.md | `[!INCLUDE [applies-to-version/_ssnoversion.md](../includes/applies-to-version/sqlserver.md)]` | [!INCLUDE [applies-to-version/_ssnoversion.md](../includes/applies-to-version/sqlserver.md)] |

## SQL Server applies-to (version-specific)

These applies-to include files specify which versions of SQL the documentation applies to.

| File name | Markdown example | Image |
| --- | --- | --- |
| applies-to-version/asa-pdw.md | `[!INCLUDE [applies-to-version/asa-pdw.md](../includes/applies-to-version/asa-pdw.md)]` | [!INCLUDE [applies-to-version/asa-pdw.md](../includes/applies-to-version/asa-pdw.md)] |

## Related content

- [Applies-to includes](sql-server-docs-contribute.md#applies-to-includes)
