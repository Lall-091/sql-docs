---
title: "Vector Functions (Transact-SQL)"
description: "Vector functions perform operations on vector type allowing applications to store and manipulate vectors in SQL Server."
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: damauri, pookam
ms.date: 05/01/2025
ms.update-cycle: 180-days
ms.service: sql
ms.subservice: system-objects
ms.topic: "reference"
ms.collection:
  - ce-skilling-ai-copilot
helpviewer_keywords:
  - "vector search, system functions"
dev_langs:
  - "TSQL"
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17 || = azuresqldb-current || =azuresqldb-mi-current || =fabric"
ms.custom:
  - build-2025
---

# Vector functions (preview)

[!INCLUDE [sqlserver2025-asdb-asmi-fabricsqldb](../../includes/applies-to-version/sqlserver2025-asdb-asmi-fabricsqldb.md)]

The following scalar functions perform operations on [vectors](../../relational-databases/vectors/vectors-sql-server.md) in binary format, allowing applications to store and manipulate vectors in the SQL Database Engine.

> [!NOTE]
> - Vector features are in preview and are subject to change. Make sure to read preview usage terms in the [Service Level Agreements (SLA) for Online Services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services) document.
> - Vector features are available in Azure SQL Managed Instance configured with the [Always-up-to-date](/azure/azure-sql/managed-instance/update-policy#always-up-to-date-update-policy) update policy. 

All Vector functions support the [Vector data type](../data-types/vector-data-type.md).

|**Function**|**Description**|
|:--|:--|
| [VECTOR_DISTANCE](vector-distance-transact-sql.md) | Calculates the distance between two vectors using a specified distance metric. |
| [VECTOR_SEARCH](vector-search-transact-sql.md) | Return the closest vectors to a given query vector and distance metric using an approximate vector search algorithm. |
| [VECTOR_NORM](vector-norm-transact-sql.md) | Takes a vector as an input and returns the norm of the vector (which is a measure of its length or magnitude) in a given [norm type](https://mathworld.wolfram.com/VectorNorm.html). |
| [VECTOR_NORMALIZE](vector-normalize-transact-sql.md) | Takes a vector as an input and returns the normalized vector, which is a vector scaled to have a length of 1 in a given [norm type](https://mathworld.wolfram.com/VectorNorm.html). Adjusts a vector so that its length is normalized following the rules of specified norm type.|
| [VECTORPROPERTY](vectorproperty-transact-sql.md) | Returns specific properties of a given vector.|

## Related content

- [Vector data type](../data-types/vector-data-type.md)
- [Overview of vectors in the SQL Database Engine](../../relational-databases/vectors/vectors-sql-server.md)
- [Intelligent applications with Azure SQL Database](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications)
