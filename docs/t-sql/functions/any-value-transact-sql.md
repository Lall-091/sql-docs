---
title: ANY_VALUE (Transact-SQL)
description: The ANY_VALUE function returns any non-NULL value from a group of rows, or NULL if all values are NULL.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: jovanpop
ms.date: 03/30/2026
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
f1_keywords:
  - "ANY_VALUE_TSQL"
  - "ANY_VALUE"
helpviewer_keywords:
  - "ANY_VALUE function"
  - "analytic functions, ANY_VALUE"
dev_langs:
  - TSQL
monikerRange: "=fabric"
---

# ANY_VALUE (Transact-SQL)

[!INCLUDE [fabric-se-dw](../../includes/applies-to-version/fabric-se-dw.md)]

The `ANY_VALUE` function returns any (non-`NULL` if possible) value from a group of rows. You can use it as both an aggregate function and a window (analytic) function:

- Aggregate usage: Returns an arbitrary value from the entire group.
- Window usage: Operates over a defined window frame and returns an arbitrary value from the entire window.

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)  

## Syntax

Aggregation function syntax:

```syntaxsql
ANY_VALUE ( [ ALL | DISTINCT ] expression )
```

Analytic function syntax:

```syntaxsql
ANY_VALUE ( [ ALL | DISTINCT ] expression) OVER ( [ <partition_by_clause> ] [ <order_by_clause> ] )
```

## Arguments

#### ALL

Applies the aggregate function to all values. ALL is the default, only meaningful option, and is available for ISO compatibility only.

#### DISTINCT

`DISTINCT` isn't meaningful with `ANY_VALUE`, and is available for ISO compatibility only.

#### *expression*  

 The value to be returned. Any of the values can be returned as the result, but the `NULL` values are skipped if possible. 

#### OVER clause

The *partition_by_clause* divides the result set produced by the `FROM` clause into partitions, and the function is applied to each partition.

If you don't specify this clause, the function treats all rows of the query result set as a single group.

The *order_by_clause* determines the order of the data before the function is applied. If you specify *partition_by_clause*, it determines the order of the data in the partition. The *order_by_clause* isn't required. 

For more information, see [SELECT - OVER clause (Transact-SQL)](../queries/select-over-clause-transact-sql.md).  

## Return types

Returns a value of the same type as *expression*. 

## Remarks

`ANY_VALUE` is nondeterministic. For more information, see [Deterministic and nondeterministic functions](../../relational-databases/user-defined-functions/deterministic-and-nondeterministic-functions.md). Unlike `FIRST_VALUE` or `LAST_VALUE`, `ANY_VALUE` doesn't provide deterministic ordering. It's designed for cases where the exact value isn't important to the query logic. 

The function attempts to return a non-`NULL` value when possible and returns `NULL` value only if all values are `NULL`. 

## Use case

A common use case for `ANY_VALUE` is when you need to include nonkey columns in a result set grouped by a key column. For example, if you group rows by `StoreID`, you can use `ANY_VALUE` to return values for columns such as store name, address, or other descriptive attributes without adding them to the `GROUP BY` clause or using more expensive functions like `MAX`, `MIN`, `FIRST_VALUE`, or `LAST_VALUE` to include them in the projection. This approach simplifies query design, improves readability, and enhances performance because SQL query doesn't need to perform unnecessary grouping on the descriptive columns. As a result, your aggregation remains concise, easier to maintain, and more efficient.

## Examples

### A. Retrieve any non-NULL value

This simple query demonstrates how `ANY_VALUE` can return an arbitrary non-NULL value from a set of values:

```sql
SELECT ANY_VALUE(v)
FROM (VALUES (NULL), (NULL), (NULL), (NULL), (2), (NULL), (NULL), (7), (NULL), (NULL)) AS t(v);
```

The function ignores `NULL` values and returns one of the non-`NULL` values (sometimes 2, sometimes 7) in a nondeterministic way.

### B. Project descriptive columns

This query summarizes total sales per store by joining `FactSales` with `DimStore`, grouping on `StoreKey`, and retrieving key store details using `ANY_VALUE`.

```sql   
USE ContosoDW;  
GO  
SELECT
    fs.StoreKey,
    ANY_VALUE(ds.StoreName)        AS StoreName,
    ANY_VALUE(ds.StoreDescription) AS StoreDescription,
    ANY_VALUE(ds.Status)           AS StoreStatus,
    ANY_VALUE(ds.Phone)            AS StorePhone,
    ANY_VALUE(ds.Fax)              AS StoreFax,
    ANY_VALUE(ds.ZipCode)          AS ZipCode,
    ANY_VALUE(ds.AddressLine1)     AS AddressLine1,
    ANY_VALUE(ds.AddressLine2)     AS AddressLine2,
    SUM(fs.UnitPrice * fs.SalesQuantity) AS SalesAmount
FROM dbo.FactSales AS fs
LEFT JOIN dbo.DimStore AS ds
    ON ds.StoreKey = fs.StoreKey
GROUP BY
    fs.StoreKey;  
```

