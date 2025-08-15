---
title: "CREATE EXTERNAL MODEL (Transact-SQL)"
description: CREATE EXTERNAL MODEL (Transact-SQL) for creating an external model object that contains the location, authentication method, and purpose of an AI model inference endpoint.
author: jettermctedder
ms.author: bspendolini
ms.reviewer: randolphwest
ms.date: 08/15/2025
ms.service: sql
ms.subservice: t-sql
ms.topic: "reference"
ms.custom:
  - sql-ai
  - build-2025
f1_keywords:
  - "CREATE_EXTERNAL_MODEL"
  - "EXTERNAL MODEL"
  - "ai_generate_embeddings"
helpviewer_keywords:
  - "External"
  - "External model"
  - "ai_generate_embeddings, external model"
dev_langs:
  - "TSQL"
monikerRange: "=azuresqldb-current || >=sql-server-ver17 || >=sql-server-linux-ver17"
---

# CREATE EXTERNAL MODEL (Transact-SQL)

[!INCLUDE [sqlserver2025](../../includes/applies-to-version/sqlserver2025.md)]

Creates an external model object that contains the location, authentication method, and purpose of an AI model inference endpoint.

## Syntax

:::image type="icon" source="../../includes/media/topic-link-icon.svg" border="false"::: [Transact-SQL syntax conventions](../../t-sql/language-elements/transact-sql-syntax-conventions-transact-sql.md)

```syntaxsql
CREATE EXTERNAL MODEL external_model_object_name
[ AUTHORIZATION owner_name ]
WITH
  (   LOCATION = '<prefix>://<path>[:<port>]'
    , API_FORMAT = '<OpenAI, Azure OpenAI, etc>'
    , MODEL_TYPE = EMBEDDINGS
    , MODEL = 'text-embedding-ada-002'
    [ , CREDENTIAL = <credential_name> ]
    [ , PARAMETERS = '{"valid":"JSON"}' ]
  );
```

## Arguments

### external_model_object_name

Specifies the user-defined name for the external model. The name must be unique within the database.

### owner_name

Specifies the name of the user or role that owns the external model. If not specified, ownership is given to the current user. Depending on permissions and roles, explicit permission needs to be granted to users to use specific external models.

### LOCATION

Provides the connectivity protocol and path to the AI model inference endpoint.

### API_FORMAT

The API message format for the AI model inference endpoint provider.

Accepted values are:

- `Azure OpenAI`
- `OpenAI`
- `Ollama`

### MODEL_TYPE

The type of model being accessed from the AI model inference endpoint location.

Accepted values are:

- `EMBEDDINGS`

### MODEL

The specific model hosted by the AI provider. For example, `text-embedding-ada-002`, `text-embedding-3-large`, or `o3-mini`.

### CREDENTIAL

