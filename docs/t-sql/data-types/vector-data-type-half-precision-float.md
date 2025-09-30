---
title: "Vector Data Type - Half Precision Float"
description: Introduces dimension type of half-precision floating point for vector data type.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: damauri, pookam, mikeray, randolphwest
ms.date: 09/16/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: quickstart
ms.collection:
  - ce-skilling-ai-copilot
ms.update-cycle: 180-days
ms.custom:
  - build-2025
f1_keywords:
  - "VECTOR"
  - "VECTOR_TSQL"
helpviewer_keywords:
  - "VECTOR data type"
  - "vector, data type"
dev_langs:
  - "TSQL"
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17"
---

# Half-precision float support in vector data type

[!INCLUDE [sqlserver2025](../../includes/applies-to-version/sqlserver2025.md)]

Beginning with [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)], you can specify the underlying base type for the **vector** data type. By default, **vector** uses `float32` as its base type. `float16` (half-precision) is an alternate type for scenarios where reduced precision is acceptable. It offers a more compact alternative by reducing storage and improving performance.

A half-precision floating point vector is an array or collection of numbers, where each number is represented using a 16-bit half-precision (`float16`) floating-point format. This representation consumes half the memory of a standard 32-bit single-precision float. Use these vector types to save memory and bandwidth, especially in deep learning and vector databases, by trading off some precision for efficiency.

While `float16` offers significant storage and performance advantages, it provides reduced numerical precision compared to `float32`. This tradeoff makes it well-suited for approximate similarity scenarios, such as semantic search, but less appropriate for workloads that require high-precision arithmetic or exact numerical fidelity.

## Key benefits of float16 support

- **Increased dimensionality support**

  SQL Server supports vectors with up to **3,996 dimensions** (`1998 × 2`) when using `float16`. This feature doubles the limitation 1,998 dimensions for `float32`. This capability enables more expressive embeddings and compatibility with larger models, for example `text-embedding-large`.

- **Reduced storage and memory footprint**

  Storing vectors in a 16-bit format significantly decreases the amount of storage required compared to full-precision vectors. This makes it feasible to store and query high-dimensional vectors at scale. This optimization also improves data density, which can enhance query performance in vector search scenarios.

- **Storage efficiency and precision control**

  Choose the most appropriate base type:

  - `float16` for compact Storage
  - `float32` for general use and higher precision tasks

  This flexibility ensures optimal resource usage without compromising application accuracy.

## Sample syntax

The usage syntax is similar to **vector** data type. However, to use `float16`, specify the base type explicitly.

```syntaxsql
column_name VECTOR(<dimensions> [, <base_type>]) [NOT NULL | NULL]
```

### Feature availability

