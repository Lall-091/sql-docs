---
title: "Quickstart: Code Generation with GitHub Copilot for SQL"
description: Learn how GitHub Copilot can accelerate database-related code generation for SQL scripts and ORM migrations in Visual Studio Code.
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

# Quickstart: Generate code (Preview)

In this quickstart, you learn how GitHub Copilot accelerates SQL and ORM development by generating context-aware code directly within Visual Studio Code. Whether you're using T-SQL or working with ORMs like Entity Framework, Sequelize, Prisma, or SQLAlchemy, GitHub Copilot helps you scaffold tables, evolve schemas, and reduce repetitive scripting, so you can stay focused on building application logic.

## Get started

[!INCLUDE [get-started](../includes/get-started.md)]

## Code Generation with GitHub Copilot

Use GitHub Copilot to generate SQL and ORM-compatible code that reflects your connected database's structure and follows best practices. From defining tables and relationships to scripting views, building migration files, or scaffolding data access layers and APIs, GitHub Copilot helps you move faster and with greater confidence.

Here are common use cases and examples of what you can ask via the chat participant:

### Generate SQL Code

GitHub Copilot can help you generate SQL code for a variety of development scenarios, from scripting, creating and modifying tables to writing stored procedures and views. These examples illustrate how you can use GitHub Copilot to automate repetitive SQL scripting and follow best practices for T-SQL development.

- Script out all the tables in the `SalesLT` schema as `CREATE TABLE` statements in `SQL`.
- Write a `SQL` stored procedure in my current database. The procedure should retrieve all customers from the `SalesLT.Customer` table where the `LastName` matches a given parameter. Make sure to use T-SQL best practices.
- Script out the `SalesLT.Customer` table as a `CREATE TABLE` statement, including all constraints and indexes.
- Generate a `SQL` script to create a view that joins the `SalesLT.Customer` and `SalesLT.SalesOrderHeader` tables, showing customer names and their total order amounts.
- Write a `SQL` script to alter the `SalesLT.Customer` table by adding a `last_updated` column with a default timestamp.

### Generate ORM Migrations

GitHub Copilot can generate ORM-compatible migrations and model definitions based on your schema context and framework of choice. From Sequelize to Entity Framework, Prisma, and SQLAlchemy, GitHub Copilot helps scaffold changes that align with your application's data model.

- Generate a Sequelize (JavaScript) model to add an `email` column (`varchar(256)`) to the `SalesLT.Customer` table.

- Generate an Entity Framework model class in C# to represent a `SalesLT.ProductModel` table with `id`, `name`, and `description` columns.

- Generate an Entity Framework model in C# based on the existing `SalesLT.Product` table.

- Write SQLAlchemy code to define a `SalesLT.OrderDetails` table with `id`, `order_date`, and `customer_id` fields, ensuring compatibility with `Python`.

- Using SQLAlchemy, write a parameterized query that retrieves all customers from the `SalesLT.Customer` table where the `LastName` matches a provided parameter.

- Update my existing Prisma model (schema.prisma) to define a new `SalesLT.Order` model with `id`, `customer_id`, and `order_date` fields.

- Generate a SQLAlchemy model class for the `SalesLT.Product` table, including columns and data types.

### Generate boilerplate app code

GitHub Copilot can also help scaffold backend and frontend components that interact with your SQL database. These examples show how you can go from schema to working application code using popular stacks like Azure Functions, Node.js, Django, and Next.js.

#### Serverless backend SQL bindings and Blazor

The following examples show full prompts you can use with GitHub Copilot Chat to scaffold an end-to-end solution. These prompts include detailed instructions and context to help Copilot generate accurate, structured code across both backend and frontend layers.

Generate a full-stack app using Azure SQL bindings for Functions and Blazor WebAssembly. Follow these steps:

