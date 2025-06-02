---
title: "Quickstart: Query Optimizer Assistant with GitHub Copilot"
description: Learn how GitHub Copilot helps developers optimize queries and analyze performance bottlenecks in SQL database code.
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

# Quickstart: Query Optimizer Assistant (Preview)

GitHub Copilot helps developers, especially those without deep T-SQL expertise, optimize queries and analyze performance bottlenecks without needing to `master` database internals. It can break down complex SQL, interpret execution plans, and suggest indexing strategies or refactoring opportunities, empowering developers to keep their apps functional and performant while staying focused on feature delivery.

## Get started

[!INCLUDE [get-started](../includes/get-started.md)]

## Optimize performance with GitHub Copilot

GitHub Copilot offers multiple ways to help developers write performant, production-ready database code without requiring deep expertise in query tuning or execution plan analysis. Whether you're building new features or investigating a performance issue, GitHub Copilot can surface insights, recommend optimizations, and help restructure queries, all within your existing workflow in Visual Studio Code.

Here are common use cases and examples of what you can ask via the chat participant.

### Optimize queries

Use GitHub Copilot to identify inefficiencies in SQL or ORM queries and suggest ways to improve performance. From rewriting slow queries to recommending indexes or avoiding anti-patterns like Cartesian joins, GitHub Copilot helps you apply T-SQL and ORM best practices based on your current context.

- Optimize the following query:

```sql
SELECT *
FROM SalesLT.SalesOrderHeader
WHERE OrderDate > '2023-01-01';
```

- Suggest indexing improvements for this query:

```sql
SELECT ProductID
FROM SalesLT.SalesOrderDetail
WHERE Quantity > 100;
```

- Rewrite this query to avoid a Cartesian join. Make sure the new query follows T-SQL best practices:

```sql
SELECT * FROM Customers, Order;
```

- Rewrite this `Prisma` query to avoid unnecessary nested selects and improve readability:

```ts
const orders = await prisma.salesOrderHeader.findMany({
  where: {
    orderDate: {
      gt: new Date('2023-01-01')
    }
  }
});
```

### Execution Plan Analysis

Execution plans provide a detailed breakdown of how the SQL engine processes queries. GitHub Copilot can help you interpret execution plans, identify bottlenecks like nested loop joins, and suggest improvements based on real-world query patterns and indexing strategies.

You can use the following query as an example to generate the execution plan using the Estimated/Actual plan option in the MSSQL extension:

```sql
SELECT soh1.SalesOrderID AS OrderA,
       soh2.SalesOrderID AS OrderB,
       soh1.TotalDue AS TotalA,
       soh2.TotalDue AS TotalB
FROM SalesLT.SalesOrderHeader AS soh1
CROSS JOIN SalesLT.SalesOrderHeader AS soh2
WHERE soh1.TotalDue < soh2.TotalDue
ORDER BY soh2.TotalDue DESC;
```

> [!TIP]  
> Make sure to include as much context as possible by selecting the query from the editor and including the `sqlplan` file in the GitHub Copilot chat window:
>
> :::image type="content" source="media/query-optimizer-assistant/vscode-execution-plan-example.png" alt-text="Screenshot showing an execution plan example in Visual Studio Code." lightbox="media/query-optimizer-assistant/vscode-execution-plan-example.png":::

- According to the execution plan shared by my database expert, the following query is using a nested loop join which is affecting the performance of my app. Can you explain in simple terms why this might be happening? Additionally, suggest optimization strategies that could improve the query's performance.

You can use the following query as an example to generate the execution plan using the Estimated/Actual plan option in the MSSQL extension:

```sql
SELECT c1.CustomerID,
       c1.LastName,
       c2.CustomerID AS MatchingCustomerID,
       c2.LastName AS MatchingLastName
FROM SalesLT.Customer AS c1
     INNER JOIN SalesLT.Customer AS c2
         ON c1.LastName = c2.LastName
        AND c1.CustomerID <> c2.CustomerID
OPTION (LOOP JOIN);
```

