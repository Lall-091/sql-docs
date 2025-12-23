---
title: "Performance Tuning with Ordered Columnstore Indexes"
description: "Learn more about how ordered columnstore indexes can benefit query performance."
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: nibruno; xiaoyul, randolphwest, dfurman
ms.date: 12/29/2025
ms.service: sql
ms.subservice: performance
ms.topic: article
ms.custom:
  - ignite-2025
monikerRange: "=azuresqldb-current || >=sql-server-ver16 || >=sql-server-linux-ver16 || =azuresqldb-mi-current || =fabric-sqldb"
---

# Performance tuning with ordered columnstore indexes

[!INCLUDE [sqlserver2022-asdb-asmi-fabricsqldb](../../includes/applies-to-version/sqlserver2022-asdb-asmi-fabricsqldb.md)]

Ordered columnstore indexes can provide faster performance by skipping large amounts of ordered data that don't match the query predicate. While loading data into an ordered columnstore index and maintaining order through index rebuild takes longer than in a non-ordered index, indexed queries can run faster with ordered columnstore.

When a query reads a columnstore index, the [!INCLUDE [ssDE](../../includes/ssde-md.md)] checks the minimum and maximum values stored in each column segment. The process eliminates segments that fall outside the bounds of the query predicate. In other words, it skips these segments when reading data from disk or memory. A query finishes faster if the number of segments to read and their total size is significantly smaller.

