---
title: "GROUP BY (Transact-SQL)"
description: A SELECT statement clause that divides the query result into groups of rows, usually by performing one or more aggregations on each group.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: randolphwest
ms.date: 02/02/2026
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
ms.custom:
  - ignite-2025
f1_keywords:
  - "GROUP"
  - "CUBE"
  - "ROLLUP"
  - "GROUPING_SETS_TSQL"
  - "GROUP BY"
  - "GROUPING SETS"
  - "GROUP_BY_TSQL"
  - "GROUP_TSQL"
  - "CUBE_TSQL"
  - "ROLLUP_TSQL"
helpviewer_keywords:
  - "GROUP BY clause, about GROUP BY clause"
  - "dividing tables into groups"
  - "GROUPING SETS"
  - "GROUP BY clause"
  - "table groups [SQL Server]"
  - "groups [SQL Server], tables divided into groups"
  - "summary values [SQL Server]"
dev_langs:
  - "TSQL"
monikerRange: ">=aps-pdw-2016 || =azuresqldb-current || =azure-sqldw-latest || >=sql-server-2016 || >=sql-server-linux-2017 || =azuresqldb-mi-current || =fabric || =fabric-sqldb"
---

# SELECT - GROUP BY clause (Transact-SQL)

[!INCLUDE [sql-asdb-asdbmi-asa-pdw-fabricse-fabricdw-fabricsqldb](../../includes/applies-to-version/sql-asdb-asdbmi-asa-pdw-fabricse-fabricdw-fabricsqldb.md)]

A `SELECT` statement clause that divides the query result into groups of rows, usually by performing one or more aggregations on each group. The `SELECT` statement returns one row per group.

## Syntax

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

Syntax for SQL Server and Azure SQL Database:

```syntaxsql
-- ISO-Compliant Syntax

GROUP BY {
      column-expression
    | ROLLUP ( <group_by_expression> [ , ...n ] )
    | CUBE ( <group_by_expression> [ , ...n ] )
    | GROUPING SETS ( <grouping_set> [ , ...n ]  )
    | () --calculates the grand total
} [ , ...n ]

<group_by_expression> ::=
      column-expression
    | ( column-expression [ , ...n ] )

<grouping_set> ::=
      () --calculates the grand total
    | <grouping_set_item>
    | ( <grouping_set_item> [ , ...n ] )

<grouping_set_item> ::=
      <group_by_expression>
    | ROLLUP ( <group_by_expression> [ , ...n ] )
    | CUBE ( <group_by_expression> [ , ...n ] )

-- For backward compatibility only.
-- Non-ISO-Compliant Syntax for SQL Server and Azure SQL Database

GROUP BY {
       ALL column-expression [ , ...n ]
    | column-expression [ , ...n ]  WITH { CUBE | ROLLUP }
       }
```

Syntax for Azure Synapse Analytics:

```syntaxsql
GROUP BY {
      column-name [ WITH (DISTRIBUTED_AGG) ]
    | column-expression
    | ROLLUP ( <group_by_expression> [ , ...n ] )
} [ , ...n ]
```

Syntax for Analytics Platform System (PDW):

```syntaxsql
GROUP BY {
      column-name [ WITH (DISTRIBUTED_AGG) ]
    | column-expression
} [ , ...n ]
```

## Arguments

### *column-expression*

Specifies a column or a non-aggregate calculation on a column. This column can belong to a table, derived table, or view. The column must appear in the `FROM` clause of the `SELECT` statement, but doesn't need to appear in the `SELECT` list.

For valid expressions, see [expression](../language-elements/expressions-transact-sql.md).

The column must appear in the `FROM` clause of the `SELECT` statement, but isn't required to appear in the `SELECT` list. However, each table or view column in any nonaggregate expression in the `<select>` list must be included in the `GROUP BY` list.

The following statements are allowed:

```sql
SELECT ColumnA,
       ColumnB
FROM T
GROUP BY ColumnA, ColumnB;

SELECT ColumnA + ColumnB
FROM T
GROUP BY ColumnA, ColumnB;

SELECT ColumnA + ColumnB
FROM T
GROUP BY ColumnA + ColumnB;

SELECT ColumnA + ColumnB + constant
FROM T
GROUP BY ColumnA, ColumnB;
```

