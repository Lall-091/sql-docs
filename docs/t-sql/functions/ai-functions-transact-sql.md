---
title: "AI Functions (Transact-SQL)"
description: Use AI functions to integrate relational data with AI inference endpoints.
author: JetterMcTedder
ms.author: bspendolini
ms.reviewer: randolphwest
ms.date: 04/30/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: reference
ms.custom:
  - build-2025
helpviewer_keywords:
  - "AI functions"
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-current || >=sql-server-ver17 || >=sql-server-linux-ver17"
---
# AI functions (Transact-SQL)

[!INCLUDE [sqlserver2025](../../includes/applies-to-version/sqlserver2025.md)]

The functions described in this article provide built-in support for AI and the creation of AI enabled applications.

| Function | Description |
| --- | --- |
| [AI_GENERATE_EMBEDDINGS](ai-generate-embeddings-transact-sql.md) | Create embeddings (vector arrays) from text expressions |
| [AI_GENERATE_CHUNKS](ai-generate-chunks-transact-sql.md) | Create chunks of text from text expressions based on size and overlap parameters |

For more info about the built-in support for AI in the database, review the following articles:

- [Vector data type](../../t-sql/data-types/vector-data-type.md)
- [Vector functions](../functions/vector-functions-transact-sql.md)
- [Intelligent applications](/azure/azure-sql/database/ai-artificial-intelligence-intelligent-applications).

## Related content

- [CREATE EXTERNAL MODEL (Transact-SQL)](../statements/create-external-model-transact-sql.md)
- [ALTER EXTERNAL MODEL (Transact-SQL)](../statements/alter-external-model-transact-sql.md)
- [DROP EXTERNAL MODEL (Transact-SQL)](../statements/drop-external-model-transact-sql.md)
- [sp_invoke_external_rest_endpoint](../../relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql.md)

