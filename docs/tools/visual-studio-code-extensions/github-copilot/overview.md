---
title: "Overview of GitHub Copilot Integration with MSSQL Extension for Visual Studio Code"
description: Introduction to the GitHub Copilot integration with the MSSQL extension for Visual Studio Code that provides AI-assisted SQL development.
author: croblesm
ms.author: roblescarlos
ms.reviewer: randolphwest
ms.date: 05/19/2025
ms.service: sql
ms.subservice: vs-code-sql-extensions
ms.topic: overview
ms.collection:
  - data-tools
  - ce-skilling-ai-copilot
ai-usage: ai-assisted
---

# GitHub Copilot for MSSQL extension for Visual Studio Code

The GitHub Copilot integration with the MSSQL extension for Visual Studio Code introduces AI-assisted development directly within the SQL development workflow.

This new feature empowers developers to write and optimize database code, generate and evolve schemas, understand existing logic, and work more confidently with code-first and data-first database development patterns using GitHub Copilot's intelligent, context-aware suggestions.

This preview is designed for developers, with a focus on the following key personas:

- **Modern Application Developers**: Building feature-rich, scalable applications with frameworks like React, Angular, .NET, ango, and Node.js.
- **AI / Cloud-Native Developers**: Specializing in containerized, serverless, and microservices-based applications, often integrating AI-powered capabilities.
- **Solutions Architects**: Designing end-to-end systems that align database solutions with broader architectural goals.
- **Database Developers**: Focusing on T-SQL, database-specific concepts, and optimizing database workflows.

## What is the MSSQL extension for Visual Studio Code?

