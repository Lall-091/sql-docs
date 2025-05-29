---
title: "AI_GENERATE_EMBEDDINGS (Transact-SQL)"
description: The AI_GENERATE_EMBEDDINGS function creates vector arrays for data.
author: jettermctedder
ms.author: bspendolini
ms.reviewer: randolphwest
ms.date: 05/21/2025
ms.service: sql
ms.topic: "reference"
ms.custom:
  - sql-ai
f1_keywords:
  - "ai_generate_embeddings_TSQL"
  - "ai_generate_embeddings"
helpviewer_keywords:
  - "ai_generate_embeddings"
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-current || >=sql-server-ver17 || >=sql-server-linux-ver17"
---
# AI_GENERATE_EMBEDDINGS (Transact-SQL)

[!INCLUDE [sqlserver2025](../../includes/applies-to-version/sqlserver2025.md)]

`AI_GENERATE_EMBEDDINGS` is a built-in function that creates embeddings (vector arrays) using a precreated AI model definition stored in the database.

## Syntax

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

```syntaxsql
AI_GENERATE_EMBEDDINGS ( source USE MODEL model_identifier [ PARAMETERS optional_json_request_body_parameters ] )
```

## Arguments

#### *source*

An [expression](../language-elements/expressions-transact-sql.md) of any character type (for example, **nvarchar**, **varchar**, **nchar**, or **char**).

#### *model_identifier*

The name of an [EXTERNAL MODEL](../statements/create-external-model-transact-sql.md) defined as an `EMBEDDING` type that is used to create the embeddings vector array.

For more information, see [CREATE EXTERNAL MODEL](../statements/create-external-model-transact-sql.md).

#### *optional_json_request_body_parameters*

A valid JSON formatted list of additional parameters. These parameters are appended to the REST request message body before being sent to the `EXTERNAL MODEL`'s endpoint location. These parameters are depenantant on what the `EXTERNAL MODEL`'s endpoint supports and accepts.

## Return types

`AI_GENERATE_EMBEDDINGS` returns a single-column table whose rows are the generated embedding vector arrays returned as JSON.

### Return format

The format of the returned JSON is as follows:

```json
[
    0.0023929428,
    0.00034713413,
    -0.0023142276,
    -0.025654867,
    -0.011492423,
    0.0010358924,
    -0.014836246,
    0.0035484824,
    0.000045630233,
    -0.027581815,
    0.023816079,
    0.005012586,
    -0.027732948,
    -0.010088143,
    ...
    -0.014571763
]
```

## Remarks

### Prerequisites

There are two prerequisites you must meet to use `AI_GENERATE_EMBEDDINGS`:

