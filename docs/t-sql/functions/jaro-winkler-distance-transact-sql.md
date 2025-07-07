---
title: "JARO_WINKLER_DISTANCE (Transact-SQL)"
description: JARO_WINKLER_DISTANCE calculates the edit distance between two strings giving preference to strings that match from the beginning for a set prefix length.
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

# JARO_WINKLER_DISTANCE (Transact-SQL) preview

[!INCLUDE [sqlserver2025-asdb-asmi-fabricsqldb](../../includes/applies-to-version/sqlserver2025-asdb-asmi-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Calculates the edit distance between two strings giving preference to strings that match from the beginning for a set prefix length.

> [!NOTE]
> - `JARO_WINKLER_DISTANCE` is currently in preview. 
> - SQL Server support for `JARO_WINKLER_DISTANCE` introduced in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)]. 
> - `JARO_WINKLER_DISTANCE` is available in Azure SQL Managed Instance configured with the [Always-up-to-date](/azure/azure-sql/managed-instance/update-policy#always-up-to-date-update-policy) update policy.

## Syntax

```syntaxsql
JARO_WINKLER_DISTANCE (
    character_expression,
    character_expression
)  
```

## Arguments

#### *character_expression*

An alphanumeric expression of character data. *character_expression* can be a constant, variable, or column. The character expression cannot be of type **varchar(max)** or **nvarchar(max)**.

## Return value

**real**

## Remarks

This function implements the Jaro-Winkler edit distance algorithm.

## Example

The following example compares two words and returns the `JARO_WINKLER_DISTANCE` value as a column, named `Distance`.

```sql
SELECT 'Colour' AS WordUK, 
       'Color' AS WordUS, 
       JARO_WINKLER_DISTANCE('Colour', 'Color') AS Distance;
```

Returns:

```output
WordUK WordUS Distance
------ ------ -------------
Colour Color  0.03333336
```

For additional examples, see [Example *JARO_WINKLER_DISTANCE*](../../relational-databases/fuzzy-string-match/overview.md#example-jaro_winkler_distance).

## Related content

- [EDIT_DISTANCE](edit-distance-transact-sql.md)
- [EDIT_DISTANCE_SIMILARITY](edit-distance-similarity-transact-sql.md)
- [JARO_WINKLER_SIMILARITY](jaro-winkler-similarity-transact-sql.md)
