---
title: "Quickstart: Security Analyzer with GitHub Copilot"
description: Learn how GitHub Copilot helps developers identify and address common security risks in SQL code and application-layer queries.
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
ms.custom:
  - build-2025
---

# Quickstart: Security Analyzer (Preview)

GitHub Copilot assists developers in identifying and addressing common security risks in SQL code and application-layer queries. It can help detect vulnerabilities like SQL injection, overexposed data, and unsafe patterns, especially for developers without a strong security background, by providing practical, context-aware recommendations during development.

## Get started

[!INCLUDE [get-started](../includes/get-started.md)]

## Detect and fix security risks with GitHub Copilot

GitHub Copilot helps developers detect and fix common security vulnerabilities early in the development process, before they reach production. Whether you're using raw SQL, ORMs, or stored procedures, GitHub Copilot can identify unsafe patterns, explain potential risks, and suggest safer alternatives based on your database context. This is especially useful for developers who don't specialize in security but need to follow secure coding practices.

Here are common use cases and examples of what you can ask via the chat participant.

### SQL injection detection

SQL injection is one of the most common and dangerous security vulnerabilities in database applications. GitHub Copilot can help identify unparameterized queries, string interpolation issues, and misuse of dynamic SQL, while recommending safer, parameterized alternatives tailored to your context.

- I'm working with `SQLAlchemy` in `Python` for my current database `SalesLT` schema. Check the following `SQLAlchemy` query for potential security risks, such as `SQL` injection, over-fetching, or performance issues. If applicable, suggest improvements using parameterized queries, connection pooling, and other secure `SQL Server` practices to ensure performance and security.

```python
query = f"SELECT * FROM SalesLT.Customer WHERE LastName = '{user_input}'"
result = engine.execute(query).fetchall()
```

- Analyze the following `JavaScript` `SQL` query for potential security vulnerabilities. Identify risks such as `SQL` injection, over-fetching, and poor authentication practices.
  Explain why this query is insecure and provide a secure alternative.

```javascript
const query = `SELECT * FROM Users WHERE Username = '${username}' AND Password = '${password}'`;
```

- Using my current database, simulate an `SQL` injection attack for the `SalesLT.uspGetCustomerOrderHistory` stored procedure and suggest fixes.

- Review the stored procedure `SalesLT.uspGetCustomerOrderHistory` in my current database for potential SQL injection vulnerabilities. Explain how unparameterized or improperly validated inputs could be exploited and recommend secure coding practices.

- Review the `SalesLT.uspGetCustomerOrderHistory_Insecure` stored procedure. Identify any potential security issues in the implementation and then provide a revised version of the stored procedure that addresses these concerns without explicitly listing security best practices.

You can use the following T-SQL to create the stored procedure:

```sql
CREATE OR ALTER PROCEDURE [SalesLT].[uspGetCustomerOrderHistory_Insecure]
@CustomerID NVARCHAR (50)
AS
BEGIN
    DECLARE @SQL AS NVARCHAR (MAX) = N'SELECT *
    FROM SalesLT.SalesOrderHeader
    WHERE CustomerID = ' + @CustomerID + ';';
    EXECUTE (@SQL);
END
GO
```

### General security suggestions

Beyond SQL injection, many database applications expose sensitive data or use insecure configurations by default. GitHub Copilot provides guidance for encrypting connections, masking or protecting personal data, and aligning with secure authentication and authorization best practices across multiple development stacks.

- Recommend secure methods for storing sensitive data in the `SalesLT.Address` table.

- What are the best strategies or built-in features in my database for masking personal data in the `SalesLT.Customer` table?

- How can I configure my connection string in `Entity Framework Core` to enforce encryption and avoid exposing credentials?

- In a `Prisma` or Node.js environment, how can I securely use Microsoft Entra ID authentication or managed identity with `SQL Server` instead of storing passwords?

- What `SQL Server` options should I enable or verify (for example, `Always Encrypted`, `Transparent Data Encryption`) to protect customer data when using ORMs like Sequelize or EF Core?

## Feedback: Security Analyzer

[!INCLUDE [feedback](../includes/feedback.md)]

## Related content

- [GitHub Copilot for MSSQL extension for Visual Studio Code](overview.md)
- [Quickstart: Use Chat and inline GitHub Copilot suggestions (Preview)](inline-copilot-suggestions.md)
- [Quickstart: Generate code (Preview)](code-generation.md)
- [Quickstart: Use the Schema Explorer and designer (Preview)](schema-explorer-designer.md)
- [Quickstart: Use the Smart Query Builder (Preview)](smart-query-builder.md)
- [Quickstart: Query Optimizer Assistant (Preview)](query-optimizer-assistant.md)
- [Quickstart: Use the Business Logic Explainer (Preview)](business-logic-explainer.md)
- [Quickstart: Localization & Formatting Helper (Preview)](localization-formatting-helper.md)
- [Quickstart: Generate data for testing and mocking (Preview)](test-and-mocking-data-generator.md)
- [Limitations and Known Issues](limitations-and-known-issues.md)
