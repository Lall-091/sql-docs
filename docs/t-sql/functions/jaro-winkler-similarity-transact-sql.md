---
title: "JARO_WINKLER_SIMILARITY (Transact-SQL)"
description: JARO_WINKLER_SIMILARITY calculates a similarity value ranging from 0 (indicating no match) to 1 (indicating full match).
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: abhtiwar, wiassaf, randolphwest
ms.date: 01/21/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-current || =fabric"
---

# JARO_WINKLER_SIMILARITY (Transact-SQL)

[!INCLUDE [asdb-fabricsqldb](../../includes/applies-to-version/asdb-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Calculates a similarity value ranging from 0 (indicating no match) to 1 (indicating full match).

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

**real**

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
Colour Color  0.9666666
```

For additional examples, see [Example *JARO_WINKLER_SIMILARITY*](../../relational-databases/fuzzy-string-match/overview.md#example-jaro_winkler_similarity).

## Related content

- [EDIT_DISTANCE](edit-distance-transact-sql.md)
- [EDIT_DISTANCE_SIMILARITY](edit-distance-similarity-transact-sql.md)
- [JARO_WINKLER_DISTANCE](jaro-winkler-distance-transact-sql.md)
