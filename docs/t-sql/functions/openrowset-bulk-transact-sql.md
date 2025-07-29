---
title: "OPENROWSET BULK (Transact-SQL)"
description: "OPENROWSET BULK operations perform bulk data manipulation operations on an external data source."
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: randolphwest, hudequei, wiassaf, jovanpop
ms.date: 06/25/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-mi-current || >=sql-server-2016 || =azuresqldb-current || >=sql-server-linux-2017 || =fabric"
---

# OPENROWSET BULK (Transact-SQL)

::: moniker range="=azuresqldb-mi-current||=azuresqldb-current||>=sql-server-2016||>=sql-server-linux-2017"

[!INCLUDE [SQL Server Azure SQL Database Azure SQL Managed Instance](../../includes/applies-to-version/sql-asdb-asdbmi.md)]

An `OPENROWSET` T-SQL command includes all connection information that is required to access remote data from an external data source. `OPENROWSET` also supports bulk operations through a built-in `BULK` provider that enables data from a file to be read and returned as a rowset. `OPENROWSET BULK` is for reading from external data files, `OPENROWSET` without bulk is for reading from another database engine.

The `OPENROWSET` function can be referenced in the `FROM` clause of a query as if it were a table name. The `OPENROWSET` function can also be referenced as the target of an `INSERT`, `UPDATE`, or `DELETE` statement, subject to the capabilities of the data provider. Although the query might return multiple result sets, `OPENROWSET` returns only the first one.

`OPENROWSET` without the `BULK` operator is available on [!INCLUDE [ssnoversion-md](../../includes/ssnoversion-md.md)] only, for more information, see [OPENROWSET (Transact-SQL)](openrowset-transact-sql.md).

Details and links to similar examples on other platforms:

- For Microsoft Fabric Data Warehouse syntax, [select Fabric in the version dropdown list](openrowset-transact-sql.md?view=fabric&preserve-view=true).
- For more information on `OPENROWSET` in [!INCLUDE [ssazure-sqldb](../../includes/ssazure-sqldb.md)], see [Data virtualization with Azure SQL Database](/azure/azure-sql/database/data-virtualization-overview?view=azuresql-db&preserve-view=true).
- For more information on `OPENROWSET` in [!INCLUDE [ssazuremi-md](../../includes/ssazuremi-md.md)], see [Data virtualization with Azure SQL Managed Instance](/azure/azure-sql/managed-instance/data-virtualization-overview?view=azuresql-mi&preserve-view=true#query-data-sources-using-openrowset).
- For information and examples with serverless SQL pools in Azure Synapse, see [How to use OPENROWSET using serverless SQL pool in Azure Synapse Analytics](/azure/synapse-analytics/sql/develop-openrowset).
- Dedicated SQL pools in Azure Synapse don't support the `OPENROWSET` function.

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

## Syntax

`OPENROWSET(BULK)` syntax is used to read external files:

```syntaxsql
OPENROWSET( BULK 'data_file' ,
            { FORMATFILE = 'format_file_path' [ <bulk_options> ]
              | SINGLE_BLOB | SINGLE_CLOB | SINGLE_NCLOB }
)

<bulk_options> ::=
   [ , DATA_SOURCE = 'data_source_name' ]

   -- bulk_options related to input file format
   [ , CODEPAGE = { 'ACP' | 'OEM' | 'RAW' | 'code_page' } ]
   [ , FORMAT = { 'CSV' | 'PARQUET' | 'DELTA' } ]
   [ , FIELDQUOTE = 'quote_character' ]
   [ , FORMATFILE = 'format_file_path' ]
   [ , FORMATFILE_DATA_SOURCE = 'data_source_name' ]

   [ , FIRSTROW = first_row ]
   [ , LASTROW = last_row ]

   [ , MAXERRORS = maximum_errors ]
   [ , ERRORFILE = 'file_name' ]
   [ , ERRORFILE_DATA_SOURCE = 'data_source_name' ]

   [ , ROWS_PER_BATCH = rows_per_batch ]
   [ , ORDER ( { column [ ASC | DESC ] } [ , ...n ] ) [ UNIQUE ] ]
```

## Arguments

### BULK arguments

Uses the `BULK` rowset provider for `OPENROWSET` to read data from a file. In [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)], `OPENROWSET` can read from a data file without loading the data into a target table. This lets you use `OPENROWSET` with a basic `SELECT` statement.

The arguments of the `BULK` option allow for significant control over where to start and end reading data, how to deal with errors, and how data is interpreted. For example, you can specify that the data file is read as a single-row, single-column rowset of type **varbinary**, **varchar**, or **nvarchar**. The default behavior is described in the argument descriptions that follow.

