---
title: "ODBC API Implementation Details"
description: "ODBC API Implementation Details"
author: markingmyname
ms.author: maghan
ms.date: 01/26/2026
ms.service: sql
ms.subservice: native-client
ms.topic: "reference"
helpviewer_keywords:
  - "ODBC, functions"
  - "SQL Server Native Client ODBC driver, SQL Server-specific behaviors"
  - "ODBC, SQL Server-specific behaviors"
  - "functions [ODBC]"
---

# ODBC API implementation details

[!INCLUDE [SQL Server Azure SQL Database Synapse Analytics PDW](../../includes/applies-to-version/sql-asdb-asdbmi-asa-pdw.md)]

Open Database Connectivity (ODBC) is a Microsoft Win32 API that enables applications to access data in ODBC-compliant data sources. This article explains how ODBC processes function calls, manages handles, interacts with drivers, and provides diagnostics. It gives developers a clearer understanding of how ODBC operates between applications, the Driver Manager, and database drivers.

The [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] Native Client ODBC driver reference doesn't document every ODBC function. It only documents those functions with parameters or behaviors unique to the [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] Native Client ODBC driver.

The [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] Native Client ODBC driver complies with the ODBC 3.51 specification. For full reference material, download the Microsoft Data Access Components SDK from the [Data Access and Storage Developer Center](https://go.microsoft.com/fwlink?linkid=4173) or view the [ODBC Programmer's Reference](../../odbc/reference/odbc-programmer-s-reference.md).

## How the ODBC API works

ODBC provides a standardized interface between applications and database drivers. When your application calls an ODBC function, the call passes through several layers before reaching the data source. Understanding this architecture helps you write more efficient code and troubleshoot connectivity problems.

### ODBC handle model

ODBC uses four hierarchical handle types to manage state:

| Handle type | Purpose |
| --- | --- |
| **Environment (HENV)** | Global ODBC settings and versioning. |
| **Connection (HDBC)** | Represents a connection to a specific data source. |
| **Statement (HSTMT)** | Manages SQL statements, parameters, and result sets. |
| **Descriptor (HDESC)** | Stores metadata for parameters and columns. |

### Driver manager and driver interaction

1. The application makes an ODBC API call.
1. The **Driver Manager** validates parameters and dispatches the call.
1. The **driver** interacts with the data source.
1. Results flow back through the Driver Manager to the application.

### Function call lifecycle

1. Allocate handles.
1. Set environment or connection attributes.
1. Connect to a data source.
1. Prepare or execute SQL statements.
1. Bind parameters or result columns.
1. Fetch rows.
1. Free handles.

### Diagnostics and error handling

Use the following diagnostic functions:

- `SQLGetDiagRec`
- `SQLGetDiagField`

Diagnostics might apply to environment, connection, or statement handles.

### Unicode vs. ANSI calls

ODBC provides two types of functions:

- **ANSI functions** like `SQLExecDirectA`
- **Unicode functions** like `SQLExecDirectW`

Use Unicode APIs for modern applications.

### Threading and pooling

- Thread safety depends on how the application configures the driver and Driver Manager.
- To reduce connection overhead, enable connection pooling at either level.

## ODBC API reference (table layout)

The following table lists the available ODBC API functions documented for the SQL Server Native Client driver. Each entry links to its corresponding detailed reference page.

| Function | Description |
| --- | --- |
| [SQLBindCol](../../relational-databases/native-client-odbc-api/sqlbindcol.md) | Bind application variables to result columns. |
| [SQLBindParameter](../../relational-databases/native-client-odbc-api/sqlbindparameter.md) | Bind application variables to SQL statement parameters. |
| [SQLBrowseConnect](../../relational-databases/native-client-odbc-api/sqlbrowseconnect.md) | Build connection strings interactively. |
| [SQLCancel](../../relational-databases/native-client-odbc-api/sqlcancel.md) | Cancel statement execution. |
| [SQLCloseCursor](../../relational-databases/native-client-odbc-api/sqlclosecursor.md) | Close an open cursor. |
| [SQLColAttribute](../../relational-databases/native-client-odbc-api/sqlcolattribute.md) | Retrieve column metadata. |
| [SQLColumnPrivileges](../../relational-databases/native-client-odbc-api/sqlcolumnprivileges.md) | Retrieve privileges for table columns. |
| [SQLColumns](../../relational-databases/native-client-odbc-api/sqlcolumns.md) | Retrieve column metadata for tables. |
| [SQLConfigDataSource](../../relational-databases/native-client-odbc-api/sqlconfigdatasource.md) | Configure DSNs. |
| [SQLConnect](../../relational-databases/native-client-odbc-api/sqlconnect.md) | Connect to a data source. |
| [SQLDescribeCol](../../relational-databases/native-client-odbc-api/sqldescribecol.md) | Retrieve column descriptions. |
| [SQLDescribeParam](../../relational-databases/native-client-odbc-api/sqldescribeparam.md) | Retrieve SQL parameter metadata. |
| [SQLDriverConnect](../../relational-databases/native-client-odbc-api/sqldriverconnect.md) | Connect using a full or partial connection string. |
| [SQLDrivers](../../relational-databases/native-client-odbc-api/sqldrivers.md) | Enumerate installed ODBC drivers. |
| [SQLEndTran](../../relational-databases/native-client-odbc-api/sqlendtran.md) | Commit or roll back transactions. |
| [SQLExecDirect](../../relational-databases/native-client-odbc-api/sqlexecdirect.md) | Execute SQL directly. |
| [SQLExecute](../../relational-databases/native-client-odbc-api/sqlexecute.md) | Execute prepared SQL statements. |
| [SQLFetch](../../relational-databases/native-client-odbc-api/sqlfetch.md) | Fetch result rows sequentially. |
| [SQLFetchScroll](../../relational-databases/native-client-odbc-api/sqlfetchscroll.md) | Fetch rows using scrollable cursors. |
| [SQLForeignKeys](../../relational-databases/native-client-odbc-api/sqlforeignkeys.md) | Retrieve foreign key information. |
| [SQLFreeHandle](../../relational-databases/native-client-odbc-api/sqlfreehandle.md) | Free an ODBC handle. |
| [SQLFreeStmt](../../relational-databases/native-client-odbc-api/sqlfreestmt.md) | Free resources associated with a statement. |
| [SQLGetConnectAttr](../../relational-databases/native-client-odbc-api/sqlgetconnectattr.md) | Retrieve connection attributes. |
| [SQLGetCursorName](../../relational-databases/native-client-odbc-api/sqlgetcursorname.md) | Retrieve the name of a cursor. |
| [SQLGetData](../../relational-databases/native-client-odbc-api/sqlgetdata.md) | Retrieve data for a result column. |
| [SQLGetDescField](../../relational-databases/native-client-odbc-api/sqlgetdescfield.md) | Retrieve descriptor fields. |
| [SQLGetDiagField](../../relational-databases/native-client-odbc-api/sqlgetdiagfield.md) | Retrieve detailed diagnostic information. |
| [SQLGetFunctions](../../relational-databases/native-client-odbc-api/sqlgetfunctions.md) | Determine which functions a driver supports. |
| [SQLGetInfo](../../relational-databases/native-client-odbc-api/sqlgetinfo.md) | Retrieve driver-specific information. |
| [SQLGetStmtAttr](../../relational-databases/native-client-odbc-api/sqlgetstmtattr.md) | Retrieve statement attributes. |
| [SQLGetTypeInfo](../../relational-databases/native-client-odbc-api/sqlgettypeinfo.md) | Retrieve supported SQL data types. |
| [SQLMoreResults](../../relational-databases/native-client-odbc-api/sqlmoreresults.md) | Process multiple result sets. |
| [SQLNativeSql](../../relational-databases/native-client-odbc-api/sqlnativesql.md) | Convert SQL statements to the driver's native SQL dialect. |
| [SQLNumParams](../../relational-databases/native-client-odbc-api/sqlnumparams.md) | Return the number of parameters in a prepared statement. |
| [SQLNumResultCols](../../relational-databases/native-client-odbc-api/sqlnumresultcols.md) | Return the number of result columns. |
| [SQLParamData](../../relational-databases/native-client-odbc-api/sqlparamdata.md) | Retrieve next parameter in a data-at-execution operation. |
| [SQLPrimaryKeys](../../relational-databases/native-client-odbc-api/sqlprimarykeys.md) | Retrieve primary key information. |
| [SQLProcedureColumns](../../relational-databases/native-client-odbc-api/sqlprocedurecolumns.md) | Retrieve stored procedure parameter metadata. |
| [SQLProcedures](../../relational-databases/native-client-odbc-api/sqlprocedures.md) | Retrieve stored procedure metadata. |
| [SQLPutData](../../relational-databases/native-client-odbc-api/sqlputdata.md) | Send parameter data at execution time. |
| [SQLRowCount](../../relational-databases/native-client-odbc-api/sqlrowcount.md) | Retrieve number of rows affected by a statement. |
| [SQLSetConnectAttr](../../relational-databases/native-client-odbc-api/sqlsetconnectattr.md) | Set connection attributes. |
| [SQLSetDescField](../../relational-databases/native-client-odbc-api/sqlsetdescfield.md) | Set descriptor fields. |
| [SQLSetDescRec](../../relational-databases/native-client-odbc-api/sqlsetdescrec.md) | Set descriptor records. |
| [SQLSetEnvAttr](../../relational-databases/native-client-odbc-api/sqlsetenvattr.md) | Set environment attributes. |
| [SQLSetStmtAttr](../../relational-databases/native-client-odbc-api/sqlsetstmtattr.md) | Set statement attributes. |
| [SQLSpecialColumns](../../relational-databases/native-client-odbc-api/sqlspecialcolumns.md) | Retrieve special column information. |
| [SQLStatistics](../../relational-databases/native-client-odbc-api/sqlstatistics.md) | Retrieve index and statistic information. |
| [SQLTablePrivileges](../../relational-databases/native-client-odbc-api/sqltableprivileges.md) | Retrieve table privilege information. |
| [SQLTables](../../relational-databases/native-client-odbc-api/sqltables.md) | Retrieve table metadata. |

## Related content

- [SQL Server Native Client (ODBC) Reference](../native-client/odbc/sql-server-native-client-odbc.md)
