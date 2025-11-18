---
title: "Quickstart: Python SQL Driver - mssql-python Rapid Prototyping with the Python Driver for SQL Server"
description: This quickstart describes creating prototypes reports quickly using mssql-python.
author: dlevy-msft-sql
ms.author: dlevy
ms.reviewer: vanto, randolphwest
ms.date: 11/18/2025
ms.service: sql
ms.subservice: connectivity
ms.topic: quickstart-sdk
ms.custom:
  - sfi-ropc-nochange
  - ignite-2025
---

# Quickstart: Rapid prototyping with the mssql-python driver for Python

In this quickstart, you use [`Streamlit`](https://streamlit.io/) to quickly create a report, allowing you to quickly gather user feedback to ensure you're on the right track. You use the `mssql-python` driver for Python to connect to your database and read the data loaded into your report.

The `mssql-python` driver doesn't require any external dependencies on Windows machines. The driver installs everything that it needs with a single `pip` install, allowing you to use the latest version of the driver for new scripts without breaking other scripts that you don't have time to upgrade and test.

[mssql-python documentation](https://github.com/microsoft/mssql-python/wiki) | [mssql-python source code](https://github.com/microsoft/mssql-python/wiki) | [Package (PyPi)](https://pypi.org/project/mssql-python/) | [uv](https://docs.astral.sh/uv/)

## Prerequisites

- Python 3

  - If you don't already have Python, install the **Python runtime** and **Python Package Index (PyPI) package manager** from [python.org](https://www.python.org/downloads/).

  - Prefer to not use your own environment? Open as a devcontainer using [GitHub Codespaces](https://github.com/features/codespaces).

    [:::image type="icon" source="https://github.com/codespaces/badge.svg":::](https://codespaces.new/github/codespaces-blank?quickstart=1)

- [Visual Studio Code](https://code.visualstudio.com/download) with the following extensions:

  - [Python extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-python.python)

  - [(Optional) Azure Repos](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azure-repos)

- [(Optional) Azure Command-Line Interface (CLI)](/cli/azure/install-azure-cli)

- If you don't already have `uv`, install `uv` by following the instructions from [https://docs.astral.sh/uv/getting-started/installation/](https://docs.astral.sh/uv/getting-started/installation/).
- A database on SQL Server, Azure SQL Database, or SQL database in Fabric with the [!INCLUDE [sssampledbobject-md](../../../includes/sssampledbobject-md.md)] sample schema and a valid connection string.
- Install one-time operating system specific prerequisites.

  ### [Alpine](#tab/alpine-linux)

  ```console
  apk add libtool krb5-libs krb5-dev
  ```

  ### [Debian/Ubuntu](#tab/debianUbuntu-linux)

  ```console
  apt-get install -y libltdl7 libkrb5-3 libgssapi-krb5-2
  ```

  ### [RHEL](#tab/RHEL-linux)

  ```console
  dnf install -y libtool-ltdl krb5-libs
  ```

  ### [SUSE](#tab/SUSE-linux)

  ```console
  zypper install -y libltdl7 libkrb5-3 libgssapi-krb5-2
  ```

  ### [openSUSE](#tab/openSUSE-linux)

  ```console
  zypper install -y libltdl7
  ```

  ### [macOS](#tab/mac)

  ```console
  brew install openssl
  ```

   ---

### Create a SQL database

This quickstart requires the *[!INCLUDE [sssampledbnormal-md](../../../includes/sssampledbnormal-md.md)] Lightweight* schema, on Microsoft SQL Server, SQL database in Fabric or Azure SQL Database.

### [Azure SQL Database](#tab/azure-sql)

[Create a SQL database in minutes using the Azure portal](/azure/azure-sql/database/single-database-create-quickstart)

### [SQL database in Fabric](#tab/fabric-sql)

[Load AdventureWorks sample data in your SQL database in Microsoft Fabric](/fabric/database/sql/load-AdventureWorks-sample-data)

### [Microsoft SQL Server](#tab/sql-server)

[AdventureWorks sample databases](../../../samples/adventureworks-install-configure.md)

[Create a new local copy of a database in a container with sqlcmd](../../../tools/sqlcmd/quickstart-sqlcmd-create-container.md)

[Create a new SQL Server container using the MSSQL extension for Visual Studio Code](../../../tools/visual-studio-code-extensions/mssql/mssql-local-container.md)

---

## Create the project and run the code

- [Create a new project](#create-a-new-project)
- [Add dependencies](#add-dependencies)
- [Launch Visual Studio Code](#launch-visual-studio-code)
- [Update pyproject.toml](#update-pyprojecttoml)
- [Update main.py](#update-mainpy)
- [Save the connection string](#save-the-connection-string)
- [Use uv run to execute the script](#use-uv-run-to-execute-the-script)

### Create a new project

1. Open a command prompt in your development directory. If you don't have one, create a new directory called `python`, `scripts`, etc. Avoid folders on your OneDrive, the synchronization can interfere with managing your virtual environment.

1. Create a new [project](https://docs.astral.sh/uv/guides/projects/#project-structure) with `uv`.

   ```console
   uv init rapid-prototyping-qs
   cd rapid-prototyping-qs
   ```

### Add dependencies

In the same directory, install the `mssql-python`, `streamlit`, and `python-dotenv` packages.

```console
uv add mssql-python python-dotenv streamlit
```

### Launch Visual Studio Code

In the same directory, run the following command.

```console
code .
```

### Update pyproject.toml

1. The [pyproject.toml](https://docs.astral.sh/uv/concepts/projects/layout/#the-pyprojecttoml) contains the metadata for your project. Open the file in your favorite editor.

1. Update the description to be more descriptive.

   ```python
   description = "A quick example of rapid prototyping using the mssql-python driver and Streamlit."
   ```

1. Save and close the file.

### Update main.py

1. Open the file named `main.py`. It should be similar to this example.

   ```python
   def main():
    print("Hello from rapid-protyping-qs!")

    if __name__ == "__main__":
      main()
   ```

1. At the top of the file, add the following imports above the line with `def main()`.

   > [!TIP]  
   > If Visual Studio Code is having trouble resolving packages, you need to [update the interpreter to use the virtual environment](https://code.visualstudio.com/docs/python/environments).

   ```python
   from os import getenv
   from dotenv import load_dotenv
   from mssql_python import connect, Connection
   import pandas as pd
   import streamlit as st
   ```

1. Between the imports and the line with `def main()`, add the following code.

   ```python
   def page_load() -> None:
      st.set_page_config(
          page_title="View Data",
          page_icon=":bar_chart:",
          layout="wide",
          initial_sidebar_state="expanded"
      )

      st.title("AdventureWorksLT Customer Order History")

      SQL_QUERY = """SELECT c.* FROM [SalesLT].[Customer] c inner join SalesLT.SalesOrderHeader soh on c.CustomerId = soh.CustomerId;"""

      df = load_data(SQL_QUERY)

      event = st.dataframe(
          df,
          width='stretch',
          hide_index=True,
          on_select="rerun",
          selection_mode="single-row"
      )

      customer = event.selection.rows

      if len(customer) == 0:
          SQL_QUERY = """select soh.OrderDate, SUM(sod.OrderQty), SUM(sod.OrderQty * sod.UnitPrice) as spend,  pc.Name as ProductCategory from SalesLT.SalesOrderDetail sod inner join SalesLt.SalesOrderHeader soh on sod.    salesorderid = soh.salesorderid inner join SalesLt.Product p on sod.productid = p.productid inner join SalesLT.ProductCategory pc on p.ProductCategoryID = pc.ProductCategoryID GROUP BY soh.OrderDate, pc.Name ORDER     BY soh.OrderDate, pc.Name;"""
      else:
          SQL_QUERY = f"""select soh.OrderDate, SUM(sod.OrderQty), SUM(sod.OrderQty * sod.UnitPrice) as spend,  pc.Name as ProductCategory from SalesLT.SalesOrderDetail sod inner join SalesLt.SalesOrderHeader soh on sod.    salesorderid = soh.salesorderid inner join SalesLt.Product p on sod.productid = p.productid inner join SalesLT.ProductCategory pc on p.ProductCategoryID = pc.ProductCategoryID where soh.CustomerID = {df.loc    [customer, 'CustomerID'].values[0]} GROUP BY soh.OrderDate, pc.Name ORDER BY soh.OrderDate, pc.Name;"""

      st.write("Here's a summary of spend by product category over time:")
      st.bar_chart(load_data(SQL_QUERY).set_index('ProductCategory')
                   ['spend'], use_container_width=True)

      if len(customer) > 0:
          st.write(
              f"Displaying orders for Customer ID: {df.loc[customer, 'CustomerID'].values[0]}")
          SQL_QUERY = f"""SELECT * FROM [SalesLT].[SalesOrderHeader] soh  WHERE soh.CustomerID = {df.loc[customer, 'CustomerID'].values[0]};"""
          st.dataframe(load_data(SQL_QUERY), hide_index=True, width='stretch')
          SQL_QUERY = f"""SELECT sod.* FROM [SalesLT].[SalesOrderHeader] soh INNER JOIN SalesLT.SalesOrderDetail sod on soh.SalesOrderId = sod.SalesOrderId WHERE CustomerID = {df.loc[customer, 'CustomerID'].values[0]};"""
          st.dataframe(load_data(SQL_QUERY), hide_index=True, width='stretch')
   ```

1. Between the imports and `def page_load() -> None:`, add this code.

   ```python
   _connection = None

   def get_connection() -> Connection:
       global _connection
       if not _connection:
           load_dotenv()
           _connection = connect(getenv("SQL_CONNECTION_STRING"))
       return _connection

   @st.cache_data
   def load_data(SQL_QUERY) -> pd.DataFrame:
       data = pd.read_sql_query(SQL_QUERY, get_connection())
       return data
   ```

1. Find this code.

   ```python
   def main():
       print("Hello from rapid-protyping-qs!")
   ```

1. Replace it with this code.

   ```python
   def main() -> None:
       page_load()
       if _connection:
           _connection.close()
   ```

1. Save and close `main.py`.

### Save the connection string

1. Open the `.gitignore` file and add an exclusion for `.env` files. Your file should be similar to this example. Be sure to save and close it when you're done.

   ```output
   # Python-generated files
   __pycache__/
   *.py[oc]
   build/
   dist/
   wheels/
   *.egg-info

   # Virtual environments
   .venv

   # Connection strings and secrets
   .env
   ```

1. In the current directory, create a new file named `.env`.

1. Within the `.env` file, add an entry for your connection string named `SQL_CONNECTION_STRING`. Replace the example here with your actual connection string value.

   ```text
   SQL_CONNECTION_STRING="Server=<server_name>;Database={<database_name>};Encrypt=yes;TrustServerCertificate=no;Authentication=ActiveDirectoryInteractive"
   ```

   > [!TIP]  
   > The connection string used here largely depends on the type of SQL database you're connecting to. If you're connecting to an *Azure SQL Database* or a *SQL database in Fabric*, use the *ODBC* connection string from the connection strings tab. You might need to adjust the authentication type depending on your scenario. For more information on connection strings and their syntax, see [connection string syntax reference](../../odbc/dsn-connection-string-attribute.md).

### Use uv run to execute the script

> [!TIP]  
> To use Microsoft Entra Authentication in macOS, you need to be logged in via either the [Azure Repos](https://marketplace.visualstudio.com/items?itemName=ms-vscode.azure-repos) extension in Visual Studio Code or by running `az login` via the [Azure Command-Line Interface (CLI)](/cli/azure/install-azure-cli).

1. In the terminal window from before, or a new terminal window open to the same directory, run the following command.

   ```console
    uv run streamlit run main.py
   ```

1. Your report opens in a new tab in your web browser.

1. Try your report to see how it works. If you change anything, save `main.py` and use the reload option in the upper right corner of the browser window.

1. To share your prototype, copy all files except for the `.venv` folder to the other machine. The `.venv` folder is recreated with the first run.

## Next step

Visit the `mssql-python` driver GitHub repository for more examples, to contribute ideas or report issues.

> [!div class="nextstepaction"]
> [mssql-python driver on GitHub](https://github.com/microsoft/mssql-python?tab=readme-ov-file#microsoft-python-driver-for-sql-server)
