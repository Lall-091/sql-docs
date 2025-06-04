---
title: "Vector Data Type (Preview)"
description: The vector data type stores vector data optimized for machine learning applications and similarity search operations.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: damauri, pookam
ms.date: 05/01/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: quickstart
ms.collection:
  - ce-skilling-ai-copilot
f1_keywords:
  - "VECTOR"
  - "VECTOR_TSQL"
helpviewer_keywords:
  - "VECTOR data type"
  - "vector, data type"
dev_langs:
  - "TSQL"
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17 || =azuresqldb-current || =fabric || =azuresqldb-mi-current"
ms.custom:
  - build-2025
---

# Vector data type (preview)

[!INCLUDE [sqlserver2025-asdb-asmi-fabricsqldb](../../includes/applies-to-version/sqlserver2025-asdb-asmi-fabricsqldb.md)]

The **vector** data type is designed to store vector data optimized for operations such as similarity search and machine learning applications. Vectors are stored in an optimized binary format but are exposed as JSON arrays for convenience. Each element of the vector is stored as a single-precision (4-byte) floating-point value.

> [!NOTE]
> - This data type is in preview and is subject to change. Make sure to read preview usage terms in [Service Level Agreements (SLA) for Online Services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services). For limitations of the current preview, see [Limitations](#limitations) and [Known issues](#known-issues).
> - Vector features are available in Azure SQL Managed Instance configured with the [Always-up-to-date](/azure/azure-sql/managed-instance/update-policy#always-up-to-date-update-policy) policy. 

For more information on working with vector data, see:

- [Overview of vectors in the SQL Database Engine](../../relational-databases/vectors/vectors-sql-server.md)
- [Intelligent applications](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications#vector-search)

## Sample syntax

The usage syntax for the **vector** type is similar to all other SQL Server data types in a table.

```syntaxsql
column_name VECTOR( {<dimensions>} ) [NOT NULL | NULL] 
```

#### Dimensions

A vector must have at least one dimension. The maximum number of dimensions supported is 1998.

## Examples

### A. Column definition

The **vector** type can be used in column definition contained in a `CREATE TABLE` statement, for example:

The following example creates a table with a vector column and inserts data into it.

```sql
CREATE TABLE dbo.vectors
(
  id INT PRIMARY KEY,
  v VECTOR(3) NOT NULL
);

INSERT INTO dbo.vectors (id, v) VALUES 
(1, '[0.1, 2, 30]'),
(2, '[-100.2, 0.123, 9.876]');

SELECT * FROM dbo.vectors;
```

### B. Usage in variables

The following example declares vectors using the new **vector** data type and calculates distances using the `VECTOR_DISTANCE` function.

The **vector** type can be used with variables:

```sql
DECLARE @v VECTOR(3) = '[0.1, 2, 30]';
SELECT @v;
```

### C. Usage in stored procedures or functions

The **vector** data type can be used as parameter in stored procedure or functions. For example:

```sql
CREATE PROCEDURE dbo.SampleStoredProcedure
@V VECTOR(3),
@V2 VECTOR(3) OUTPUT
AS
BEGIN
    SELECT @V;
    SET @V2 = @V;
END
```

## Feature availability

The new **vector** type is available under all database compatibility levels.

## Compatibility

To allow all clients to be able to operate on vector data, vectors are exposed as **varchar(max)** types. Client applications can work with vector data as if it was a JSON Array. The SQL Database Engine automatically converts vectors to and from a JSON array, making the new type transparent for the client. All drivers and all languages are automatically compatible with the new type.

You can start to use the new vector type right away. Here's some examples:

### [C#](#tab/csharp-sample)

With C#, vectors can be serialized and deserialized to and from string using the `JsonSerializer` class.

```csharp
using Microsoft.Data.SqlClient;
using Dapper;
using DotNetEnv;
using System.Text.Json;

namespace DotNetSqlClient;

class Program
{
    static void Main(string[] args)
    {
        Env.Load();

        var v1 = new float[] { 1.0f, 2.0f, 3.0f };

        using var conn = new SqlConnection(Env.GetString("MSSQL"));
        conn.Execute("INSERT INTO dbo.vectors VALUES(100, @v)", param: new {@v = JsonSerializer.Serialize(v1)});

        var r = conn.ExecuteScalar<string>("SELECT v FROM dbo.vectors") ?? "[]";
        var v2 = JsonSerializer.Deserialize<float[]>(r); 
        Console.WriteLine(JsonSerializer.Serialize(v2));          
    }
}
```

### [Python](#tab/python-sample)

With Python, applications can write and read vector data using `json.loads` and `json.dumps`:

```python
import json
from utilities import get_conn

conn = get_conn()

cursor = conn.cursor()
query = "INSERT INTO dbo.vectors VALUES(100, ?)"
cursor.execute(query, json.dumps([1,2,3]))
cursor.close()

cursor = conn.cursor()
query = "SELECT v FROM dbo.vectors"
cursor.execute(query)
rows = cursor.fetchall()
for row in rows:
    print(json.loads(row[0]))
cursor.close()

conn.close()
```

For more information on the `get_conn` function, see [Migrate a Python application to use passwordless connections with Azure SQL Database](/azure/azure-sql/database/azure-sql-passwordless-migration-python?view=azuresql&preserve-view=true&tabs=sign-in-azure-cli%2Cazure-portal-create%2Cazure-portal-assign%2Capp-service-identity#update-the-local-connection-configuration).

> [!WARNING]
> Make sure to add `LongAsMax=yes` in the connection string used with Python to send data using the **nvarchar(max)** type instead of the obsolete **ntext** to avoid any conversion error message, for example: "DataError: ('22018', '[22018] [Microsoft][ODBC Driver 17 for SQL Server][SQL Server]Operand type clash: ntext is incompatible with vector (206) (SQLExecDirectW)')". For more information, see [PyODBC - LongAsMax](https://github.com/mkleehammer/pyodbc/wiki/Connecting-to-SQL-Server-from-Windows#longasmax).

---

## Tools

The following tools support the **vector** data type:

- [SQL Server Management Studio](https://aka.ms/ssms) version 21 and later
- [DacFX and SqlPackage](../../tools/sqlpackage/release-notes-sqlpackage.md) version 162.5 (November 2024) and later
- [Microsoft.Build.Sql](../../tools/sql-database-projects/sql-database-projects.md) version 1.0.0 (March 2025) and later
- [SQL Server Data Tools (Visual Studio 2022)](https://visualstudio.microsoft.com/downloads/) version 17.13 and later
<!-- - The [mssql extension for Visual Studio Code](/sql/tools/visual-studio-code/mssql-extensions)   -->

## Limitations

The **vector** type has the following limitations:

### Tables

- Column-level constraints aren't supported, except for `NULL`/`NOT NULL` constraints.
  - `DEFAULT` and `CHECK` constraints aren't supported for **vector** columns.
  - Key constraints, such as `PRIMARY KEY` or `FOREIGN KEY`, aren't supported for **vector** columns. Equality, uniqueness, joins using vector columns as keys, and sort orders don't apply to **vector** data types.
  - There's no notion of uniqueness for vectors, so unique constraints aren't applicable.
  - Checking the range of values within a vector is also not applicable.
- Vectors don't support comparison, addition, subtraction, multiplication, division, concatenation, or any other mathematical, logical, and compound assignment operators.
- **vector** columns can't be used in memory-optimized tables.
- Altering **vector** columns using `ALTER TABLE ... ALTER COLUMN` to other data types isn't permitted.

### Table schema metadata

- [sp_describe_first_result_set](../../relational-databases/system-stored-procedures/sp-describe-first-result-set-transact-sql.md) system stored procedure doesn't correctly return the **vector** data type. Therefore, many data access clients and driver see a **varchar** or **nvarchar** data type.

### Conversions

- Implicit and explicit conversion using `CAST` or `CONVERT` from the **vector** type can be done to **varchar**, **nvarchar** and **json** types. Similarly, only **varchar**, **nvarchar** and **json** can be implicitly or explicitly converted to the **vector** type.
- The **vector** type can't be used with the **sql_variant** type or assigned to a **sql_variant** variable or column. This restriction similar to **varchar(max)**, **varbinary(max)**, **nvarchar(max)**, **xml**, **json**, and CLR-based data types.

### Indexes

- B-tree indexes or columnstore indexes aren't allowed on **vector** columns. However, a **vector** column can be specified as an included column in an index definition.

### User-defined types

- Creation of alias type using `CREATE TYPE` for the **vector** type isn't allowed, similar to the behavior of the **xml** and **json** data types.

### Ledger tables

- Stored procedure `sp_verify_database_ledger` generates an error if the database contains a table with a **vector** column.

### Always Encrypted

- **vector** type isn't supported with Always Encrypted feature.

## Known issues

In the ongoing preview there are the following known issues:

- Tools like SQL Server Management Studio, Azure Data Studio, or the mssql extension for VS Code currently might not be able to generate the script of a table that has a column using the **vector** data type.
- Tools like SQL Server Management Studio, Azure Data Studio, or the mssql extension for VS Code currently might report a data type of **varbinary** instead of **vector** for a column using the **vector** type.
- Import and Export via DacFx currently doesn't work if there's a table using **vector** type.
- Column encryption doesn't currently support the **vector** type.
- Data Masking currently shows **vector** data as **varbinary** data type in the portal.
- When passing a **vector** type to `LEN` and `DATALENGTH` error 8116 (Argument data type vector is invalid for argument 1 of function) is returned.

## Related content

- [Overview of vectors in the SQL Database Engine](../../relational-databases/vectors/vectors-sql-server.md)
- [Intelligent applications](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications?view=azuresql&preserve-view=true#vector-search)
- [Vector Functions](../functions/vector-functions-transact-sql.md)