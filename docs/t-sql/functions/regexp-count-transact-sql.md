---
title: "REGEXP_COUNT (Transact-SQL)"
description: REGEXP_COUNT returns the number of times that a matched expression pattern exists in a string.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: abhtiwar, wiassaf, randolphwest
ms.date: 12/31/2024
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-current || =fabric"
---

# REGEXP_COUNT (Transact-SQL)

[!INCLUDE [asdb-fabricsqldb](../../includes/applies-to-version/asdb-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Counts the number of times that a regular expression pattern is matched in a string.

```syntaxsql
REGEXP_COUNT (
    string_expression,
    pattern_expression [ , start [ , flags ] ]
)  
```

## Arguments

#### *string_expression*

[!INCLUDE [regexp-string-expression](../../includes/regexp-string-expression.md)]

#### *pattern_expression*

[!INCLUDE [regexp-pattern-expression](../../includes/regexp-pattern-expression.md)]

#### *start*

Specify the starting position for the search within the search string. Optional. Type is **int** or **bigint**.

The numbering is 1-based, meaning the first character in the expression is `1` and the value must be `>= 1`. If the start expression is less than `1`, the returned `pattern_expression` begins at the first character that is specified in `string_expression`. If the start expression is greater than the length of `string_expression`, the function returns 0. The default is `1`.

If the start expression is less than `1`, the query returns an error.

#### *flags*

[!INCLUDE [regexp-flags-expression](../../includes/regexp-flags-expression.md)]

## Return value

**int**

## Examples

Count how many times the letter `a` appears in each product name.

```sql
SELECT PRODUCT_NAME, REGEXP_COUNT(PRODUCT_NAME, 'a') AS A_COUNT FROM PRODUCTS; 
```

Count how many products have a name that ends with `ing`.

```sql
SELECT COUNT(*) FROM PRODUCTS WHERE REGEXP_COUNT(PRODUCT_NAME, 'ing$') > 0;
```

Count how many products have a name that contains three consecutive consonants, ignoring case.

```sql
SELECT COUNT(*) FROM PRODUCTS WHERE REGEXP_COUNT(PRODUCT_NAME, '[^aeiou]{3}', 1, 'i') > 0; 
```

## Related content

- [Work with regular expressions](../../relational-databases/regular-expressions/overview.md)
- [Regular expressions functions (Transact-SQL)](regular-expressions-functions-transact-sql.md)