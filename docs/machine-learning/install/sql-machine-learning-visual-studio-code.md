---
title: "Visual Studio Code Notebooks (Python, R)"
description: Learn how to run Python and R scripts in a notebook in Visual Studio Code with SQL Server Machine Learning Services.
author: VanMSFT
ms.author: vanto
ms.date: 12/12/2025
ms.service: sql
ms.subservice: machine-learning-services
ms.topic: how-to
ms.custom:
  - sfi-image-nochange
monikerRange: ">=sql-server-2017 || >=sql-server-linux-ver15"
---
# Run Python and R scripts in Visual Studio Code notebooks with SQL Server Machine Learning Services

[!INCLUDE [SQL Server 2017 and later](../../includes/applies-to-version/sqlserver2017.md)]

Learn how to run Python and R scripts in [Visual Studio Code](https://code.visualstudio.com) notebooks with [SQL Server Machine Learning Services](../sql-server-machine-learning-services.md). Visual Studio Code is a cross-platform development tool.

## Prerequisites

- Download and install [Visual Studio Code](https://code.visualstudio.com)) on your workstation. Visual Studio Code is cross-platform and runs on Windows, macOS, and Linux.

- Install the [Polyglot Notebooks extension](https://code.visualstudio.com/docs/languages/polyglot) for Visual Studio Code.

- A server with SQL Server Machine Learning Services installed and enabled. You can use Machine Learning Services on [Windows](sql-machine-learning-services-windows-install.md), [Linux](../../linux/sql-server-linux-setup-machine-learning.md), or [Big Data Clusters](../../big-data-cluster/machine-learning-services.md).

## Create a SQL notebook

> [!IMPORTANT]  
> Machine Learning Services runs as part of SQL Server. Therefore, you need to use a SQL kernel and not a Python kernel.

You can use Machine Learning Services in Visual Studio Code with a SQL notebook. To create a new notebook, follow these steps:

1. Select **File** and **New Notebook** to create a new notebook. The notebook uses the **SQL kernel** by default.

1. Select **Attach To** and **Change Connection**.

   :::image type="content" source="media/ads-attach-to-connection.png" alt-text="Screenshot of Visual Studio Code SQL Notebook change connection.":::

1. Connect to an existing or new SQL Server. You can either:

   1. Choose an existing connection under **Recent Connections** or **Saved Connections**.

   1. Create a new connection under **Connection Details**. Fill out the connection details to your SQL Server and database.

   :::image type="content" source="media/ads-connection-details.png" alt-text="Screenshot of Visual Studio Code SQL Notebook connection details.":::

## Run Python or R scripts

SQL Notebooks consist of code and text cells. Use code cells to run Python or R scripts through the stored procedure [sp_execute_external_scripts](../../relational-databases/system-stored-procedures/sp-execute-external-script-transact-sql.md). Use text cells to document your code in the notebook.

### Run a Python script

Follow these steps to run a Python script:

1. Select **+ Code** to add a code cell.

   :::image type="content" source="media/ads-add-code.png" alt-text="Screenshot of Visual Studio Code SQL Notebooks add code block." lightbox="media/ads-add-code.png":::

1. Enter the following script in the code cell:

   ```sql
   EXECUTE sp_execute_external_script
       @language = N'Python',
       @script = N'
               a = 1
               b = 2
               c = a/b
               d = a*b
               print(c, d)
               ';
   ```

1. Select **Run cell** (the round black arrow) or press **F5** to run the single cell.

   :::image type="content" source="media/ads-run-python.png" alt-text="Screenshot of Visual Studio Code SQL Notebooks run Python code." lightbox="media/ads-run-python.png":::

1. The result appears under the code cell.

   :::image type="content" source="media/ads-run-python-output.png" alt-text="Screenshot of Visual Studio Code SQL Notebook Python code output." lightbox="media/ads-run-python-output.png":::

### Run an R script

Follow these steps to run an R script:

1. Select **+ Code** to add a code cell.

   :::image type="content" source="media/ads-add-code.png" alt-text="Screenshot of Visual Studio Code SQL Notebooks add code block." lightbox="media/ads-add-code.png":::

1. Enter the following script in the code cell:

   ```sql
   EXECUTE sp_execute_external_script
       @language = N'R',
       @script = N'
               a <- 1
               b <- 2
               c <- a/b
               d <- a*b
               print(c(c, d))
               ';
   ```

1. Select **Run cell** (the round black arrow) or press **F5** to run the single cell.

   :::image type="content" source="media/ads-run-r.png" alt-text="Screenshot of Visual Studio Code SQL Notebooks run R code." lightbox="media/ads-run-r.png":::

1. The result appears under the code cell.

   :::image type="content" source="media/ads-run-r-output.png" alt-text="Screenshot of Visual Studio Code SQL Notebook R code output." lightbox="media/ads-run-r-output.png":::

## Related content

- [SQL Notebooks in Visual Studio Code](https://devblogs.microsoft.com/dotnet/net-interactive-with-sql-net-notebooks-in-visual-studio-code/)
- [Jupyter Notebooks in VS Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)
- [Polyglot Notebooks in VS Code](https://code.visualstudio.com/docs/languages/polyglot)
- [Quickstart: Run simple Python scripts with SQL machine learning](../tutorials/quickstart-python-create-script.md)
- [Quickstart: Run simple R scripts with SQL machine learning](../tutorials/quickstart-r-create-script.md)