The following statements aren't allowed:

```sql
SELECT ColumnA,
       ColumnB
FROM T
GROUP BY ColumnA + ColumnB;

SELECT ColumnA + constant + ColumnB
FROM T
GROUP BY ColumnA + ColumnB;
```

The column expression can't contain:

- A column alias that you define in the `SELECT` list. It can use a column alias for a derived table that is defined in the `FROM` clause.
- A column of type **text**, **ntext**, or **image**. However, you can use a column of text, ntext, or image as an argument to a function that returns a value of a valid data type. For example, the expression can use `SUBSTRING()` and `CAST()`. This rule also applies to expressions in the `HAVING` clause.
- xml data type methods. It can include a user-defined function that uses xml data type methods. It can include a computed column that uses xml data type methods.
- A subquery. Error 144 is returned.
- A column from an indexed view.

### GROUP BY *column-expression* [ ,...n ]

Groups the `SELECT` statement results according to the values in a list of one or more column expressions.

For example, this query creates a `Sales` table with columns for `Region`, `Territory`, and `Sales`. It inserts four rows and two of the rows have matching values for `Region` and `Territory`.

```sql
CREATE TABLE Sales
(
    Region VARCHAR (50),
    Territory VARCHAR (50),
    Sales INT
);
GO

INSERT INTO Sales VALUES (N'Canada', N'Alberta', 100);
INSERT INTO Sales VALUES (N'Canada', N'British Columbia', 200);
INSERT INTO Sales VALUES (N'Canada', N'British Columbia', 300);
INSERT INTO Sales VALUES (N'United States', N'Montana', 100);
```

The `Sales` table contains these rows:

| Region | Territory | Sales |
| --- | --- | --- |
| Canada | Alberta | 100 |
| Canada | British Columbia | 200 |
| Canada | British Columbia | 300 |
| United States | Montana | 100 |

This next query groups `Region` and `Territory` and returns the aggregate sum for each combination of values.

```sql
SELECT Region,
       Territory,
       SUM(sales) AS TotalSales
FROM Sales
GROUP BY Region, Territory;
```

The query result has three rows since there are three combinations of values for `Region` and `Territory`. The `TotalSales` for Canada and British Columbia is the sum of two rows.

| Region | Territory | TotalSales |
| --- | --- | --- |
| Canada | Alberta | 100 |
| Canada | British Columbia | 500 |
| United States | Montana | 100 |

### GROUP BY ROLLUP

Creates a group for each combination of column expressions. In addition, it "rolls up" the results into subtotals and grand totals. To do this, it moves from right to left, decreasing the number of column expressions over which it creates groups and the aggregations.

The column order affects the `ROLLUP` output and can affect the number of rows in the result set.

For example, `GROUP BY ROLLUP (col1, col2, col3, col4)` creates groups for each combination of column expressions in the following lists:

- col1, col2, col3, col4
- col1, col2, col3, NULL
- col1, col2, NULL, NULL
- col1, NULL, NULL, NULL
- NULL, NULL, NULL, NULL (This is the grand total)

Using the table from the previous example, this code runs a `GROUP BY ROLLUP` operation instead of a simple `GROUP BY`.

```sql
SELECT Region,
       Territory,
       SUM(Sales) AS TotalSales
FROM Sales
GROUP BY ROLLUP(Region, Territory);
```

The query result has the same aggregations as the simple `GROUP BY` without the `ROLLUP`. In addition, it creates subtotals for each value of Region. Finally, it gives a grand total for all rows. The result looks like this:

| Region | Territory | TotalSales |
| --- | --- | ---: |
| Canada | Alberta | 100 |
| Canada | British Columbia | 500 |
| Canada | NULL | 600 |
| United States | Montana | 100 |
| United States | NULL | 100 |
| NULL | NULL | 700 |

### GROUP BY CUBE ()

