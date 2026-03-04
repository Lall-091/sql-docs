---
title: ALTER FULLTEXT CATALOG (Transact-SQL)
description: ALTER FULLTEXT CATALOG (Transact-SQL)
author: markingmyname
ms.author: maghan
ms.reviewer: randolphwest
ms.date: 03/04/2026
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
f1_keywords:
  - "ALTER_FULLEXT_CATALOG_TSQL"
  - "ALTER FULLEXT CATALOG"
helpviewer_keywords:
  - "modifying full-text catalogs"
  - "full-text catalogs [SQL Server], rebuilding"
  - "accent sensitivity"
  - "ALTER FULLTEXT CATALOG statement"
  - "full-text catalogs [SQL Server], modifying"
  - "full-text catalogs [SQL Server], reorganizing"
dev_langs:
  - TSQL
---
# ALTER FULLTEXT CATALOG (Transact-SQL)

[!INCLUDE [SQL Server Azure SQL Database Azure SQL Managed Instance](../../includes/applies-to-version/sql-asdb-asdbmi.md)]

Use this statement to change the properties of a full-text catalog.

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

## Syntax

```syntaxsql
ALTER FULLTEXT CATALOG catalog_name
{ REBUILD [ WITH ACCENT_SENSITIVITY = { ON | OFF } ]
| REORGANIZE
| AS DEFAULT
}
```

## Arguments

#### *catalog_name*

Specifies the name of the catalog to modify. If a catalog with the specified name doesn't exist, [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] returns an error and doesn't perform the `ALTER` operation.

#### REBUILD

The [!INCLUDE [ssdenoversion-md](../../includes/ssdenoversion-md.md)] rebuilds the entire catalog. When you rebuild a catalog, the existing catalog is deleted and a new catalog is created in its place. All the tables that have full-text indexing references are associated with the new catalog. Rebuilding resets the full-text metadata in the database system tables.

#### WITH ACCENT_SENSITIVITY = { ON | OFF }

Specifies if the catalog to be altered is accent-sensitive or accent-insensitive for full-text indexing and querying.

To determine the current accent-sensitivity property setting of a full-text catalog, use the `FULLTEXTCATALOGPROPERTY` function with the `AccentSensitivity` property value against *catalog_name*.

- If the function returns `1`, the full-text catalog is accent sensitive.
- If the function returns `0`, the catalog isn't accent sensitive.

The catalog and database default accent sensitivity are the same.

#### REORGANIZE

The [!INCLUDE [ssdenoversion-md](../../includes/ssdenoversion-md.md)] performs a *master merge*, which involves merging the smaller indexes created in the process of indexing into one large index. Merging the full-text index fragments can improve performance and free up disk and memory resources. If there are frequent changes to the full-text catalog, use this command periodically to reorganize the full-text catalog.

`REORGANIZE` also optimizes internal index and catalog structures.

Depending on the amount of indexed data, a master merge might take some time to complete. Merging a large amount of data can create a long running transaction, delaying truncation of the transaction log during a checkpoint. In this case, the transaction log might grow significantly under the full recovery model.

As a best practice, ensure that your transaction log contains sufficient space for a long-running transaction before reorganizing a large full-text index in a database that uses the full recovery model. For more information, see [Manage the size of the transaction log file](../../relational-databases/logs/manage-the-size-of-the-transaction-log-file.md).

#### AS DEFAULT

Specifies that this catalog is the default catalog. When you create full-text indexes without specifying catalogs, the default catalog is used. If there's an existing default full-text catalog, setting this catalog `AS DEFAULT` overrides the existing default.

## Permissions

To use `ALTER FULLTEXT CATALOG`, you need one of the following permissions:

- `ALTER` permission on the full-text catalog
- Membership in the **db_owner** or **db_ddladmin** fixed database roles
- Membership in the **sysadmin** fixed server role

To use `ALTER FULLTEXT CATALOG ... AS DEFAULT`, you need `ALTER` permission on the full-text catalog, and `CREATE FULLTEXT CATALOG` permission on the database.

## Examples

The following example changes the `AccentSensitivity` property of the default full-text catalog `ftCatalog`, which is accent sensitive.

1. Change catalog to accent insensitive.

   ```sql
   USE AdventureWorks2025;
   GO

   ALTER FULLTEXT CATALOG ftCatalog
   REBUILD WITH ACCENT_SENSITIVITY = OFF;
   ```

1. Check accent sensitivity.

   ```sql
   SELECT FULLTEXTCATALOGPROPERTY('ftCatalog', 'AccentSensitivity');
   ```

   The query returns `0`, which means the catalog isn't accent sensitive.

## Related content

- [sys.fulltext_catalogs (Transact-SQL)](../../relational-databases/system-catalog-views/sys-fulltext-catalogs-transact-sql.md)
- [CREATE FULLTEXT CATALOG (Transact-SQL)](create-fulltext-catalog-transact-sql.md)
- [DROP FULLTEXT CATALOG (Transact-SQL)](drop-fulltext-catalog-transact-sql.md)
- [Full-Text Search](../../relational-databases/search/full-text-search.md)