- `sp_invoke_external_endpoint` must be enabled in the database using [sp_configure](../../relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql.md?tabs=request-headers#permissions).

- an [EXTERNAL MODEL](../statements/create-external-model-transact-sql.md) of the `EMBEDDINGS` type, accessible via the correct grants, roles, and/or permissions.

### Optional parameters

The parameter `optional_json_request_body_parameters` in `AI_GENERATE_EMBEDDINGS` is used when an endpoint parameter needs to be added to the body of the embeddings request message. Adding an optional parameter overrides the value at runtime if that parameter is defined in the model definition.

For example, if the [EXTERNAL MODEL](../statements/create-external-model-transact-sql.md) contains the parameter for `dimensions` set to 1536, by passing that parameter in the `optional_json_request_body_parameters` at runtime with a new value as seen here: `json_object('dimensions':755)`, the `dimensions` parameter on the model is overridden.

The value passed into `optional_json_request_body_parameters` must be valid JSON.

### Create embedding endpoints

For more information on creating embedding endpoints, review the process for [Azure OpenAI](/azure/ai-services/openai/how-to/create-resource), [OpenAI](https://platform.openai.com/docs/guides/embeddings), or [Ollama](https://github.com/ollama/ollama/blob/main/docs/api.md#generate-embeddings).

### Extended Events (XEvent)

`AI_GENERATE_EMBEDDINGS` has an extended event (``ai_generate_embeddings_summary``) that can be enabled for troubleshooting. It contains information about the REST request and response such as status code, any errors it encountered, the model name used, and token counts used by the embedding endpoint. The extended event ``external_rest_endpoint_summary`` contains additional information that can be for troubleshooting and debugging REST requests.

## Examples

### A. Create embeddings with a SELECT statement

The following example shows how to use the `AI_GENERATE_EMBEDDINGS` function with a select statement which returns vector array results.

```sql
SELECT id,
       AI_GENERATE_EMBEDDINGS(large_text USE MODEL MyAzureOpenAIModel)
FROM myTable;
```

### B. Create embeddings with a SELECT statement using AI_GENERATE_CHUNKS

The following example shows how to use the `AI_GENERATE_EMBEDDINGS` function with the `AI_GENERATE_CHUNKS` function to pass text broken up in specified chunk sizes with a select statement which returns vector array results.

```sql
SELECT
    id,
    title,
    large_text,
    AI_GENERATE_EMBEDDINGS(c.chunk_text USE MODEL MyAzureOpenAiModel)
FROM
    myTable
CROSS APPLY
    AI_GENERATE_CHUNKS(source = large_text, chunk_type = N'FIXED' , chunk_size = 10) c;
```

### C. Create embeddings with a table update

The following example shows how to use the `AI_GENERATE_EMBEDDINGS` function with a table update statement to return the vector array results into a vector data type column.

```sql
UPDATE t
    SET myEmbeddings = AI_GENERATE_EMBEDDINGS(t.text USE MODEL MyAzureOpenAiModel)
FROM myTable AS t;
```

### D. Create embeddings with a SELECT statement and PARAMETERS

The following example shows how to use the `AI_GENERATE_EMBEDDINGS` function with a select statement and passing optional parameters to the endpoint, which returns vector array results.

```sql
SELECT id,
       AI_GENERATE_EMBEDDINGS(large_text USE MODEL MyAzureOpenAIModel PARAMETERS '{"dimensions" : 768 }')
FROM myTable;
```

### E. A full example with chunking, AI_GENERATE_EMBEDDINGS, and model creation

This example is a full flow from creating the [CREATE EXTERNAL MODEL](../statements/create-external-model-transact-sql.md), using `AI_GENERATE_EMBEDDINGS`, and using [AI_GENERATE_CHUNKS](ai-generate-chunks-transact-sql.md) to insert the results into a table with a **vector** data type. Remember to replace `<password>` with a valid password.

```sql
-- Turn external REST endpoint invocation ON in the database
EXECUTE sp_configure 'external rest endpoint enabled', 1;
RECONFIGURE WITH OVERRIDE;
GO

-- Create a master key for the database
IF NOT EXISTS (SELECT *
               FROM sys.symmetric_keys
               WHERE [name] = '##MS_DatabaseMasterKey##')
    BEGIN
        CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'<password>';
    END
GO

-- Create access credentials to Azure OpenAI using a key:
CREATE DATABASE SCOPED CREDENTIAL [https://my-azure-openai-endpoint.openai.azure.com/]
    WITH IDENTITY = 'HTTPEndpointHeaders', secret = '{"api-key":"YOUR_AZURE_OPENAI_KEY"}';
GO

-- Create an external model to call the Azure OpenAI embeddings REST endpoint
CREATE EXTERNAL MODEL MyAzureOpenAiModel
WITH (
      LOCATION = 'https://my-azure-openai-endpoint.openai.azure.com/openai/deployments/text-embedding-ada-002/embeddings?api-version=2023-05-15',
      API_FORMAT = 'Azure OpenAI',
      MODEL_TYPE = EMBEDDINGS,
      MODEL = 'text-embedding-ada-002',
      CREDENTIAL = [https://my-azure-openai-endpoint.openai.azure.com/]
);

-- Create a table with text to chunk and insert data
CREATE TABLE textchunk
(
    text_id INT IDENTITY (1, 1) PRIMARY KEY,
    text_to_chunk NVARCHAR (MAX)
);
GO

INSERT INTO textchunk (text_to_chunk)
VALUES
('All day long we seemed to dawdle through a country which was full of beauty of every kind. Sometimes we saw little towns or castles on the top of steep hills such as we see in old missals; sometimes we ran by rivers and streams which seemed from the wide stony margin on each side of them to be subject to great floods.'),
('My Friend, Welcome to the Carpathians. I am anxiously expecting you. Sleep well to-night. At three to-morrow the diligence will start for Bukovina; a place on it is kept for you. At the Borgo Pass my carriage will await you and will bring you to me. I trust that your journey from London has been a happy one, and that you will enjoy your stay in my beautiful land. Your friend, DRACULA')
GO

-- Create a new table to hold the chunked text and vector embeddings
CREATE TABLE text_embeddings
(
    embeddings_id INT IDENTITY (1, 1) PRIMARY KEY,
    chunked_text NVARCHAR (MAX),
    vector_embeddings VECTOR (1536)
);

-- Insert the chunked text and vector embeddings into the text_embeddings table using AI_GENERATE_CHUNKS and AI_GENERATE_EMBEDDINGS
INSERT INTO text_embeddings (chunked_text, vector_embeddings)
SELECT c.chunk, AI_GENERATE_EMBEDDINGS(c.chunk USE MODEL MyAzureOpenAiModel)
FROM textchunk t
CROSS APPLY
    AI_GENERATE_CHUNKS(source = t.text_to_chunk, chunk_type = N'FIXED', chunk_size = 100) c;

-- View the results
SELECT * FROM text_embeddings;
```

## Related content

- [CREATE EXTERNAL MODEL (Transact-SQL)](../statements/create-external-model-transact-sql.md)
- [ALTER EXTERNAL MODEL (Transact-SQL)](../statements/alter-external-model-transact-sql.md)
- [DROP EXTERNAL MODEL (Transact-SQL)](../statements/drop-external-model-transact-sql.md)
- [AI_GENERATE_CHUNKS (Transact-SQL)](ai-generate-chunks-transact-sql.md)
- [sp_invoke_external_rest_endpoint](../../relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql.md)
- [Create and deploy an Azure OpenAI Service resource](/azure/ai-services/openai/how-to/create-resource)