`float16` vector is currently available for preview. To test, enable the `PREVIEW_FEATURES` database scoped configuration option. For details, review [PREVIEW_FEATURES = { ON | OFF }](../statements/alter-database-scoped-configuration-transact-sql.md#preview_features---on--off-).

```sql
ALTER DATABASE SCOPED CONFIGURATION SET PREVIEW_FEATURES = ON;
GO
```

## Examples

Define a **vector** column in a `CREATE TABLE` statement using either the default base type or an explicit one.

By default, the base type is `float32`.

```sql
-- Default: float32
CREATE TABLE ExampleTable
(
    id INT PRIMARY KEY,
    VectorColumn VECTOR (3)
);
```

To use **half-precision**, specify `float16` explicitly.

```sql
-- Explicit float16
CREATE TABLE ExampleTable (
    id INT PRIMARY KEY,
    VectorColumn VECTOR(3, float16)
);
```

The following example creates a table with a half precision float vector column and inserts data into it.

```sql
-- Step 0: Enable Preview Features
ALTER DATABASE SCOPED CONFIGURATION
SET PREVIEW_FEATURES = ON;
GO

-- Step 1: Create a Table with a VECTOR(5, float16) Column
CREATE TABLE dbo.Articles
(
    id INT PRIMARY KEY,
    title NVARCHAR(100),
    content NVARCHAR(MAX),
    embedding VECTOR(5, float16)
);

-- Step 2: Insert Sample Data
INSERT INTO Articles (id, title, content, embedding)
VALUES
    (1, 'Intro to AI', 'This article introduces AI concepts.', '[0.1, 0.2, 0.3, 0.4, 0.5]'),
    (2, 'Deep Learning', 'Deep learning is a subset of ML.', '[0.2, 0.1, 0.4, 0.3, 0.6]'),
    (3, 'Neural Networks', 'Neural networks are powerful models.', '[0.3, 0.3, 0.2, 0.5, 0.1]'),
    (4, 'Machine Learning Basics', 'ML basics for beginners.', '[0.4, 0.5, 0.1, 0.2, 0.3]'),
    (5, 'Advanced AI', 'Exploring advanced AI techniques.', '[0.5, 0.4, 0.6, 0.1, 0.2]');

-- Step 3: Perform a Vector Similarity Search Using VECTOR_DISTANCE function
DECLARE @v VECTOR(5, float16) = '[0.3, 0.3, 0.3, 0.3, 0.3]';

SELECT TOP (3)
    id,
    title,
    VECTOR_DISTANCE('cosine', @v, embedding) AS distance
FROM dbo.Articles
ORDER BY distance;

-- Step 4: Optionally Create a Vector Index
CREATE VECTOR INDEX vec_idx ON Articles(embedding)
WITH (
    metric = 'cosine',
    type = 'diskANN'
);

-- Step 5: Perform a Vector Similarity Search
DECLARE @qv VECTOR(5, float16) = '[0.3, 0.3, 0.3, 0.3, 0.3]';

SELECT
    t.id,
    t.title,
    t.content,
    s.distance
FROM
VECTOR_SEARCH(
    table = Articles AS t,
    column = embedding,
    similar_to = @qv,
    metric = 'cosine',
    top_n = 3
) AS s
ORDER BY s.distance, t.title;
```

## Inspect vector base type metadata

The following query confirms actual base type and dimensions of a **vector** column:

```sql
--Inspect Vector Base type Metadata in sys.columns
SELECT name AS column_name,
    system_type_id,
    user_type_id,
    vector_dimensions,
    vector_base_type,
    vector_base_type_desc
FROM sys.columns
WHERE object_id = OBJECT_ID('dbo.Articles');
```

Output columns:

- `vector_dimensions`: Number of dimensions defined for the vector.

- `vector_base_type`: Internal numeric code for the base type:
  - `0` = `float32`
  - `1` = `float16`

- `vector_base_type_desc`: Human-readable description of the base type.

## Supported implicit & explicit conversion

SQL Server supports both *implicit* and *explicit* conversion from **varchar**, **nvarchar**, and **json** strings to `VECTOR(<dimension_count>, float16)`, as long as the vector is declared with an explicit dimension count.

```sql
DECLARE @j JSON = '[1.0, 2.0, 3.0]';
DECLARE @v VECTOR(3, float16);
SET @v = CAST(@j AS VECTOR(3, float16)); -- Explicit conversion from JSON to float16

DECLARE @v1 VARCHAR(50) = '[1.0, 2.0, 3.0]';
DECLARE @v2 VECTOR(3, float16);
SET @v2 = CAST(@v1 AS VECTOR(3, float16)); -- Explicit conversion from VARCHAR to float16

DECLARE @v1 NVARCHAR(50) = N'[1.0, 2.0, 3.0]';
DECLARE @v2 VECTOR(3, float16);
SET @v2 = CAST(@v1 AS VECTOR(3, float16)); -- Explicit conversion from NVARCHAR to float16
```

Implicit Conversion is supported only when the target **vector** type is fully declared.

```sql
-- Implicit conversion from VARCHAR to float16
DECLARE @v1 VARCHAR(50) = '[1.0, 2.0, 3.0]';
DECLARE @v2 VECTOR(3, float16);
SET @v2 = @v1;

-- Implicit conversion from NVARCHAR to float16
DECLARE @v1 NVARCHAR(50) = N'[1.0, 2.0, 3.0]';
DECLARE @v2 VECTOR(3, float16);
SET @v2 = @v1

--From JSON_ARRAY to VECTOR
DECLARE @v3 VECTOR(3, float16) = JSON_ARRAY(1.0, 2.0, 3.0);
```

## Unsupported or error-prone scenarios

The following examples highlight common errors and limitations when working with half-precision float **vector** data type in SQL Server.

### Explicit and implicit conversion between base types float32 and float16

SQL Server currently does **not** support implicit conversion between `VECTOR(float32)` and `VECTOR(float16)`.

Additionally, *explicit conversion* using `CAST` or `CONVERT` is currently *blocked*.

```sql
DECLARE @v1 VECTOR(3, float16);
DECLARE @v2 VECTOR(3, float32) = '[1.0, 2.0, 3.0]';
SET @v1 = CAST(@v2 AS VECTOR(3, float16)); -- Explicit conversion from float32 to float16
-- ❌ Error: Msg 42238, Level 16, State 1, Line 61
Conversion of vector from data type float32 to float16 is not allowed.
```

### Dimension mismatch
Conversion between vectors with mismatched dimensions isn't allowed and raises a dimension mismatch error.

```sql
DECLARE @v1 VECTOR(3, float16) = '[1.0, 2.0, 3.0]';
DECLARE @v2 VECTOR(4, float16) = NULL;
SET @v1 = @v2;
-- Error: Msg 42204, Level 16, State 1, Line 10
The vector dimensions 4 and 3 do not match
```

### Null handling

If a vector is declared without a dimension count, assigning a value to it raises an error.

```sql
DECLARE @v1 VECTOR(3, float16) = NULL;
DECLARE @v2 VECTOR(3, float16) = '[1.0, 2.0, 3.0]';
SET @v1 = @v2; -- This works

--However, if the dimension count is not specified, it raises an error
DECLARE @v1 VECTOR(float16) = NULL;
DECLARE @v2 VECTOR(3, float16) = '[1.0, 2.0, 3.0]';
SET @v1 = @v2;
```

### Out-of-range values

Out-of-range values for `float16` (for example, above 65504.0) raise an error during assignment.

```sql
DECLARE @v VECTOR(3, float16) = '[1.0, 2.0, 70000.0]';
-- Error: Input JSON contains out-of-range values for float16
```

### Mixed base types in functions

Mixed base types in functions like `VECTOR_DISTANCE` aren't supported and raises a type error.

```sql
DECLARE @v1 VECTOR(3, float32) = '[1.0, 2.0, 3.0]';
DECLARE @v2 VECTOR(3, float16) = '[1, 2, 3]';
SELECT VECTOR_DISTANCE('euclidean', @v1, @v2);
-- Error: VECTOR_DISTANCE does not support different base types
```

### Unsupported architecture

`float16` isn't supported on Arm64 architectures, and using it raises a runtime error

```sql
DECLARE @v1 VECTOR(3, float16) = '[1.0, 2.0, 3.0]';
DECLARE @v2 VECTOR(3, int) = '[1, 2, 3]';
SELECT VECTOR_DISTANCE('euclidean', @v1, @v2);
-- Error: float16 is not supported on ARM64 architecture
```

### SIMD overflow

SIMD-based operations (for example, AVX2, SSE4.2) might produce overflow errors if values exceed representable ranges.

```sql
DECLARE @v AS VECTOR (8) = '[-2.9e+38, ..., 2.9e+38]';

SELECT VECTOR_NORM(@v, 'norm1');
-- Behavior depends on ARITHABORT setting:
--     ARITHABORT ON  → Error
--     ARITHABORT OFF → NULL
```

### Tools support

SQL Server Management Studio (SSMS) doesn't currently distinguish between `float32` and `float16` in the UI. Use `sys.columns` to confirm the actual base type used in a schema.

### Binary transport support for float16 vectors not yet available

`float16` vectors are currently transmitted as **varchar(max)** (JSON array) over TDS. Binary transport support for `float16` isn't yet available in drivers like ODBC, JDBC, and .NET.

> [!NOTE]  
> All limitations that apply to the default **vector** type (with `float32`) also apply to `VECTOR(float16)`.

## Related content

- [Overview of vector search and vector indexes in the SQL Database Engine](../../sql-server/ai/vectors.md)
- [Intelligent applications](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications#vector-search)
