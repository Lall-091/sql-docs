---
title: "SQL Server 2025 Known Issues"
description: "Known issues, causes, and workarounds for SQL Server 2025 Preview (17.x), covering upgrades, replication, PolyBase, session behavior, platform compatibility (Windows and Linux), backup compression, and other platform-specific limitations."
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: randolphwest
ms.date: 09/24/2025
ms.service: sql
ms.subservice: release-landing
ms.topic: troubleshooting-known-issue
monikerRange: ">=sql-server-2016"
---

# SQL Server 2025 Preview known issues

[!INCLUDE [sqlserver2025](../includes/applies-to-version/sqlserver2025.md)]

This article describes known issues for [!INCLUDE [sssql25-md](../includes/sssql25-md.md)].

[!INCLUDE [sssql25-md](../includes/sssql25-md.md)] has currently identified the following known issues:

- [Windows Arm64 not supported](#windows-arm64-not-supported)
- [In-place upgrade fails due to Microsoft Visual C++ Redistributable](#in-place-upgrade-fails-due-to-microsoft-visual-c-redistributable)
- [SQL Server on Windows fails to start on machines with more than 64 logical cores per NUMA node](#sql-server-on-windows-fails-to-start-on-machines-with-more-than-64-logical-cores-per-numa-node)
- [Database mail on Linux](#database-mail-on-linux)
- [SQLPS](#sqlps)
- [Incorrect behavior of SESSION_CONTEXT in parallel plans](#incorrect-behavior-of-session_context-in-parallel-plans)
- [Issue when setting the backup compression algorithm to ZSTD](#setting-the-backup-compression-algorithm-to-zstd)
- [Local ONNX models not supported on Linux operating systems](#local-onnx-models-not-supported-on-linux-operating-systems)
- [PBKDF2 hashing algorithm can affect login performance](#pbkdf2-hashing-algorithm-can-affect-login-performance)
- [Access violation exception can occur on readable secondary replicas under certain conditions](#access-violation-exception-can-occur-on-readable-secondary-replicas-under-certain-conditions)
- [Vector index](#vector-index)

## Windows Arm64 not supported

[!INCLUDE [sssql25-md](../includes/sssql25-md.md)] isn't supported on Windows Arm64. Only Intel and AMD x86-64 CPUs with [up to 64 cores per NUMA node](compute-capacity-limits-by-edition-of-sql-server.md#numa-64) are currently supported.

## In-place upgrade fails due to Microsoft Visual C++ Redistributable

An upgrade from the following versions might fail:

- [!INCLUDE [sssql16-md](../includes/sssql16-md.md)]
- [!INCLUDE [sssql17-md](../includes/sssql17-md.md)]

This can happen when the existing operating system environment is missing the Microsoft Visual C++ Redistributable for Visual Studio 2022, or an older version of this component is installed.

When this happens, the installation log includes an entry like the following example:

```output
This application requires Microsoft Visual C++ Redistributable for
Visual Studio 2022 (x64/x86, version 14.34 at minimum).
Please install the Redistributable, then run this installer again.
For more information, see: https://go.microsoft.com/fwlink/?linkid=2219560.
```

To complete the upgrade, add or repair the redistributable component, and run the installation again.

To get the redistributable file, review [Microsoft Visual C++ Redistributable latest supported downloads](/cpp/windows/latest-supported-vc-redist).

## SQL Server on Windows fails to start on machines with more than 64 logical cores per NUMA node

**Issue**: SQL Server instances on Windows might fail to start after the installation if the machine has more than 64 logical cores per NUMA node.

For more information, see [Limit number of logical cores per NUMA node to 64](compute-capacity-limits-by-edition-of-sql-server.md#limit-number-of-logical-cores-per-numa-node-to-64).

## Database mail on Linux

**Issue**: Database mail on Linux doesn't work when SQL Server is configured to enforce strict encryption.

Currently, the only workaround isn't to enforce strict encryption.

## SQLPS

**Issue**: SQLPS.exe, the SQL Agent PowerShell subsystem, and the SQLPS PowerShell module don't work when SQL is configured to enforce strict encryption.

Currently, the only workaround isn't to enforce strict encryption.

The SQL Server Agent job `syspolicy_purge_history` reports a failure on step 3. This job runs daily by default. An instance that doesn't enforce strict encryption doesn't reproduce this problem; another option is to disable the job.

## Incorrect behavior of SESSION_CONTEXT in parallel plans

Queries that use the built-in `SESSION_CONTEXT` function might return incorrect results or trigger access violation (AV) dumps when executed in parallel query plans. This issue stems from the way the function interacts with parallel execution threads, particularly when the session is reset for reuse.

For more information, see the [Known issues](../t-sql/functions/session-context-transact-sql.md#known-issues) section in `SESSION_CONTEXT`.

<a id="setting-the-backup-compression-algorithm-to-zstd"></a>

## Issue when setting the backup compression algorithm to ZSTD

There's a known issue when attempting to set the [backup compression algorithm](../database-engine/configure-windows/view-or-configure-the-backup-compression-algorithm-server-configuration-option.md) to ZSTD.

When specifying the ZSTD algorithm (`backup compression algorithm = 3`), the following error message returns:

```output
Msg 15129, Level 16, State 1
Procedure sp_configure '3' is not a valid value for configuration option 'backup compression algorithm'.
```

Use the new compression algorithm directly in the [BACKUP](../t-sql/statements/backup-transact-sql.md#compression) Transact-SQL command instead of setting the server configuration option.

## Local ONNX models not supported on Linux operating systems

[CREATE EXTERNAL MODEL](../t-sql/statements/create-external-model-transact-sql.md) local ONNX models hosted directly on the SQL Server aren't currently available for Linux on [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] RC 1.

## PBKDF2 hashing algorithm can affect login performance

In [!INCLUDE [sssql25-md](../includes/sssql25-md.md)], password-based authentication uses PBKDF2 (RFC2898) as the default hashing algorithm. This enhancement improves password security by applying 100,000 iterations of SHA-512 hashing. The increased computational cost of PBKDF2 means slightly longer SQL Authentication login time. This effect is especially noticeable in environments without connection pooling, or where login latency is closely monitored. In pooled environments, the effect is typically minimal.

For more information, see [CREATE LOGIN](../t-sql/statements/create-login-transact-sql.md) and [Support for Iterated and Salted Hash Password Verifiers in SQL Server 2022 CU12](https://techcommunity.microsoft.com/blog/azuresqlblog/support-for-iterated-and-salted-hash-password-verifiers-in-sql-server-2022-cu12/4087155).

## Access violation exception can occur on readable secondary replicas under certain conditions

Consider a database enabled to use the [Query Store for readable secondaries](../relational-databases/performance/query-store-for-secondary-replicas.md) feature, using the following data definitional language (DDL) command:

```sql
ALTER DATABASE [Database_Name]
    SET QUERY_STORE (OPERATION_MODE = READ_WRITE);
```

Queries that meet the following conditions could experience an access violation when a PSP [query variant](../relational-databases/performance/parameter-sensitive-plan-optimization.md#query-variant) can't determine the persisted state of its parent dispatcher statement:

- Executed on a secondary replica
- Sensitive to parameter sniffing
- Eligible for parameter sensitive plan (PSP) optimization

A fix has been identified and will be part of a future release of [!INCLUDE [sssql25-md](../includes/sssql25-md.md)].

**Workaround**: Disable PSP on secondaries for each database that was onboarded to use the Query Store for readable secondaries feature. From within the context of a specific database, issue the following Transact-SQL statement:

```sql
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY
    SET PARAMETER_SENSITIVE_PLAN_OPTIMIZATION = OFF;
```

## Vector index

Currently, when you create a vector index on some datasets, it may return the following errors:

- Error 9829: `STRING_AGG aggregation result exceeded the limit of 8000 bytes. Use LOB types to avoid result truncation.`
- 42234: `Internal SQL error during DiskANN graph build`

A fix has been identified and will be part of a future release of [!INCLUDE [sssql25-md](../includes/sssql25-md.md)].

## Related content

- [What's new in SQL Server 2025 Preview](what-s-new-in-sql-server-2025.md)
- [SQL Server 2025 Preview release notes](sql-server-2025-release-notes.md)
- [Breaking changes to Database Engine features in SQL Server 2025 Preview](../database-engine/breaking-changes-to-database-engine-features-in-sql-server-2025.md)
