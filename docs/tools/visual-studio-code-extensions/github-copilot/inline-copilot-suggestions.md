---
title: "Quickstart: Chat / Inline GitHub Copilot Suggestions"
description: Learn how to use GitHub Copilot's inline suggestions and chat experience to enhance your SQL development in Visual Studio Code.
author: croblesm
ms.author: roblescarlos
ms.reviewer: randolphwest
ms.date: 05/19/2025
ms.service: sql
ms.subservice: vs-code-sql-extensions
ms.topic: quickstart
ms.collection:
  - data-tools
  - ce-skilling-ai-copilot
ai-usage: ai-assisted
---

# Quickstart: Use Chat and inline GitHub Copilot suggestions (Preview)

GitHub Copilot provides both inline suggestions while typing in the code editor and an interactive chat experience. You can ask the chat participant questions or provide prompts by typing `@mssql` followed by your prompt.

## Get started

[!INCLUDE [get-started](../includes/get-started.md)]

## Chat with the MSSQL's chat participant in Visual Studio Code

Use the `@mssql` chat participant in GitHub Copilot Chat to bring intelligent, context-aware assistance into your SQL development workflow, all directly within Visual Studio Code. Whether you're writing queries, evolving your schema, or integrating with application code, GitHub Copilot can help you design and understand relational models, generate or optimize T-SQL code, create seed data, scaffold ORM migrations, and even explain business logic or security concerns using natural language, all tailored to your connected database context.

Here are common use cases and examples of what you can ask via the chat participant:

### List or explore objects in your database schema

Ask questions about tables, columns, schemas, and object metadata in your database.

- Show all objects in the `SalesLT` schema of my current database, grouped by type.
- List the columns, data types, and nullability of the `SalesLT.Customer` table.
- How many tables, views, and procedures are defined in my current database?

### Write simple queries

Get help writing common SQL queries for filtering, aggregation, and joins.

- Write a T-SQL query to list all customers from `SalesLT.Customer` who placed an order in the last 30 days based on the latest order date.
- Generate a query that calculates the average order total per customer from the `SalesLT.SalesOrderHeader` table, sorted descending.
- Update the previous query to include the full name of each customer from the `SalesLT.Customer` table.

### Explain relationships or concepts

Ask for simplified explanations of schema relationships, query logic, or features relevant to development.

- Describe the foreign key relationship between `SalesLT.SalesOrderHeader` and `SalesLT.Customer` tables in my current database.
- I'm a developer new to T-SQL. Explain how `SalesLT.SalesOrderHeader` is related to `SalesLT.Customer`, and what keys are involved.
- Explain how vector data types work in SQL Server and when to use them for AI scenarios.

### Generate migration or integration code

Request help generating SQL or ORM-based migration scripts.

- Create a T-SQL script to add a foreign key constraint on `SalesLT.SalesOrderDetail.ProductID` referencing `SalesLT.Product.ProductID`.
- Generate a Sequelize migration to add a foreign key from `SalesLT.SalesOrderDetail.ProductID` to `SalesLT.Product.ProductID`, assuming both exist.

## Use inline suggestions with GitHub Copilot

You can start by typing a T-SQL query in a new editor window, like `SELECT * FROM SalesLT.Customer`, and observe the inline suggestions provided by GitHub Copilot. The suggestions will appear as you type, and you can accept them by pressing `Tab` or `Enter`.

Alternatively, you can type the same query, `SELECT * FROM SalesLT.Customer`, directly into the editor. Then, highlight it to reveal the ✨ **smart action** icon, which appears next to the highlighted query. This icon provides quick access to additional GitHub Copilot options, such as `Modify using Copilot` to adjust your query, `/doc` to generate documentation, or the ability to ask GitHub Copilot general questions related to the query.

:::image type="content" source="media/inline-copilot-suggestions/vscode-smart-action-icon.png" alt-text="Screenshot showing the smart action icon for modifying SQL queries using GitHub Copilot in Visual Studio Code.":::

When you select **Review using GitHub Copilot**, you see an inline recommendation like this:

:::image type="content" source="media/inline-copilot-suggestions/vscode-inline-recommendation.png" alt-text="Screenshot showing an inline recommendation from GitHub Copilot for optimizing a SQL query in Visual Studio Code." lightbox="media/inline-copilot-suggestions/vscode-inline-recommendation.png":::

You can also invoke GitHub Copilot via a shortcut (`⌘+I` for macOS / `Ctrl+I` for Windows/Linux) and ask questions or request modifications to your query.

:::image type="content" source="media/inline-copilot-suggestions/vscode-copilot-shortcut.png" alt-text="Screenshot demonstrating how to invoke GitHub Copilot using the keyboard shortcut in Visual Studio Code." lightbox="media/inline-copilot-suggestions/vscode-copilot-shortcut.png":::

## Feedback: Inline GitHub Copilot suggestions

[!INCLUDE [feedback](../includes/feedback.md)]

## Related content

- [GitHub Copilot for MSSQL extension for Visual Studio Code](overview.md)
- [Quickstart: Generate code (Preview)](code-generation.md)
- [Quickstart: Use the Schema Explorer and designer (Preview)](schema-explorer-designer.md)
- [Quickstart: Use the Smart Query Builder (Preview)](smart-query-builder.md)
- [Quickstart: Query Optimizer Assistant (Preview)](query-optimizer-assistant.md)
- [Quickstart: Use the Business Logic Explainer (Preview)](business-logic-explainer.md)
- [Quickstart: Security Analyzer (Preview)](security-analyzer.md)
- [Quickstart: Localization & Formatting Helper (Preview)](localization-formatting-helper.md)
- [Quickstart: Generate data for testing and mocking (Preview)](test-and-mocking-data-generator.md)
- [Limitations and Known Issues](limitations-and-known-issues.md)
