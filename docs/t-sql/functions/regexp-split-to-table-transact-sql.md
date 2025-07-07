---
title: "REGEXP_SPLIT_TO_TABLE (Transact-SQL)"
description: Returns a table of strings split, delimited by the regex pattern. If there's no match to the pattern, the function returns the string.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: abhtiwar, wiassaf, randolphwest
ms.date: 05/19/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
dev_langs:
  - "TSQL"
monikerRange: "= sql-server-ver17 || = sql-server-linux-ver17 || =azuresqldb-current || =azuresqldb-mi-current || =fabric"
ms.custom:
  - build-2025
---

# REGEXP_SPLIT_TO_TABLE preview

[!INCLUDE [sqlserver2025-asdb-asmi-fabric](../../includes/applies-to-version/sqlserver2025-asdb-asmi-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Returns a table of strings split, delimited by the regex pattern. If there's no match to the pattern, the function returns the string.

```syntaxsql
REGEXP_SPLIT_TO_TABLE
     (
      string_expression,
      pattern_expression [, flags ]
     )
```

Requires database compatibility level 170. To set database compatibility level, review [ALTER DATABASE (Transact-SQL) compatibility level](../../t-sql/statements/alter-database-transact-sql-compatibility-level.md).

> [!NOTE]
> Regular expressions are available in Azure SQL Managed Instance configured with the [Always-up-to-date](/azure/azure-sql/managed-instance/update-policy#always-up-to-date-update-policy) update policy.


## Arguments

#### *string_expression*

[!INCLUDE [regexp-string-expression](../../includes/regexp-string-expression.md)] 

#### *pattern_expression*

[!INCLUDE [regexp-pattern-expression](../../includes/regexp-pattern-expression.md)]

#### *flags*

[!INCLUDE [regexp-flags-expression](../../includes/regexp-flags-expression.md)]

## Returns

`REGEXP_SPLIT_TO_TABLE` returns the following two-column table:

| Column name | Data type | Description |
| --- | --- | --- |
| `value` | Same type as `string_expression` or **varchar** | If the delimiter is found, it's the matching substring. Otherwise it's the whole expression. |
| `ordinal` | **bigint** | 1-based index value of each substring position from the input expression. |

Return a table split for `the quick brown fox jumps over the lazy dog`.

```sql
SELECT *
FROM REGEXP_SPLIT_TO_TABLE('the quick brown fox jumps over the lazy dog', '\s+');
```

```output
Value  Ordinal
the    1
quick  2
brown  3
fox    4
jumps  5
over   6
the    7
lazy   8
dog    9
```

## Related content

- [Work with regular expressions](../../relational-databases/regular-expressions/overview.md)
- [Regular expressions functions (Transact-SQL)](regular-expressions-functions-transact-sql.md)