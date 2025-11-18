---
title: "Performance Tuning With Ordered Columnstore Indexes"
description: "Learn more about how ordered columnstore indexes can benefit your query performance."
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: nibruno; xiaoyul, randolphwest, dfurman
ms.date: 04/14/2025
ms.service: sql
ms.subservice: performance
ms.topic: conceptual
ms.custom:
  - ignite-2025
monikerRange: "=azuresqldb-current || >=sql-server-ver16 || >=sql-server-linux-ver16 || =azuresqldb-mi-current || =fabric-sqldb"
---

# Performance tuning with ordered columnstore indexes

[!INCLUDE [sqlserver2022-asdb-asmi-fabricsqldb](../../includes/applies-to-version/sqlserver2022-asdb-asmi-fabricsqldb.md)]

By enabling efficient segment elimination, ordered columnstore indexes provide faster performance by skipping large amounts of ordered data that don't match the query predicate. Loading data into an ordered columnstore index and keeping it ordered via index rebuilds can take longer than in a non-ordered index because of the data sorting operation, however with ordered columnstore indexes queries can run faster afterwards.

When users query a columnstore table, the optimizer checks the minimum and maximum values stored in each segment. Segments that are outside the bounds of the query predicate aren't read from disk to memory. A query can finish faster if the number of segments to read and their total size are smaller.

For ordered columnstore index availability, see [Ordered columnstore index availability](columnstore-indexes-overview.md#ordered-columnstore-index-availability).

For more information about recently added features for columnstore indexes, see [What's new in columnstore indexes](columnstore-indexes-what-s-new.md).

## Ordered vs. non-ordered columnstore index

In a columnstore index, data in each column of each rowgroup is compressed into a separate segment. Each segment contains metadata describing its minimum and maximum values, so segments that are outside the bounds of the query predicate aren't read from disk during query execution.

When a columnstore index is not ordered, the index builder doesn't sort the data before compressing it into segments. That means that segments with overlapping value ranges can occur, causing queries to read more segments from disk and take longer to finish.

When you create an ordered columnstore index, the [!INCLUDE [ssDE](../../includes/ssde-md.md)] sorts the existing data by the order keys you specify before the index builder compresses them into segments. With sorted data, segment overlapping is reduced or eliminated, allowing queries to have a more efficient segment elimination and thus faster performance because there are fewer segments to read from disk.

Depending on the available memory, the data size, the degree of parallelism, the index type (clustered vs. nonclustered), and the type of index build (offline vs. online), the sort for ordered columnstore indexes might be full (no segment overlap) or partial (some segment overlap). For example, partial sort occurs when the available memory is insufficient for a full sort. Queries using an ordered columnstore index often execute faster than with a non-ordered index even if the ordered index was built using a partial sort.

Full sort is provided for ordered clustered columnstore indexes created or rebuilt with both `ONLINE = ON` and `MAXDOP = 1` options. In this case, the sort is not limited by the available memory because it uses the `tempdb` database to spill the data that doesn't fit in memory. This can make the index build process slower due to the additional `tempdb` I/O. However, with an online index rebuild, queries can continue using the existing index while the new ordered index is being rebuilt.

Full sort might also be provided for ordered clustered and nonclustered columnstore indexes created or rebuilt with both `ONLINE = OFF` and `MAXDOP = 1` options if the amount of data to be sorted is sufficiently small to fully fit in available memory.

In all other cases, the sort in ordered columnstore indexes is partial.

> [!NOTE]
> Currently, ordered columnstore indexes can be created or rebuilt online only in [!INCLUDE [ssazure-sqldb](../../includes/ssazure-sqldb.md)], in [!INCLUDE [ssazure-sqlmi-autd](../../includes/ssazure-sqlmi-autd.md)], and in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)].

To check the segment ranges for a column and determine if there is any segment overlap, use the following query, substituting placeholders with your schema, table, and column names:

```sql
SELECT OBJECT_SCHEMA_NAME(o.object_id) AS schema_name,
       o.name AS table_name,
       cols.name AS column_name,
       pnp.index_id,
       cls.row_count,
       pnp.data_compression_desc,
       cls.segment_id,
       cls.column_id,
       cls.min_data_id,
       cls.max_data_id
FROM sys.partitions AS pnp
INNER JOIN sys.tables AS t
ON pnp.object_id = t.object_id
INNER JOIN sys.objects AS o
ON t.object_id = o.object_id
INNER JOIN sys.column_store_segments AS cls
ON pnp.partition_id = cls.partition_id
INNER JOIN sys.columns AS cols
ON o.object_id = cols.object_id
   AND
   cls.column_id = cols.column_id
WHERE OBJECT_SCHEMA_NAME(o.object_id) = '<Schema Name>'
      AND
      o.name = '<Table Name>'
      AND
      cols.name = '<Column Name>'
ORDER BY o.name, pnp.index_id, cls.min_data_id;
```

For example, the output from this query for a fully sorted columnstore index might look as follows. Note that there is no overlap in the `min_data_id` and `max_data_id` columns for different segments.

