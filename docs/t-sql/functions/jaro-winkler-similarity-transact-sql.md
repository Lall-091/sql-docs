---
title: "JARO_WINKLER_SIMILARITY (Transact-SQL)"
description: JARO_WINKLER_SIMILARITY calculates a similarity value ranging from 0 (indicating no match) to 100 (indicating full match).
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: abhtiwar, wiassaf, randolphwest
ms.date: 05/19/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-current || =azuresqldb-mi-current || =fabric || >=sql-server-2016"
ms.custom:
  - build-2025
---

# JARO_WINKLER_SIMILARITY (Transact-SQL) preview

[!INCLUDE [sqlserver2025-asdb-asmi-fabricsqldb](../../includes/applies-to-version/sqlserver2025-asdb-asmi-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Calculates a similarity value ranging from 0 (indicating no match) to 100 (indicating full match).

> [!NOTE]
> - `JARO_WINKLER_SIMILARITY` is currently in preview. 
> - SQL Server support for `JARO_WINKLER_SIMILARITY` introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)]. 
> - `JARO_WINKLER_SIMILARITY` is available in Azure SQL Managed Instance with the **SQL Server 2025** or **Always-up-to-date** [update policy](/azure/azure-sql/managed-instance/update-policy).

## Syntax

```syntaxsql
JARO_WINKLER_SIMILARITY (
    character_expression,
    character_expression
)  
```

## Arguments

#### *character_expression*

An alphanumeric expression of character data. *character_expression* can be a constant, variable, or column. The character expression cannot be of type **varchar(max)** or **nvarchar(max)**.

## Return value

**int**

## Remarks

This function implements the Jaro-Winkler edit distance algorithm and calculates the similarity value.

## Examples

The following example compares two words and returns the `JARO_WINKLER_SIMILARITY` value as a column, named `Similarity`.

```sql
SELECT 'Colour' AS WordUK, 
       'Color' AS WordUS, 
       JARO_WINKLER_SIMILARITY('Colour', 'Color') AS Similarity;
```

Returns:

```output
WordUK WordUS Similarity
------ ------ -------------
Colour Color  97
```

For additional examples, see [Example *JARO_WINKLER_SIMILARITY*](../../relational-databases/fuzzy-string-match/overview.md#example-jaro_winkler_similarity).

## Related content

- [EDIT_DISTANCE](edit-distance-transact-sql.md)
- [EDIT_DISTANCE_SIMILARITY](edit-distance-similarity-transact-sql.md)
- [JARO_WINKLER_DISTANCE](jaro-winkler-distance-transact-sql.md)
