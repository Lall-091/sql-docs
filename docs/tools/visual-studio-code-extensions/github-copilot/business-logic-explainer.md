---
title: "Quickstart: Business Logic Explainer with GitHub Copilot"
description: Learn how GitHub Copilot helps developers understand and work with complex application logic in SQL, ORM frameworks, or database code.
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

# Quickstart: Use the Business Logic Explainer (Preview)

In this quickstart, you learn how the Business Logic Explainer helps developers understand and work with complex application logic implemented in SQL, ORM (Object-Relational Mapping) frameworks, or directly in the database. The assistant analyzes SQL code, ORM models, or existing database schemas to explain the underlying business rules and provide actionable documentation.

## Get started

[!INCLUDE [get-started](../includes/get-started.md)]

## Understand business logic with GitHub Copilot

GitHub Copilot can help you understand and explain business rules embedded in database code, ORM models, and application queries. From stored procedures to LINQ queries and Sequelize expressions, GitHub Copilot provides natural language insights to make complex logic more accessible.

Here are common use cases and examples of what you can ask via the chat participant:

### Explain T-SQL logic

Use GitHub Copilot to understand and explain T-SQL logic, from stored procedures to inline conditional statements. Whether you're reviewing discount rules, procedural logic, or optimization conditions, GitHub Copilot can analyze and document business rules implemented in T-SQL.

- Explain what the `SalesLT.uspGetCustomerOrderHistory` stored procedure does and suggest ways to optimize it.
- Debug the `SalesLT.uspGetTopSellingProducts` stored procedure and suggest improvements.
- Analyze the following `SQL` code snippet from my current database. Document the business rules implemented in this discount application process, including conditions for eligibility, discount rate adjustments, and any limits imposed on the discount amount. Also, provide actionable insights or suggestions to improve clarity or performance if necessary.

```sql
DECLARE @OrderTotal AS DECIMAL (10, 2) = 1500.00;
DECLARE @DiscountCode AS NVARCHAR (20) = 'DISCOUNT10';
DECLARE @DiscountPct AS DECIMAL (5, 2) = CASE WHEN @OrderTotal > 1000.00 THEN 5.0 ELSE 0.0 END;

IF @DiscountCode = 'DISCOUNT10'
    BEGIN
        SET @DiscountPct = CASE WHEN @DiscountPct < 10.0 THEN 10.0 ELSE @DiscountPct END;
    END

DECLARE @DiscountAmount AS DECIMAL (10, 2) = (@OrderTotal * @DiscountPct / 100.0);

IF @DiscountAmount > 200.00
    BEGIN
        SET @DiscountAmount = 200.00;
    END

SELECT @OrderTotal AS OrderTotal,
       @DiscountPct AS DiscountPercentage,
       @DiscountAmount AS DiscountAmount;
```

### Explain ORM logic

- Explain what the following SQLAlchemy query does:

```python
from sqlalchemy import func

top_customers = (
    session.query(SalesOrderHeader.CustomerID, func.count().label("OrderCount"))
    .group_by(SalesOrderHeader.CustomerID)
    .order_by(func.count().desc())
    .limit(10)
)
```

- What does this Entity Framework LINQ query do? Describe how it groups customers by tier based on their total purchases.

```csharp
var customerTiers = context.SalesOrderHeaders
    .GroupBy(o => o.CustomerID)
    .Select(g => new {
        CustomerID = g.Key,
        TotalSpent = g.Sum(o => o.TotalDue),
        Tier = g.Sum(o => o.TotalDue) >= 10000 ? "Gold" :
               g.Sum(o => o.TotalDue) >= 5000 ? "Silver" : "Bronze"
    });
```

- Analyze the logic of this Prisma query and explain how it determines which products are considered "low inventory".

```ts
const lowInventoryProducts = await prisma.product.findMany({
  where: {
    SafetyStockLevel: {
      lt: 50
    }
  },
  select: {
    ProductID: true,
    Name: true,
    SafetyStockLevel: true
  }
});
```

- Review and explain what this Sequelize query does. Add inline comments to clarify how it calculates total revenue per customer and filters for customers with significant spending:

```js
const results = await SalesOrderHeader.findAll({
  attributes: ['CustomerID', [sequelize.fn('SUM', sequelize.col('TotalDue')), 'TotalSpent']],
  group: ['CustomerID'],
  having: sequelize.literal('SUM(TotalDue) > 5000')
});
```

- Using SQLAlchemy, generate a query to list products that have never been ordered and ask GitHub Copilot to explain the join logic and filtering behavior.

- In Prisma, write a query that retrieves customers who placed an order in the last 30 days. Explain what the following Prisma query does. Add inline comments to clarify how the date filtering works and how recent orders are determined:

### Understand business intent through queries

GitHub Copilot helps developers understand not just how a query works, but why it exists. This includes the real-world purpose behind data filters, groupings, and aggregations. These explanations are especially useful during onboarding, allowing developers to grasp the goals behind reports, logic gates, or system metrics embedded in SQL and ORM code.

- Describe the business goal of the following SQL query. What insight is it trying to surface?

```sql
SELECT TOP 10 CustomerID,
              COUNT(*) AS OrderCount
FROM SalesLT.SalesOrderHeader
GROUP BY CustomerID
ORDER BY OrderCount DESC;
```

- Summarize what this query is intended to achieve from a business perspective.

```sql
SELECT ProductID,
       SUM(LineTotal) AS TotalSales
FROM SalesLT.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(LineTotal) > 10000;
```

- Analyze the `SalesLT.uspGetCustomerOrderHistory` stored procedure and describe the business logic it implements.

- Explain this Entity Framework LINQ query and describe what business logic it implements:

```csharp
var highValueCustomers = context.SalesOrderHeaders
    .Where(o => o.TotalDue > 1000)
    .GroupBy(o => o.CustomerID)
    .Select(g => new { CustomerID = g.Key, OrderCount = g.Count() })
    .OrderByDescending(x => x.OrderCount)
    .Take(10)
    .ToList();
```

- Using `Sequelize`, explain what this query does and describe any business assumptions it makes:

```js
const customerRevenue = await SalesOrderHeader.findAll({
  attributes: ['CustomerID', [sequelize.fn('SUM', sequelize.col('TotalDue')), 'TotalSpent']],
  group: ['CustomerID'],
  having: sequelize.literal('SUM(TotalDue) > 5000')
});
```

## Feedback: Business Logic Explainer

[!INCLUDE [feedback](../includes/feedback.md)]

## Related content

- [GitHub Copilot for MSSQL extension for Visual Studio Code](overview.md)
- [Quickstart: Use Chat and inline GitHub Copilot suggestions (Preview)](inline-copilot-suggestions.md)
- [Quickstart: Generate code (Preview)](code-generation.md)
- [Quickstart: Use the Schema Explorer and designer (Preview)](schema-explorer-designer.md)
- [Quickstart: Use the Smart Query Builder (Preview)](smart-query-builder.md)
- [Quickstart: Query Optimizer Assistant (Preview)](query-optimizer-assistant.md)
- [Quickstart: Security Analyzer (Preview)](security-analyzer.md)
- [Quickstart: Localization & Formatting Helper (Preview)](localization-formatting-helper.md)
- [Quickstart: Generate data for testing and mocking (Preview)](test-and-mocking-data-generator.md)
- [Limitations and Known Issues](limitations-and-known-issues.md)
