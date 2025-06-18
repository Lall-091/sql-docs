---
title: "Quickstart: Use GitHub Copilot Agent Mode (Preview)"
description: Learn how to use GitHub Copilot Agent Mode with the MSSQL extension to connect to databases, explore schemas, and run SQL queries directly from the GitHub Copilot chat in Visual Studio Code.
author: croblesm
ms.author: roblescarlos
ms.reviewer: randolphwest
ms.date: 06/18/2025
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

GitHub Copilot Agent Mode brings a contextual, action-driven chat experience into the MSSQL extension for Visual Studio Code. With Agent Mode, GitHub Copilot can go beyond suggesting code—it can securely execute real database tasks using natural language prompts or built-in tools. You can list all your connections, connect to specific server/databases and explore schemas without leaving your editor.

> [!TIP]  
> You don't need to mention a participant like `@mssql` to use SQL tools in Agent Mode. Once the MSSQL extension is active, its tools are automatically available in the Agent Mode interface. For more information, see [Agent Mode Tools](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode#_agent-mode-tools).

These actions are powered by tools contributed by the MSSQL extension and surfaced directly within GitHub Copilot's Agent Mode. For more information on how Agent Mode works, see the [Visual Studio Code documentation on Agent Mode](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode#_use-agent-mode).

## What is Agent Mode?

Agent Mode enables GitHub Copilot to go beyond suggesting code. It can now perform secure, confirmed actions inside your SQL development environment, using either chat variables like `#mssql_connect` or natural phrases like "*Connect to my Library database using my LocalDev profile.*"

:::image type="content" source="media/agent-mode/agent-tool-chat.png" alt-text="Screenshot of GitHub Copilot Agent Mode chat interface." lightbox="media/agent-mode/agent-tool-chat.png":::

## MSSQL Agent Mode tool reference

This section provides a detailed reference for the SQL-specific tools available in GitHub Copilot Agent Mode. The MSSQL extension contributes these tools, enabling GitHub Copilot to execute actions through chat variables or natural language prompts. All tools require user confirmation before execution.

:::image type="content" source="media/agent-mode/agent-tools.png" alt-text="Screenshot of list of SQL-specific tools contributed by the MSSQL extension in Copilot Agent Mode." lightbox="media/agent-mode/agent-tools.png":::

> [!TIP]  
> You can also use chat variables like `#mssql_connect` to invoke these tools directly, or write prompts in natural language such as "Connect to my development database." GitHub Copilot handles tool selection automatically.

### Connection management

| Tool name | Description |
| --- | --- |
| connect_server | Establishes a database connection using a saved connection profile or a specified server/database pair. |
| disconnect_server | Terminates the current active connection session. |
| list_servers | Lists all saved SQL Server connection profiles in your environment. |

#### Examples

- Connect to my LocalDev environment
- Disconnect from my current database
- List my available connection profiles

:::image type="content" source="media/agent-mode/agent-tool-connect.png" alt-text="Screenshot of example using an agent tool to connect to a database in the GitHub Copilot chat." lightbox="media/agent-mode/agent-tool-connect.png":::

#### How connection logic works

GitHub Copilot Agent Mode supports flexible ways to connect to your SQL database, either by referencing saved profiles or by specifying a server and database directly. Here's how the connection logic works:

##### Connect via saved profile

- A user can connect by referencing the name of a saved connection profile.
- GitHub Copilot uses the `mssql_list_servers` tool to verify the profile exists.
- The `mssql_connect` tool then uses the saved `profileId` and its parameters to establish the connection.

##### Connect via server/database specification

- If a saved profile matches both the specified server and database:
  - GitHub Copilot uses `mssql_list_servers` to find the match.
  - It then calls `mssql_connect` using the full profile.

- If a saved profile matches only the server:
  - GitHub Copilot finds the matching server profile.
  - It attempts to connect by substituting the user-requested database into that profile.
  - If the connection fails, an error is shown.

- If no profile matches the specified server:
  - GitHub Copilot reports an error.

This flexible matching system allows GitHub Copilot to handle a range of connection scenarios, minimizing user effort while ensuring secure, confirmable actions.

### Schema exploration

| Tool name | Description |
| --- | --- |
| show_schema | Displays a high-level diagram of your connected database schema, including tables and relationships. |

#### Examples

- Show me the schema for this database

:::image type="content" source="media/agent-mode/agent-tool-schema.gif" alt-text="Screenshot of animation showing the database schema visualizer tool in Copilot Agent Mode." lightbox="media/agent-mode/agent-tool-schema.gif":::

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
> For more information on how confirmation works across all tools in Agent Mode, see the [official VS Code documentation on tool approvals](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode#_manage-tool-approvals).

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
