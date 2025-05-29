---
title: "VECTOR_SEARCH (Transact-SQL)"
description: "VECTOR_SEARCH search for vectors similar to a given query vectors using an approximate nearest neighbors vector search algorithm."
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: damauri
ms.date: 05/01/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
f1_keywords:
  - "VECTOR_SEARCH"
  - "VECTOR_SEARCH_TSQL"
helpviewer_keywords:
  - "VECTOR_SEARCH function"
  - "vector, search"
dev_langs:
  - "TSQL"
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17"
---

# VECTOR_SEARCH (Transact-SQL) (Preview)

[!INCLUDE [SQL Server 2025](../../includes/applies-to-version/_ss2025.md)]

Search for vectors similar to a given query vectors using an approximate nearest neighbors vector search algorithm. To learn more about how vector indexing and vector search works, and the differences between exact and approximate search, refer to [Vectors in the SQL Database Engine](../../relational-databases/vectors/vectors-sql-server.md).

## Preview feature

> [!NOTE]
> This function is in preview and is subject to change. Make sure to read preview usage terms in [Service Level Agreements (SLA) for Online Services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

This feature is in preview. In order to use this feature, you must enable the following [trace flags](../database-console-commands/dbcc-traceon-transact-sql.md):

```sql
DBCC TRACEON(466, 474, 13981, -1)
```

Make sure to check out the [current limitations](#limitations) before using it.

## Syntax

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)  

```syntaxsql
VECTOR_SEARCH(
    TABLE = object [AS source_table_alias]
    , COLUMN = vector_column
    , SIMILAR_TO = query_vector
    , METRIC = { 'cosine' | 'dot' | 'euclidean' }
    , TOP_N = k
) [AS result_table_alias]
```  

## Arguments

### *TABLE = object [AS source_table_alias]*

Table on which perform the search. It must be a base table. Views, temporary tables, both local and global, are not supported.

### *COLUMN = vector_column*

The vector column in which search is performed. The column must be a [vector](../data-types/vector-data-type.md) data type.

### *SIMILAR_TO = query_vector*

The vector used for search. It must be a variable or a column of **vector** type.

### *METRIC = { 'cosine' | 'dot' | 'euclidean' }*

The distance metric used to calculate the distance between the query vector and the vectors in the specified column. An ANN (Approximate Nearest Neighbor) index is used only if a matching ANN index, with the same metric and on the same column, is found. If there are no compatible ANN indexes, a warning is raised and the KNN (k-Nearest Neighbor) algorithm is used.

### *TOP_N = \<k>*

The maximum number of similar vectors that must be returned. It must be a positive **integer**. 

### *result_table_alias*

The alias is used to reference the result set. 

## Return result set

The returned result set has all the columns from the table specified in TABLE argument, plus the extra `distance` column. The `distance` column contains the distance between the given vector in the COLUMN argument and the vector specified in SIMILAR_TO argument.

## Limitations

The current preview has the following limitations:

### Post-filtering only

Vector search happens before applying any predicate. Additional predicates are applied only after the most similar vectors are returned. The following sample returns the top 10 rows with embeddings most similar to the query vector `@qv`, then applies the predicate specified in the `WHERE` clause. If none of the 10 rows associated with the vectors returned by the vector search have the `accepted` column equal to 1, the result is empty. 

```sql
SELECT
  s.id, 
  s.title,
  r.distance
FROM
  VECTOR_SEARCH(
    TABLE = dbo.sessions AS s, 
    COLUMN = embedding, 
    SIMILAR_TO = @qv, 
    METRIC = 'cosine', 
    TOP_N = 10 
  ) AS r
WHERE
  accepted = 1
ORDER BY
  r.distance
```

### VECTOR_SEARCH cannot be used in views

`VECTOR_SEARCH` cannot be used in the body of a view.

## Examples

### Example 1

The following example finds the 10 most similar articles to the `Pink Floyd music style` in the `wikipedia_articles_embeddings` table.

```sql
DECLARE @qv VECTOR(1536) = AI_GENERATE_EMBEDDING(N'Pink Floyd music style' USE MODEL Ada2Embeddings);
SELECT 
    t.id, s.distance, t.title
FROM
    VECTOR_SEARCH(
        TABLE = [dbo].[wikipedia_articles_embeddings] as t, 
        COLUMN = [content_vector], 
        SIMILAR_TO = @qv, 
        METRIC = 'cosine', 
        TOP_N = 10
    ) AS s
ORDER BY s.distance
```

### Example 2

Same as example 1, but this time the query vectors are taking from another table instead of a variable.

```sql
CREATE TABLE #t (
  id INT, 
  q NVARCHAR(MAX),
  v VECTOR(1536)
);
INSERT INTO 
  #t
SELECT 
    id, q, ai_generate_embeddings(q USE MODEL Ada2Embeddings)
FROM
    (VALUES 
        (1, N'four legged furry animal'),
        (2, N'pink floyd music style')
    ) S(id, q)
;

SELECT 
    t.id, s.distance, t.title
FROM
    #t AS qv
CROSS APPLY
    VECTOR_SEARCH(
        TABLE = [dbo].[wikipedia_articles_embeddings] as t, 
        COLUMN = [content_vector], 
        SIMILAR_TO = qv.v, 
        METRIC = 'cosine', 
        TOP_N = 10
    ) AS s
WHERE
  qv.id = 2
ORDER BY 
  s.distance
```

### Example 3

A basic end-to-end example using `CREATE VECTOR INDEX` and the related `VECTOR_SEARCH` function. The embeddings are mocked. In a real world scenario, embeddings are generated using an embedding model and [AI_GENERATE_EMBEDDINGS](../functions/ai-generate-embeddings-transact-sql.md), or an external library such as [OpenAI SDK](https://github.com/openai/openai-dotnet?tab=readme-ov-file#how-to-generate-text-embeddings).

The following code block demonstrates the `VECTOR_SEARCH` function with mock embeddings:

1. Enables the trace flag, necessary in the current preview.
1. Create a sample table `dbo.Articles` with a column `embedding` with data type **vector(5)**.
1. Insert sample data with mock embedding data.
1. Create a vector index on `dbo.Articles.embedding`.
1. Demonstrate the vector similarity search with the `VECTOR_SEARCH` function.

```sql
-- Step 0: Enable Preview Feature
DBCC TRACEON(466, 474, 13981, -1);
GO

-- Step 1: Create a sample table with a VECTOR(5) column
CREATE TABLE dbo.Articles 
(
    id INT PRIMARY KEY,
    title NVARCHAR(100),
    content NVARCHAR(MAX),
    embedding VECTOR(5) -- mocked embeddings
);

-- Step 2: Insert sample data
INSERT INTO Articles (id, title, content, embedding)
VALUES
(1, 'Intro to AI', 'This article introduces AI concepts.', '[0.1, 0.2, 0.3, 0.4, 0.5]'),
(2, 'Deep Learning', 'Deep learning is a subset of ML.', '[0.2, 0.1, 0.4, 0.3, 0.6]'),
(3, 'Neural Networks', 'Neural networks are powerful models.', '[0.3, 0.3, 0.2, 0.5, 0.1]'),
(4, 'Machine Learning Basics', 'ML basics for beginners.', '[0.4, 0.5, 0.1, 0.2, 0.3]'),
(5, 'Advanced AI', 'Exploring advanced AI techniques.', '[0.5, 0.4, 0.6, 0.1, 0.2]');

-- Step 3: Create a vector index on the embedding column
CREATE VECTOR INDEX vec_idx ON Articles(embedding)
WITH (metric = 'cosine', type = 'diskann');

-- Step 4: Perform a vector similarity search
DECLARE @qv VECTOR(5) = '[0.3, 0.3, 0.3, 0.3, 0.3]';
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

## Related content

- [Overview of vectors in the SQL Database Engine](../../relational-databases/vectors/vectors-sql-server.md)
- [Vector data type](../data-types/vector-data-type.md)
- [CREATE VECTOR INDEX (Transact-SQL)](../statements/create-vector-index-transact-sql.md)
- [Azure SQL Database Vector Search Samples](https://github.com/Azure-Samples/azure-sql-db-vector-search)
