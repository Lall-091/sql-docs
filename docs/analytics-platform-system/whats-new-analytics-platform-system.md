---
title: "What's New"
titleSuffix: Analytics Platform System
description: See what's new in Analytics Platform System, a scale-out on-premises appliance that hosts MPP SQL Server Parallel Data Warehouse.
author: charlesfeddersen
ms.author: charlesf
ms.reviewer: randolphwest
ms.date: 12/29/2025
ms.service: sql
ms.subservice: data-warehouse
ms.topic: whats-new
ms.custom:
  - intro-whats-new
  - sfi-ropc-nochange
---
# What's new in Analytics Platform System, a scale-out MPP data warehouse

See what's new in the latest Appliance Updates for Analytics Platform System (APS). APS is a scale-out on-premises appliance that hosts MPP SQL Server Parallel Data Warehouse.

::: moniker range=">= aps-pdw-2016-au7 "

<a id="h2-aps-cu7.8"></a>

## APS CU7.8

Release date - November 2021

### SCVMM2016

APS CU 7.8 software adds support for offline installation of SCVMM2016.

Patched VMM with latest [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] version.

Release also includes extra security updates and bug fixes.

<a id="h2-aps-cu7.7"></a>

## APS CU7.7

Release date - November 2020

### SCVMM2016

APS CU7.7 software upgrades VMM VM to Windows Server 2016 and installs SCVMM2016. SCVMM 2012 R2 that is currently in use has an end of life date of July 2022. The newer SCVMM is needed to be supported making CU7.7 a mandatory upgrade. Upgrade to CU7.7 as soon as possible.

### SSIS destination adapter for SQL Server 2019 as target

