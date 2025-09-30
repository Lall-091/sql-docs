---
title: "REGEXP_LIKE (Transact-SQL)"
description: REGEXP_LIKE Returns a Boolean value that indicates whether the text input matches the regex pattern.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: abhtiwar, wiassaf, randolphwest
ms.date: 05/19/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
dev_langs:
  - "TSQL"
monikerRange:  "= sql-server-ver17 || = sql-server-linux-ver17 || =azuresqldb-current || =azuresqldb-mi-current || =fabric"
ms.custom:
  - build-2025
---

# REGEXP_LIKE (Transact-SQL) preview

[!INCLUDE [sqlserver2025-asdb-asmi-fabric](../../includes/applies-to-version/sqlserver2025-asdb-asmi-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Indicates if the regular expression pattern matches in a string.

```syntaxsql
REGEXP_LIKE 
     (
      string_expression,
      pattern_expression [, flags ]
     )
```

`REGEXP_LIKE` requires database compatibility level 170 and above. If the database compatibility level is lower than 170, `REGEXP_LIKE` is not available. Other [regular expression scalar functions](regular-expressions-functions-transact-sql.md) are available at all compatibility levels.

You can check compatibility level in the `sys.databases` view or in database properties. You can change the compatibility level of a database with the following command:

```sql
ALTER DATABASE [DatabaseName] SET COMPATIBILITY_LEVEL = 170;
```

> [!NOTE]
> Regular expressions are available in Azure SQL Managed Instance with the **SQL Server 2025** or **Always-up-to-date** [update policy](/azure/azure-sql/managed-instance/update-policy).

## Arguments

#### *string_expression*

[!INCLUDE [regexp-string-expression](../../includes/regexp-string-expression.md)]

#### *pattern_expression*

[!INCLUDE [regexp-pattern-expression](../../includes/regexp-pattern-expression.md)]

#### *flags*

[!INCLUDE [regexp-flags-expression](../../includes/regexp-flags-expression.md)]

## Return value

Boolean value. `true` or `false`.

## Remarks

### SARGability support

**Applies to**: [!INCLUDE [ssazure-sqldb](../../includes/ssazure-sqldb.md)], [!INCLUDE[ssazuremi](../../includes/ssazuremi-md.md)], and SQL database in Microsoft Fabric. Currently not supported on [!INCLUDE [ssnoversion-md](../../includes/ssnoversion-md.md)].

`REGEXP_LIKE` supports *SARGability* when the pattern begins with anchor `^` and also the patterns that include quantifiers such as `*`, `+`, `?`, `{n}`, `{n,}`, and `{n,m}`, for example, `^ab+` or `^ab*` etc. It also supports range characters like `[0-9A-Za-z]` and allows the use of backslash `\` to escape the metacharacters. This allows the query optimizer to use index seek operations, improving query performance. However, regular expressions do not honor collation rules, which may lead to differences in behavior when compared to other string comparison functions like `LIKE`, especially on indexed columns with language-specific collations.

For example, in Turkish collation, the characters `i` and `I` are treated distinctly even in the case-insensitive collation due to language-specific rules.

> [!NOTE]  
> [!INCLUDE [search-argument](../../includes/paragraph-content/search-argument.md)]

### Cardinality estimation

To enhance the accuracy of [cardinality estimation](../../relational-databases/performance/cardinality-estimation-sql-server.md) for the `REGEXP_LIKE` function, you can use the `ASSUME_FIXED_MIN_SELECTIVITY_FOR_REGEXP` and `ASSUME_FIXED_MAX_SELECTIVITY_FOR_REGEXP` query hints to adjust the default selectivity values. For more information, see [Query hints](../queries/hints-transact-sql-query.md#use_hint).

These query hints are also integrated with [Cardinality estimation (CE) feedback](../../relational-databases/performance/intelligent-query-processing-cardinality-estimation-feedback.md). The CE feedback model automatically identifies queries using `REGEXP_LIKE` function where there is a significant difference between estimated and actual row counts. It then applies the appropriate selectivity hint at the query level to improve plan quality without requiring manual input.

To disable the automatic feedback behavior, enable Trace Flag 16268.

## Examples

Select all records from the `EMPLOYEES` table where the first name starts with `A` and ends with `Y`

```sql
SELECT * FROM EMPLOYEES WHERE REGEXP_LIKE (FIRST_NAME, '^A.*Y$'); 
```

Select all records from the `ORDERS` table where the order date is in February 2020.

```sql
SELECT * FROM ORDERS WHERE REGEXP_LIKE (ORDER_DATE, '2020-02-\d\d'); 
```

Select all records from the `PRODUCTS` table where the product name contains at least three consecutive vowels

```sql
SELECT * FROM PRODUCTS WHERE REGEXP_LIKE (PRODUCT_NAME, '[AEIOU]{3,}'); 
```

Create employees table with `CHECK` constraints for `Email` and `Phone_Number` columns. 

```sql
DROP TABLE IF EXISTS EMPLOYEES;

CREATE TABLE EMPLOYEES (  
    ID INT IDENTITY(101,1),  
    [Name] VARCHAR(150),  
    Email VARCHAR(320)  
    CHECK (REGEXP_LIKE(Email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),  
    Phone_Number NVARCHAR(20)  
    CHECK (REGEXP_LIKE (Phone_Number, '^(\d{3})-(\d{3})-(\d{4})$'))  
);
```

Here's an example that demonstrates SARGable vs non-SARGable use of the `REGEXP_LIKE` function with Turkish collation.

```sql
-- Create a temporary table with Turkish collation and and an index
CREATE TABLE #Users (
    Username NVARCHAR(100) COLLATE Turkish_100_CI_AS_SC_UTF8 NOT NULL,
    INDEX idx_username (Username)
);

-- Insert sample data
INSERT INTO #Users (Username)
VALUES (N'i'),    -- lowercase i
       (N'I'),    -- uppercase dotless I
       (N'İ'),    -- uppercase dotted İ
       (N'abc');

-- SARGable pattern: starts with ^ and uses quantifier
-- This will use index seek if applicable, but REGEXP_LIKE ignores collation
-- So 'i' and 'I' are treated as different characters
SELECT 'SARGable' AS PatternType, * 
FROM #Users
WHERE REGEXP_LIKE(Username, '^i');

-- Non-SARGable pattern: does not start with ^
-- REGEXP_LIKE performs full scan, and matches are case-insensitive since 'i' flag is supplied
-- So both 'i' and 'I' will match
SELECT 'Non-SARGable' AS PatternType, * 
FROM #Users
WHERE REGEXP_LIKE(Username, 'i','i');

-- Cleanup
DROP TABLE #Users;
```


## Related content

- [Work with regular expressions](../../relational-databases/regular-expressions/overview.md)
- [Regular expressions functions (Transact-SQL)](regular-expressions-functions-transact-sql.md)
