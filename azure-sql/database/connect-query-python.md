---
title: Use Python to Query a Database
titleSuffix: Azure SQL Database & Azure SQL Managed Instance
description: This article shows you how to use Python to create a program that connects to a database in Azure SQL Database and query it using Transact-SQL statements.
author: dlevy-msft-sql
ms.author: dlevy
ms.reviewer: wiassaf, mathoma, randolphwest
ms.date: 09/10/2025
ms.service: azure-sql
ms.subservice: connect
ms.topic: quickstart
ms.custom:
  - sqldbrb=2
  - devx-track-python
  - mode-api
  - py-fresh-zinc
  - sfi-ropc-nochange
ms.devlang: python
monikerRange: "=azuresql || =azuresql-db || =azuresql-mi"
---
# Quickstart: Use Python to query a database in Azure SQL Database or Azure SQL Managed Instance

[!INCLUDE [appliesto-sqldb-sqlmi](../includes/appliesto-sqldb-sqlmi-asa.md)]

In this quickstart, you use Python to connect to Azure SQL Database, Azure SQL Managed Instance, or Synapse SQL database and use T-SQL statements to query data.

[mssql-python documentation](https://github.com/microsoft/mssql-python/wiki) | [mssql-python source code](https://github.com/microsoft/mssql-python/wiki) | [Package (PyPi)](https://pypi.org/project/mssql-python/)

## Prerequisites

To complete this quickstart, you need:

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?icid=azurefreeaccount?ref=microsoft.com&utm_source=microsoft.com&utm_medium=docs&utm_campaign=visualstudio).

- A database

  [!INCLUDE [create-configure-database](../includes/create-configure-database.md)]

- Python 3

  - If you don't already have Python, install the **Python runtime** and **Python Package Index (PyPI) package manager** from [python.org](https://www.python.org/downloads/).

  - Prefer to not use your own environment? Open as a devcontainer using [GitHub Codespaces](https://github.com/features/codespaces).

    [:::image type="icon" source="https://github.com/codespaces/badge.svg":::](https://codespaces.new/github/codespaces-blank?quickstart=1)

- A database on SQL Server, Azure SQL Database, or SQL database in Fabric with the [!INCLUDE [sssampledbobject-md](../../docs/includes/sssampledbobject-md.md)] sample schema and a valid connection string.

## Setting up

Follow these steps to configure your development environment to develop an application using the `mssql-python` Python driver.

> [!NOTE]  
> This driver uses the [Tabular Data Stream (TDS)](/openspecs/windows_protocols/ms-tds/b46a581a-39de-4745-b076-ec4dbb7d13ec) protocol, which is enabled by default in SQL Server, SQL database in Fabric and Azure SQL Database. No extra configuration is required.

### Install the mssql-python package

Get the [`mssql-python` package](https://pypi.org/project/mssql-python/) from PyPI.

1. Open a command prompt in an empty directory.

1. Install the `mssql-python` package.

   ### [Windows](#tab/windows)

   ```bash
   pip install mssql-python
   ```

   ### [Linux](#tab/linux)

   ```bash
   sudo apt-get -y install libltdl7
   pip install mssql-python
   ```

   ### [macOS](#tab/mac)

   ```bash
   brew install openssl
   pip install mssql-python
   ```

   ---

### Install python-dotenv package

Get the [`python-dotenv`](https://pypi.org/project/python-dotenv/) from PyPI.

1. In the same directory, install the `python-dotenv` package.

   ```bash
   pip install python-dotenv
   ```

### Check installed packages

You can use the PyPI command-line tool to verify that your intended packages are installed.

1. Check the list of installed packages with `pip list`.

   ```bash
   pip list
   ```

## Create new files

1. In the current directory, create a new file named `.env`.

1. Within the `.env` file, add an entry for your connection string named `SQL_CONNECTION_STRING`. Replace the example here with your actual connection string value.

   ```text
   SQL_CONNECTION_STRING="Server=<server_name>;Database={<database_name>};Encrypt=yes;TrustServerCertificate=no;Authentication=ActiveDirectoryInteractive"
   ```

   > [!TIP]  
   > The connection string used here largely depends on the type of SQL database you're connecting to. If you're connecting to an *Azure SQL Database* or a *SQL database in Fabric*, use the *ODBC* connection string from the connection strings tab. You might need to adjust the authentication type depending on your scenario. For more information on connection strings and their syntax, see [DSN and Connection String Keywords and Attributes](/sql/connect/odbc/dsn-connection-string-attribute).

1. In a text editor, create a new file named *sqltest.py*.

1. Add the following code.

   ```python
   from os import getenv
   from dotenv import load_dotenv
   from mssql_python import connect

   load_dotenv()

   with connect(getenv("SQL_CONNECTION_STRING")) as conn:
       with conn.cursor() as cursor:
           cursor.execute("SELECT TOP 3 name, collation_name FROM sys.databases")
           rows = cursor.fetchall()
           for row in rows:
               print(row.name, row.collation_name)
   ```

## Run the code

1. At a command prompt, run the following command:

   ```cmd
   python sqltest.py
   ```

1. Verify that the databases and their collations are returned, and then close the command window.

   If you receive an error:

   - Verify that the server name, database name, username, and password you're using are correct.

   - If you're running the code from a local environment, verify that the firewall of the Azure resource you're trying to access is configured to allow access from your environment's IP address.

## Related content

- [Tutorial: Design a relational database in Azure SQL Database](design-first-database-tutorial.md)
- [Microsoft Python drivers for SQL Server](/sql/connect/python/python-driver-for-sql-server/)
- [Python developer center](https://azure.microsoft.com/develop/python/?v=17.23h)