`GROUP BY CUBE` creates groups for all possible combinations of columns. For `GROUP BY CUBE (a, b)`, the results have groups for unique values of `(a, b)`, `(NULL, b)`, `(a, NULL)`, and `(NULL, NULL)`.

Using the table from the previous examples, this code runs a `GROUP BY CUBE` operation on Region and Territory.

```sql
SELECT Region,
       Territory,
       SUM(Sales) AS TotalSales
FROM Sales
GROUP BY CUBE(Region, Territory);
```

The query result has groups for unique values of `(Region, Territory)`, `(NULL, Territory)`, `(Region, NULL)`, and `(NULL, NULL)`. The results look like this:

| Region | Territory | TotalSales |
| --- | --- | --- |
| Canada | Alberta | 100 |
| NULL | Alberta | 100 |
| Canada | British Columbia | 500 |
| NULL | British Columbia | 500 |
| United States | Montana | 100 |
| NULL | Montana | 100 |
| NULL | NULL | 700 |
| Canada | NULL | 600 |
| United States | NULL | 100 |

### GROUP BY GROUPING SETS ()

The `GROUPING SETS` option combines multiple `GROUP BY` clauses into one `GROUP BY` clause. The results are the same as using `UNION ALL` on the specified groups.

For example, `GROUP BY ROLLUP (Region, Territory)` and `GROUP BY GROUPING SETS ( ROLLUP (Region, Territory))` return the same results.

When `GROUPING SETS` has two or more elements, the results are a union of the elements. This example returns the union of the `ROLLUP` and `CUBE` results for Region and Territory.

```sql
SELECT Region,
       Territory,
       SUM(Sales) AS TotalSales
FROM Sales
GROUP BY GROUPING SETS(ROLLUP(Region, Territory), CUBE(Region, Territory));
```

The results are the same as this query that returns a union of the two `GROUP BY` statements.

```sql
SELECT Region,
       Territory,
       SUM(Sales) AS TotalSales
FROM Sales
GROUP BY ROLLUP(Region, Territory)
UNION ALL
SELECT Region,
       Territory,
       SUM(Sales) AS TotalSales
FROM Sales
GROUP BY CUBE(Region, Territory);
```

SQL doesn't consolidate duplicate groups generated for a `GROUPING SETS` list. For example, in `GROUP BY ((), CUBE (Region, Territory))`, both elements return a row for the grand total, and both rows appear in the results.

### GROUP BY ()

Specifies the empty group, which generates the grand total. This group is useful as one of the elements of a `GROUPING SET`. For example, this statement gives the total sales for each region and then gives the grand total for all regions.

```sql
SELECT Region,
       SUM(Sales) AS TotalSales
FROM Sales
GROUP BY GROUPING SETS(Region, ());
```

### GROUP BY ALL column-expression [ ,...n ]

**Applies to**: SQL Server and Azure SQL Database

> [!NOTE]  
> Use this syntax only for backward compatibility. Avoid using this syntax in new development work, and plan to modify applications that currently use this syntax.

Specifies whether to include all groups in the results, regardless of whether they meet the search criteria in the `WHERE` clause. Groups that don't meet the search criteria have `NULL` for the aggregation.

`GROUP BY ALL`:

- Isn't supported in queries that access remote tables if there's also a `WHERE` clause in the query.
- Fails on columns that have the FILESTREAM attribute.

### GROUP BY column-expression [ ,...n ] WITH { CUBE | ROLLUP }

**Applies to**: SQL Server and Azure SQL Database

> [!NOTE]  
> Use this syntax only for backward compatibility. Avoid using this syntax in new development work, and plan to modify applications that currently use this syntax.

### WITH (DISTRIBUTED_AGG)

**Applies to**: [!INCLUDE [ssazuresynapse-md](../../includes/ssazuresynapse-md.md)] and [!INCLUDE [ssPDW](../../includes/sspdw-md.md)]

The `DISTRIBUTED_AGG` query hint forces the massively parallel processing (MPP) system to redistribute a table on a specific column before performing an aggregation. Only one column in the `GROUP BY` clause can have a `DISTRIBUTED_AGG` query hint. After the query finishes, the redistributed table is dropped. The original table isn't changed.