1. Backend: Azure Functions (C#) with SQL Bindings

   - Configure `SQL Bindings` to automatically read and write data from the `SalesLT.Customer` table.
   - Implement HTTP-triggered functions with the following endpoints:
     - `GET /api/customers` – Fetch all customers.
     - `GET /api/customers/{id}` – Get a specific customer by ID.
     - `POST /api/customers` – Create a new customer.
     - `PUT /api/customers/{id}` – Update an existing customer.
     - `DELETE /api/customers/{id}` – Delete a customer.
   - Use `Dependency Injection` for database connections and logging.
   - Include an `appsettings.json` file to store database connection strings and environment variables.
   - Use `Azure Functions Core Tools` to run and test the functions locally.

1. Frontend: Blazor WebAssembly (Optional)

   - Create a `Blazor WebAssembly` frontend that consumes the API.
   - Display a table with customer data and a form to add new customers.
   - Use `HttpClient` to call the `Azure Functions` endpoints.
   - Implement two-way data binding to handle form inputs dynamically.
   - Use `Bootstrap` or `Blazor` components for styling and layout.

Ensure the project includes setup instructions for running both the `Azure Functions` backend and `Blazor WebAssembly` frontend locally, with proper `.env` or `local.settings.json` configurations for database connections.

#### Full-Stack with Node.js and Next.js

The following is a detailed prompt you can provide in GitHub Copilot Chat to generate the full backend setup, including API routes and database integration.

Generate a REST API using Node.js with Express that connects to my local SQL Database. Use the Tedious package for SQL Server connections and Prisma as the ORM. Follow these steps:

1. Backend: Node.js + Express

   - Establish a database connection using `Prisma` with `Tedious` as the `SQL` Server driver.
   - Implement API routes for `SalesLT.Customer` with the following endpoints:
     - `GET /customers` – Fetch all customers.
     - `GET /customers/:id` – Get a specific customer by ID.
     - `POST /customers` – Create a new customer.
     - `PUT /customers/:id` – Update an existing customer.
     - `DELETE /customers/:id` – Delete a customer.
   - Configure `Prisma` to map the `SalesLT.Customer` table and generate database migrations using `prisma migrate dev`.
   - Use `dotenv` for environment variables (database credentials, ports, etc.).
   - Add `Jest` for testing the API endpoints.

1. Frontend: Next.js + TypeScript (Optional)

   - Create a `Next.js` frontend that consumes the API.
   - Display a table with customer data and a form to add new customers.
   - Use `React` hooks (`useState`, `useEffect`) to manage state and fetch data dynamically.
   - Style the UI using `Tailwind CSS`.
   - Implement server-side data fetching (`getServerSideProps`) in `Next.js` for improved performance.

Ensure the project includes setup instructions for running both the backend and frontend independently, with proper `.env` configurations for the database connection.

#### Backend: Django + Django REST framework

The following is a detailed prompt you can provide in GitHub Copilot Chat to generate the full backend setup, including API routes and database integration.

Scaffold a `Django` backend with `Django REST Framework` for the `SalesLT.Customer` table. Follow these steps:

- Implement API routes using Django's `ModelViewSet` with the following endpoints:
  - `GET /customers` – Fetch all customers.
  - `GET /customers/{id}` – Get a specific customer by ID.
  - `POST /customers` – Create a new customer.
  - `PUT /customers/{id}` – Update an existing customer.
  - `DELETE /customers/{id}` – Delete a customer.

- Add instructions for generating database migrations with `python manage.py makemigrations` and `migrate`.

## Feedback: Code Generation

[!INCLUDE [feedback](../includes/feedback.md)]

## Related content

- [GitHub Copilot for MSSQL extension for Visual Studio Code](overview.md)
- [Quickstart: Use Chat and inline GitHub Copilot suggestions (Preview)](inline-copilot-suggestions.md)
- [Quickstart: Use the Schema Explorer and designer (Preview)](schema-explorer-designer.md)
- [Quickstart: Use the Smart Query Builder (Preview)](smart-query-builder.md)
- [Quickstart: Query Optimizer Assistant (Preview)](query-optimizer-assistant.md)
- [Quickstart: Use the Business Logic Explainer (Preview)](business-logic-explainer.md)
- [Quickstart: Security Analyzer (Preview)](security-analyzer.md)
- [Quickstart: Localization & Formatting Helper (Preview)](localization-formatting-helper.md)
- [Quickstart: Generate data for testing and mocking (Preview)](test-and-mocking-data-generator.md)
- [Limitations and Known Issues](limitations-and-known-issues.md)
