---
title: "Schema Explorer & Designer with GitHub Copilot"
description: Learn how GitHub Copilot can help design, understand, and evolve database schemas with context-aware suggestions in Visual Studio Code.
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

# Quickstart: Use the Schema Explorer and designer (Preview)

In this quickstart, you learn how GitHub Copilot assists developers in designing, understanding, and evolving database schemas with context-aware suggestions. Whether you're building from scratch or reverse-engineering existing tables, GitHub Copilot streamlines the process across SQL and ORM (Object-Relational Mapping) frameworks, making schema work faster, smarter, and easier to maintain.

This section covers both creating new schemas from scratch and working with existing databases. You can use GitHub Copilot to generate code-first schema definitions, update objects, or reverse-engineer and explore existing databases.

## Schema creation

- Write a SQL script to create a new schema named `blog` for a blog application. The schema should include three tables: `Posts`, `Comments`, and `Users`. Each table must have appropriate primary keys, and the necessary foreign key relationships and constraints should be defined.
- Add a new column named `LastModified` of type `datetime` to the `Posts` table in the `blog` schema. Generate the updated SQL script reflecting this change, including the full definition of the modified schema.
  - It isn't needed to create the schema, but it would be great if you could use the script generated and run it to validate the accuracy of the generated code. The following section continues using this new schema called `blog`.
- Generate a `Prisma` schema for a blog application using my current database. The schema should define a new database schema named `blog` and include tables for `posts`, `authors`, and `comments`, with appropriate relationships and constraints.
- Generate a `Prisma` migration to add a column called `LastModified` (`datetime`) to the `Post` table.
- Reverse engineer the current database and generate `CREATE TABLE` statements for all tables in the `SalesLT` schema.
- Summarize the structure of the `SalesLT.Product` table in natural language.
- Generate a `models.py` (`Django`) file that reflects the structure of the `SalesLT.Customer` table.
- Generate an `Entity Framework Core` DbContext and model classes for the `SalesLT` schema.
- Create a Sequelize model definition for the `SalesLT.Product` and `SalesLT.Category` tables with appropriate associations.
- Generate a `TypeORM` entity for the `SalesLT.Customer` table, including primary key and indexed fields.
- Generate a `knex.js` migration script to create the `SalesLT.SalesOrderHeader` table with `OrderDate`, `CustomerID`, and `TotalDue` columns.

## Define relationships

- Write SQL to define a one-to-many relationship between `Users` and `Posts` in the `blog` schema. Ensure the foreign key in `Posts` references `Users(UserId)`.
- Add a `Categories` table to the `blog` schema and update the `Posts` table to include a nullable foreign key referencing `Categories(CategoryId)`.
- Write SQL to update the `Users` table to include a `RoleId` column and create a new `Roles` table. Define a foreign key relationship and enforce that every user must have a role.
- Identify and describe all foreign key relationships that involve the `SalesLT.SalesOrderHeader` table.
- Write a SQL script that removes a foreign key between `Posts` and `Categories` in the `blog` schema and replaces it with a many-to-many relationship using a new join table.
- Write `Prisma` relation mappings between `Customer`, `SalesOrderHeader`, and `SalesOrderDetail`.
- Update a Sequelize model to include a `hasMany` and `belongsTo` relationship between `Customer` and `Order`.

## Schema validation

- Suggest constraints for a table storing user passwords (for example, special characters and length limits).
- Confirm that the `Name` column in `SalesLT.ProductCategory` doesn't use `nvarchar(max)` and has a reasonable maximum length constraint.
- Check whether the `SalesLT.Address` table has a primary key and all required fields defined.
- Generate a SQL script to validate that all tables in the `SalesLT` schema include a `CreatedDate` or `ModifiedDate` column.
- Define a SQLAlchemy model for the `Customer` table and include validation logic using Pydantic or custom Python validators before inserting into the database.
- Add `Data Annotations` in an `Entity Framework` model to ensure fields like `Email` and `PhoneNumber` follow specific formats.

## Feedback: Schema Explorer & Designer

[!INCLUDE [feedback](../includes/feedback.md)]

## Related content

- [GitHub Copilot for MSSQL extension for Visual Studio Code](overview.md)
- [Quickstart: Use Chat and inline GitHub Copilot suggestions (Preview)](inline-copilot-suggestions.md)
- [Quickstart: Generate code (Preview)](code-generation.md)
- [Quickstart: Use the Smart Query Builder (Preview)](smart-query-builder.md)
- [Quickstart: Query Optimizer Assistant (Preview)](query-optimizer-assistant.md)
- [Quickstart: Use the Business Logic Explainer (Preview)](business-logic-explainer.md)
- [Quickstart: Security Analyzer (Preview)](security-analyzer.md)
- [Quickstart: Localization & Formatting Helper (Preview)](localization-formatting-helper.md)
- [Quickstart: Generate data for testing and mocking (Preview)](test-and-mocking-data-generator.md)
- [Limitations and Known Issues](limitations-and-known-issues.md)