> [!NOTE]  
> The `DISTRIBUTED_AGG` query hint is provided for backward compatibility with earlier [!INCLUDE [ssPDW](../../includes/sspdw-md.md)] versions and doesn't improve performance for most queries. By default, MPP already redistributes data as necessary to improve performance for aggregations.

## Remarks

### How GROUP BY interacts with the SELECT statement

`SELECT` list:

- Vector aggregates. If you include aggregate functions in the `SELECT` list, `GROUP BY` calculates a summary value for each group. These functions are known as vector aggregates.
- Distinct aggregates. The aggregates `AVG(DISTINCT <column_name>)`, `COUNT(DISTINCT <column_name>)`, and `SUM(DISTINCT <column_name>)` work with `ROLLUP`, `CUBE`, and `GROUPING SETS`.

`WHERE` clause:

- SQL removes rows that don't meet the conditions in the `WHERE` clause before it performs any grouping operation.

`HAVING` clause:

- SQL uses the `HAVING` clause to filter groups in the result set.

`ORDER BY` clause:

- Use the `ORDER BY` clause to order the result set. The `GROUP BY` clause doesn't order the result set.

`NULL` values:

- If a grouping column contains `NULL` values, all `NULL` values are considered equal, and they're collected into a single group.

## Limitations

**Applies to**: SQL Server and [!INCLUDE [ssazuresynapse-md](../../includes/ssazuresynapse-md.md)]

### Maximum capacity

For a `GROUP BY` clause that uses `ROLLUP`, `CUBE`, or `GROUPING SETS`, the maximum number of expressions is 32. The maximum number of groups is 4,096 (2<sup>12</sup>). The following examples fail because the `GROUP BY` clause has more than 4,096 groups.

- The following example generates 4,097 (2<sup>12</sup> + 1) grouping sets and then fails.

  ```sql
  GROUP BY GROUPING SETS( CUBE(a1, ..., a12), b)
  ```

- The following example generates 4,097 (2<sup>12</sup> + 1) groups and then fails. Both `CUBE ()` and the `()` grouping set produce a grand total row and duplicate grouping sets aren't eliminated.

  ```sql
  GROUP BY GROUPING SETS( CUBE(a1, ..., a12), ())
  ```

- This example uses the backward compatible syntax. It generates 8,192 (2<sup>13</sup>) grouping sets and then fails.

  ```sql
  GROUP BY CUBE (a1, ..., a13)
  GROUP BY a1, ..., a13 WITH CUBE
  ```

  For backward compatible `GROUP BY` clauses that don't contain `CUBE` or `ROLLUP`, the number of `GROUP BY` items is limited by the `GROUP BY` column sizes, the aggregated columns, and the aggregate values involved in the query. This limit originates from the limit of 8,060 bytes on the intermediate worktable that holds intermediate query results. A maximum of 12 grouping expressions is permitted when `CUBE` or `ROLLUP` is specified.

### Support for ISO and ANSI SQL-2006 GROUP BY Features

The `GROUP BY` clause supports all `GROUP BY` features that are included in the SQL-2006 standard with the following syntax exceptions:

- Grouping sets aren't allowed in the `GROUP BY` clause unless they're part of an explicit `GROUPING SETS` list. For example, `GROUP BY Column1, (Column2, ...ColumnN)` is allowed in the standard but not in Transact-SQL. Transact-SQL supports `GROUP BY C1, GROUPING SETS ((Column2, ...ColumnN))` and `GROUP BY Column1, Column2, ... ColumnN`, which are semantically equivalent. These clauses are semantically equivalent to the previous `GROUP BY` example. This restriction avoids the possibility that `GROUP BY Column1, (Column2, ...ColumnN)` might be misinterpreted as `GROUP BY C1, GROUPING SETS ((Column2, ...ColumnN))`, which aren't semantically equivalent.

