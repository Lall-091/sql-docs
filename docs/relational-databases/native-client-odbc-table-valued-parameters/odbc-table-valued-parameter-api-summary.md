---
title: "ODBC Table-Valued Parameter API Summary"
description: "ODBC Table-Valued Parameter API Summary"
author: markingmyname
ms.author: maghan
ms.date: 01/26/2026
ms.service: sql
ms.subservice: native-client
ms.topic: "reference"
helpviewer_keywords:
  - "ODBC, API support for table-valued parameters"
  - "table-valued parameters (ODBC), API support"
---

# ODBC table-valued parameter API summary

[!INCLUDE [SQL Server Azure SQL Database Synapse Analytics PDW](../../includes/applies-to-version/sql-asdb-asdbmi-asa-pdw.md)]

ODBC supports table-valued parameters (TVPs) through enhancements to several existing API functions. These functions work together to describe TVP schemas, bind and transmit row sets, fetch metadata, and manage descriptor records.  
The following sections organize the relevant ODBC functions into logical groups to help you understand how each part of the TVP pipeline operates.

## TVP schema discovery and metadata functions

These functions help an application discover the structure of table-valued parameters, including column metadata, parameter definitions, and available SQL data types.

| Function | Purpose |
|----------|----------|
| [SQLColumns](../../relational-databases/native-client-odbc-api/sqlcolumns.md) | Retrieves column metadata for a table‑valued parameter or table type. |
| [SQLDescribeParam](../../relational-databases/native-client-odbc-api/sqldescribeparam.md) | Returns metadata for a TVP parameter, including type, precision, and scale. |
| [SQLGetTypeInfo](../../relational-databases/native-client-odbc-api/sqlgettypeinfo.md) | Retrieves the SQL data types supported by the driver for table‑valued parameter columns. |
| [SQLPrimaryKeys](../../relational-databases/native-client-odbc-api/sqlprimarykeys.md) | Provides information about key columns in table types used with TVPs. |
| [SQLProcedureColumns](../../relational-databases/native-client-odbc-api/sqlprocedurecolumns.md) | Retrieves metadata for TVP-related stored procedure parameters. |
| [SQLTables](../../relational-databases/native-client-odbc-api/sqltables.md) | Lists tables and table types available as sources for TVP declarations. |

## TVP parameter binding and data transmission

These functions handle binding structured data to parameters, passing the data to the server, or streaming rows during execution.

| Function | Purpose |
|----------|---------|
| [SQLBindParameter](../../relational-databases/native-client-odbc-api/sqlbindparameter.md) | Binds a table-valued parameter to an application buffer or rowset. |
| [SQLParamData](../../relational-databases/native-client-odbc-api/sqlparamdata.md) | Retrieves the next part of a streamed TVP parameter when using data-at-execution. |
| [SQLPutData](../../relational-databases/native-client-odbc-api/sqlputdata.md) | Sends TVP data in chunks during data-at-execution operations. |

## Statement execution for TVPs

These functions execute SQL statements that reference TVPs and manage the execution lifecycle.

| Function | Purpose |
|----------|---------|
| [SQLExecDirect](../../relational-databases/native-client-odbc-api/sqlexecdirect.md) | Executes a SQL statement that uses TVPs without preparing it first. |
| [SQLExecute](../../relational-databases/native-client-odbc-api/sqlexecute.md) | Executes a previously prepared SQL statement that includes TVP parameters. |

## Descriptor and attribute management for TVPs

Use these functions to manage descriptor fields and statement attributes required to describe rowsets and structured parameters correctly.

| Function | Purpose |
|----------|---------|
| [SQLGetDescField](../../relational-databases/native-client-odbc-api/sqlgetdescfield.md) | Retrieves descriptor metadata for TVP columns or rowsets. |
| [SQLGetDescRec](../../relational-databases/native-databases/native-client-odbc-api/sqlgetdescrec.md) | Retrieves a complete descriptor record for a TVP. |
| [SQLSetDescField](../../relational-databases/native-client-odbc-api/sqlsetdescfield.md) | Sets descriptor metadata for TVP columns or rowsets. |
| [SQLSetDescRec](../../relational-databases/native-client-odbc-api/sqlsetdescrec.md) | Sets a full descriptor record for structured TVP data. |
| [SQLGetStmtAttr](../../relational-databases/native-client-odbc-api/sqlgetstmtattr.md) | Retrieves statement attributes affecting TVP execution behavior. |
| [SQLSetStmtAttr](../../relational-databases/native-client-odbc-api/sqlsetstmtattr.md) | Sets statement attributes such as rowset sizes or streaming flags for TVP operations. |

## Diagnostics and error handling for TVPs

Use these functions to help your applications detect errors, warnings, or status messages during TVP binding and execution.

| Function | Purpose |
|----------|---------|
| [SQLGetDiagField](../../relational-databases/native-client-odbc-api/sqlgetdiagfield.md) | Retrieves diagnostic information generated during TVP processing. |

## Related content

- [Table-Valued Parameters (ODBC)](../../relational-databases/native-client-odbc-table-valued-parameters/table-valued-parameters-odbc.md)
