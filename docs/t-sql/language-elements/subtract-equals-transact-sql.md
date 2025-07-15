---
title: "-= (Subtraction Assignment) (Transact-SQL)"
description: Subtracts two numbers and sets a value to the result of the operation.
author: rwestMSFT
ms.author: randolphwest
ms.date: 07/15/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
ms.custom:
  - ignite-2024
f1_keywords:
  - "-="
  - "-=_TSQL"
helpviewer_keywords:
  - "compound operators, -="
  - "assignment operators, -="
  - "augmented operators, -="
  - "-= (subtract equals)"
  - "-= (subtraction assignment)"
dev_langs:
  - "TSQL"
monikerRange: ">=aps-pdw-2016 || =azuresqldb-current || =azure-sqldw-latest || >=sql-server-2016 || >=sql-server-linux-2017 || =azuresqldb-mi-current || =fabric"
---

# -= (Subtraction assignment) (Transact-SQL)

[!INCLUDE [sql-asdb-asdbmi-asa-pdw-fabricse-fabricdw-fabricsqldb](../../includes/applies-to-version/sql-asdb-asdbmi-asa-pdw-fabricse-fabricdw-fabricsqldb.md)]

Subtracts two numbers and sets a value to the result of the operation. For example, if a variable @x equals 35, then @x -= 2 takes the original value of @x, subtracts 2 and sets @x to that new value (33).

## Syntax

```syntaxsql
expression - = expression
```

## Arguments

#### *expression*

Any valid [expression](expressions-transact-sql.md) of any one of the data types in the numeric category except the **bit** data type.

## Return types

Returns the data type of the argument with the higher precedence. For more information, see [Data type precedence](../data-types/data-type-precedence-transact-sql.md).

## Remarks

For more information, see [- (Subtraction)](subtract-transact-sql.md).

## Related content

- [Compound Operators (Transact-SQL)](compound-operators-transact-sql.md)
- [Expressions (Transact-SQL)](expressions-transact-sql.md)
- [Operators (Transact-SQL)](operators-transact-sql.md)
