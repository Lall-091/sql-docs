---
title: Insert Python Dataframe into SQL Table
titleSuffix: SQL machine learning
description: How to insert data from a dataframe into SQL table.
author: VanMSFT
ms.author: vanto
ms.reviewer: dlevy
ms.date: 02/03/2026
ms.service: sql
ms.subservice: machine-learning
ms.topic: how-to
ms.custom:
  - sfi-ropc-blocked
  - ignite-2025
monikerRange: ">=sql-server-2017 || >=sql-server-linux-ver15 || =azuresqldb-mi-current || =azuresqldb-current || =fabric-sqldb"
---
# Insert Python dataframe into SQL table

[!INCLUDE [SQL Server SQL DB SQL MI FabricSQLDB](../../includes/applies-to-version/sql-asdb-asdbmi-fabricsqldb.md)]

This article describes how to insert a [pandas](https://pandas.pydata.org/) dataframe into a SQL database using the [mssql-python](../../connect/python/mssql-python/python-sql-driver-mssql-python.md) driver in Python.

## Prerequisites

::: moniker range=">=sql-server-2017||>=sql-server-linux-ver15"
- [SQL Server for Windows](../../database-engine/install-windows/install-sql-server.md) or [For Linux](../../linux/sql-server-linux-overview.md)
  ::: moniker-end

::: moniker range="=azuresqldb-current"
- [Azure SQL Database](/azure/sql-database/sql-database-get-started-portal)
  ::: moniker-end

::: moniker range="=fabric-sqldb"
- [SQL database in Fabric](/fabric/database/sql/create)
  ::: moniker-end

::: moniker range="=azuresqldb-mi-current"
- [Azure SQL Managed Instance](/azure/azure-sql/managed-instance/instance-create-quickstart)

- [SQL Server Management Studio](/ssms/install/install) for restoring the sample database to Azure SQL Managed Instance.
  ::: moniker-end

- Azure Data Studio. To install, see [Download and install Azure Data Studio](/azure-data-studio/download-azure-data-studio).

- Follow the steps in [AdventureWorks sample databases](../../samples/adventureworks-install-configure.md) to restore the OLTP version of the AdventureWorks sample database for your version of SQL Server.

  You can verify that the database was restored correctly by querying the **HumanResources.Department** table:

  ```sql
  USE AdventureWorks;
  SELECT * FROM HumanResources.Department;
  ```

## Install Python packages

### Install mssql-python

[!INCLUDE [mssql-python-linux-macos-prereqs](../../includes/mssql-python-linux-macos-prereqs.md)]

### Install other packages

1. In Azure Data Studio, open a new notebook and connect to the Python 3 kernel.

1. Select **Manage Packages**.

   :::image type="content" source="../media/python-dataframe-sql-server/manage-packages.png" alt-text="Manage packages":::

1. In the **Manage Packages** pane, select the **Add new** tab.

1. Enter `pandas`, select **Search**, then select **Install**.

## Create a sample CSV file

Copy the following text and save it to a file named `department.csv`.

```text
DepartmentID,Name,GroupName,
1,Engineering,Research and Development,
2,Tool Design,Research and Development,
3,Sales,Sales and Marketing,
4,Marketing,Sales and Marketing,
5,Purchasing,Inventory Management,
6,Research and Development,Research and Development,
7,Production,Manufacturing,
8,Production Control,Manufacturing,
9,Human Resources,Executive General and Administration,
10,Finance,Executive General and Administration,
11,Information Services,Executive General and Administration,
12,Document Control,Quality Assurance,
13,Quality Assurance,Quality Assurance,
14,Facilities and Maintenance,Executive General and Administration,
15,Shipping and Receiving,Inventory Management,
16,Executive,Executive General and Administration
```

## Create a new database table

1. Follow the steps in [Connect to a SQL Server](../../azure-data-studio/quickstart-sql-server.md?view=sql-server-ver15&preserve-view=true#connect-to-a-sql-server) to connect to the AdventureWorks database.

1. Create a table named **HumanResources.DepartmentTest**. You use the SQL table for the dataframe insertion.

   ```sql
   CREATE TABLE [HumanResources].[DepartmentTest](
   [DepartmentID] [smallint] NOT NULL,
   [Name] [dbo].[Name] NOT NULL,
   [GroupName] [dbo].[Name] NOT NULL
   )
   GO
   ```

## Load a dataframe from the CSV file

Use the Python `pandas` package to create a dataframe, load the CSV file, and then load the dataframe into the new SQL table, **HumanResources.DepartmentTest**.

1. Connect to the **Python 3** kernel.

1. Paste the following code into a code cell, updating the code with the correct values for `server`, `database`, `username`, `password`, and the location of the CSV file.

   ```Python
   from mssql_python import connect
   import pandas as pd
   # insert data from csv file into dataframe.
   # working directory for csv file: type "pwd" in Azure Data Studio or Linux
   # working directory in Windows c:\users\username
   df = pd.read_csv("c:\\user\\username\department.csv")
   # Some other example server values are
   # server = 'localhost\sqlexpress' # for a named instance
   # server = 'myserver,port' # to specify an alternate port
   server = 'yourservername'
   database = 'AdventureWorks'
   username = 'username'
   password = 'yourpassword'
   connection_string = f'Server={server};Database={database};UID={username};PWD={password};TrustServerCertificate=yes;'
   conn = connect(connection_string)
   cursor = conn.cursor()
   # Insert Dataframe into SQL Server:
   for index, row in df.iterrows():
        cursor.execute("INSERT INTO HumanResources.DepartmentTest (DepartmentID,Name,GroupName) values(?,?,?)", (row.DepartmentID, row.Name, row.GroupName))
   conn.commit()
   cursor.close()
   conn.close()
   ```

1. Run the cell.

## Confirm data in the database

Connect to the SQL kernel and AdventureWorks database and run the following SQL statement to confirm the table was successfully loaded with data from the dataframe.

```sql
SELECT count(*) from HumanResources.DepartmentTest;
```

Results

```bash
(No column name)
16
```

## Next step

> [!div class="nextstepaction"]
> [Plot histograms in Python](python-plot-histogram.md)