By applying the `ANY_VALUE` function, you can include nongrouping columns (such as `StoreName`, `StoreDescription`, `StoreStatus`, `StorePhone`, `StoreFax`, `ZipCode`, `AddressLine1`, and `AddressLine2`) without listing them in the `GROUP BY` clause. 

### C. Unpivot values from rows to columns

The `FactSales` table contains one row per line item, where `OrderKey` identifies the order. For each order, attributes such as `OrderDate`, `DeliveryDate`, `CustomerKey`, and `StoreKey` are repeated across all rows belonging to the same `OrderKey`. In contrast, `ProductKey` varies by line item, with one product per `LineNumber`.

The following query pivots the `FactSales` rows so that each `OrderKey` is a single row. It keeps the shared order-level attributes and creates a separate column (`ProductKey0`, `ProductKey1`, ...) for the product associated with each line number. The `ANY_VALUE` function is used to pick a representative value from each group, while the conditional expressions extract the product for each specific line item.

```sql
SELECT
    OrderKey,
    -- Projecting groups that are same within the group.
    ANY_VALUE(OrderDate)      AS OrderDate,
    ANY_VALUE(DeliveryDate)   AS DeliveryDate,
    ANY_VALUE(CustomerKey)    AS CustomerKey,
    ANY_VALUE(StoreKey)       AS StoreKey,
    -- Unpivoted values returned as multiple columns per row
    ANY_VALUE(IIF(LineNumber = 0, ProductKey, NULL)) AS ProductKey0,
    ANY_VALUE(IIF(LineNumber = 1, ProductKey, NULL)) AS ProductKey1,
    ANY_VALUE(IIF(LineNumber = 2, ProductKey, NULL)) AS ProductKey2,
    ANY_VALUE(IIF(LineNumber = 3, ProductKey, NULL)) AS ProductKey3,
    ANY_VALUE(IIF(LineNumber = 4, ProductKey, NULL)) AS ProductKey4,
    ANY_VALUE(IIF(LineNumber = 5, ProductKey, NULL)) AS ProductKey5,
    ANY_VALUE(IIF(LineNumber = 6, ProductKey, NULL)) AS ProductKey6
FROM dbo.FactSales
GROUP BY
    OrderKey;
```

By using the `ANY_VALUE` function, you avoid placing `OrderDate`, `DeliveryDate`, `CustomerKey`, and `StoreKey` in the `GROUP BY` clause. The `ANY_VALUE` function simplifies the query and can improve performance because only a single column (`OrderKey`) is used in the `GROUP BY` clause.
The `ANY_VALUE` + `CASE WHEN` pattern extracts the appropriate `ProductKey` for each line item and returns them as separate columns. In practice, this pattern produces a programmatic pivot of the product keys (an alternative to the traditional `UNPIVOT` operator).

### D. Random value per two column partition

You're producing a sales-level detail report with a daily key performance indicator (KPI) per store. In the report, you need to return the same `SalesOrderNumber` per (`StoreKey`, `DateKey`) partition where no business rule exists to pick a specific `SalesOrderNumber`. There's no requirement to pick earliest, latest, or greatest order per line in the report. For example, the user interface shows "a reference order for the store-day" next to each line so an analyst can quickly jump to an order from the (store, day) pair. 

The intent is to return one consistent `SalesOrderNumber` per (store, day).

```sql
USE ContosoDW;
GO
SELECT
    fs.DateKey,
    fs.StoreKey,

    -- Window KPI: total sales per Store-Day (keeps row-level output)
    SUM(fs.UnitPrice * fs.SalesQuantity)
      OVER (PARTITION BY fs.StoreKey, dd.DateKey) AS DailySales,

    -- Partition label with no preferred ordering: any one order from that Store-Day
    ANY_VALUE(fs.SalesOrderNumber)
      OVER (PARTITION BY fs.StoreKey, dd.DateKey) AS SampleOrderNumber

FROM dbo.FactSales AS fs;
```

If you replace the `ANY_VALUE(fs.SalesOrderNumber)` expression with `fs.SalesOrderNumber` column reference, the label varies row-by-row; you lose the "one consistent label per (store, day)" behavior.

## Related content

- [Aggregate functions (Transact-SQL)](aggregate-functions-transact-sql.md)
- [Analytic functions (Transact-SQL)](analytic-functions-transact-sql.md)
- [SELECT - OVER clause (Transact-SQL)](../queries/select-over-clause-transact-sql.md)
