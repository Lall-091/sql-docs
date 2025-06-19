---
title: "Vector Data Type"
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

# Vector data type

[!INCLUDE [sqlserver2025-asdb-asmi-fabricsqldb](../../includes/applies-to-version/sqlserver2025-asdb-asmi-fabricsqldb.md)]

The **vector** data type is designed to store vector data optimized for operations such as similarity search and machine learning applications. Vectors are stored in an optimized binary format but are exposed as JSON arrays for convenience. Each element of the vector is stored as a single-precision (4-byte) floating-point value.

To provide a familiar experience for developers, the **vector** data type is created and displayed as a JSON array. For example, a vector with three dimensions can be represented as `'[0.1, 2, 30]'`. Implicit and explicit conversion from and to the **vector** type can be done using **varchar**, **nvarchar** and **json** types. 

> [!NOTE]
>
> For limitations, review [Limitations](#limitations) and [Known issues](#known-issues).
>
> Vector features are available in Azure SQL Managed Instance configured with the [Always-up-to-date](/azure/azure-sql/managed-instance/update-policy#always-up-to-date-update-policy) policy.

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
(2, '[-100.2, 0.123, 9.876]'),
(3, JSON_ARRAY(1.0, 2.0, 3.0)); -- Using JSON_ARRAY to create a vector

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

## Conversions

 
- The **vector** type can't be used with the **sql_variant** type or assigned to a **sql_variant** variable or column. This restriction is similar to **varchar(max)**, **varbinary(max)**, **nvarchar(max)**, **xml**, **json**, and CLR-based data types.

## Compatibility

### Enhancements to TDS Protocol

SQL Server stores vectors in an optimized binary format but exposes them as JSON arrays for convenience.
**Supported** drivers use enhancements to the TDS protocol to transmit vector data more efficiently in binary format and present them to applications as native vector types. This approach reduces payload size, eliminates the overhead of JSON parsing, and preserves full floating-point precision. As a result, it improves both performance and accuracy when working with high-dimensional vectors in AI and machine learning scenarios.

#### Native Driver Support

Applications using **TDS version 7.4 or higher** and updated drivers can natively read, write, stream, and bulk copy vector data.

These capabilities require versions of the drivers listed below. Ensure you're using the correct version to enable native vector support.

- **Microsoft.Data.SqlClient**: Version **6.1.0** introduces the `SqlVector` type, extending `System.Data.SqlDbTypes`.
- **Microsoft JDBC Driver for SQL Server**: Version **13.1.0 Preview** introduces the `microsoft.sql.Types.VECTOR` type and `microsoft.sql.Vector` class.

> [!NOTE]
> For clients that don't support the updated TDS protocol, SQL Server continues to expose vector data as **varchar(max)** types to ensure backward compatibility. Client applications can work with vector data as if it were a JSON array. The SQL Database Engine automatically converts vectors to and from a JSON array, making the new type transparent for the client. Hence drivers and all languages are automatically compatible with the new type.

You can start using the new **vector** type right away. The following examples show different languages and driver configurations.

### [.NET](#tab/csharp)

> [!IMPORTANT]
> Requires **Microsoft.Data.SqlClient 6.1.0** or later for native vector support.

```csharp
static void InsertNonNullVal(SqlConnection conn)
{
    Console.WriteLine("Inserting non-null value with SqlDbType");

    using SqlCommand command = new SqlCommand("INSERT INTO dbo.vectors VALUES (@Id, @VectorData)", conn);

    command.Parameters.AddWithValue("@Id", 1);

    var vectorParameter = new SqlParameter("@VectorData", Microsoft.Data.SqlDbTypeExtensions.Vector);
    vectorParameter.Value = new Microsoft.Data.SqlTypes.SqlVectorFloat32(new float[] { 3.14159f, 1.61803f, 1.41421f });
    command.Parameters.Add(vectorParameter);

    command.ExecuteNonQuery();
}

static void ReadWithGetValue(SqlConnection connection)
{
    Console.WriteLine("Reading values using GetValue method:");

    using (SqlCommand commandSourceData = new SqlCommand("SELECT v FROM dbo.vectors;", connection))
    using (SqlDataReader reader = commandSourceData.ExecuteReader())
    while (reader.Read())
    {
        var vector = reader.GetValue(0);        
        if (vector != null && vector != DBNull.Value)
        {
            Console.WriteLine("Type: " + vector.GetType() + " Element Count: " + ((SqlVectorFloat32)vector).Length);

            var values = ((SqlVectorFloat32)vector).Values;
            Console.WriteLine("Values: " + string.Join(", ", values));
        }              
    }
}
```

> [!NOTE]
> If you're not using the latest .NET drivers, you can still work with vector data in **C#** by serializing and deserializing it as a JSON string using the `JsonSerializer` class. This ensures compatibility with the `varchar(max)` representation of vectors exposed by SQL Server for older clients.

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

### [JDBC](#tab/jdbc)

> [!IMPORTANT]
> Requires **Microsoft JDBC Driver for SQL Server 13.1.0 Preview or later** for native vector type support.

Example of Insertion of **vector** data into table

```java
@Test
public void getVectorData() throws SQLException {
    String query = "SELECT v FROM " + AbstractSQLGenerator.escapeIdentifier(tableName);
    try (PreparedStatement stmt = connection.prepareStatement(query)) {
        try (ResultSet rs = stmt.executeQuery()) {
            assertTrue(rs.next(), "No result found for inserted vector.");
            ResultSetMetaData meta = rs.getMetaData();
            int columnCount = meta.getColumnCount();

            while (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = meta.getColumnName(i);
                    int columnType = meta.getColumnType(i); // from java.sql.Types

                    Object value = null;
                    switch (columnType) {
                        case Types.VARCHAR:
                        case Types.NVARCHAR:
                            value = rs.getString(i);
                            break;
                        case microsoft.sql.Types.VECTOR:
                            value = rs.getObject(i, microsoft.sql.Vector.class);
                    }

                    System.out.println(columnName + " = " + value + " (type: " + columnType + ")");
                }
                System.out.println("---");
            }
        }
    }
}
```
  
### [Python (mssql-python)](#tab/python)

With Python, applications can write and read vector data using `json.loads` and `json.dumps`:
This sample is using Python with the latest [Microsoft official Python driver for SQL Server](https://github.com/microsoft/mssql-python/wiki). Applications can write and read vector data using `json.loads` and `json.dumps`:

```python
import json
import os, json
import mssql_python

connection_string = os.environ["MSSQL"]
conn = mssql_python.connect(connection_string)

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


### [Python (PyODBC)](#tab/python-sample-pyodbc)

This sample is using Python with popular [PyODBC](https://github.com/mkleehammer/pyodbc/wiki) driver from the community. Applications can write and read vector data using `json.loads` and `json.dumps`:

```python
import os, json
from utilities import get_conn

conn = get_conn()
conn = get_conn(os.environ["MSSQL"])

cursor = conn.cursor()
query = "INSERT INTO dbo.vectors VALUES(100, ?)"
cursor.execute(query, json.dumps([1,2,3]))
cursor.commit()
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

- [SQL Server Management Studio](https://aka.ms/ssms) version 21 and later versions
- [DacFX and SqlPackage](../../tools/sqlpackage/release-notes-sqlpackage.md) version 162.5 (November 2024) and later versions
- The [SQL Server extension for Visual Studio Code](../../tools/visual-studio-code-extensions/mssql/mssql-extension-visual-studio-code.md) version 1.32 (May 2025) and later versions
- [Microsoft.Build.Sql](../../tools/sql-database-projects/sql-database-projects.md) version 1.0.0 (March 2025) and later versions
- [SQL Server Data Tools (Visual Studio 2022)](https://visualstudio.microsoft.com/downloads/) version 17.13 and later versions

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

### Indexes

- B-tree indexes or columnstore indexes aren't allowed on **vector** columns. However, a **vector** column can be specified as an included column in an index definition.

### Table schema metadata

- [sp_describe_first_result_set](../../relational-databases/system-stored-procedures/sp-describe-first-result-set-transact-sql.md) system stored procedure doesn't correctly return the **vector** data type. Therefore, many data access clients and driver see a **varchar** or **nvarchar** data type.

### Ledger tables

- Stored procedure `sp_verify_database_ledger` generates an error if the database contains a table with a **vector** column.

### User-defined types

- Creation of alias type using `CREATE TYPE` for the **vector** type isn't allowed, similar to the behavior of the **xml** and **json** data types.

### Always Encrypted

- **vector** type isn't supported with Always Encrypted feature.

## Known issues

- Data Masking currently shows **vector** data as **varbinary** data type in the Azure portal.

## Related content

- [Overview of vectors in the SQL Database Engine](../../relational-databases/vectors/vectors-sql-server.md)
- [Intelligent applications](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications?view=azuresql&preserve-view=true#vector-search)
- [Vector Functions](../functions/vector-functions-transact-sql.md)