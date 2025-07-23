---
title: "Quickstart: Use GitHub Copilot Agent Mode (Preview)"
description: Learn how to use GitHub Copilot Agent Mode with the MSSQL extension to connect to databases, explore schemas, and run SQL queries directly from the GitHub Copilot chat in Visual Studio Code.
author: croblesm
ms.author: roblescarlos
ms.reviewer: randolphwest
ms.date: 07/23/2025
ms.service: sql
ms.subservice: vs-code-sql-extensions
ms.topic: quickstart
ms.collection:
  - data-tools
  - ce-skilling-ai-copilot
ms.custom:
  - build-2025
ai-usage: ai-assisted
---

# Quickstart: Use GitHub Copilot Agent Mode (Preview)

GitHub Copilot Agent Mode brings a contextual, action-driven chat experience into the MSSQL extension for Visual Studio Code. With Agent Mode, GitHub Copilot can go beyond suggesting code—it can securely execute real database tasks using natural language prompts or built-in tools. You can list all your connections, connect to specific server/databases, and explore schemas without leaving your editor.

> [!TIP]  
> You don't need to mention a participant like `@mssql` to use SQL tools in Agent Mode. Once the MSSQL extension is active, its tools are automatically available in the Agent Mode interface. For more information, see [Agent Mode Tools](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode#_agent-mode-tools).

These actions are powered by tools contributed by the MSSQL extension and surfaced directly within GitHub Copilot's Agent Mode. For more information on how Agent Mode works, see the [Visual Studio Code documentation on Agent Mode](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode#_use-agent-mode).

## What is Agent Mode?

Agent Mode enables GitHub Copilot to go beyond suggesting code. It can now perform secure, confirmed actions inside your SQL development environment, using either chat variables like `#mssql_connect`, or natural phrases like:

```copilot-prompt
Connect to my Library database using my LocalDev profile
```

:::image type="content" source="media/agent-mode/agent-tool-chat.png" alt-text="Screenshot of GitHub Copilot Agent Mode chat interface." lightbox="media/agent-mode/agent-tool-chat.png":::

## MSSQL Agent Mode tool reference

This section provides a detailed reference for the SQL-specific tools available in GitHub Copilot Agent Mode. The MSSQL extension contributes these tools, enabling GitHub Copilot to execute actions through chat variables or natural language prompts. All tools require user confirmation before execution.

:::image type="content" source="media/agent-mode/agent-tools.png" alt-text="Screenshot of list of SQL-specific tools contributed by the MSSQL extension in Copilot Agent Mode.":::

> [!TIP]  
> You can also use chat variables like `#mssql_connect` to invoke these tools directly, or write prompts in natural language such as:
>
> ```copilot-prompt
> Connect to my development database
> ```

GitHub Copilot handles tool selection automatically.

### Connection management

| Tool name | Description |
| --- | --- |
| `connect` | Establishes a database connection using a saved connection profile or a specified server/database pair. |
| `disconnect` | Terminates the current active connection session. |
| `change_database` | Changes the database for an existing connection session. |
| `get_connection_details` | Gets connection details for a specific MSSQL connection. |
| `list_servers` | Lists all saved SQL Server connection profiles in your environment. |
| `list_databases` | Lists all available databases for a connected MSSQL server. |

#### Examples

The following phrases can be used to interact with GitHub Copilot.

```copilot-prompt
- Connect to my LocalDev environment
- Disconnect from my current database
- List my available connection profiles
- List all databases in the localhost server
- Set the active connection to localhost
- Set AdventureWorks as the active database
- Get the connection string for AdventureWorks on localhost
```

:::image type="content" source="media/agent-mode/agent-tool-connect.png" alt-text="Screenshot of example using an agent tool to connect to a database in the GitHub Copilot chat." lightbox="media/agent-mode/agent-tool-connect.png":::

#### How connection logic works

GitHub Copilot Agent Mode supports flexible ways to connect to your SQL database, either by referencing saved profiles or by specifying a server and database directly. Here's how the connection logic works:

When you connect via saved profile:

1. A user can connect by referencing the name of a saved connection profile.
1. GitHub Copilot uses the `mssql_list_servers` tool to verify the profile exists.
1. The `mssql_connect` tool then uses the saved `profileId` and its parameters to establish the connection.

When you connect via server/database specification:

- If a saved profile matches both the specified server and database:

  1. GitHub Copilot uses `mssql_list_servers` to find the match.
  1. It then calls `mssql_connect` using the full profile.

- If a saved profile matches only the server:

  1. GitHub Copilot finds the matching server profile.
  1. It attempts to connect by substituting the user-requested database into that profile.
  1. If the connection fails, an error is shown.

- If no profile matches the specified server:

  - GitHub Copilot reports an error.

This flexible matching system allows GitHub Copilot to handle a range of connection scenarios, minimizing user effort while ensuring secure, confirmable actions.

### Schema exploration

| Tool name | Description |
| --- | --- |
| `show_schema` | Displays a high-level diagram of your connected database schema, including tables and relationships. |
| `list_schemas` | Lists all schemas in a database for a connected MSSQL server. |
| `list_tables` | Lists all tables in a database for a connected MSSQL server. |
| `list_views` | Lists all views in a database for a connected MSSQL server. |
| `list_functions` | Lists all functions in a database for a connected MSSQL server. |

#### Examples

The following phrases can be used to interact with GitHub Copilot.

```copilot-prompt
- Show me the schema for this database
- Show me all tables in the current database
- List all views from this MSSQL database
- Give me a list of all the functions available in this schema
- What schemas are available in this database?
```

:::image type="content" source="media/agent-mode/agent-tool-schema.gif" alt-text="Screenshot of animation showing the database schema visualizer tool in Copilot Agent Mode." lightbox="media/agent-mode/agent-tool-schema.gif":::

### Query execution

| Tool name | Description |
| --- | --- |
| `run_query` | Executes a SQL query against the connected database. |

#### Examples

The following phrases can be used to interact with GitHub Copilot.

```copilot-prompt
- Give me the top five posts published this week
- Execute the current file to find how many comments each post has
- Get all categories along with the number of posts in each
```

:::image type="content" source="media/agent-mode/agent-tool-run-query-1.png" alt-text="Screenshot of example using an agent tool to connect to a database and retrieve data." lightbox="media/agent-mode/agent-tool-run-query-1.png":::

:::image type="content" source="media/agent-mode/agent-tool-run-query-2.png" alt-text="Screenshot of another example using an agent tool to connect to a database and retrieve data." lightbox="media/agent-mode/agent-tool-run-query-2.png":::

## How tools are managed in Agent Mode

GitHub Copilot can invoke MSSQL-specific tools and other extension-contributed tools while processing your request. These tools are visible in the Agent Mode interface under the Tools menu, where you can enable or disable specific tools.

When a tool is invoked—especially if it interacts with your machine or database—GitHub Copilot prompts for confirmation to ensure secure execution. You can allow the tool for just the current session, the workspace, or approve it permanently.

For more on tool visibility and approvals, visit [Manage tool approvals](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode#_manage-tool-approvals).

### Agent Mode confirmation workflow

When GitHub Copilot selects a tool, it prompts you with a confirmation dialog showing details about the requested action. You must explicitly approve the request before it can execute any commands that interact with your machine or database:

- **Allow in this session**
- **Allow in this workspace**
- **Always allow**

This confirmation step helps ensure secure, intentional interactions with your development environment.

> [!NOTE]  
> For more information on how confirmation works across all tools in Agent Mode, see the [Visual Studio Code documentation on tool approvals](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode#_manage-tool-approvals).

## Related content

- [Quickstart: Use Chat and inline GitHub Copilot suggestions (Preview)](inline-copilot-suggestions.md)
- [Quickstart: Generate code (Preview)](code-generation.md)
- [Quickstart: Use the Schema Explorer and designer (Preview)](schema-explorer-designer.md)
- [Quickstart: Use the Smart Query Builder (Preview)](smart-query-builder.md)
- [Quickstart: Query Optimizer Assistant (Preview)](query-optimizer-assistant.md)
- [Quickstart: Use the Business Logic Explainer (Preview)](business-logic-explainer.md)
- [Quickstart: Security Analyzer (Preview)](security-analyzer.md)
- [Quickstart: Localization & Formatting Helper (Preview)](localization-formatting-helper.md)
- [Quickstart: Generate data for testing and mocking (Preview)](test-and-mocking-data-generator.md)
- [Limitations and known issues](limitations-and-known-issues.md)