- Grouping sets aren't allowed inside grouping sets. For example, `GROUP BY GROUPING SETS (A1, A2,...An, GROUPING SETS (C1, C2, ...Cn))` is allowed in the SQL-2006 standard but not in Transact-SQL. Transact-SQL allows `GROUP BY GROUPING SETS( A1, A2,...An, C1, C2, ...Cn)` or `GROUP BY GROUPING SETS( (A1), (A2), ... (An), (C1), (C2), ... (Cn))`, which are semantically equivalent to the first `GROUP BY` example and have clearer syntax.

- `GROUP BY ALL` and `GROUP BY DISTINCT` are only allowed in a simple `GROUP BY` clause that contains column expressions. You can't use them with the `GROUPING SETS`, `ROLLUP`, `CUBE`, `WITH CUBE`, or `WITH ROLLUP` constructs. `ALL` is the default and is implicit. It's also only allowed in the backward compatible syntax.

### Comparison of supported `GROUP BY` features

The following table describes the `GROUP BY` features that different SQL Server versions and database compatibility levels support.

| Feature | SQL Server Integration Services | SQL Server compatibility level 100 or higher |
| --- | --- | --- |
| `DISTINCT` aggregates | Not supported for `WITH CUBE` or `WITH ROLLUP`. | Supported for `WITH CUBE`, `WITH ROLLUP`, `GROUPING SETS`, `CUBE`, or `ROLLUP`. |
| User-defined function with `CUBE` or `ROLLUP` name in the `GROUP BY` clause | User-defined function `dbo.cube(<arg1>, ...<argN>)` or `dbo.rollup(<arg1>, ...<argN>)` in the `GROUP BY` clause is allowed.<br /><br />For example: `SELECT SUM (x) FROM T GROUP BY dbo.cube(y);` | User-defined function `dbo.cube (<arg1>, ...<argN>)` or `dbo.rollup(arg1>, ...<argN>)` in the `GROUP BY` clause isn't allowed.<br /><br />For example: `SELECT SUM (x) FROM T GROUP BY dbo.cube(y);`<br /><br />The following error message is returned: "Incorrect syntax near the keyword 'cube'&#124;'rollup'."<br /><br />To avoid this problem, replace `dbo.cube` with `[dbo].[cube]` or `dbo.rollup` with `[dbo].[rollup]`.<br /><br />The following example is allowed: `SELECT SUM (x) FROM T GROUP BY [dbo].[cube](y);` |
| `GROUPING SETS` | Not supported | Supported |
| `CUBE` | Not supported | Supported |
| `ROLLUP` | Not supported | Supported |
| Grand total, such as `GROUP BY()` | Not supported | Supported |
| `GROUPING_ID` function | Not supported | Supported |
| `GROUPING` function | Supported | Supported |
| `WITH CUBE` | Supported | Supported |
| `WITH ROLLUP` | Supported | Supported |
| `WITH CUBE` or `WITH ROLLUP` "duplicate" grouping removal | Supported | Supported |

## Examples

### A. Use a basic GROUP BY clause

The following example retrieves the total for each `SalesOrderID` from the `SalesOrderDetail` table. This example uses AdventureWorks.

```sql
SELECT SalesOrderID,
       SUM(LineTotal) AS SubTotal
FROM Sales.SalesOrderDetail AS sod
GROUP BY SalesOrderID
ORDER BY SalesOrderID;
```

### B. Use a GROUP BY clause with multiple tables

The following example retrieves the number of employees for each `City` from the `Address` table joined to the `EmployeeAddress` table. This example uses AdventureWorks.

```sql
SELECT a.City,
       COUNT(bea.AddressID) AS EmployeeCount
FROM Person.BusinessEntityAddress AS bea
     INNER JOIN Person.Address AS a
         ON bea.AddressID = a.AddressID
GROUP BY a.City
ORDER BY a.City;
```

### C. Use a GROUP BY clause with an expression

The following example retrieves the total sales for each year by using the `DATEPART` function. You must include the same expression in both the `SELECT` list and `GROUP BY` clause.

```sql
SELECT DATEPART(yyyy, OrderDate) AS N'Year',
       SUM(TotalDue) AS N'Total Order Amount'
FROM Sales.SalesOrderHeader
GROUP BY DATEPART(yyyy, OrderDate)
ORDER BY DATEPART(yyyy, OrderDate);
```