For information about how to use the `BULK` option, see the [Remarks](#remarks) section later in this article. For information about the permissions that the `BULK` option requires, see the [Permissions](#permissions) section, later in this article.

> [!NOTE]  
> When used to import data with the full recovery model, `OPENROWSET (BULK ...)` doesn't optimize logging.

For information on preparing data for bulk import, see [Prepare data for bulk export or import](../../relational-databases/import-export/prepare-data-for-bulk-export-or-import-sql-server.md).

#### BULK '*data_file*'

The full path of the data file whose data is to be copied into the target table.

```sql
SELECT * FROM OPENROWSET(
   BULK 'C:\DATA\inv-2017-01-19.csv',
   SINGLE_CLOB
) AS DATA;
```

Beginning with [!INCLUDE [sssql17-md](../../includes/sssql17-md.md)], the data_file can be in Azure Blob Storage. For examples, see [Examples of bulk access to data in Azure Blob Storage](../../relational-databases/import-export/examples-of-bulk-access-to-data-in-azure-blob-storage.md).

### BULK error handling options

#### ERRORFILE = '*file_name*'

Specifies the file used to collect rows that have formatting errors and can't be converted to an OLE DB rowset. These rows are copied into this error file from the data file "as is."

The error file is created at the start of the command execution. An error is raised if the file already exists. Additionally, a control file that has the extension .ERROR.txt is created. This file references each row in the error file and provides error diagnostics. After the errors are corrected, the data can be loaded.

Beginning with [!INCLUDE [sssql17-md](../../includes/sssql17-md.md)], the `error_file_path` can be in Azure Blob Storage.

#### ERRORFILE_DATA_SOURCE_NAME

Beginning with [!INCLUDE [sssql17-md](../../includes/sssql17-md.md)], this argument is a named external data source pointing to the Azure Blob storage location of the error file that will contain errors found during the import. The external data source must be created using the `TYPE = BLOB_STORAGE`. For more information, see [CREATE EXTERNAL DATA SOURCE (Transact-SQL)](../statements/create-external-data-source-transact-sql.md).

#### MAXERRORS = *maximum_errors*

Specifies the maximum number of syntax errors or nonconforming rows, as defined in the format file, which can occur before `OPENROWSET` throws an exception. Until `MAXERRORS` is reached, `OPENROWSET` ignores each bad row, not loading it, and counts the bad row as one error.

The default for *maximum_errors* is 10.

> [!NOTE]  
> `MAX_ERRORS` doesn't apply to `CHECK` constraints, or to converting **money** and **bigint** data types.

### BULK data processing options

#### DATA_SOURCE 

`DATA_SOURCE` is the external location created with [CREATE EXTERNAL DATA SOURCE](../statements/create-external-data-source-transact-sql.md).

#### FIRSTROW = *first_row*

Specifies the number of the first row to load. The default is 1. This indicates the first row in the specified data file. The row numbers are determined by counting the row terminators. `FIRSTROW` is 1-based.

#### LASTROW = *last_row*

Specifies the number of the last row to load. The default is 0. This indicates the last row in the specified data file.

#### ROWS_PER_BATCH = *rows_per_batch*

Specifies the approximate number of rows of data in the data file. This value should be of the same order as the actual number of rows.

`OPENROWSET` always imports a data file as a single batch. However, if you specify *rows_per_batch* with a value > 0, the query processor uses the value of *rows_per_batch* as a hint for allocating resources in the query plan.

By default, `ROWS_PER_BATCH` is unknown. Specifying `ROWS_PER_BATCH = 0` is the same as omitting `ROWS_PER_BATCH`.

#### ORDER ( { *column* [ ASC | DESC ] } [ ,... *n* ] [ UNIQUE ] )

An optional hint that specifies how the data in the data file is sorted. By default, the bulk operation assumes the data file is unordered. Performance can improve if the query optimizer can exploit the order to generate a more efficient query plan. The following list provides examples for when specifying a sort can be beneficial:

- Inserting rows into a table that has a clustered index, where the rowset data is sorted on the clustered index key.
- Joining the rowset with another table, where the sort and join columns match.
- Aggregating the rowset data by the sort columns.
- Using the rowset as a source table in the `FROM` clause of a query, where the sort and join columns match.

#### UNIQUE

Specifies that the data file doesn't have duplicate entries.

If the actual rows in the data file aren't sorted according to the order that is specified, or if the `UNIQUE` hint is specified and duplicates keys are present, an error is returned.

Column aliases are required when `ORDER` is used. The column alias list must reference the derived table that is being accessed by the `BULK` clause. The column names that are specified in the `ORDER` clause refer to this column alias list. Large value types (**varchar(max)**, **nvarchar(max)**, **varbinary(max)**, and **xml**) and large object (LOB) types (**text**, **ntext**, and **image**) columns can't be specified.

#### SINGLE_BLOB

Returns the contents of *data_file* as a single-row, single-column rowset of type **varbinary(max)**.

> [!IMPORTANT]  
> We recommend that you import XML data only using the `SINGLE_BLOB` option, rather than `SINGLE_CLOB` and `SINGLE_NCLOB`, because only `SINGLE_BLOB` supports all Windows encoding conversions.

#### SINGLE_CLOB

By reading *data_file* as ASCII, returns the contents as a single-row, single-column rowset of type **varchar(max)**, using the collation of the current database.

#### SINGLE_NCLOB

By reading *data_file* as Unicode, returns the contents as a single-row, single-column rowset of type **nvarchar(max)**, using the collation of the current database.

```sql
SELECT * FROM OPENROWSET(
    BULK N'C:\Text1.txt',
    SINGLE_NCLOB
) AS Document;
```

### BULK input file format options

#### CODEPAGE = { 'ACP' | 'OEM' | 'RAW' | '*code_page*' }

Specifies the code page of the data in the data file. `CODEPAGE` is relevant only if the data contains **char**, **varchar**, or **text** columns with character values more than 127 or less than 32.

> [!IMPORTANT]  
> `CODEPAGE` isn't a supported option on Linux.

> [!NOTE]  
> We recommend that you specify a collation name for each column in a format file, except when you want the 65001 option to have priority over the collation/code page specification.

| CODEPAGE value | Description |
| --- | --- |
| `ACP` | Converts columns of **char**, **varchar**, or **text** data type from the ANSI/[!INCLUDE [msCoName](../../includes/msconame-md.md)] Windows code page (ISO 1252) to the [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] code page. |
| `OEM` (default) | Converts columns of **char**, **varchar**, or **text** data type from the system OEM code page to the [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] code page. |
| `RAW` | No conversion occurs from one code page to another. This is the fastest option. |
| `code_page` | Indicates the source code page on which the character data in the data file is encoded; for example, 850.<br /><br />**Important** Versions before [!INCLUDE [sssql16-md](../../includes/sssql16-md.md)] don't support code page 65001 (UTF-8 encoding). |

#### FORMAT = { 'CSV' | 'PARQUET' | 'DELTA' }

Beginning with [!INCLUDE [sssql17-md](../../includes/sssql17-md.md)], this argument specifies a comma separated values file compliant to the [RFC 4180](https://datatracker.ietf.org/doc/html/rfc4180) standard.

Beginning with [!INCLUDE [sssql22-md](../../includes/sssql22-md.md)], both Parquet and Delta formats are supported.

```sql
SELECT *
FROM OPENROWSET(BULK N'D:\XChange\test-csv.csv',
    FORMATFILE = N'D:\XChange\test-csv.fmt',
    FIRSTROW=2,
    FORMAT='CSV') AS cars;
```

#### FORMATFILE = '*format_file_path*'

Specifies the full path of a format file. [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] supports two types of format files: XML and non-XML.

A format file is required to define column types in the result set. The only exception is when `SINGLE_CLOB`, `SINGLE_BLOB`, or `SINGLE_NCLOB` is specified; in which case, the format file isn't required.

For information about format files, see [Use a format file to bulk import data (SQL Server)](../../relational-databases/import-export/use-a-format-file-to-bulk-import-data-sql-server.md).

Beginning with [!INCLUDE [sssql17-md](../../includes/sssql17-md.md)], the format_file_path can be in Azure Blob Storage. For examples, see [Examples of bulk access to data in Azure Blob Storage](../../relational-databases/import-export/examples-of-bulk-access-to-data-in-azure-blob-storage.md).

#### FIELDQUOTE = '*field_quote*'

Beginning with [!INCLUDE [sssql17-md](../../includes/sssql17-md.md)], this argument specifies a character that is used as the quote character in the CSV file. If not specified, the quote character (`"`) is used as the quote character as defined in the [RFC 4180](https://datatracker.ietf.org/doc/html/rfc4180) standard. Only a single character can be specified as the value for this option.

## Remarks

`OPENROWSET` can be used to access remote data from OLE DB data sources only when the **DisallowAdhocAccess** registry option is explicitly set to `0` for the specified provider, and the Ad Hoc Distributed Queries advanced configuration option is enabled. When these options aren't set, the default behavior doesn't allow for ad hoc access.

When you access remote OLE DB data sources, the login identity of trusted connections isn't automatically delegated from the server on which the client is connected to the server that is being queried. Authentication delegation must be configured.

Catalog and schema names are required if the data provider supports multiple catalogs and schemas in the specified data source. Values for `catalog` and `schema` can be omitted when the data provider doesn't support them. If the provider supports only schema names, a two-part name of the form `schema.object` must be specified. If the provider supports only catalog names, a three-part name of the form `catalog.schema.object` must be specified. For more information, see [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md).

Three-part names must be specified for pass-through queries that use the [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] Native Client OLE DB provider.

`OPENROWSET` doesn't accept variables for its arguments.

Any call to `OPENDATASOURCE`, `OPENQUERY`, or `OPENROWSET` in the `FROM` clause is evaluated separately and independently from any call to these functions used as the target of the update, even if identical arguments are supplied to the two calls. In particular, filter or join conditions applied on the result of one of those calls has no effect on the results of the other.

## Use OPENROWSET with the BULK option

The following [!INCLUDE [tsql](../../includes/tsql-md.md)] enhancements support the `OPENROWSET(BULK...)` function:

- A `FROM` clause that is used with `SELECT` can call `OPENROWSET(BULK...)` instead of a table name, with full `SELECT` functionality.

   `OPENROWSET` with the `BULK` option requires a correlation name, also known as a range variable or alias, in the `FROM` clause. Column aliases can be specified. If a column alias list isn't specified, the format file must have column names. Specifying column aliases overrides the column names in the format file, such as:

  - `FROM OPENROWSET(BULK...) AS table_alias`
  - `FROM OPENROWSET(BULK...) AS table_alias(column_alias,...n)`

  > [!IMPORTANT]  
  > Failure to add the `AS <table_alias>` will result in the error:
  > Msg 491, Level 16, State 1, Line 20
  > A correlation name must be specified for the bulk rowset in the from clause.

- A `SELECT...FROM OPENROWSET(BULK...)` statement queries the data in a file directly, without importing the data into a table. `SELECT...FROM OPENROWSET(BULK...)` statements can also list bulk-column aliases by using a format file to specify column names, and also data types.
- Using `OPENROWSET(BULK...)` as a source table in an `INSERT` or `MERGE` statement bulk imports data from a data file into a [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] table. For more information, see [Use BULK INSERT or OPENROWSET(BULK...) to import data to SQL Server](../../relational-databases/import-export/import-bulk-data-by-using-bulk-insert-or-openrowset-bulk-sql-server.md).
- When the `OPENROWSET BULK` option is used with an `INSERT` statement, the `BULK` clause supports table hints. In addition to the regular table hints, such as `TABLOCK`, the `BULK` clause can accept the following specialized table hints: `IGNORE_CONSTRAINTS` (ignores only the `CHECK` and `FOREIGN KEY` constraints), `IGNORE_TRIGGERS`, `KEEPDEFAULTS`, and `KEEPIDENTITY`. For more information, see [Table Hints (Transact-SQL)](../queries/hints-transact-sql-table.md).

  For information about how to use `INSERT...SELECT * FROM OPENROWSET(BULK...)` statements, see [Bulk Import and Export of Data (SQL Server)](../../relational-databases/import-export/bulk-import-and-export-of-data-sql-server.md). For information about when row-insert operations that are performed by bulk import are logged in the transaction log, see [Prerequisites for minimal logging in bulk import](../../relational-databases/import-export/prerequisites-for-minimal-logging-in-bulk-import.md).

> [!NOTE]  
> When you use `OPENROWSET`, it's important to understand how [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] handles impersonation. For information about security considerations, see [Use BULK INSERT or OPENROWSET(BULK...) to import data to SQL Server](../../relational-databases/import-export/import-bulk-data-by-using-bulk-insert-or-openrowset-bulk-sql-server.md).

### Bulk importing SQLCHAR, SQLNCHAR, or SQLBINARY data

`OPENROWSET(BULK...)` assumes that, if not specified, the maximum length of `SQLCHAR`, `SQLNCHAR`, or `SQLBINARY` data doesn't exceed 8,000 bytes. If the data being imported is in a LOB data field that contains any **varchar(max)**, **nvarchar(max)**, or **varbinary(max)** objects that exceed 8,000 bytes, you must use an XML format file that defines the maximum length for the data field. To specify the maximum length, edit the format file and declare the MAX_LENGTH attribute.

> [!NOTE]  
> An automatically generated format file doesn't specify the length or maximum length for a LOB field. However, you can edit a format file and specify the length or maximum length manually.

### Bulk exporting or importing SQLXML documents

To bulk export or import SQLXML data, use one of the following data types in your format file.

| Data type | Effect |
| --- | --- |
| `SQLCHAR` or `SQLVARYCHAR` | The data is sent in the client code page, or in the code page implied by the collation. |
| `SQLNCHAR` or `SQLNVARCHAR` | The data is sent as Unicode. |
| `SQLBINARY` or `SQLVARYBIN` | The data is sent without any conversion. |

## Permissions

`OPENROWSET` with external data sources, requires the following permissions:

- `ADMINISTER DATABASE BULK OPERATIONS`

  or

- `ADMINISTER BULK OPERATIONS`

The following example grants `ADMINISTEER DATABASE BULK OPERATIONS` to a principal.

```sql
GRANT ADMINISTER DATABASE BULK OPERATIONS TO [<principal_name>];
```

If the target storage account is private, the principal must also have the **Storage Blob Data Reader** role (or higher) assigned at the container or storage account level.

## Examples

This section provides general examples to demonstrate how to use `OPENROWSET BULK` syntax. 

### A. Use OPENROWSET to BULK INSERT file data into a varbinary(max) column

**Applies to:** [!INCLUDE [ssnoversion-md](../../includes/ssnoversion-md.md)] only.

The following example creates a small table for demonstration purposes, and inserts file data from a file named `Text1.txt` located in the `C:` root directory into a **varbinary(max)** column.

```sql
CREATE TABLE myTable (
    FileName NVARCHAR(60),
    FileType NVARCHAR(60),
    Document VARBINARY(MAX)
);
GO

INSERT INTO myTable (
    FileName,
    FileType,
    Document
)
SELECT 'Text1.txt' AS FileName,
    '.txt' AS FileType,
    *
FROM OPENROWSET(
    BULK N'C:\Text1.txt',
    SINGLE_BLOB
) AS Document;
GO
```

### B. Use the OPENROWSET BULK provider with a format file to retrieve rows from a text file

**Applies to:** [!INCLUDE [ssnoversion-md](../../includes/ssnoversion-md.md)] only.

The following example uses a format file to retrieve rows from a tab-delimited text file, `values.txt` that contains the following data:

```output
1     Data Item 1
2     Data Item 2
3     Data Item 3
```

The format file, `values.fmt`, describes the columns in `values.txt`:

```output
9.0
2
1  SQLCHAR  0  10 "\t"    1  ID           SQL_Latin1_General_Cp437_BIN
2  SQLCHAR  0  40 "\r\n"  2  Description  SQL_Latin1_General_Cp437_BIN
```

This query retrieves that data:

```sql
SELECT a.* FROM OPENROWSET(
    BULK 'C:\test\values.txt',
   FORMATFILE = 'C:\test\values.fmt'
) AS a;
```

### C. Specify a format file and code page

**Applies to:** [!INCLUDE [ssnoversion-md](../../includes/ssnoversion-md.md)] only.

The following example shows how to use both the format file and code page options at the same time.

```sql
INSERT INTO MyTable
SELECT a.* FROM OPENROWSET (
    BULK N'D:\data.csv',
    FORMATFILE = 'D:\format_no_collation.txt',
    CODEPAGE = '65001'
) AS a;
```

### D. Access data from a CSV file with a format file

**Applies to:** [!INCLUDE [sssql17-md](../../includes/sssql17-md.md)] and later versions only.

```sql
SELECT * FROM OPENROWSET(
    BULK N'D:\XChange\test-csv.csv',
    FORMATFILE = N'D:\XChange\test-csv.fmt',
    FIRSTROW = 2,
    FORMAT = 'CSV'
) AS cars;
```

### E. Access data from a CSV file without a format file

**Applies to:** [!INCLUDE [ssnoversion-md](../../includes/ssnoversion-md.md)] only.

```sql
SELECT * FROM OPENROWSET(
   BULK 'C:\Program Files\Microsoft SQL Server\MSSQL14.CTP1_1\MSSQL\DATA\inv-2017-01-19.csv',
   SINGLE_CLOB
) AS DATA;
```

```sql
SELECT *
FROM OPENROWSET('MSDASQL',
    'Driver={Microsoft Access Text Driver (*.txt, *.csv)}',
    'SELECT * FROM E:\Tlog\TerritoryData.csv'
);
```

> [!IMPORTANT]  
> The ODBC driver should be 64-bit. Open the **Drivers** tab of the [Connect to an ODBC Data Source (SQL Server Import and Export Wizard)](../../integration-services/import-export-data/connect-to-an-odbc-data-source-sql-server-import-and-export-wizard.md) application in Windows to verify this. There's 32-bit `Microsoft Text Driver (*.txt, *.csv)` that will not work with a 64-bit version of `sqlservr.exe`.

### F. Access data from a file stored on Azure Blob Storage

**Applies to:** [!INCLUDE [sssql17-md](../../includes/sssql17-md.md)] and later versions only.

In [!INCLUDE [sssql17-md](../../includes/sssql17-md.md)] and later versions, the following example uses an external data source that points to a container in an Azure storage account and a database scoped credential created for a shared access signature.

```sql
SELECT * FROM OPENROWSET(
   BULK 'inv-2017-01-19.csv',
   DATA_SOURCE = 'MyAzureInvoices',
   SINGLE_CLOB
) AS DataFile;
```

For complete `OPENROWSET` examples including configuring the credential and external data source, see [Examples of bulk access to data in Azure Blob Storage](../../relational-databases/import-export/examples-of-bulk-access-to-data-in-azure-blob-storage.md).

<a id="j-importing-into-a-table-from-a-file-stored-on-azure-blob-storage"></a>

### G. Import into a table from a file stored on Azure Blob Storage

The following example shows how to use the `OPENROWSET` command to load data from a csv file in an Azure Blob storage location on which you created the SAS key. The Azure Blob storage location is configured as an external data source. This requires a database scoped credential using a shared access signature that is encrypted using a master key in the user database.

```sql
-- Optional: a MASTER KEY is not required if a DATABASE SCOPED CREDENTIAL is not required because the blob is configured for public (anonymous) access!
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<password>';
GO

-- Optional: a DATABASE SCOPED CREDENTIAL is not required because the blob is configured for public (anonymous) access!
CREATE DATABASE SCOPED CREDENTIAL MyAzureBlobStorageCredential
    WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
    SECRET = '******srt=sco&sp=rwac&se=2017-02-01T00:55:34Z&st=2016-12-29T16:55:34Z***************';

-- Make sure that you don't have a leading ? in the SAS token, and that you
-- have at least read permission on the object that should be loaded srt=o&sp=r,
-- and that expiration period is valid (all dates are in UTC time)
CREATE EXTERNAL DATA SOURCE MyAzureBlobStorage
WITH (
    TYPE = BLOB_STORAGE,
    LOCATION = 'https://****************.blob.core.windows.net/curriculum',
    -- CREDENTIAL is not required if a blob is configured for public (anonymous) access!
    CREDENTIAL = MyAzureBlobStorageCredential
);

INSERT INTO achievements
WITH (TABLOCK) (
    id,
    description
)
SELECT * FROM OPENROWSET(
    BULK 'csv/achievements.csv',
    DATA_SOURCE = 'MyAzureBlobStorage',
    FORMAT = 'CSV',
    FORMATFILE = 'csv/achievements-c.xml',
    FORMATFILE_DATA_SOURCE = 'MyAzureBlobStorage'
) AS DataFile;
```

### H. Use a managed identity for an external source

**Applies to:** [!INCLUDE[ssazuremi-md](../../includes/ssazuremi-md.md)] and [!INCLUDE[ssazure-sqldb](../../includes/ssazure-sqldb.md)]

The following example creates a credential by using a managed identity, creates an external source and then loads data from a CSV hosted on the external source.

First, create the credential and specify blob storage as the external source:

```sql
CREATE DATABASE SCOPED CREDENTIAL sampletestcred
WITH IDENTITY = 'MANAGED IDENTITY';

CREATE EXTERNAL DATA SOURCE SampleSource
WITH (
    LOCATION = 'abs://****************.blob.core.windows.net/curriculum',
    CREDENTIAL = sampletestcred
);
```

Next, load data from the CSV file hosted on blob storage:

```sql
SELECT * FROM OPENROWSET(
    BULK 'Test - Copy.csv',
    DATA_SOURCE = 'SampleSource',
    SINGLE_CLOB
) as test;
```

### I. Use OPENROWSET to access several Parquet files using S3-compatible object storage

**Applies to:** [!INCLUDE [sssql22-md](../../includes/sssql22-md.md)] and later versions.

The following example uses access several Parquet files from different location, all stored on S3-compatible object storage:

```sql
CREATE DATABASE SCOPED CREDENTIAL s3_dsc
WITH IDENTITY = 'S3 Access Key',
SECRET = 'contosoadmin:contosopwd';
GO

CREATE EXTERNAL DATA SOURCE s3_eds
WITH
(
    LOCATION = 's3://10.199.40.235:9000/movies',
    CREDENTIAL = s3_dsc
);
GO

SELECT * FROM OPENROWSET(
    BULK (
        '/decades/1950s/*.parquet',
        '/decades/1960s/*.parquet',
        '/decades/1970s/*.parquet'
    ),
    FORMAT = 'PARQUET',
    DATA_SOURCE = 's3_eds'
) AS data;
```

### J. Use OPENROWSET to access several Delta tables from Azure Data Lake Gen2

**Applies to:** [!INCLUDE [sssql22-md](../../includes/sssql22-md.md)] and later versions.

In this example, the data table container is named `Contoso`, and is located on an Azure Data Lake Gen2 storage account.

```sql
CREATE DATABASE SCOPED CREDENTIAL delta_storage_dsc
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = '<SAS Token>';

CREATE EXTERNAL DATA SOURCE Delta_ED
WITH (
    LOCATION = 'adls://<container>@<storage_account>.dfs.core.windows.net',
    CREDENTIAL = delta_storage_dsc
);

SELECT *
FROM OPENROWSET(
    BULK '/Contoso',
    FORMAT = 'DELTA',
    DATA_SOURCE = 'Delta_ED'
) AS result;
```

### K. Use OPENROWSET to query public-anonymous dataset

The following example uses the publicly available [NYC yellow taxi trip records open data set](/azure/open-datasets/dataset-taxi-yellow).

Create the data source first:

```sql
CREATE EXTERNAL DATA SOURCE NYCTaxiExternalDataSource
WITH (LOCATION = 'abs://nyctlc@azureopendatastorage.blob.core.windows.net');
```

Query all files with .parquet extension in folders matching name pattern:

```sql
SELECT TOP 10 *
FROM OPENROWSET(
 BULK 'yellow/puYear=*/puMonth=*/*.parquet',
 DATA_SOURCE = 'NYCTaxiExternalDataSource',
 FORMAT = 'parquet'
) AS filerows;
```

### More examples

For more examples that show using `INSERT...SELECT * FROM OPENROWSET(BULK...)`, see the following articles:

- [Examples of bulk import and export of XML documents (SQL Server)](../../relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server.md)
- [Keep identity values when bulk importing data (SQL Server)](../../relational-databases/import-export/keep-identity-values-when-bulk-importing-data-sql-server.md)
- [Keep nulls or default values during bulk import (SQL Server)](../../relational-databases/import-export/keep-nulls-or-use-default-values-during-bulk-import-sql-server.md)
- [Use a format file to bulk import data (SQL Server)](../../relational-databases/import-export/use-a-format-file-to-bulk-import-data-sql-server.md)
- [Use character format to import or export data (SQL Server)](../../relational-databases/import-export/use-character-format-to-import-or-export-data-sql-server.md)
- [Use a Format File to Skip a Table Column (SQL Server)](../../relational-databases/import-export/use-a-format-file-to-skip-a-table-column-sql-server.md)
- [Use a format file to skip a data field (SQL Server)](../../relational-databases/import-export/use-a-format-file-to-skip-a-data-field-sql-server.md)
- [Use a format file to map table columns to data-file fields (SQL Server)](../../relational-databases/import-export/use-a-format-file-to-map-table-columns-to-data-file-fields-sql-server.md)
- [Query data sources using OPENROWSET in Azure SQL Managed Instances](/azure/azure-sql/managed-instance/data-virtualization-overview#query-data-sources-using-openrowset)

## Related content

- [DELETE (Transact-SQL)](../statements/delete-transact-sql.md)
- [FROM clause plus JOIN, APPLY, PIVOT (Transact-SQL)](../queries/from-transact-sql.md)
- [Bulk Import and Export of Data (SQL Server)](../../relational-databases/import-export/bulk-import-and-export-of-data-sql-server.md)
- [INSERT (Transact-SQL)](../statements/insert-transact-sql.md)
- [OPENDATASOURCE (Transact-SQL)](opendatasource-transact-sql.md)
- [OPENQUERY (Transact-SQL)](openquery-transact-sql.md)
- [SELECT (Transact-SQL)](../queries/select-transact-sql.md)
- [sp_serveroption (Transact-SQL)](../../relational-databases/system-stored-procedures/sp-serveroption-transact-sql.md)
- [UPDATE (Transact-SQL)](../queries/update-transact-sql.md)
- [WHERE (Transact-SQL)](../queries/where-transact-sql.md)

::: moniker-end

::: moniker range="=fabric"

[!INCLUDE [fabric-se-and-dw](../../includes/applies-to-version/fabric-se-and-dw.md)]

The T-SQL `OPENROWSET` function reads a content of a file in Azure Data Lake storage. You can read text/CSV, Parquet, or JSON-lines file formats that are stored in Azure Data Lake or Azure Blob storage.

The `OPENROWSET` function reads data from a file and returns it as a rowset. The `OPENROWSET` function can be referenced in the `FROM` clause of a query as if it were a table name. 

This article applies only to [!INCLUDE [fabric](../../includes/fabric.md)] [!INCLUDE [fabric-dw](../../includes/fabric-dw.md)]. There are functional differences between the OPENROWSET function in Fabric Warehouse and SQL analytics endpoint items.

Details and links to similar examples on other platforms:

- For syntax in other services [select your version in the version drop down](openrowset-transact-sql.md?view=sql-server-ver16&preserve-view=true).

## Syntax

```syntaxsql
SELECT <columns>
FROM OPENROWSET(
    BULK 'https://<storage>.blob.core.windows.net/path/folder1=*/folder2=*/<filename>'
    [, FORMAT = ('PARQUET' | 'CSV' | 'JSONL') ]

    -- execution options
    [, ROWS_PER_BATCH=number_of_rows]

    -- Text/CSV encoding options
    [, DATAFILETYPE = {'char' | 'widechar' }     ]
    [, CODEPAGE = {'ACP' | 'OEM' | 'raw' | '<code_page>' } ]

    -- Text/CSV formatting options
    [, ROWTERMINATOR = 'row_terminator' ]
    [, FIELDTERMINATOR =  'field_terminator' ]
    [, FIELDQUOTE = 'string_delimiter' ]
    [ , PARSER_VERSION = 'parser_version' ]
    [, ESCAPECHAR = 'escape_char' ]
    [, HEADER_ROW = [true|false] ]
    [, FIRSTROW = first_row ]
    [, LASTROW = last_row ]

    -- execution options
    [, ROWS_PER_BATCH=number_of_rows]
) 
[
    WITH (  ( <column_name> <sql_datatype> [ '<column_path>' | <column_ordinal> ] )+ )
]
[ AS <alias> ]
```

## Arguments

#### BULK 'data_file'

The URI of the data file(s) whose data is to be read and returned as row set. The URI can reference Azure Data Lake storage or Azure Blob storage.

The URI may include the `*` character to match any sequence of characters, allowing `OPENROWSET` to pattern-match against the URI. Additionally, it can end with `/**` to enable recursive traversal through all subfolders.

The URI of the data file(s) whose data is to be read and returned as row set. The URI can reference Azure Data Lake storage or Azure Blob storage. The supported URI formats are:

- `https://{storage}.blob.core.windows.net/[container}/{file path}`
- `https://{storage}.dfs.core.windows.net/[container}/{file path}`
- `abfss://[container}@{storage}.dfs.core.windows.net/{file path}`

For example:

```sql
SELECT TOP 10 *
FROM OPENROWSET(
    BULK 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/bing_covid-19_data/latest/*.parquet'
);
```

### BULK input file format options

#### FORMAT = { 'CSV' | 'PARQUET' | 'JSONL' }

Specifies the format of the referenced file. If the file extension in the path ends with `.csv`, `.tsv`, `.parquet`, `.parq`, `.jsonl`, `.ldjson`, or `.ndjson`, the `FORMAT` option doesn't need to be specified. 

> [!NOTE]
> The `OPENROWSET` function can read only **newline-delimited** JSON format. This feature is currently in preview.
> The newline character must be used as a separator between JSON documents, and cannot be placed in the middle of a JSON document.

For example:

```sql
SELECT *
FROM OPENROWSET(
    BULK 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/bing_covid-19_data/latest/bing_covid-19_data.parquet'
);
```

If the file path doesn't end with one of these extensions, you need to specify a `FORMAT`, for example:

```sql
SELECT TOP 10 *
FROM OPENROWSET(
      BULK 'abfss://nyctlc@azureopendatastorage.blob.core.windows.net/yellow/**',
      FORMAT='PARQUET'
)
```

#### ROWS_PER_BATCH = *rows_per_batch*

Specifies the approximate number of rows of data in the data file. This value is an estimate, and should be an approximation (within one order of magnitude) of the actual number of rows. By default, `ROWS_PER_BATCH` is estimated based on file characteristics (number of files, file sizes, size of the returned data types). Specifying `ROWS_PER_BATCH = 0` is the same as omitting `ROWS_PER_BATCH`.

For example:

```sql
SELECT TOP 10 *
FROM OPENROWSET(
    BULK 'abfss://public@pandemicdatalake.dfs.core.windows.net/curated/covid-19/bing_covid-19_data/latest/bing_covid-19_data.parquet',
    ROWS_PER_BATCH = 100000
);
```

### Text/CSV encoding options

#### DATAFILETYPE = { 'char' | 'widechar' }

Specifies that `OPENROWSET(BULK)` should read single-byte(ASCII, UTF8) or multi-byte (UTF16) file content.

|DATAFILETYPE value|All data represented in:|
|------------------------|------------------------------|
| **char** (default) |Character format.<br /><br />For more information, see [Use Character Format to Import or Export Data](../../relational-databases/import-export/use-character-format-to-import-or-export-data-sql-server.md).|
| **widechar** |Unicode characters.<br /><br />For more information, see [Use Unicode Character Format to Import or Export Data](../../relational-databases/import-export/use-unicode-character-format-to-import-or-export-data-sql-server.md).|

#### CODEPAGE = { 'ACP' | 'OEM' | 'RAW' | '*code_page*' }

Specifies the code page of the data in the data file. `CODEPAGE` is relevant only if the data contains **char**, **varchar**, or **text** columns with character values more than 127 or less than 32.

| CODEPAGE value | Description |
| --- | --- |
| `ACP` | Converts columns of **char**, **varchar**, or **text** data type from the ANSI/[!INCLUDE [msCoName](../../includes/msconame-md.md)] Windows code page (ISO 1252) to the [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] code page. |
| `OEM` (default) | Converts columns of **char**, **varchar**, or **text** data type from the system OEM code page to the [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)] code page. |
| `RAW` | No conversion occurs from one code page to another. This is the fastest option. |
| `code_page` | Indicates the source code page on which the character data in the data file is encoded; for example, 850.<br /><br />**Important** Versions before [!INCLUDE [sssql16-md](../../includes/sssql16-md.md)] don't support code page 65001 (UTF-8 encoding). |

### Text/CSV formatting options

#### ROWTERMINATOR = '*row_terminator*'

Specifies the row terminator to be used for **char** and **widechar** data files. The default row terminator is `\r\n` (newline character). For more information, see [Specify field and row terminators](../../relational-databases/import-export/specify-field-and-row-terminators-sql-server.md).

#### FIELDTERMINATOR = '*field_terminator*'

Specifies the field terminator to be used for **char** and **widechar** data files. The default field terminator is `,` (comma). For more information, see [Specify Field and Row Terminators](../../relational-databases/import-export/specify-field-and-row-terminators-sql-server.md?view=fabric&preserve-view=true).

For example, to read tab-delimited data from a file:

```sql
SELECT *
FROM OPENROWSET(
    BULK '{file path}',
    ROWTERMINATOR = '\t'
);
```

#### FIELDQUOTE = '*field_quote*'

Specifies a character that is used as the quote character in the CSV file. If not specified, the quote character (`"`) is used as the quote character as defined in the [RFC 4180](https://datatracker.ietf.org/doc/html/rfc4180) standard. The `FIELDTERMINATOR` character (for example, a comma) can be placed within the field quotes and it will be considered as a regular character in the cell wrapped with the `FIELDQUOTE` characters. 

For example, use `FIELDQUOTE = '"'` on the following comma-separated value (CSV) dataset, with commas in an address field. The address field's values will be retained as a single value, not split into multiple values by the commas within the `"` (quote) characters.

```sql
SELECT *
FROM OPENROWSET(
    BULK '{file path}',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ','
);
```

```csv
Empire State Building,40.748817,-73.985428,"20 W 34th St, New York, NY 10118","\icons\sol.png"
Statue of Liberty,40.689247,-74.044502,"Liberty Island, New York, NY 10004","\icons\sol.png"
```

#### PARSER_VERSION = 'parser_version'

Specifies parser version to be used when reading files. Currently supported CSV parser versions are 1.0 and 2.0:

- PARSER_VERSION = '1.0'
- PARSER_VERSION = '2.0'

CSV parser version 1.0 is default and feature rich. Version 2.0 is built for performance and doesn't support all options and encodings. 

CSV parser version 1.0 specifics:

- Following options aren't supported: HEADER_ROW.
- Default terminators are `\r\n`, `\n` and `\r`. 
- If you specify `\n` (newline) as the row terminator, it will be automatically prefixed with a `\r` (carriage return) character, which results in a row terminator of `\r\n`.

CSV parser version 2.0 specifics:

- Not all data types are supported.
- Maximum character column length is 8000.
- Maximum row size limit is 8 MB.
- Following options aren't supported: `DATA_COMPRESSION`.
- Quoted empty string ("") is interpreted as empty string.
- DATEFORMAT SET option isn't honored.
- Supported format for **date** data type: `YYYY-MM-DD`
- Supported format for **time** data type: `HH:MM:SS[.fractional seconds]`
- Supported format for **datetime2** data type: `YYYY-MM-DD HH:MM:SS[.fractional seconds]`
- Default terminators are `\r\n` and `\n`.

#### ESCAPE_CHAR = 'char'

Specifies the character in the file that is used to escape itself and all delimiter values in the file. If the escape character is followed by a value other than itself, or any of the delimiter values, the escape character is dropped when reading the value. 

The `ESCAPECHAR` parameter will be applied regardless of whether the `FIELDQUOTE` is or isn't enabled. It won't be used to escape the quoting character. The quoting character must be escaped with another quoting character. The quoting character can appear within column value only if value is encapsulated with quoting characters.

In the following example, comma (`,`) and backslash (`\`) are escaped and represented as `\,` and `\\`:

```sql
SELECT *
FROM OPENROWSET(
    BULK '{file path}',
    ESCAPECHAR = '\'
);
```

```csv
Place,Address,Icon
Empire State Building,20 W 34th St\, New York\, NY 10118,\\icons\\sol.png
Statue of Liberty,Liberty Island\, New York\, NY 10004,\\icons\\sol.png
```

#### HEADER_ROW = { TRUE | FALSE }

Specifies whether a CSV file contains header row. Default is `FALSE`. Supported in `PARSER_VERSION='2.0'`. If `TRUE`, the column names will be read from the first row according to `FIRSTROW` argument. If `TRUE` and schema is specified using `WITH`, binding of column names will be done by column name, not ordinal positions.

Specifies whether a CSV file contains header row that should not be returned with other data rows. Default is `FALSE`. Supported in `PARSER_VERSION='2.0'`. If `TRUE`, the column names will be read from the first row according to `FIRSTROW` argument. If `TRUE` and schema is specified using `WITH`, binding of column names will be done by column name, not ordinal positions.

```sql
SELECT *
FROM OPENROWSET(
    BULK '{file path}',
    HEADER_ROW = TRUE
);
```

```csv
Place,Latitude,Longitude,Address,Area,State,Zipcode
Empire State Building,40.748817,-73.985428,20 W 34th St,New York,NY,10118
Statue of Liberty,40.689247,-74.044502,Liberty Island,New York,NY,10004
```

#### FIRSTROW = *first_row*

Specifies the number of the first row to load. The default is 1. This indicates the first row in the specified data file. The row numbers are determined by counting the row terminators. `FIRSTROW` is 1-based.

#### LASTROW = *last_row*

Specifies the number of the last row to load. The default is 0. This indicates the last row in the specified data file.

### Execution options

#### ROWS_PER_BATCH = *rows_per_batch*

Specifies the approximate number of rows of data in the data file. This value should be of the same order as the actual number of rows.

By default, `ROWS_PER_BATCH` is estimated based on file characteristics (number of files, file sizes, size of the returned data types). Specifying `ROWS_PER_BATCH = 0` is the same as omitting `ROWS_PER_BATCH`.

### WITH Schema

The `WITH` schema specifies the columns that define the result set of the `OPENROWSET` function. It includes column definitions for every column that will be returned as a result and outlines the mapping rules that bind the underlying file columns to the columns in the result set.

In the following example:

- The `country_region` column has **varchar(50)** type and referencing the underlying column with the same name
- The `date` column is referencing a CSV/Parquet column or JSONL property with a different physical name
- The `cases` column is referencing the third column in the file
- The `fatal_cases` column is referencing a nested Parquet property or JSONL sub-object

```sql
SELECT *
FROM OPENROWSET(<...>) 
WITH (
        country_region varchar(50), --> country_region column has varchar(50) type and referencing the underlying column with the same name
        [date] DATE '$.updated',   --> date is referencing a CSV/Parquet column or JSONL property with a different physical name
        cases INT 3,             --> cases is referencing third column in the file
        fatal_cases INT '$.statistics.deaths'  --> fatal_cases is referencing a nested Parquet property or JSONL sub-object
     );
```

#### <column_name>

The name of the column that will be returned in the result rowset. The data for this column is read from the underlying file column with the same name, unless overridden by `<column_path>` or `<column_ordinal>`. The name of the column must follow the [rules for column name identifiers](../../relational-databases/databases/database-identifiers.md?view=fabric&preserve-view=true#rules-for-regular-identifiers).

#### <column_type>

The T-SQL type of the column in the result set. The values from the underlying file are converted to this type when `OPENROWSET` returns the results. For more information, see [Data types in Fabric Warehouse](/fabric/data-warehouse/data-types#data-types-in-warehouse).

#### <column_path>

A dot-separated path (for example `$.description.location.lat`) used to reference nested fields in complex types like Parquet.

#### <column_ordinal>

A number representing the physical index of the column that will be mapped to the column in the `WITH` clause.

## Remarks

The supported features are summarized in the table:

| Feature           | Supported | Not available |
|-------------------|-----------|----------------------|
| **File formats**  | Parquet, CSV, JSONL (preview) | Delta, Azure Cosmos DB, JSON, relational databases |
| **Authentication**| EntraID/SPN passthrough, public storage | SAS/SAK, SPN, Managed access |
| **Storage**       | Azure Blob Storage, Azure Data Lake Storage | Fabric OneLake |
| **Options**       | Only full/absolute URI in `OPENROWSET`  | Relative URI path in `OPENROWSET`, `DATA_SOURCE` |
| **Partitioning**  | You can use the `filepath()` function in a query. |  |

## Examples

### A. Read a parquet file from Azure Blob Storage

In the following example you can see how to read 100 rows from a Parquet file:

```sql
SELECT TOP 100 * 
FROM OPENROWSET(
    BULK 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/bing_covid-19_data/latest/bing_covid-19_data.parquet'
);
```

### B. Read a custom CSV file

In the following example you can see how to read rows from a CSV file with a header row and explicitly specified terminator characters that are separating rows and fields:

```sql
SELECT *
FROM OPENROWSET(
BULK 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/bing_covid-19_data/latest/bing_covid-19_data.csv',
 HEADER_ROW = TRUE,
 ROW_TERMINATOR = '\n',
 FIELD_TERMINATOR = ',');
```

### C. Specify the file column schema while reading a file

In the following example you can see how to explicitly specify the schema of row that will be returned as a result of the `OPENROWSET` function:

```sql
SELECT *
FROM OPENROWSET(
BULK 'https://pandemicdatalake.blob.core.windows.net/public/curated/covid-19/bing_covid-19_data/latest/bing_covid-19_data.parquet') 
WITH (
        updated DATE
        ,confirmed INT
        ,deaths INT
        ,iso2 VARCHAR(8000)
        ,iso3 VARCHAR(8000)
        );
```

<a id="reading-partitioned-data-sets"></a>

### D. Read partitioned data sets

In the following example you can see how to use the `filepath()` function to read the parts of URI from the matched file path:

```sql
SELECT TOP 10 
  files.filepath(2) AS area
, files.*
FROM OPENROWSET(
BULK 'https://synapseaisolutionsa.blob.core.windows.net/public/NYC_Property_Sales_Dataset/*_*.csv',
 HEADER_ROW = TRUE) 
AS files
WHERE files.filepath(1) = '2009';
```

### E. Specify the file column schema while reading a JSONL file

In the following example, you can see how to explicitly specify the schema of row that will be returned as a result of the `OPENROWSET` function:

```sql
SELECT TOP 10 *
FROM OPENROWSET(
BULK 'https://pandemicdatalake.dfs.core.windows.net/public/curated/covid-19/bing_covid-19_data/latest/bing_covid-19_data.jsonl') 
WITH (
        country_region varchar(50),
        date DATE '$.updated',
        cases INT '$.confirmed',
        fatal_cases INT '$.deaths'
     );
```

If a column name doesn't match the physical name of a column in the properties if the JSONL file, you can specify the physical name in JSON path after the type definition. You can use multiple properties. For example, `$.location.latitude` to reference the nested properties in parquet complex types or JSON sub-objects.

## Related content

- [Specify field and row terminators (SQL Server)](../../relational-databases/import-export/specify-field-and-row-terminators-sql-server.md)

::: moniker-end
