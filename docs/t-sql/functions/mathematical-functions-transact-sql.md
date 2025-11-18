---
title: "Mathematical Functions (Transact-SQL)"
description: Mathematical Transact-SQL functions in the SQL Server Database Engine.
author: markingmyname
ms.author: maghan
ms.reviewer: randolphwest
ms.date: 12/16/2024
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
ms.custom:
  - ignite-2025
helpviewer_keywords:
  - "calculations [SQL Server]"
  - "mathematical functions [SQL Server]"
  - "functions [SQL Server], mathematical"
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-current || =azuresqldb-mi-current || >=sql-server-2016 || >=sql-server-linux-2017 || =azuresqledge-current || =azure-sqldw-latest || >=aps-pdw-2016 || =fabric || =fabric-sqldb"
---
# Mathematical functions (Transact-SQL)

[!INCLUDE [sql-asdb-asdbmi-asa-pdw-fabricse-fabricdw-fabricsqldb](../../includes/applies-to-version/sql-asdb-asdbmi-asa-pdw-fabricse-fabricdw-fabricsqldb.md)]

The following scalar functions perform a calculation, usually based on input values that are provided as arguments, and return a numeric value:

- [ABS](abs-transact-sql.md)
- [ACOS](acos-transact-sql.md)
- [ASIN](asin-transact-sql.md)
- [ATAN](atan-transact-sql.md)
- [ATN2](atn2-transact-sql.md)
- [CEILING](ceiling-transact-sql.md)
- [COS](cos-transact-sql.md)
- [COT](cot-transact-sql.md)
- [DEGREES](degrees-transact-sql.md)
- [EXP](exp-transact-sql.md)
- [FLOOR](floor-transact-sql.md)
- [LOG](log-transact-sql.md)
- [LOG10](log10-transact-sql.md)
- [PI](pi-transact-sql.md)
- [POWER](power-transact-sql.md)
- [RADIANS](radians-transact-sql.md)
- [RAND](rand-transact-sql.md)
- [ROUND](round-transact-sql.md)
- [SIGN](sign-transact-sql.md)
- [SIN](sin-transact-sql.md)
- [SQRT](sqrt-transact-sql.md)
- [SQUARE](square-transact-sql.md)
- [TAN](tan-transact-sql.md)

Arithmetic functions, such as `ABS`, `CEILING`, `DEGREES`, `FLOOR`, `POWER`, `RADIANS`, and `SIGN`, return a value having the same data type as the input value. Trigonometric and other functions, including `EXP`, `LOG`, `LOG10`, `SQUARE`, and `SQRT`, cast their input values to **float** and return a **float** value.

All mathematical functions, except for `RAND`, are deterministic functions. This means they return the same results each time they're called with a specific set of input values. `RAND` is deterministic only when a seed parameter is specified. For more information about function determinism, see [Deterministic and nondeterministic functions](../../relational-databases/user-defined-functions/deterministic-and-nondeterministic-functions.md).

## Related content

- [Arithmetic operators (Transact-SQL)](../language-elements/arithmetic-operators-transact-sql.md)
- [What are the SQL database functions?](functions.md)