### D. Use a GROUP BY clause with a HAVING clause

The following example uses the `HAVING` clause to specify which groups generated in the `GROUP BY` clause should be included in the result set.

```sql
SELECT DATEPART(yyyy, OrderDate) AS N'Year',
       SUM(TotalDue) AS N'Total Order Amount'
FROM Sales.SalesOrderHeader
GROUP BY DATEPART(yyyy, OrderDate)
HAVING DATEPART(yyyy, OrderDate) >= N'2003'
ORDER BY DATEPART(yyyy, OrderDate);
```

## Examples: Azure Synapse Analytics and Analytics Platform System (PDW)

### E. Basic use of the GROUP BY clause

The following example finds the total amount for all sales on each day. One row containing the sum of all sales is returned for each day.

```sql
-- Uses AdventureWorksDW
SELECT OrderDateKey,
       SUM(SalesAmount) AS TotalSales
FROM FactInternetSales
GROUP BY OrderDateKey
ORDER BY OrderDateKey;
```

### F. Basic use of the DISTRIBUTED_AGG hint

This example uses the DISTRIBUTED_AGG query hint to force the appliance to shuffle the table on the `CustomerKey` column before it performs the aggregation.

```sql
-- Uses AdventureWorksDW
SELECT CustomerKey,
       SUM(SalesAmount) AS sas
FROM FactInternetSales
GROUP BY CustomerKey WITH(DISTRIBUTED_AGG)
ORDER BY CustomerKey DESC;
```

### G. Syntax variations for GROUP BY

When the select list has no aggregations, you must include each column in the select list in the `GROUP BY` list. You can include computed columns in the select list, but you aren't required to include them in the `GROUP BY` list. These examples show syntactically valid `SELECT` statements:

```sql
-- Uses AdventureWorks
SELECT LastName,
       FirstName
FROM DimCustomer
GROUP BY LastName, FirstName;
SELECT NumberCarsOwned
FROM DimCustomer
GROUP BY YearlyIncome, NumberCarsOwned;
SELECT (SalesAmount + TaxAmt + Freight) AS TotalCost
FROM FactInternetSales
GROUP BY SalesAmount, TaxAmt, Freight;
SELECT SalesAmount,
       SalesAmount * 1.10 AS SalesTax
FROM FactInternetSales
GROUP BY SalesAmount;
SELECT SalesAmount
FROM FactInternetSales
GROUP BY SalesAmount, SalesAmount * 1.10;
```

<a id="h-using-a-group-by-with-multiple-group-by-expressions"></a>

### H. Use a GROUP BY clause with multiple GROUP BY expressions

The following example groups results using multiple `GROUP BY` criteria. If, within each `OrderDateKey` group, subgroups exist that the `DueDateKey` value differentiates, the query defines a new grouping for the result set.

```sql
-- Uses AdventureWorks
SELECT OrderDateKey,
       DueDateKey,
       SUM(SalesAmount) AS TotalSales
FROM FactInternetSales
GROUP BY OrderDateKey, DueDateKey
ORDER BY OrderDateKey;
```

<a id="i-using-a-group-by-clause-with-a-having-clause"></a>

### I. Use a GROUP BY clause with a HAVING clause

The following example uses the `HAVING` clause to specify the groups generated in the `GROUP BY` clause that should be included in the result set. Only those groups with order dates in 2004 or later are included in the results.

```sql
-- Uses AdventureWorks
SELECT OrderDateKey,
       SUM(SalesAmount) AS TotalSales
FROM FactInternetSales
GROUP BY OrderDateKey
HAVING OrderDateKey > 20040000
ORDER BY OrderDateKey;
```

## Related content

- [GROUPING_ID (Transact-SQL)](../functions/grouping-id-transact-sql.md)
- [GROUPING (Transact-SQL)](../functions/grouping-transact-sql.md)
- [SELECT (Transact-SQL)](select-transact-sql.md)
- [SELECT clause (Transact-SQL)](select-clause-transact-sql.md)
