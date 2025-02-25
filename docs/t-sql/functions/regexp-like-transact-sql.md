---
title: "REGEXP_LIKE (Transact-SQL)"
description: REGEXP_LIKE Returns a Boolean value that indicates whether the text input matches the regex pattern.
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

# REGEXP_LIKE (Transact-SQL)

[!INCLUDE [asdb-fabricsqldb](../../includes/applies-to-version/asdb-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Indicates if the regular expression pattern matches in a string.

```syntaxsql
REGEXP_LIKE 
     (
      string_expression,
      pattern_expression [, flags ]
     )
```

> [!NOTE]
> **REGEXP_LIKE** is available only under compatibility level 170 and above. If your database compatibility level is lower than 170, SQL Server can't find and run **REGEXP_LIKE**. Other regular expression scalar functions are available at all compatibility levels.
>
> You can check compatibility level in the `sys.databases` view or in database properties. You can change the compatibility level of a database with the following command:
>
> ```sql
> ALTER DATABASE [DatabaseName] SET COMPATIBILITY_LEVEL = 170;
> ```

## Arguments

#### *string_expression*

[!INCLUDE [regexp-string-expression](../../includes/regexp-string-expression.md)]

#### *pattern_expression*

[!INCLUDE [regexp-pattern-expression](../../includes/regexp-pattern-expression.md)]

#### *flags*

[!INCLUDE [regexp-flags-expression](../../includes/regexp-flags-expression.md)]

## Return value

Boolean value. `true` or `false`.

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

## Related content

- [Work with regular expressions](../../relational-databases/regular-expressions/overview.md)
- [Regular expressions functions (Transact-SQL)](regular-expressions-functions-transact-sql.md)
