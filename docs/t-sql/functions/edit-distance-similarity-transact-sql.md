---
title: "EDIT_DISTANCE_SIMILARITY (Transact-SQL)"
description: EDIT_DISTANCE_SIMILARITY calculates a similarity value ranging from 0 (indicating no match) to 100 (indicating full match).
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: abhtiwar, wiassaf, randolphwest
ms.date: 01/15/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-current || =fabric"
---

# EDIT_DISTANCE_SIMILARITY (Transact-SQL)

[!INCLUDE [asdb-fabricsqldb](../../includes/applies-to-version/asdb-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Calculates a similarity value ranging from 0 (indicating no match) to 100 (indicating full match).

```syntaxsql
EDIT_DISTANCE_SIMILARITY (
    character_expression,
    character_expression
)  
```

## Arguments

#### *character_expression*

An alphanumeric expression of character data. *character_expression* can be a constant, variable, or column. The character expression cannot be of type **varchar(max)** or **nvarchar(max)**.

## Return type

**int**

## Remarks

This function implements the Damerau-Levenshtein algorithm. If any of the inputs is NULL then the function returns a NULL value. Otherwise, the function returns an integer value from 0 to 100. The similarity value is computed as `(1 – (edit_distance / greatest(len(string1), len(string2)))) * 100`.

## Example

The following example compares two words and returns the `EDIT_DISTANCE_SIMILARITY()` value as a column, named `Distance`.

```sql
SELECT 'Colour' AS WordUK, 
       'Color' AS WordUS, 
       EDIT_DISTANCE_SIMILARITY('Colour', 'Color') AS Distance;
```

Returns:

```output
WordUK WordUS Distance
------ ------ -----------
Colour Color  83
```

For additional examples, see [Example *EDIT_DISTANCE_SIMILARITY()*](../../relational-databases/fuzzy-string-match/overview.md#example-edit_distance_similarity).

## Related content

- [EDIT_DISTANCE](edit-distance-transact-sql.md)
- [JARO_WINKLER_DISTANCE](jaro-winkler-distance-transact-sql.md)
- [JARO_WINKLER_SIMILARITY](jaro-winkler-similarity-transact-sql.md)