The [MSSQL extension in Visual Studio Code](https://aka.ms/vscode-mssql-marketplace) is designed to help developers seamlessly work with their databases, simplifying the use of SQL database in Fabric, all Azure SQL offerings, and SQL Server as the backend for their applications.

To learn more about the extension, visit the [GitHub repository](https://github.com/microsoft/vscode-mssql).

## What is GitHub Copilot for the MSSQL extension for Visual Studio Code?

GitHub Copilot for the MSSQL extension integrates the power of AI-driven assistance directly into your SQL development workflow within Visual Studio Code. It enables developers to:

- Explore, design, and evolve database schemas using intelligent, code-first / data-first guidance.
- Apply contextual suggestions for SQL syntax, relationships, and constraints.
- Write, optimize, and troubleshoot SQL queries with AI-recommended improvements.
- Generate mock data and seed scripts to support testing and development environments.
- Accelerate schema evolution by autogenerating ORM (Object-Relational Mapping) migrations or T-SQL change scripts.
- Understand and document business logic embedded in stored procedures, views, and functions.
- Get security-related recommendations, such as avoiding SQL injection or excessive permissions.
- Receive natural language explanations to help developers unfamiliar with T-SQL write and understand code confidently.
- Help reverse-engineering existing databases by explaining SQL schemas and relationships.
- Help scaffold backend components (for example, data access layers) based on your current database context.

## Supported SQL Server platforms

GitHub Copilot for the MSSQL extension works with all of these SQL Server platforms:

### SQL Server

- SQL Server 2019
- SQL Server 2022
- SQL Server 2025 (Public Preview)
- SQL Server running on any platform:
  - Windows
  - Linux
  - Containers (local and Kubernetes deployments)

### Azure SQL

- Azure SQL Database
- Azure SQL Managed Instance
- SQL Server on Azure Virtual Machines

### Microsoft Fabric

- SQL database in Fabric
- Fabric Data Warehouse
- Fabric Lakehouse (SQL analytics endpoint)

## Target Audience

GitHub Copilot for the MSSQL extension is designed for developers who work with applications and SQL databases in Visual Studio Code. It provides intelligent assistance to help you write, optimize, and understand database code more effectively.

| Persona | Description |
| --- | --- |
| **Modern Application Developers** | Building robust, scalable applications using frameworks like React, Angular, .NET, Django, and Node.js, often following a code-first approach where application logic drives database design. GitHub Copilot streamlines database interactions by assisting with schema generation, query authoring, and integration patterns directly from your codebase, boosting productivity and minimizing context switching. |
| **AI / Cloud-Native Developers** | Building serverless, containerized, and microservices-based solutions that integrate AI capabilities, both within the application and the database layer. GitHub Copilot accelerates development by generating intelligent T-SQL queries, managing schema changes, and assisting with data access patterns common in cloud-native architectures. It also helps developers use AI features built into the database, such as vector search and hybrid retrieval scenarios, to build intelligent, AI-ready applications. |
| **Solutions Architects** | Designing data-centric systems and ensuring consistency across services and environments. GitHub Copilot helps visualize, validate, and prototype database interactions, making it easier to align database design with system architecture goals. |
| **Database Engineers** | Managing schema evolution, writing complex T-SQL queries, and optimizing performance. GitHub Copilot speeds up development by offering suggestions, explaining code, and identifying potential optimizations, boosting both speed and confidence. |

## Features (Preview)

| Feature | Description |
| --- | --- |
| **Chat / Inline Copilot Suggestions** | Engage in natural language conversations with the `@mssql` chat participant or use inline completions for T-SQL or ORM code. Suggestions adapt based on your database schema and active files. |
| **Schema Explorer & Designer** | Understand, design, and evolve your database schema using AI assistance. Supports object creation, relationships, and reverse engineering. |
| **Smart Query Builder** | Generate SQL and ORM (Object-Relational Mapping) queries using filters, joins, groupings, and conditions, based on schema awareness and natural language prompts. |
| **Code Generation** | Quickly scaffold database code, stored procedures, or ORM-based data access layers based on your current database schema and active files. GitHub Copilot understands your context and can generate repeatable patterns such as CRUD operations or access methods aligned with your development stack. |
| **Query Optimizer Assistant** | Get AI-generated tips for improving the performance of your SQL queries. GitHub Copilot might suggest better indexing strategies, refactor joins, or spot inefficiencies in WHERE clauses, helpful for developers who aren't experts in performance tuning. Additionally, it supports analysis of execution plans for in-depth analysis, enabling more precise recommendations tailored to your query's actual execution context. |
| **Business Logic Explainer** | Ask GitHub Copilot to explain in simple terms what a stored procedure, view, or user-defined function does. This is especially useful for onboarding new developers who need to understand how business rules are implemented without reading hundreds of lines of T-SQL code. |
| **Security Analyzer** | GitHub Copilot can analyze patterns that might expose your code to SQL injection, overly permissive roles, or unencrypted sensitive data. It can also recommend safer ways to handle credentials, user input, and authentication flows, directly in your context. |
| **Localization & Formatting Helper** | Whether you're building multilingual apps or just ensuring proper sorting and encoding, GitHub Copilot can suggest appropriate collation settings, Unicode usage, and query patterns that support language- and region-specific requirements. |
| **Test Data Generator** | Generate close to realistic, schema-aware sample data (via SQL INSERTs or ORM seeders) to populate your development environment. GitHub Copilot can even extrapolate schema from an existing sample (JSON, CSV, TXT) or autogenerate themed data to support prototyping or testing. |

## Prerequisites

### Install Visual Studio Code

1. Download Visual Studio Code [here](https://code.visualstudio.com/download).
1. Complete the installation following the wizard.

## Install the MSSQL extension in Visual Studio Code

To get started with SQL development in Visual Studio Code, install the **MSSQL extension**:

1. Open **Visual Studio Code**.
1. Select the **Extensions** icon in the Activity Bar (press `Cmd+Shift+X` on macOS or `Ctrl+Shift+X` on Windows/Linux).
1. In the **search bar**, type `mssql`.
1. Find **SQL Server (mssql)** in the results and select it.
1. Select the **Install** button.
:::image type="content" source="media/overview/mssql-extension-vscode.png" alt-text="Screenshot of the MSSQL extension in Visual Studio Code." lightbox="media/overview/mssql-extension-vscode.png":::

> [!TIP]  
> If you're unfamiliar with the MSSQL extension for Visual Studio Code, see [What is the MSSQL extension for Visual Studio Code?](../mssql/mssql-extension-visual-studio-code.md) for a comprehensive overview of its features and capabilities.

### Set up GitHub Copilot in Visual Studio Code

1. Make sure you have a GitHub account. If you don't have one, sign up for free at [GitHub](https://github.com).
1. Ensure you have an active GitHub Copilot subscription. You can start a free trial or purchase a subscription at [GitHub Copilot](https://docs.github.com/en/copilot/about-github-copilot/plans-for-github-copilot).
1. In Visual Studio Code, open the **Extensions** view (press `Cmd+Shift+X` on macOS or `Ctrl+Shift+X` on Windows/Linux).
1. Search for and install both **GitHub Copilot** and **GitHub Copilot Chat** extensions.
:::image type="content" source="media/overview/github-copilot-extension-vscode.png" alt-text="Screenshot of the GitHub Copilot extension in Visual Studio Code.":::
1. After installation, you'll need to sign in to your GitHub account. Use Visual Studio Code command palette `GitHub Copilot: Sign in` or sign in using the GitHub Copilot icon from the status bar at the bottom of the window.
:::image type="content" source="media/overview/github-copilot-signin-vscode.png" alt-text="Screenshot of the GitHub Copilot sign-in in Visual Studio Code." lightbox="media/overview/github-copilot-signin-vscode.png":::
1. After signing in, you might need to authorize the GitHub Copilot extension to access your GitHub account. Follow the prompts to complete the authorization process.
1. Once signed in, GitHub Copilot will be active and ready to assist as you write code in your editor.

For more details, see the official [Quickstart for GitHub Copilot in Visual Studio Code](https://docs.github.com/en/copilot/quickstart?tool=visualstudio).

### Connect to a database

To get started with GitHub Copilot for the MSSQL extension, simply connect to a supported SQL Server or Azure SQL database from the **Connections** view in Visual Studio Code.

> [!NOTE]  
> For step-by-step instructions on how to create a new connection profile and connect to a database, see [Quickstart: Connect to and query a database with the MSSQL extension for Visual Studio Code](../mssql/connect-database-visual-studio-code.md).

## Start Chatting with Your Database

You can begin using GitHub Copilot by initiating a chat session with your database:

1. Go to the **Connections** view in the MSSQL extension.
1. Right-click on a connected database.
1. Select **Chat with this database** from the context menu.
:::image type="content" source="media/overview/vscode-chat-database-context-menu.png" alt-text="Screenshot showing the database context menu, selecting the Chat with this database option.":::

After selecting this option, you'll be prompted to allow the MSSQL extension to access the language models provided by GitHub Copilot Chat.  
This is required to enable contextual conversations about your database.

:::image type="content" source="media/overview/vscode-copilot-access-prompt.png" alt-text="Screenshot of Placeholder for Copilot access notification.":::

Once approved, a GitHub Copilot chat window opens in the context of the selected database. You're now ready to start asking questions, generating SQL, or exploring schema insights using natural language.

## Manage database context

GitHub Copilot uses your current database connection to provide schema-aware suggestions. You can view your current database context by checking the status bar in Visual Studio Code.

:::image type="content" source="media/overview/vscode-copilot-chat-window.png" alt-text="Screenshot of the GitHub Copilot chat window in Visual Studio Code." lightbox="media/overview/vscode-copilot-chat-window.png":::

If you want to switch to a different database:

- Use the **Change Database** button in the MSSQL extension sidebar, or

  :::image type="content" source="media/overview/vscode-copilot-change-database-1.png" alt-text="Screenshot of the GitHub Copilot chat window and MSSQL extension changing database context using the change database option in Visual Studio Code." lightbox="media/overview/vscode-copilot-change-database-1.png":::

- Select the status bar panel displaying the current connection (server, database, user). This opens a dropdown list to select a different database from your configured profiles.

  :::image type="content" source="media/overview/vscode-copilot-change-database-2.png" alt-text="Screenshot of the GitHub Copilot chat window and MSSQL extension changing database context using the status bar in Visual Studio Code." lightbox="media/overview/vscode-copilot-change-database-2.png":::

> [!IMPORTANT]  
> GitHub Copilot requires an active database connection to provide meaningful suggestions. Without it, the chat experience won't be able to access schema or data context.

This gives you the flexibility to switch between environments while retaining context-aware assistance from GitHub Copilot.

## Share Your Experience

[!INCLUDE [feedback](../includes/feedback.md)]

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
- [Limitations and Known Issues](limitations-and-known-issues.md)
