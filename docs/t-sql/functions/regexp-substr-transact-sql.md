---
title: "REGEXP_SUBSTR (Transact-SQL)"
description: REGEXP_SUBSTR returns one occurrence of a substring of a string that matches the regular expression pattern.
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

# REGEXP_SUBSTR (Transact-SQL)

[!INCLUDE [asdb-fabricsqldb](../../includes/applies-to-version/asdb-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Returns one occurrence of a substring of a string that matches the regular expression pattern. If no match is found, it returns NULL.

```syntaxsql
REGEXP_SUBSTR 
     (
      string_expression,
      pattern_expression [, start [, occurrence [, flags [, group ] ] ] ] 
     )
```

## Arguments

#### *string_expression*

[!INCLUDE [regexp-string-expression](../../includes/regexp-string-expression.md)]

#### *pattern_expression*

[!INCLUDE [regexp-pattern-expression](../../includes/regexp-pattern-expression.md)]

#### *start*

Specify the starting position for the search within the search string. Optional. Type is **int** or **bigint**.

The numbering is 1-based, meaning the first character in the expression is `1` and the value must be `>= 1`. If the start expression is less than `1`, returns error. If the start expression is greater than the length of `string_expression`, the function returns `NULL`. The default is `1`.

#### *occurrence*

An expression (positive integer) that specifies which occurrence of the pattern expression within the source string to be searched or replaced. Default is `1`. Searches at the first character of the `string_expression`. For a positive integer `n`, it searches for the `nth` occurrence beginning with the first character following the first occurrence of the `pattern_expression`, and so forth.

#### *flags*

[!INCLUDE [regexp-flags-expression](../../includes/regexp-flags-expression.md)]

#### *group*

Specifies which capture group (`subexpression`) of a `pattern_expression` determines the position within `string_expression` to return. The capture group (`subexpression`) is a fragment of pattern enclosed in parentheses and can be nested. The capture groups are numbered in the order in which their left parentheses appear. The data type of group will be integer and the value must be greater than or equal to 0 and must not be greater than the number of capture groups (subexpressions) in pattern_expression. The default group value is 0, which indicates that the position is based on the string that matches the entire pattern.



## Return value

String.

## Examples

Extract the domain name from an email address.

```sql
SELECT REGEXP_SUBSTR (EMAIL, '@(.+)$', 1, 1, 'i', 1) AS DOMAIN FROM CUSTOMERS; 
```

Find the first word in a sentence that starts with a vowel.

```sql
SELECT REGEXP_SUBSTR (COMMENT, '\b[aeiou]\w*', 1, 1, 'i') AS WORD FROM FEEDBACK; 
```

Get the last four digits of a credit card number.

```sql
SELECT REGEXP_SUBSTR (CARD_NUMBER, '\d{4}$') AS LAST_FOUR FROM PAYMENTS; 
```

## Related content

- [Work with regular expressions](../../relational-databases/regular-expressions/overview.md)
- [Regular expressions functions (Transact-SQL)](regular-expressions-functions-transact-sql.md)
