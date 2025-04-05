---
title: Microsoft Copilot in Azure with Azure SQL Database Overview
description: "Learn more about the possibilities of Microsoft Copilot in Azure with Azure SQL Database for administrators and developers."
author: markingmyname
ms.author: maghan
ms.reviewer: kendalv, jenhayes, wiassaf
ms.date: 04/08/2025
ms.service: azure-sql-database
ms.subservice: sql-ai-copilot
ms.topic: overview
ms.collection:
  - ce-skilling-ai-copilot
ms.custom:
  - build-2025
monikerRange: "=azuresql || =azuresql-db"
---

# Microsoft Copilot in Azure with Azure SQL Database

[!INCLUDE [appliesto-sqldb](../includes/appliesto-sqldb.md)]

[Microsoft Copilot in Azure](/azure/copilot/overview) with Azure SQL Database is a [capability](/azure/copilot/capabilities#perform-tasks) of the Microsoft Azure Copilot experience that enhances the management and operation of Azure services, providing robust capabilities for SQL-dependent applications. It provides a conversational interface for users to interact with their databases, allowing them to ask questions and receive relevant answers based on the context of their database. It improves productivity in the Azure portal by offering self-help for database administration. This makes it easier for developers and database administrators to manage their databases, troubleshoot issues, and optimize performance.troubleshoot issues, and optimize performance.

This article provides an overview of Microsoft Copilot in Azure with Azure SQL Database, including its features, how it works, and best practices for effective use.

## How Copilot works in Azure SQL Database

Microsoft Copilot in Azure is now integrated with Azure SQL Database.

Copilot in Azure SQL Database uses large language models (LLMs) to analyze the context of your database and provide relevant answers to your questions. It applies various data sources, including public documentation, dynamic management views, catalog views, and Azure supportability diagnostics, to generate applicable responses. This allows users to ask questions in natural language and receive detailed explanations and suggestions for their database-related queries.

## Features of Copilot in Azure SQL Database

Copilot provides relevant answers to user questions, simplifying database management by applying database context, documentation, dynamic management views, Query Store, and other knowledge sources.

For example:

- Database administrators can independently manage databases and resolve issues, or learn more about the performance and capabilities of your database.

- Developers can ask questions about their data as they would in text or conversation to generate a T-SQL query. Developers can also learn to write queries faster through detailed explanations of the generated query.

- **Microsoft Copilot in Azure integration**: This experience adds Azure SQL Database skills into Microsoft Copilot in Azure, customers with self-guided assistance, empowering them to manage their databases and solve issues independently.

- Copilot integrates data and formulates applicable responses using public documentation, dynamic management views, catalog views, and Azure supportability diagnostics.

## Enable Copilot in your Azure tenant

For information on enabling Microsoft Copilot, visit [What is Microsoft Copilot for Azure](/azure/copilot/overview).

## Best practices for using Copilot in Azure SQL Database

You can ask and receive helpful, context-rich suggestions from [Microsoft Copilot in Azure](/azure/copilot/overview) within the Azure portal.

Microsoft Copilot in Azure is a set of experiences that are powered by large language models (LLMs). Output produced by Copilot might contain inaccuracies, biases, or other unintended content. As with any generative AI model, humans should review the output produced by Copilot before use.

Some example scenarios for using Copilot in Azure SQL Database include:

- When you want to know the **current active connections** to your database, you could provide the prompt:

  ```copilot-prompt
  Who are currently actively connected to the database?
  ```

  Copilot in Azure returns a list of active connections to your database.

- When you're working with a slow Azure SQL Database, you could provide the prompt:

  ```copilot-prompt
  My database is slow
  ```

  Microsoft Copilot in Azure starts looking at your database based on your context in the Azure portal. After the check, Copilot will detail specific areas that might be contributing to the issue. In this example, there was a specific query driving high CPU utilization:

- You can continue the conversation and investigation with the prompt:

  ```copilot-prompt
  How can I tune that high CPU query?
  ```

## Example prompts

The following example prompts are clear, specific, and tailored to the properties of your schema and database.

You can provide prompts for the **Microsoft Copilot in Azure** around different capability areas.

  ```copilot-prompt
    - Who are currently actively connected to the database?
    - Show me all the queries in my workload that have anti-patterns in them.
    - Which connection string should I use to connect to my DB?
  ```

For a list of more prompts, visit [List of sample prompts](copilot-prompts-list.md).

> [!NOTE]
> AI powers Copilot, so surprises and mistakes are possible.

## Responsible AI in Microsoft Copilot in Azure

Microsoft is committed to responsible AI. We are continuously working to improve the quality and safety of our AI systems. Microsoft Copilot in Azure is designed to help you be more productive, but it is important to remember that it is not a replacement for human judgment. Always review the output produced by Copilot before using it in production.

For more information on how Microsoft implements responsible AI tools in [Microsoft Copilot in Azure](/azure/copilot/overview), see [Responsible AI FAQ for Microsoft Copilot in Azure](/azure/copilot/responsible-ai-faq).

## Related content

- [Microsoft Copilot in Azure](/azure/copilot/overview)
- [Frequently asked questions](copilot-azure-sql-faq.yml)
- [Intelligent applications with Azure SQL Database](../database/ai-artificial-intelligence-intelligent-applications.md)