For ordered columnstore index availability in various SQL platforms and SQL Server versions, see [Ordered columnstore index availability](columnstore-indexes-overview.md#ordered-columnstore-index-availability).

For more information about recently added features for columnstore indexes, see [What's new in columnstore indexes](columnstore-indexes-what-s-new.md).

## Ordered vs. non-ordered columnstore index

In a columnstore index, the data in each column of each rowgroup is compressed into a separate segment. Each segment contains metadata describing its minimum and maximum values, so the query execution process can skip segments that fall outside the bounds of the query predicate.

When a columnstore index isn't ordered, the index builder doesn't sort the data before compressing it into segments. That means that segments with overlapping value ranges can occur, causing queries to read more segments to obtain the required data. As a result, queries can take longer to finish.

When you create an ordered columnstore index, the [!INCLUDE [ssDE](../../includes/ssde-md.md)] sorts the existing data by the order keys you specify before the index builder compresses them into segments. With sorted data, segment overlapping is reduced or eliminated, allowing queries to use a more efficient segment elimination and thus faster performance because there are fewer segments and less data to read.

## Reduce segment overlap

When you build an ordered columnstore index, the [!INCLUDE [ssDE](../../includes/ssde-md.md)] sorts the data on a best-effort basis. Depending on the available memory, the data size, the degree of parallelism, the index type (clustered vs. nonclustered), and the type of index build (offline vs. online), the sort for ordered columnstore indexes might be full with no segment overlap, or partial with some segment overlap.

The following table describes the resulting sort type when you create or rebuild an ordered columnstore index, depending on index build options.

| Prerequisites | Sort type |
| --- | --- |
| `ONLINE = ON` and `MAXDOP = 1` | Full |
| `ONLINE = OFF`, `MAXDOP = 1`, and the data to sort fully fits in the query workspace memory | Full |
| All other cases | Partial |

In the first case when both `ONLINE = ON` and `MAXDOP = 1`, the sort isn't limited by the query workspace memory because it uses the `tempdb` database to spill the data that doesn't fit in memory. This approach can make the index build process slower due to the additional `tempdb` I/O. However, because the index build is performed online, queries can continue using the existing index while the new ordered index is being built.

Similarly, with an offline rebuild of a partitioned columnstore index, the rebuild is done one partition at a time. Other partitions remain available for queries.

When `MAXDOP` is greater than 1, each thread used for ordered columnstore index build works on a subset of data and sorts it locally. There's no global sorting across data sorted by different threads. Using parallel threads can reduce the time to create the index, but it results in more overlapping segments than when using a single thread.

> [!TIP]  
> Even if the sort in an ordered columnstore index is partial, segments can still be eliminated (skipped). A full sort isn't required to gain query performance benefits if a partial sort avoids many segment overlaps.
>
> To find the number of non-overlapping segments in an ordered columnstore index, see the [Determine the sort quality for an ordered columnstore index](#determine-the-sort-quality-for-an-ordered-columnstore-index) example.

You can create or rebuild ordered columnstore indexes online only in [!INCLUDE [ssazure-sqldb](../../includes/ssazure-sqldb.md)], in [!INCLUDE [ssazure-sqlmi-autd](../../includes/ssazure-sqlmi-autd.md)], and starting with [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)]. In SQL Server, online index operations aren't available in all editions. For more information, see [Editions and supported features of SQL Server 2025](../../sql-server/editions-and-components-of-sql-server-2025.md) and [Perform index operations online](perform-index-operations-online.md).

### Add new data or update existing data

The new data resulting from a DML batch or a bulk load operation on an ordered columnstore index is sorted within that batch only. There's no global sorting that includes existing data in the table. To reduce segment overlaps after inserting the new data or updating existing data, rebuild the index.

## Query performance

The performance gain from an ordered columnstore index depends on the query patterns, the size of data, the sort quality, and the compute resources available for query execution.

Queries with the following patterns typically run faster with ordered columnstore indexes:

- Queries that have equality, inequality, or range predicates.
- Queries where the predicate columns and the ordered CCI columns are the same.

In this example, table `T1` has a clustered columnstore index ordered in the sequence of `Col_C`, `Col_B`, and `Col_A`.

```sql
CREATE CLUSTERED COLUMNSTORE INDEX MyOrderedCCI
ON T1
ORDER(Col_C, Col_B, Col_A);
```

The performance of query 1 and 2 can benefit from ordered columnstore index more than query 3 and 4, because they reference all the ordered columns.

```sql
-- query 1
SELECT *
FROM T1
WHERE Col_C = 'c'
      AND Col_B = 'b'
      AND Col_A = 'a';

-- query 2
SELECT *
FROM T1
WHERE Col_B = 'b'
      AND Col_C = 'c'
      AND Col_A = 'a';

-- query 3
SELECT *
FROM T1
WHERE Col_B = 'b'
      AND Col_A = 'a';

-- query 4
SELECT *
FROM T1
WHERE Col_A = 'a'
      AND Col_C = 'c';
```

## Data load performance

The performance of a data load into a table with an ordered columnstore index is similar to a partitioned table. Loading data can take longer than with a non-ordered columnstore index because of the data sorting operation, but queries can run faster afterwards.

## Examples

### Create an ordered columnstore index

Clustered ordered columnstore index:

```sql
CREATE CLUSTERED COLUMNSTORE INDEX OCCI
ON dbo.Table1
ORDER(Column1, Column2);
```

Nonclustered ordered columnstore index:

```sql
CREATE NONCLUSTERED COLUMNSTORE INDEX ONCCI
ON dbo.Table1(Column1, Column2, Column3)
ORDER(Column1, Column2);
```

### Check for ordered columns and order ordinal

```sql
SELECT OBJECT_SCHEMA_NAME(c.object_id) AS schema_name,
       OBJECT_NAME(c.object_id) AS table_name,
       c.name AS column_name,
       i.column_store_order_ordinal
FROM sys.index_columns AS i
     INNER JOIN sys.columns AS c
         ON i.object_id = c.object_id
        AND c.column_id = i.column_id
WHERE column_store_order_ordinal > 0;
```

### Add or remove order columns and rebuild an existing ordered columnstore index

Clustered ordered columnstore index:

```sql
CREATE CLUSTERED COLUMNSTORE INDEX OCCI
ON dbo.Table1
ORDER(Column1, Column2)
WITH (DROP_EXISTING = ON);
```

Nonclustered ordered columnstore index:

```sql
CREATE NONCLUSTERED COLUMNSTORE INDEX ONCCI
ON dbo.Table1(Column1, Column2, Column3)
ORDER(Column1, Column2)
WITH (DROP_EXISTING = ON);
```

### Create an ordered clustered columnstore index online with full sort on a heap table

```sql
CREATE CLUSTERED COLUMNSTORE INDEX OCCI
ON dbo.Table1
ORDER(Column1)
WITH (ONLINE = ON, MAXDOP = 1);
```

### Rebuild an ordered clustered columnstore index online with full sort

```sql
CREATE CLUSTERED COLUMNSTORE INDEX OCCI
ON dbo.Table1
ORDER(Column1)
WITH (DROP_EXISTING = ON, ONLINE = ON, MAXDOP = 1);
```

### Determine the sort quality for an ordered columnstore index

This example determines the sort quality for all ordered columnstore indexes in the database. In this example, sort quality is defined as a ratio of non-overlapping segments to all segments for each order column, expressed as a percentage.

```sql
WITH ordered_column_segment
AS (SELECT p.object_id,
           i.name AS index_name,
           ic.column_store_order_ordinal,
           cls.row_count,
           cls.column_id,
           cls.min_data_id,
           cls.max_data_id,
           LAG(max_data_id) OVER (
               PARTITION BY cls.partition_id, ic.column_store_order_ordinal
               ORDER BY cls.min_data_id
           ) AS prev_max_data_id,
           LEAD(min_data_id) OVER (
               PARTITION BY cls.partition_id, ic.column_store_order_ordinal
               ORDER BY cls.min_data_id
           ) AS next_min_data_id
    FROM sys.partitions AS p
         INNER JOIN sys.indexes AS i
             ON p.object_id = i.object_id
            AND p.index_id = i.index_id
         INNER JOIN sys.column_store_segments AS cls
             ON p.partition_id = cls.partition_id
         INNER JOIN sys.index_columns AS ic
             ON ic.object_id = p.object_id
            AND ic.index_id = p.index_id
            AND ic.column_id = cls.column_id
    WHERE ic.column_store_order_ordinal > 0)
SELECT OBJECT_SCHEMA_NAME(object_id) AS schema_name,
       OBJECT_NAME(object_id) AS object_name,
       index_name,
       INDEXPROPERTY(object_id, index_name, 'IsClustered') AS is_clustered_column_store,
       COL_NAME(object_id, column_id) AS order_column_name,
       column_store_order_ordinal,
       SUM(row_count) AS row_count,
       SUM(is_overlapping_segment) AS overlapping_segments,
       COUNT(1) AS total_segments,
       (1 - SUM(is_overlapping_segment) / COUNT(1)) * 100 AS order_quality_percent
FROM ordered_column_segment
CROSS APPLY (SELECT CAST (IIF (prev_max_data_id > min_data_id
                 OR next_min_data_id < max_data_id, 1, 0) AS FLOAT) AS is_overlapping_segment
            ) AS ios
GROUP BY object_id, index_name, column_id, column_store_order_ordinal
ORDER BY schema_name, object_name, index_name, column_store_order_ordinal;
```

## Related content

- [Columnstore index design guidelines](../sql-server-index-design-guide.md#columnstore_index)
- [Columnstore indexes - data loading guidance](columnstore-indexes-data-loading-guidance.md)
- [Get started with columnstore indexes for real-time operational analytics](get-started-with-columnstore-for-real-time-operational-analytics.md)
- [Columnstore indexes in data warehousing](columnstore-indexes-data-warehouse.md)
- [Optimize index maintenance to improve query performance and reduce resource consumption](reorganize-and-rebuild-indexes.md)
- [Columnstore index architecture](../sql-server-index-design-guide.md#columnstore_index)
- [CREATE INDEX (Transact-SQL)](../../t-sql/statements/create-index-transact-sql.md)
- [ALTER INDEX (Transact-SQL)](../../t-sql/statements/alter-index-transact-sql.md)
