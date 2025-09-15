---
title: "REGEXP_MATCHES (Transact-SQL)"
description: Returns a table of captured substring(s) that match a regular expression pattern to a string. If no match is found, the function returns no row.
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

# REGEXP_MATCHES (Transact-SQL) preview

[!INCLUDE [sqlserver2025-asdb-asmi-fabric](../../includes/applies-to-version/sqlserver2025-asdb-asmi-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Returns a table of captured substring(s) that match a regular expression pattern to a string. If no match is found, the function returns no row.

```syntaxsql
REGEXP_MATCHES
     (
      string_expression,
      pattern_expression [, flags ]
     )
```

Requires database compatibility level 170. To set database compatibility level, review [ALTER DATABASE (Transact-SQL) compatibility level](../../t-sql/statements/alter-database-transact-sql-compatibility-level.md).

> [!NOTE]
> Regular expressions are available in Azure SQL Managed Instance with the **SQL Server 2025** or **Always-up-to-date** [update policy](/azure/azure-sql/managed-instance/update-policy).


## Arguments

#### *string_expression*

[!INCLUDE [regexp-string-expression](../../includes/regexp-string-expression.md)] 

#### *pattern_expression*

[!INCLUDE [regexp-pattern-expression](../../includes/regexp-pattern-expression.md)]

#### *flags*

[!INCLUDE [regexp-flags-expression](../../includes/regexp-flags-expression.md)]

## Returns

Returns a tabular result as follows:

| Column name | Data type | Description |
| --- | --- | --- |
| `match_id` | **bigint** | The sequence of matching words. |
| `start_position` | **int** | Starting index position. |
| `end_position` | **int** | Ending index position. |
| `match_value` | Same type as `string_expression` or **varchar** | Matching expression. |
| `substring_matches` | **json** | JSON document describing match. |

## Examples

Return tabular results from `'Learning #AzureSQL #AzureSQLDB'` that start with a `#` character followed by one or more alphanumeric characters (`A-Z, a-z, 0-9`) or underscores (`_`).

```sql
SELECT *
FROM REGEXP_MATCHES('Learning #AzureSQL #AzureSQLDB', '#([A-Za-z0-9_]+)');
```

```output
match_id start_position end_position match_value substring_matches
1        10             18           #AzureSQL   [{"value":"AzureSQL","start":11,"length":8}]
2        20             30           #AzureSQLDB [{"value":"AzureSQLDB","start":21,"length":10}]
```

Return strings from `ABC` that match strings that start with the letter `A` followed by exactly two characters.

```sql
SELECT *
FROM REGEXP_MATCHES('ABC', '^(A)(..)$');
```

```output
match_id start_position end_position match_value substring_matches
1        1              3            ABC         [{"value":"A","start":1,"length":1},{"value":"BC","start":2,"length":2}]
```

## Related content

- [Work with regular expressions](../../relational-databases/regular-expressions/overview.md)
- [Regular expressions functions (Transact-SQL)](regular-expressions-functions-transact-sql.md)