Download the APS SSIS destination adapter that supports [!INCLUDE [sssql19-md](../includes/sssql19-md.md)] as a deployment target from the [download site](https://www.microsoft.com/download/details.aspx?id=57472).

<a id="h2-aps-cu7.6"></a>

## APS CU7.6

Release date - April 2020

### Rename column

After upgrading to CU7.6, you can rename a column of a user-created table. For syntax, examples, limitations, and more information, see [RENAME](../t-sql/statements/rename-transact-sql.md).

### Alter view

You can now alter views. For more information, see [ALTER VIEW](../t-sql/statements/alter-view-transact-sql.md).

<a id="h2-aps-cu7.5"></a>

## APS CU7.5

Release date - September 2019

### Alter external data source

You can alter the external data source definition with the CU7.5 update. If you use Hadoop name node high availability, you can alter the data source to change the arguments when a failover happens. For APS, you can change only the `LOCATION`, `RESOURCE_MANAGER_LOCATION`, and `CREDENTIAL`. For more information, see [ALTER EXTERNAL DATA SOURCE](../t-sql/statements/alter-external-data-source-transact-sql.md).

### CDH 5.15 and 5.16 support with PolyBase

PolyBase on APS with CU7.5 update now supports CDH 5.15 and 5.16 versions of Hadoop distribution from Cloudera. Use option 6 for CDH 5.x versions.

### TRY_CONVERT and TRY_CAST support

CU7.5 APS now supports [TRY_CAST](../t-sql/functions/try-cast-transact-sql.md) and [TRY_CONVERT](../t-sql/functions/try-convert-transact-sql.md) tsql functions. Both of these functions return a value converted to the specified data type if the convert succeeds; otherwise, returns null.

<a id="h2-aps-cu7.4"></a>

## APS CU7.4

Release date - May 2019

<a id="loading-large-rows-with-dwloader"></a>

### Load large rows with dwloader

APS CU7.4 introduces a new **dwloader** to load rows into tables that are larger than 32 KB (32,768 bytes). This version of the tool supports the `-l` switch that takes an integer value between 32,768 and 33,554,432 (in bytes) to load rows larger than 32 KB. Only use this option when loading large rows (greater than 32 KB), as this switch allocates more memory on the client and the server and might slow down loads. You can download **dwloader** from [download site](https://www.microsoft.com/download/details.aspx?id=57472).

### HDP 3.0 and 3.1 support with PolyBase

PolyBase on APS now supports HDP 3.0 and 3.1 with this update. Use option 7 for HDP 3.x versions. For more information, see [PolyBase connectivity configuration](../database-engine/configure-windows/polybase-connectivity-configuration-transact-sql.md).

### UTF-16 file support with PolyBase

PolyBase now support reading delimited text files that are in UTF-16 (LE) encoding. See [CREATE EXTERNAL FILE FORMAT](../t-sql/statements/create-external-file-format-transact-sql.md) for setup details.

<a id="h2-aps-cu7.3"></a>

## APS CU7.3

Release date - December 2018

### Common subexpression elimination

APS CU7.3 improves query performance with common subexpression elimination in the SQL query optimizer. This improvement helps queries in two ways. First, the optimizer can identify and eliminate these expressions, which reduces SQL compilation time. Second, the optimizer eliminates data movement operations for these redundant subexpressions, so execution time for queries is faster. For a detailed explanation of this feature, see [Common subexpression elimination explained](common-sub-expression-elimination.md).

### APS Informatica connector for Informatica 10.2.0 published

You can download a version of Informatica connectors for APS that works with Informatica version 10.2.0 and 10.2.0 Hotfix 1. For more information, visit the [download site](https://www.microsoft.com/download/details.aspx?id=57472).

> [!NOTE]  
> APS Informatica connector for Informatica 10.2.0 or 10.2.0 Hotfix 1 doesn't work on strict TLS 1.2 and requires TLS 1.0 and 1.1 to be fully functional.

#### Supported versions

| APS Version | Informatica PowerCenter | Driver |
| --- | --- | --- |
| APS 2016 | 9.6.1 | SQL Server Native Client 11.x |
| APS 2016 and later | 10.2.0, 10.2.0 Hotfix 1 | SQL Server Native Client 11.x |

<a id="h2-aps-cu7.2"></a>

## APS CU7.2

Release date - October 2018

### Support for TLS 1.2

APS CU7.2 supports TLS 1.2. You can set client machine to APS and APS intra-node communication to communicate only over TLS 1.2. Tools like SSDT, SSIS, and **dwloader** that are installed on client machines and set to communicate only over TLS 1.2 can now connect to APS using TLS 1.2. By default, APS supports all TLS (1.0, 1.1, and 1.2) versions for backward compatibility. If you want to set your APS appliance to strictly use TLS 1.2, change the registry settings.

For more information, see [configuring TLS 1.2 on APS](configure-tls12-aps.md).

### Hadoop encryption zone support for PolyBase

PolyBase can communicate to Hadoop encryption zones. See APS configuration changes that are needed in [configure Hadoop security](polybase-configure-hadoop-security.md#encryptionzone).

### Insert-select MAXDOP options

You can now pick MAXDOP settings greater than 1 for insert-select operations, using a [feature switch](appliance-feature-switch.md). Set the MAXDOP setting to 0, 1, 2, or 4. The default is 1.

> [!IMPORTANT]  
> Increasing MAXDOP might sometimes result in slower operations or deadlock errors. If that condition occurs, change the setting back to MAXDOP 1 and retry the operation.

### Columnstore index health DMV

You can view columnstore index health information using `dm_pdw_nodes_db_column_store_row_group_physical_stats` dmv. Use the following view to determine fragmentation and decide when to rebuild or reorganize a columnstore index.

```sql
CREATE VIEW dbo.vCS_rg_physical_stats
AS
WITH cte
AS (SELECT tb.[name] AS [logical_table_name],
           rg.[row_group_id] AS [row_group_id],
           rg.[state] AS [state],
           rg.[state_desc] AS [state_desc],
           rg.[total_rows] AS [total_rows],
           rg.[trim_reason_desc] AS trim_reason_desc,
           mp.[physical_name] AS physical_name
    FROM sys.[schemas] AS sm
         INNER JOIN sys.[tables] AS tb
             ON sm.[schema_id] = tb.[schema_id]
         INNER JOIN sys.[pdw_table_mappings] AS mp
             ON tb.[object_id] = mp.[object_id]
         INNER JOIN sys.[pdw_nodes_tables] AS nt
             ON nt.[name] = mp.[physical_name]
         INNER JOIN sys.[dm_pdw_nodes_db_column_store_row_group_physical_stats] AS rg
             ON rg.[object_id] = nt.[object_id]
            AND rg.[pdw_node_id] = nt.[pdw_node_id]
            AND rg.[pdw_node_id] = nt.[pdw_node_id])
SELECT *
FROM cte;
```

### PolyBase date range increase for ORC and Parquet files

Reading, importing, and exporting date data types using PolyBase now supports dates before 1970-01-01 and after 2038-01-20 for ORC and Parquet file types.

### SSIS destination adapter for SQL Server 2017 as target

An APS SSIS destination adapter that supports [!INCLUDE [sssql17-md](../includes/sssql17-md.md)] as deployment target can be downloaded from [download site](https://www.microsoft.com/download/details.aspx?id=57472).

<a id="h2-aps-cu7.1"></a>

## APS CU7.1

Release date - July 2018

### DBCC commands don't consume concurrency slots (behavior change)

APS supports a subset of the T-SQL [DBCC commands](../t-sql/database-console-commands/dbcc-transact-sql.md) such as [DBCC DROPCLEANBUFFERS](../t-sql/database-console-commands/dbcc-dropcleanbuffers-transact-sql.md). Previously, these commands consumed a [concurrency slot](workload-management.md#concurrency-slots) and reduced the number of user loads and queries that could run. The `DBCC` commands now run in a local queue and don't consume a user concurrency slot. This change improves overall query execution performance.

### Replaces some metadata calls with catalog objects

Using catalog objects for metadata calls instead of using SMO improves performance in APS. Starting from CU7.1, some of these metadata calls use catalog objects by default. You can turn off this behavior with a [feature switch](appliance-feature-switch.md) if you encounter any problems with metadata queries.

### Bug fixes

APS CU7.1 is upgraded to [!INCLUDE [sssql16-md](../includes/sssql16-md.md)] SP2 CU2. The upgrade fixes some of the following issues.

| Title | Description |
| --- | --- |
| **Potential tuple mover deadlock** | The upgrade fixes a long standing possibility of deadlock in a distributed transaction and tuple mover background thread. After installing CU7.1, customers who used trace flag 634 to stop tuple mover as a [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] startup parameter or global trace flag, can safely remove it. |
| **Certain lag/lead query fails** | Certain queries on CCI tables with nested lag/lead functions that cause an error are now fixed with this upgrade. |

<a id="h2-aps-au7"></a>

## APS AU7

Release date - May 2018

APS 2016 is a prerequisite to upgrade to AU7. The following features are introduced in APS AU7:

### Auto-create and auto-update statistics

APS AU7 creates and updates statistics automatically, by default. To update statistics settings, administrators can use a feature switch menu item in the [Configuration Manager](appliance-configuration.md#CMTasks). The [feature switch](appliance-feature-switch.md) controls the auto-create, auto-update, and asynchronous update behavior of statistics. You can also update statistics settings with the [ALTER DATABASE (Parallel Data Warehouse)](../t-sql/statements/alter-database-transact-sql.md?tabs=sqlpdw) statement.

### T-SQL

`SELECT @var` is now supported. For more information, see [select local variable](../t-sql/language-elements/select-local-variable-transact-sql.md).

Query hints HASH and ORDER GROUP are now supported. For more information, see [Query hints](../t-sql/queries/hints-transact-sql-query.md).

### Feature switch

APS AU7 introduces Feature Switch in [Configuration Manager](launch-the-configuration-manager.md). AutoStatsEnabled and DmsProcessStopMessageTimeoutInSeconds are now configurable options that administrators can change.

### Known issues

With APS AU7 software, an Intel BIOS update is provided which fixes a problem described as *speculative execution side-channel attacks*. The attacks aim to exploit what are called *Spectre and Meltdown vulnerabilities*. Although the BIOS update is packaged together with APS, you install the BIOS update manually and not as part of the APS AU7 software install.

Microsoft advises all customers to install the BIOS update. The effect of Kernel Virtual Address Shadowing (KVAS), Kernel Page Table Indirection (KPTI), and Indirect Branch Prediction mitigation (IBP) on various SQL workloads in various environments shows significant degradation on some workloads. Based on the results, test the performance effect of enabling BIOS update before you deploy them in a production environment. For SQL Server guidance, see [KB4073225](https://support.microsoft.com/help/4073225/).

::: moniker-end
::: moniker range=">= aps-pdw-2016 "
<a id="h2-aps-au6"></a>

## APS 2016

This section describes the features introduced in APS 2016-AU6.

### SQL Server 2016

APS AU6 runs on the latest [!INCLUDE [sssql16-md](../includes/sssql16-md.md)] release. It uses the default [database compatibility level 130](../t-sql/statements/alter-database-transact-sql-compatibility-level.md). [!INCLUDE [sssql16-md](../includes/sssql16-md.md)] supports features such as:

- Secondary indexes for clustered columnstore indexes.
- Kerberos for PolyBase.

### T-SQL

APS AU6 supports these T-SQL compatibility improvements. These additional language elements make it easier to migrate from SQL Server and other data sources.

- [Column-level SQL collations](../relational-databases/collations/collation-and-unicode-support.md) are now supported, in addition to Windows collations.
- [Nonclustered indexes on clustered columnstore indexes](../t-sql/statements/create-index-transact-sql.md) improve performance of queries that search for specific values in the clustered columnstore index.
- [SELECT...INTO](../t-sql/queries/select-into-clause-transact-sql.md)
- [sp_spaceused()](../relational-databases/system-stored-procedures/sp-spaceused-transact-sql.md) displays the disk space used or reserved in a table or database.
- [Wide tables](../sql-server/maximum-capacity-specifications-for-sql-server.md) support is the same as [!INCLUDE [sssql16-md](../includes/sssql16-md.md)]. The previous limit of 32 K for the row size no longer exists.

**Data types**

- [VARCHAR(MAX)](../t-sql/data-types/char-and-varchar-transact-sql.md), [NVARCHAR(MAX)](../t-sql/data-types/nchar-and-nvarchar-transact-sql.md), and [VARBINARY(MAX)](../t-sql/data-types/binary-and-varbinary-transact-sql.md). These LOB data types have a maximum size of 2 GB. To load these objects, use the [bcp utility](../tools/bcp-utility.md). PolyBase and **dwloader** don't currently support these data types.
- [SYSNAME](../relational-databases/system-catalog-views/sys-types-transact-sql.md)
- [UNIQUEIDENTIFIER](../t-sql/data-types/uniqueidentifier-transact-sql.md)
- [NUMERIC](../t-sql/data-types/decimal-and-numeric-transact-sql.md) and DECIMAL data types.

**Window functions**

- [ROWS or RANGE](../t-sql/queries/select-over-clause-transact-sql.md) in the OVER clause of the SELECT statement.
- [FIRST_VALUE](../t-sql/functions/first-value-transact-sql.md)
- [LAST_VALUE](../t-sql/functions/last-value-transact-sql.md)
- [CUME_DIST](../t-sql/functions/cume-dist-transact-sql.md)
- [PERCENT_RANK](../t-sql/functions/percent-rank-transact-sql.md)

**Security functions**

- [CHECKSUM](../t-sql/functions/checksum-transact-sql.md) and [BINARY_CHECKSUM](../t-sql/functions/binary-checksum-transact-sql.md)
- [HAS_PERMS_BY_NAME](../t-sql/functions/has-perms-by-name-transact-sql.md)

**Additional functions**

- [NEWID](../t-sql/functions/newid-transact-sql.md)
- [RAND](../t-sql/functions/rand-transact-sql.md)

### PolyBase and Hadoop enhancements

- Compatibility with Hortonworks HDP 2.4 and HDP 2.5
- Kerberos support through database scoped credentials
- Credential support with Azure Storage Blobs

### Install and upgrade enhancements

**Enterprise architecture updates**

Upgrading your existing appliance to APS AU6 installs the latest firmware and driver updates, which include security fixes.

An appliance from HPE or DELL includes all the latest updates plus:

- Latest generation processor support (Broadwell)
- Update to DDR4 DIMMs
- Improved DIMM throughput

**Integration**

- Fully Qualified Domain Name (FQDN) support makes it possible to set up a Domain trust to the appliance.
- To use FQDN, you need to do a full upgrade and opt-in during the upgrade.

**Reduced downtime**

Installing or upgrading to APS AU6 is faster and requires less downtime than previous releases. To reduce downtime, the install or upgrade:

- Streamlines applying WSUS updates by using an image that contains all the updates through June 2016
- Applies security updates with the driver and firmware updates
- Places the latest hotfixes and the appliance verification utility (PAV) on your appliance so they're ready to install with no need to download them.

::: moniker-end
