---
title: "Ghost cleanup process guide"
description: Learn about the ghost cleanup process, a background process that deletes records off of pages that have been marked for deletion in SQL Server.
author: MashaMSFT
ms.author: mathoma
ms.reviewer: dfurman
ms.date: 12/07/2025
ms.service: sql
ms.subservice: supportability
ms.topic: conceptual
helpviewer_keywords:
  - "ghost cleanup"
  - "ghost records"
  - "ghost clean up process"
---

# Ghost cleanup process guide

The ghost cleanup process is a single-threaded background process that deletes records marked for deletion in data pages. The following article provides an overview of this process.

## Ghost records

Records that are deleted from the leaf level pages of an index aren't physically removed from the page. Instead, the record is marked as 'to be deleted', or *ghosted*. This means that the row stays on the page but a bit is changed in the row header to indicate that the row is a ghost. This is to optimize performance during a delete operation. Ghosts are necessary for row-level locking, but are also necessary for snapshot isolation transactions where the database engine must maintain older row versions.

## Ghost record cleanup task

Records that are marked for deletion, or *ghosted*, are cleaned up by the background ghost cleanup process when they are no longer required. The ghost cleanup process runs periodically and checks to see if any pages have ghost records. If it finds any, it physically removes the records that are marked for deletion, or *ghosted*.

When a record is ghosted, the database is marked as having ghosted entries. The ghost cleanup process only scans such databases. The ghost cleanup process also marks the database as having no ghosted records once all ghosted records have been removed, and skips this database the next time it runs. The process also skips any database if it can't acquire a shared lock on the database. It retries lock acquisition on the database the next time it runs.

The follwoing query returns an approximate number of ghosted records in a database.

```sql
SELECT SUM(ghost_record_count) AS total_ghost_records,
       DB_NAME(database_id) AS database_name
FROM sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL, 'SAMPLED')
GROUP BY database_id
ORDER BY total_ghost_records DESC;
```

## Disable ghost cleanup

In high-load systems with many deletes, the ghost cleanup process might cause a performance issue because it replaces the frequently accessed pages in the buffer pool with pages that have ghosted records. As a result, the frequently accessed pages must be re-read from disk, generating extra disk IO and increasing query latency. If this occurs, you can disable ghost cleanup using [trace flag 661](../t-sql/database-console-commands/dbcc-traceon-trace-flags-transact-sql.md#tf661).

Without ghost cleanup, your database can grow unnecessarily large, which can lead to performance issues. Since the ghost cleanup process removes records that are marked as ghosts, disabling the process leaves these records on the page, preventing the database engine from reusing this space. This forces the database engine to add data to new pages instead, leading to bloated database files, and can also cause [page splits](indexes/specify-fill-factor-for-an-index.md). Page splits increase disk IO which can reduce query performance.

If ghost cleanup is disabled, the only action that removes the ghosted records is an index rebuild. Rebuilding an index creates new pages from existing data, omitting ghosted records in the process.

> [!WARNING]
> Disabling the ghost cleanup process permanently is not recommended.

## Related content

- [Pages and extents architecture guide](pages-and-extents-architecture-guide.md)


