---
title: MSSQL extension for Visual Studio Code Get Started
description: MSSQL extension for Visual Studio Code get started.
author: croblesm
ms.author: roblescarlos
ms.reviewer: maghan, randolphwest
ms.date: 05/19/2025
ms.service: sql
ms.subservice: vs-code-sql-extensions
ms.topic: include
ms.collection:
  - data-tools
---

Ensure that you're connected to a database and have an active editor window open with the MSSQL extension. This connection allows the `@mssql` chat participant to understand the context of your database environment, enabling accurate and context-aware suggestions. Without a database connection, the chat participant won't have the schema or data context to provide meaningful responses.

The following examples use the `AdventureWorksLT2022` sample database, which you can download from the [Microsoft SQL Server Samples and Community Projects](https://go.microsoft.com/fwlink/?LinkID=85384) home page.

For best results, adjust table and schema names to match your own environment.

Make sure the chat includes the `@mssql` prefix. For example, type `@mssql` followed by your question or prompt. This ensures that the chat participant understands you're asking for SQL-related assistance.