> [!TIP]  
> Make sure to include as much context as possible by selecting the query from the editor and including the `sqlplan` file in the GitHub Copilot chat window:
>
> :::image type="content" source="media/query-optimizer-assistant/vscode-nested-loop-join-example.png" alt-text="Screenshot showing an execution plan with nested loop join in Visual Studio Code." lightbox="media/query-optimizer-assistant/vscode-nested-loop-join-example.png":::

- Explain the execution plan for this query that performs a join with a filter on TotalDue:

```sql
SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       soh.SalesOrderID,
       soh.TotalDue
FROM SalesLT.Customer AS c
     INNER JOIN SalesLT.SalesOrderHeader AS soh
         ON c.CustomerID = soh.CustomerID
WHERE soh.TotalDue > 500;
```

### Query Restructuring

Restructuring queries using Common Table Expressions (CTEs) can improve readability and maintainability, especially for complex logic or nested subqueries. GitHub Copilot can help rewrite your existing queries to use CTEs while preserving intent and improving clarity.

- Rewrite this query using Common Table Expressions (`CTEs`) to improve clarity:

```sql
SELECT *
FROM (SELECT ProductID,
             SUM(Quantity) AS TotalQuantity
      FROM Sales
      GROUP BY ProductID) AS SubQuery;
```

- Rewrite the following query using a CTE (Common table expression) to improve readability and maintainability:

```sql
SELECT soh.CustomerID,
       COUNT(*) AS OrderCount
FROM SalesLT.SalesOrderHeader AS soh
WHERE soh.OrderDate > '2022-01-01'
GROUP BY soh.CustomerID
HAVING COUNT(*) > 5;
```

- Use a CTE to separate the aggregation logic from the filter condition in this query:

```sql
SELECT ProductID,
       AVG(UnitPrice) AS AvgPrice
FROM SalesLT.SalesOrderDetail
GROUP BY ProductID
HAVING AVG(UnitPrice) > 50;
```

### Code-First Performance Scenarios

When working with ORMs like Entity Framework, Prisma, or Sequelize, performance can degrade if queries aren't optimized. GitHub Copilot helps detect and resolve issues such as missing indexes, inefficient filtering, and N+1 problems in code-first workflows.

- In a Prisma project, how would you ensure that queries filtering by `OrderDate` in `SalesOrderHeader` are using indexes effectively?
- Using Entity Framework Core, how can you analyze and optimize a LINQ query that retrieves the top 10 customers by total order value?
- In Sequelize, how do you restructure a query that fetches order history with product details to minimize N+1 query issues?

## Feedback: Query Optimizer Assistant

To help us refine and improve GitHub Copilot for the MSSQL extension, use the following GitHub issue template to submit your feedback: [GitHub Copilot Feedback](https://aka.ms/vscode-mssql-copilot-feedback)

When submitting feedback, consider including:

- **Scenarios tested** – Let us know which areas you focused on for example, schema creation, query generation, security, localization.
- **What worked well** – Describe any experiences that felt smooth, helpful, or exceeded your expectations.
- **Issues or bugs** – Include any problems, inconsistencies, or confusing behaviors. Screenshots or screen recordings are especially helpful!
- **Suggestions for improvement** – Share ideas for improving usability, expanding coverage, or enhancing the GitHub Copilot's responses.

## Related content

- [GitHub Copilot for MSSQL extension for Visual Studio Code](overview.md)
- [Quickstart: Use Chat and inline GitHub Copilot suggestions (Preview)](inline-copilot-suggestions.md)
- [Quickstart: Generate code (Preview)](code-generation.md)
- [Quickstart: Use the Schema Explorer and designer (Preview)](schema-explorer-designer.md)
- [Quickstart: Use the Smart Query Builder (Preview)](smart-query-builder.md)
- [Quickstart: Use the Business Logic Explainer (Preview)](business-logic-explainer.md)
- [Quickstart: Security Analyzer (Preview)](security-analyzer.md)
- [Quickstart: Localization & Formatting Helper (Preview)](localization-formatting-helper.md)
- [Quickstart: Generate data for testing and mocking (Preview)](test-and-mocking-data-generator.md)
- [Limitations and Known Issues](limitations-and-known-issues.md)
