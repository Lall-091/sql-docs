---
title: Vector & Embeddings Frequently Asked Questions (FAQ)
description: Answers to common questions about vector search and vector indexes in the SQL Server Database Engine.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: damauri, mikeray
ms.date: 07/24/2025
ms.service: sql
ms.topic: faq
ms.collection:
  - ce-skilling-ai-copilot
ms.custom:
  - intro-quickstart
helpviewer_keywords:
  - "Vectors"
  - "Vectors, built-in support"
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17 || =azuresqldb-current || =azuresqldb-mi-current || =fabric"
---

# Vector and embeddings: Frequently asked questions (FAQ)

[!INCLUDE [sqlserver2025-asdb-asmi-fabricsqldb](../../includes/applies-to-version/sqlserver2025-asdb-asmi-fabricsqldb.md)]

This article contains frequently asked questions about vectors and embeddings in the SQL Database Engine.

> [!NOTE]
> Vector features are available in Azure SQL Managed Instance configured with the [Always-up-to-date](/azure/azure-sql/managed-instance/update-policy#always-up-to-date-update-policy) policy. 

## How do I keep embedding up to date?

Update embeddings every time the underlying data that they represent changes. This is especially important for scenarios where the data is dynamic, such as user-generated content or frequently updated databases. To find out more about several strategies to keep embeddings up to date, see [Database and AI: solutions for keeping embeddings updated](https://devblogs.microsoft.com/azure-sql/database-and-ai-solutions-for-keeping-embeddings-updated/).

## What is the overhead storage and processing for vector search?

The overhead for vector search primarily involves the storage of the vector data type and the computational resources required for indexing and searching. The `VECTOR` data type is designed to be efficient in terms of storage, but the exact overhead can vary based on the size - the number of dimensions - of the vectors stored.

For more information about how to choose the right vector size, review [Embedding models and dimensions: optimizing the performance-resource usage ratio](https://devblogs.microsoft.com/azure-sql/embedding-models-and-dimensions-optimizing-the-performance-resource-usage-ratio/).

A SQL Server data page can hold up to 8,060 bytes, so the size of the vector affects how many vectors can be stored in a single page. For example, if you have a vector with 1,024 dimensions, and each dimension is a single precision **float** (4 bytes), the total size of the vector would be 4,104 bytes (4096 bytes payload + 8 bytes header). This limits the number of vectors that can fit in a single page to one.

## What embedding model should I use, and when?

There are many embedding models available, and the choice of which one to use depends on the specific use case and the type of data being processed. Some models support multiple languages, while others support multimodal data (text, images, etc.). Some are available only online, others can be run locally. 

In addition to the model itself, consider the size of the model and the number of dimensions it produces. Larger models may provide better accuracy but require more computational resources and storage space, but in many cases having more dimension doesn't really change the quality that much, for common use cases.

For more information about how to choose the right embedding model, see [Embedding models and dimensions: optimizing the performance-resource usage ratio](https://devblogs.microsoft.com/azure-sql/embedding-models-and-dimensions-optimizing-the-performance-resource-usage-ratio/).

## How to decide when to use single-precision (4-byte) vs half-precision (2-byte) floating-point values for vectors?

When storing embedding vectors in a database, the choice between single-precision (float32) and half-precision (float16) floats often comes down to balancing storage efficiency with numerical fidelity. 

Fortunately, embeddings are typically not highly sensitive to small changes in precision.

Embeddings are dense vector representations used in tasks like semantic search, recommendation systems, and natural language processing. These vectors are often the output of neural networks, which are inherently tolerant to small numerical variations. As a result, reducing precision from float32 to float16 usually has minimal impact on the quality of similarity comparisons or downstream tasks—especially during inference.

Using float16 can significantly reduce storage and memory usage, which is particularly beneficial when working with large-scale embedding datasets. 

## What about sparse vectors?

At this time, the **vector** data type in the SQL Database Engine is designed for dense vectors, which are arrays of floating-point numbers where most of the elements are non-zero. Sparse vectors, which contain a significant number of zero elements, aren't natively supported. 

## What are some performance benchmarks for SQL vector search?

Performance can vary widely based on the specific use case, the size of the dataset, and the complexity of the queries. However, SQL Server's vector search capabilities are designed to be efficient and scalable, leveraging indexing techniques to optimize search performance.

## What if I have more than one column that I would like to use for generating embeddings?

If you have multiple columns that you want to use for generating embeddings, you have two main options:

- Create one embedding for each column, or
- Concatenate the values of multiple columns into a single string and then generate a single embedding for that concatenated string.

For more information about the two options and the related database design considerations, see [Efficiently and Elegantly Modeling Embeddings](https://devblogs.microsoft.com/azure-sql/efficiently-and-elegantly-modeling-embeddings-in-azure-sql-and-sql-server/).

## What about re-ranking?

Re-ranking is a technique used to improve the relevance of search results by re-evaluating the initial results based on additional criteria or models. In the SQL Database Engine, you can implement re-ranking by combining vector search with full-text (which provides BM25 ranking) or additional SQL queries or machine learning models to refine the results based on specific business logic or user preferences.

For more information, review [Enhancing Search Capabilities with Hybrid Search and RRF Re-Ranking](https://devblogs.microsoft.com/azure-sql/enhancing-search-capabilities-in-sql-server-and-azure-sql-with-hybrid-search-and-rrf-re-ranking/).

## When to use AI Search (now AI Foundry) vs using SQL for vectors search scenarios?

AI Search (now AI Foundry) is a specialized service designed for advanced search scenarios, including vector search, natural language processing, and AI-driven insights. It provides a comprehensive set of features for building intelligent search applications, such as built-in support for various AI models, advanced ranking algorithms, and integration with other AI services.

The SQL Database Engine provides the ability to store any kind of data and run any kind of query: structured and unstructured, and to perform vector search on that data. It is a good choice for scenarios where you need to do search across all these data together, and you don't want to use a separate service for search that would complicate your architecture. The SQL Database Engine offers critical enterprise security features to make sure data is always protected, such as row-level security (RLS), dynamic data masking (DDM), Always Encrypted, immutable ledger tables, and transparent data encryption (TDE).

Here's an example of a single query that can be run in Azure SQL or SQL Server that combines vector, geospatial, structured and unstructured data all at once. The sample query retrieves the top 50 most relevant restaurants based on the description of the restaurant, the location of the restaurant, and the user's preferences, using vector search for the description and geospatial search for the location, filtering also by star numbers, number of reviews, category and so on:

```sql
DECLARE @p GEOGRAPHY = GEOGRAPHY::Point(47.6694141, - 122.1238767, 4326);
DECLARE @e VECTOR (1536) = AI_GENERATE_EMBEDDINGS('I want to eat a good focaccia' USE model Text3Embedding);

SELECT TOP (50)
    b.id AS business_id,
    b.name AS business_name,
    r.id AS review_id,
    r.stars,
    r.review,
    VECTOR_DISTANCE('cosine', re.embedding, @e) AS semantic_distance,
    @p.STDistance(geo_location) AS geo_distance
FROM dbo.reviews r
INNER JOIN dbo.reviews_embeddings re
    ON r.id = re.review_id
INNER JOIN dbo.business b
    ON r.business_id = b.id
WHERE b.city = 'Redmond'
    AND @p.STDistance(b.geo_location) < 5000 -- 5 km
    AND r.stars >= 4
    AND b.reviews >= 30
    AND JSON_VALUE(b.custom_attributes, '$.local_recommended') = 'true'
    AND VECTOR_DISTANCE('cosine', re.embedding, @e) < 0.2
ORDER BY semantic_distance DESC;
```

In the previous sample, Exact Nearest Neighbor (ENN) search is used to find the most relevant reviews based on the semantic distance of the embeddings, while also filtering by geospatial distance and other business attributes. This query demonstrates the power of combining vector search with traditional SQL capabilities to create a rich and efficient search experience.

If you want to use Approximate Nearest Neighbor (ANN) search, you can create a vector index on the `reviews_embeddings` table and use the `VECTOR_SEARCH` function to perform the search.

## Where can I find a self-paced lab to learn more about embeddings and vector search?

Review the self-paced [Azure SQL Cryptozoology AI Embeddings](https://devblogs.microsoft.com/azure-sql/azure-sql-cryptozoology-ai-embeddings-lab-now-available/) lab.

## Related content

- [Vector data type](../../t-sql/data-types/vector-data-type.md)
- [Vector functions](../../t-sql/functions/vector-functions-transact-sql.md)
- [VECTOR_DISTANCE (Transact-SQL)](../../t-sql/functions/vector-distance-transact-sql.md)
- [VECTOR_SEARCH (Transact-SQL)](../../t-sql/functions/vector-search-transact-sql.md)
- [CREATE VECTOR INDEX (Transact-SQL)](../../t-sql/statements/create-vector-index-transact-sql.md)
- [Azure SQL Database Vector Search Samples](https://github.com/Azure-Samples/azure-sql-db-vector-search)
- [Intelligent applications with Azure SQL Database](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications)
- [Intelligent applications and AI Frequently Asked Questions (FAQ)](../../sql-server/artificial-intelligence-intelligent-applications-faq.md)
