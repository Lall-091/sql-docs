---
title: "Quickstart: Data Generator for Testing and Mocking (Preview)"
description: Learn how GitHub Copilot helps developers quickly create realistic and themed datasets to support SQL database application development, testing, and demos.
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

# Quickstart: Generate data for testing and mocking (Preview)

In this quickstart, you learn how to use GitHub Copilot to create realistic and themed datasets to support application development, testing, and demos. By analyzing the schema and context of your database, GitHub Copilot can generate mock data aligned with real-world formats, simulate edge cases, and reduce the manual effort of seeding databases, making testing faster and more representative of actual scenarios.

## Get started

[!INCLUDE [get-started](../includes/get-started.md)]

## Generate realistic and testable data with GitHub Copilot

GitHub Copilot can assist with generating test and mock data directly from your SQL schema or JSON samples. Whether you're preparing datasets for demos, testing edge cases, or seeding your development environment with themed or randomized data, GitHub Copilot offers contextual suggestions to help reduce time and improve coverage, especially in scenarios where manual data entry would be slow or inconsistent.

Here are common use cases and examples of what you can ask via the chat participant.

### Mock data generation

Use GitHub Copilot to generate themed, randomized, or representative mock data for your existing tables. You can request specific row counts, apply name/value patterns, or build datasets based on external structures like JSON samples.

- Generate mock data for the `SalesLT.Customer` table with 100 sample records.

- Populate the `SalesLT.Product` table with 50 items, each with unique names and prices.

- Generate mock data for the `SalesLT.SalesOrderHeader` table with 200 records, including order dates and customer IDs.

- Based on this sample JSON with four records, generate a SQL table schema and populate it with 50 mock records. Use character names from well-known sci-fi books (for example, Dune, Foundation, Ready Player One) for the `firstName` and `lastName` fields to make the data more realistic and themed:

  ```json
  [
    { "firstName": "Alice", "lastName": "Smith", "email": "alice@example.com" },
    { "firstName": "Bob", "lastName": "Jones", "email": "bob@example.com" },
    { "firstName": "Charlie", "lastName": "Brown", "email": "charlie@example.com" },
    { "firstName": "Dana", "lastName": "White", "email": "dana@example.com" }
  ]
  ```

### Edge case testing

Go beyond basic data generation by using GitHub Copilot to simulate edge cases and verify your system's behavior. Whether you're stress-testing business logic, checking for data validation failures, or ensuring relational consistency, GitHub Copilot can help generate the right data, and write assertions or test logic to validate outcomes.

- Generate insert statements for `SalesLT.SalesOrderDetail` with `OrderQty` values at the upper boundary (for example, 1,000 units) and verify that the system enforces quantity constraints.

- Create test data for `SalesLT.Customer` with invalid email formats and write a query that flags these records for review.

- Generate test data for `SalesLT.Product` with edge-case pricing, such as `StandardCost = 0` or negative values, and write a query that highlights anomalies.

- Simulate data integrity by generating 500 `SalesOrderDetail` rows that correctly reference valid `ProductID` and `SalesOrderID` values from related tables, and ensure GitHub Copilot includes validation logic.

- Write a test script that confirms the `SalesOrderHeader.TotalDue` value is always greater than the `SubTotal` for each order, helpful for spotting miscalculations in business logic.

- Using SQLAlchemy, create a test that attempts to insert a `SalesOrderDetail` record with a null `ProductID` and verify that the ORM raises an integrity error due to the foreign key constraint.

- With Prisma, generate test logic that tries to insert a `Product` with a `StandardCost` of `-10`. Validate that Prisma rejects the entry and logs an appropriate error message.

### Feedback: Generate data for testing and mocking

[!INCLUDE [feedback](../includes/feedback.md)]

## Related content

- [GitHub Copilot for MSSQL extension for Visual Studio Code](overview.md)
- [Quickstart: Use Chat and inline GitHub Copilot suggestions (Preview)](inline-copilot-suggestions.md)
- [Quickstart: Generate code (Preview)](code-generation.md)
- [Quickstart: Use the Schema Explorer and designer (Preview)](schema-explorer-designer.md)
- [Quickstart: Use the Smart Query Builder (Preview)](smart-query-builder.md)
- [Quickstart: Query Optimizer Assistant (Preview)](query-optimizer-assistant.md)
- [Quickstart: Use the Business Logic Explainer (Preview)](business-logic-explainer.md)
- [Quickstart: Security Analyzer (Preview)](security-analyzer.md)
- [Quickstart: Localization & Formatting Helper (Preview)](localization-formatting-helper.md)
- [Limitations and Known Issues](limitations-and-known-issues.md)
