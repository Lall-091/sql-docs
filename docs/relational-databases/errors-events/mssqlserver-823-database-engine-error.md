---
title: "MSSQLSERVER Error 823 | mssqlserver_823"
description: A description and some common solutions to Microsoft SQL Server Error 823 (mssqlserver_823), which is a severe system-level error condition that threatens database integrity and must be addressed immediately.
author: MashaMSFT
ms.author: mathoma
ms.reviewer: randolphwest
ms.date: 05/30/2025
ms.service: sql
ms.subservice: supportability
ms.topic: "reference"
helpviewer_keywords:
  - "823 (Database Engine error)"
---
# MSSQLSERVER error 823

[!INCLUDE [SQL Server](../../includes/applies-to-version/sqlserver.md)]

## Details

| Attribute | Value |
| :--- | :--- |
| Product Name | SQL Server |
| Event ID | 823 |
| Event Source | MSSQLSERVER |
| Component | SQLEngine |
| Symbolic Name | B_HARDERR |
| Message Text | The operating system returned error %ls to SQL Server during a %S_MSG at offset %#016I64x in file '%ls'. Additional messages in the SQL Server error log and system event log may provide more detail. This is a severe system-level error condition that threatens database integrity and must be corrected immediately. Complete a full database consistency check (DBCC CHECKDB). This error can be caused by many factors; for more information, see SQL Server Books Online. |

## Explanation

SQL Server uses Windows APIs (for example, [ReadFile](/windows/win32/api/fileapi/nf-fileapi-readfile), [WriteFile](/windows/win32/api/fileapi/nf-fileapi-writefile), [ReadFileScatter](/windows/win32/api/fileapi/nf-fileapi-readfilescatter), [WriteFileGather](/windows/win32/api/fileapi/nf-fileapi-writefilegather)) to perform file I/O operations. After SQL Server performs these I/O operations, it checks for any error conditions associated with these API calls. If the API calls fail with an Operating System error, then SQL Server reports Error 823.

The 823 error message contains the following information:

- The database file against which the I/O operation was performed.
- The offset within the file where the I/O operation was attempted. This is the physical byte offset from the start of the file. Dividing this number by 8,192 gives you the logical page number that is affected by the error.
- Whether the I/O operation is a read or write request.
- The Operating System error code and error description in parentheses.

**Operating system error:** A read or write Windows API call isn't successful, and SQL Server encounters an operating system error that is related to the Windows API call. The following message is an example of an 823 error:

```output
Error: 823, Severity: 24, State: 2.
The operating system returned error 1117 (The request could not be performed because of an I/O device error.) to SQL Server during a read at offset 0x0000002d460000 in file 'E:\Program Files\Microsoft SQL Server\Mssql\Data\mydb.MDF'. Additional messages in the SQL Server error log and system event log may provide more detail. This is a severe, system-level error condition that threatens database integrity and must be corrected immediately. It is recommended to complete a full database consistency check (DBCC CHECKDB). This error can be caused by many factors; for more information, see SQL Server Books Online.
```

You might see errors from the DBCC CHECKDB statement on the database that is associated with the file in the error message. You can run the DBCC CHECKDB statement when you see an 823 error. If the DBCC CHECKDB statement doesn't report any errors, you probably have an intermittent system problem or a disk problem.

Additional diagnostic information for 823 errors might be written to the SQL Server error log file when you use trace flag 818.
For more information, see [SQL Server diagnostics detects unreported I/O problems due to stale reads or lost writes](/troubleshoot/sql/database-engine/database-file-operations/diagnostics-for-unreported-io-problems).

## Cause

The 823 error message usually indicates that there's a problem with underlying storage system or the hardware or a driver that is in the path of the I/O request. You can encounter this error when there are inconsistencies in the file system or if the database file is damaged. For a file read, SQL Server has already retried the read request four times before it returns 823. If the retry operation succeeds, the query doesn't fail, but message [MSSQLSERVER_825](mssqlserver-825-database-engine-error.md) is written into the ERRORLOG and Event Log.

## User action

- Review the [suspect_pages](../system-tables/suspect-pages-transact-sql.md) table in `msdb` for other pages that are encountering this problem (in the same database or different databases).

- Check the consistency of databases located on the same volume (as the one reported in the 823 message) using DBCC CHECKDB command. If you find inconsistencies from the DBCC CHECKDB command, use the guidance from [How to troubleshoot database consistency errors reported by DBCC CHECKB](/troubleshoot/sql/database-engine/database-file-operations/troubleshoot-dbcc-checkdb-errors).

- Review the Windows Event logs for any errors or messages reported from the Operating System or a Storage Device or a Device Driver. If they're related to this error in some manner, address those errors first. For example, apart from the 823 message, you might also notice an event like "The driver detected a controller error on \Device\Harddisk4\DR4" reported by the Disk source in the Event Log. In that case, you have to evaluate if this file is present on this device and then first correct those disk errors.

- Use the [Use the SQLIOSim utility to simulate SQL Server activity on a disk subsystem](/troubleshoot/sql/tools/sqliosim-utility-simulate-activity-disk-subsystem) utility to find out if these 823 errors can be reproduced outside of regular SQL Server I/O requests. The SQLIOSim utility ships with SQL Server 2008 and later versions so there's no need for a separate download. You can typically find it in your `C:\Program Files\Microsoft SQL Server\MSSQLxx.MSSQLSERVER\MSSQL\Binn` folder.

- Work with your hardware vendor or device manufacturer to ensure
  - The hardware devices and configuration conform to the I/O requirements of SQL Server
  - The device drivers and other supporting software components of all devices in the I/O path are up to date

- If the hardware vendor or device manufacturer provided you with any diagnostic utilities, use them to evaluate the health of the I/O system

- Evaluate if there are [filter drivers](/troubleshoot/sql/database-engine/performance/performance-consistency-issues-filter-drivers-modules) that exist in the path of these I/O requests that encounter problems.
  - Check if there are any updates to these filter drivers
  - Can these filter drivers be removed or disabled to observe if the problem that results in the 823 error goes away?

### Example with OS error 21

In this case, the underlying OS error 21 indicates that the disk device is offline and not available for the OS and SQL Server to use.

```output
Error: 823, Severity: 24, State: 2.
The operating system returned error 21 (The device is not ready.) to SQL Server during a read at offset 0x0000002d460000 in file 'E:\Program Files\Microsoft SQL Server\Mssql\Data\mydb.MDF'. Additional messages in the SQL Server error log and system event log may provide more detail. This is a severe, system-level error condition that threatens database integrity and must be corrected immediately. It is recommended to complete a full database consistency check (DBCC CHECKDB). This error can be caused by many factors; for more information, see SQL Server Books Online.
```

#### Resolution

If you encounter a similar scenario, address the underlying OS error. In this case, work with your system administrator and hardware vendor to ensure that the disk device is online, functioning properly and there are no errors and damage reported.

An unstable network connection can also cause this error, for example when database files are stored on a network-attached storage (NAS) or SAN device accessed over the network. In cases like this one, you might have to check the physical integrity of the databases once the disk device is restored by running [DBCC CHECKDB](../../t-sql/database-console-commands/dbcc-checkdb-transact-sql.md). If database damage is reported, restore a last known good database backup.