```output
schema_name table_name column_name index_id row_count data_compression_desc segment_id column_id min_data_id max_data_id
----------- ---------- ----------- -------- --------- --------------------- ---------- --------- ----------- -----------
dbo         Table1     Column1     1        479779    COLUMNSTORE           0          1         -17         1469515
dbo         Table1     Column1     1        887658    COLUMNSTORE           1          1         1469516     2188146
dbo         Table1     Column1     1        930144    COLUMNSTORE           2          1         2188147     11072928
```

> [!NOTE]
> In an ordered columnstore index, the new data resulting from the same batch of DML or data loading operations is sorted within that batch only. There's no global sorting that includes existing data in the table.
>
> To sort data in the index after inserting new data or updating existing data, rebuild the index.

For an offline rebuild of a partitioned columnstore index, rebuild is done one partition at a time. Data in the partition that is being rebuilt is unavailable until the rebuild is complete for that partition.

Data remains available during an online rebuild. For more information, see [Perform index operations online](perform-index-operations-online.md).

## Query performance

The performance gain from an ordered columnstore index depends on the query patterns, the size of data, how well the data is sorted, the physical structure of segments, and the compute resources available for query execution.

Queries with the following patterns typically run faster with ordered columnstore indexes.

- Queries that have equality, inequality, or range predicates.
- Queries where the predicate columns and the ordered CCI columns are the same.

In this example, table `T1` has a clustered columnstore index ordered in the sequence of `Col_C`, `Col_B`, and `Col_A`.

```sql
CREATE CLUSTERED COLUMNSTORE INDEX MyOrderedCCI ON T1
ORDER (Col_C, Col_B, Col_A);
```

The performance of query 1 and 2 can benefit from ordered columnstore index more than query 3 and 4, because they reference all the ordered columns.

```sql
-- query 1
SELECT *
FROM T1
WHERE Col_C = 'c' AND Col_B = 'b' AND Col_A = 'a';

-- query 2
SELECT *
FROM T1
WHERE Col_B = 'b' AND Col_C = 'c' AND Col_A = 'a';

-- query 3
SELECT *
FROM T1
WHERE Col_B = 'b' AND Col_A = 'a';

-- query 4
SELECT *
FROM T1
WHERE Col_A = 'a' AND Col_C = 'c';
```

## Data load performance

The performance of data load into a table with an ordered columnstore index is similar to a partitioned table. Loading data can take longer than with a non-ordered columnstore index because of the data sorting operation, however queries can run faster afterwards.

## Reduce segment overlapping

The number of overlapping segments depends on the size of data to sort, the available memory, and the maximum degree of parallelism (`MAXDOP`) setting during ordered columnstore index build. The following strategies reduce segment overlapping, however they can make the index build process take longer.

- If online index build is available, use both `ONLINE = ON` and `MAXDOP = 1` options when creating an ordered clustered columnstore index. This creates a fully sorted index.
- If online index build isn't available, use the `MAXDOP = 1` option.
- Pre-sort the data by the sort keys before the load.

When `MAXDOP` is greater than 1, each thread used for ordered columnstore index build works on a subset of data and sorts it locally. There's no global sorting across data sorted by different threads. Using parallel threads can reduce the time to create the index, but it generates more overlapping segments than when using a single thread. Using a single threaded operation delivers the highest compression quality. You can specify `MAXDOP` with the `CREATE INDEX` command.

## Examples

### Check for ordered columns and order ordinal

```sql
SELECT object_name(c.object_id) AS table_name,
       c.name AS column_name,
       i.column_store_order_ordinal
FROM sys.index_columns AS i
INNER JOIN sys.columns AS c
ON i.object_id = c.object_id
   AND
   c.column_id = i.column_id
WHERE column_store_order_ordinal <> 0;
```

### Create an ordered columnstore index

Clustered ordered columnstore index:

```sql
CREATE CLUSTERED COLUMNSTORE INDEX OCCI
ON dbo.Table1
ORDER (Column1, Column2);
```

Nonclustered ordered columnstore index:

```sql
CREATE NONCLUSTERED COLUMNSTORE INDEX ONCCI
ON dbo.Table1
(
Column1, Column2, Column3
)
ORDER (Column1, Column2);
```

### Add or remove order columns and rebuild an existing ordered columnstore index

Clustered ordered columnstore index:

```sql
CREATE CLUSTERED COLUMNSTORE INDEX OCCI
ON dbo.Table1
ORDER (Column1, Column2)
WITH (DROP_EXISTING = ON);
```

Nonclustered ordered columnstore index:

```sql
CREATE NONCLUSTERED COLUMNSTORE INDEX ONCCI
ON dbo.Table1
(
Column1, Column2, Column3
)
ORDER (Column1, Column2)
WITH (DROP_EXISTING = ON);
```

### Create an ordered clustered columnstore index online with full sort on a heap table

```sql
CREATE CLUSTERED COLUMNSTORE INDEX OCCI
ON dbo.Table1
ORDER (Column1)
WITH (ONLINE = ON, MAXDOP = 1);
```

### Rebuild an ordered clustered columnstore index online with full sort

```sql
CREATE CLUSTERED COLUMNSTORE INDEX OCCI
ON dbo.Table1
ORDER (Column1)
WITH (DROP_EXISTING = ON, ONLINE = ON, MAXDOP = 1);
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