Indicate which `DATABASE SCOPED CREDENTIAL` object is used with the AI model inference endpoint. More on accepted credential types and naming rules can be found in [sp_invoke_external_rest_endpoint](../../relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql.md), or in the [Remarks](#remarks) section of this article.

### PARAMETERS

A valid JSON string that contains runtime parameters to be appended to the AI model inference endpoint request message. For example:

```text
'{ "dimensions": 1536 }'
```

## Permissions

### External model creation and altering

Requires `ALTER ANY EXTERNAL MODEL` or `CREATE EXTERNAL MODEL` database permission.

For example:

```sql
GRANT CREATE EXTERNAL MODEL TO [<PRINCIPAL>];
```

or

```sql
GRANT ALTER ANY EXTERNAL MODEL TO [<PRINCIPAL>];
```

### External model grants

To use an external model in an AI function, a principal must be granted the ability to `EXECUTE` it.

For example:

```sql
GRANT EXECUTE ON EXTERNAL MODEL::MODEL_NAME TO [<PRINCIPAL>];
GO
```

## Retry count

If the embeddings call encounters HTTP status codes indicating temporary issues, you can configure the request to automatically retry. To specify the number of retries, add the following JSON to the `PARAMETERS` on the `EXTERNAL MODEL`. The `<number_of_retries>` should be a whole number between zero (`0`) and ten (`10`), inclusive, and can't be `NULL` or negative.

```text
{ "sql_rest_options": { "retry_count": <number_of_retries> } }
```

For example, to set the `retry_count` to 3, you would write the following JSON string:

```json
{ "sql_rest_options": { "retry_count": 3 } }
```

### Retry count with other parameters

Retry count can also be combined with other parameters as long as it's a valid JSON string.

```json
{ "dimensions": 725, "sql_rest_options": { "retry_count": 5 } }
```

## Remarks

### HTTPS and TLS

Only AI model inference endpoints that are configured to use HTTPS with TLS encryption protocol are supported for the `LOCATION` parameter.

### Accepted API formats and model types

The following sections outline accepted API Formats for each `MODEL_TYPE`.

#### API_FORMAT for EMBEDDINGS

This table outlines the API Formats and URL endpoint structures for the `EMBEDDINGS` model type. To view specific payload structures, use the link in the API Format column.

| API format | Location path format |
| --- | --- | --- |
| [Azure OpenAI](/azure/ai-services/openai/reference#embeddings) | https://{endpoint}/openai/deployments/{deployment-id}/embeddings?api-version={date} |
| [OpenAI](https://platform.openai.com/docs/api-reference/embeddings/create) | https:<span>//</span>{server_name}/v1/embeddings |
| [Ollama](https://github.com/ollama/ollama/blob/main/docs/api.md#generate-embeddings) | https:<span>//</span>localhost:{port}/api/embed |

#### Create embedding endpoints

For more information on creating embedding endpoints, use these links for the appropriate AI model inference endpoint provider:

- [Azure OpenAI](/azure/ai-services/openai/how-to/create-resource)
- [OpenAI](https://platform.openai.com/docs/guides/embeddings)
- [Ollama](https://github.com/ollama/ollama/blob/main/docs/api.md#generate-embeddings)

### Credential name rules for EXTERNAL MODEL

The created `DATABASE SCOPED CREDENTIAL` used by an `EXTERNAL MODEL` must adhere to specific following rules:

- Must be a valid URL

- The URL domain must be one of those domains included in the allowlist

- The URL must not contain a query string

- Protocol + Fully Qualified Domain Name (FQDN) of the called URL must match Protocol + FQDN of the credential name

- Each part of the called URL path must match completely with the respective part of URL path in the credential name

- The credential must point to a path that is more generic than the request URL. For example, a credential created for path `https://northwind.azurewebsite.net/customers` can't be used for the URL `https://northwind.azurewebsite.net`

#### Collation and credential name rules

[RFC 3986 Section 6.2.2.1](https://www.rfc-editor.org/rfc/rfc3986#section-6.2.2.1) states that "When a URI uses components of the generic syntax, the component syntax equivalence rules always apply; namely, that the scheme and host are case-insensitive," and [RFC 7230 Section 2.7.3](https://www.rfc-editor.org/rfc/rfc7230#section-2.7.3) mentions that "all other are compared in a case-sensitive manner."

As there's a collation rule set at the database level, the following logic is applied, to be coherent with the database collation rule, and the RFC mentioned previously. (The described rule could potentially be more restrictive than the RFC rules, for example if database is set to use a case-sensitive collation):

1. Check if the URL and credential match using the RFC, which means:
   - Check the scheme and host using a case-insensitive collation (`Latin1_General_100_CI_AS_KS_WS_SC`)
   - Check all other segments of the URL are compared in a case-sensitive collation (`Latin1_General_100_BIN2`)

1. Check that the URL and credential match using the database collation rules (and without doing any URL encoding).

### Managed Identity

To use [Managed Identity](/entra/identity/managed-identities-azure-resources/overview) for authentication on SQL Server 2025, you must enable the option by using `sp_configure` with a user that is [granted the ALTER SETTINGS server-level permission](../../relational-databases/system-stored-procedures/sp-configure-transact-sql.md#permissions).

```sql
EXECUTE sp_configure 'allow server scoped db credentials', 1;
RECONFIGURE WITH OVERRIDE;
```

### SCHEMABINDING

Dropping views created with `SCHEMABINDING` and referencing an `EXTERNAL MODEL` (such as a `SELECT` statement using `AI_GENERATE_EMBEDDINGS`) is prevented with the Database Engine raising an error. The view definition itself must first be modified or dropped to remove dependencies referencing an `EXTERNAL MODEL`.

## Catalog View

External Model metadata is viewed by querying the `sys.external_models` catalog view. Note, you must have access to a model to be able to view the metadata.

```sql
SELECT * FROM sys.external_models;
```

## Examples

### Create an EXTERNAL MODEL with Azure OpenAI using Managed Identity

This example creates an `EXTERNAL MODEL` of the `EMBEDDINGS` type using Azure OpenAI and uses [Managed Identity](/entra/identity/managed-identities-azure-resources/overview) for authentication.

> [!IMPORTANT]  
> If using Managed Identity with Azure OpenAI and SQL Server 2025, the [Cognitive Services OpenAI Contributor](/azure/role-based-access-control/built-in-roles#ai--machine-learning) role must be granted to [SQL Server's system-assigned managed identity enabled by Azure Arc](../../sql-server/azure-arc/managed-identity.md). For more information, see [Role-based access control for Azure OpenAI in Azure AI Foundry Models](/azure/ai-services/openai/how-to/role-based-access-control).

```sql
-- Create access credentials to Azure OpenAI using a managed identity:
CREATE DATABASE SCOPED CREDENTIAL [https://my-azure-openai-endpoint.openai.azure.com/]
    WITH IDENTITY = 'Managed Identity', secret = '{"resourceid":"https://cognitiveservices.azure.com"}';
GO

-- Create the EXTERNAL MODEL
CREATE EXTERNAL MODEL MyAzureOpenAiModel
AUTHORIZATION CRM_User
WITH (
      LOCATION = 'https://my-azure-openai-endpoint.openai.azure.com/openai/deployments/text-embedding-ada-002/embeddings?api-version=2024-02-01',
      API_FORMAT = 'Azure OpenAI',
      MODEL_TYPE = EMBEDDINGS,
      MODEL = 'text-embedding-ada-002',
      CREDENTIAL = [https://my-azure-openai-endpoint.openai.azure.com/]
);
```

### Create an EXTERNAL MODEL with Azure OpenAI using API keys and parameters

This example creates an `EXTERNAL MODEL` of the `EMBEDDINGS` type using Azure OpenAI and uses API Keys for authentication. The example also uses `PARAMETERS` to set the dimensions parameter at the endpoint to 725.

```sql
-- Create access credentials to Azure OpenAI using a key:
CREATE DATABASE SCOPED CREDENTIAL [https://my-azure-openai-endpoint.openai.azure.com/]
    WITH IDENTITY = 'HTTPEndpointHeaders', secret = '{"api-key":"YOUR_AZURE_OPENAI_KEY"}';
GO

-- Create the EXTERNAL MODEL
CREATE EXTERNAL MODEL MyAzureOpenAiModel
AUTHORIZATION CRM_User
WITH (
      LOCATION = 'https://my-azure-openai-endpoint.openai.azure.com/openai/deployments/text-embedding-3-small/embeddings?api-version=2024-02-01',
      API_FORMAT = 'Azure OpenAI',
      MODEL_TYPE = EMBEDDINGS,
      MODEL = 'text-embedding-3-small',
      CREDENTIAL = [https://my-azure-openai-endpoint.openai.azure.com/],
      PARAMETERS = '{"dimensions":725}'
);
```

### Create an EXTERNAL MODEL with Ollama and an explicit owner

This example creates an `EXTERNAL MODEL` of the `EMBEDDINGS` type using Ollama hosted locally for development purposes.

```sql
CREATE EXTERNAL MODEL MyOllamaModel
AUTHORIZATION AI_User
WITH (
      LOCATION = 'https://localhost:11435/api/embed',
      API_FORMAT = 'Ollama',
      MODEL_TYPE = EMBEDDINGS,
      MODEL = 'all-minilm'
);
```

### Create an EXTERNAL MODEL with OpenAI

This example creates an `EXTERNAL MODEL` of the `EMBEDDINGS` type using the OpenAI `API_FORMAT` and HTTP header based credentials for authentication.

```sql
-- Create access credentials
CREATE DATABASE SCOPED CREDENTIAL [https://openai.com]
WITH IDENTITY = 'HTTPEndpointHeaders', secret = '{"Bearer":"YOUR_OPENAI_KEY"}';
GO

-- Create the external model
CREATE EXTERNAL MODEL MyAzureOpenAiModel
AUTHORIZATION CRM_User
WITH (
      LOCATION = 'https://api.openai.com/v1/embeddings',
      API_FORMAT = 'OpenAI',
      MODEL_TYPE = EMBEDDINGS,
      MODEL = 'text-embedding-ada-002',
      CREDENTIAL = [https://openai.com]
);
```

## Related content

- [ALTER EXTERNAL MODEL (Transact-SQL)](alter-external-model-transact-sql.md)
- [DROP EXTERNAL MODEL (Transact-SQL)](drop-external-model-transact-sql.md)
- [AI_GENERATE_EMBEDDINGS (Transact-SQL)](../functions/ai-generate-embeddings-transact-sql.md)
- [AI_GENERATE_CHUNKS (Transact-SQL) (Preview)](../functions/ai-generate-chunks-transact-sql.md)
- [sys.external_models](../../relational-databases/system-catalog-views/sys-external-models-transact-sql.md)
- [Create and deploy an Azure OpenAI in Azure AI Foundry Models resource](/azure/ai-services/openai/how-to/create-resource)
- [Server configuration options](../../database-engine/configure-windows/server-configuration-options-sql-server.md)
- [Role-based access control for Azure OpenAI in Azure AI Foundry Models](/azure/ai-services/openai/how-to/role-based-access-control)
