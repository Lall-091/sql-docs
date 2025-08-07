---
title: Create Azure Functions with the SQL Bindings Extension for Visual Studio Code Through Command Palette
description: Use the Visual Studio Code command palette to create Azure functions with SQL Bindings.
author: VasuBhog
ms.author: vabhog
ms.reviewer: drskwier, maghan, randolphwest
ms.date: 11/18/2024
ms.service: sql
ms.subservice: vs-code-sql-extensions
ms.topic: conceptual
ms.collection:
  - data-tools
ms.custom: sfi-image-nochange
---

# Create Azure Functions with the SQL Bindings extension for Visual Studio Code through the Command Palette

[!INCLUDE [sql-asdb-asdbmi-asa](../../../includes/applies-to-version/sql-asdb-asdbmi-asa.md)]

## Overview

Microsoft SQL Bindings for Visual Studio Code enable users to develop Azure Functions with Azure SQL bindings. For more information, see [Create Azure Functions with the SQL Bindings extension for Visual Studio Code](create-azure-function.md). To install the extension, see [SQL Bindings extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-mssql.sql-bindings-vscode).

## Command Palette

Run the `MS SQL: Create Azure Function with SQL Binding` command from the command palette to create a new function with a SQL binding.

:::image type="content" source="media/create-azure-function-command-palette/create-azure-function-using-command-palette.png" alt-text="Screenshot of a Visual Studio Code command palette command `MS SQL: Create Azure Function with SQL Binding (preview)." lightbox="media/create-azure-function-command-palette/create-azure-function-using-command-palette.png":::

The extension then prompts you to select the object type to insert (`Input binding`) or upsert into (`Output binding`), either a `Table` or `View`.

:::image type="content" source="media/create-azure-function-command-palette/select-object-type.png" alt-text="Screenshot of a prompt to select the object type.":::

Then the extension prompts you to select a connection profile to use for the Azure Function or create a connection profile.

:::image type="content" source="media/create-azure-function-command-palette/prompt-for-connection-profile.png" alt-text="Screenshot of a prompt for connection profile.":::

Once you either select a connection profile or create a new connection profile, the extension prompts you to select the database from the selected connection to use for the Azure Function.

:::image type="content" source="media/create-azure-function-command-palette/select-database.png" alt-text="Screenshot of a prompt for a database.":::

Once you select a database, the extension prompts you to select a table, or view to use or to enter a table or view to query or upsert into. This prompt is based on the object type you selected earlier.

> [!NOTE]  
> Azure Function with SQL Binding from a `View` is only supported for `Input` bindings.

Prompt for Table:

:::image type="content" source="media/create-azure-function-command-palette/select-table.png" alt-text="Screenshot of a prompt for table.":::

Prompt for View:

:::image type="content" source="media/create-azure-function-command-palette/select-view.png" alt-text="Screenshot of a prompt for view.":::

The extension then prompts you to enter the function name to be used for the Azure Function.

:::image type="content" source="media/create-azure-function-command-palette/function-name-prompt.png" alt-text="Screenshot of a prompt to enter function name.":::

If you already have connection strings stored in the local.settings.json, then the extension prompts you to select the connection string to use for the Azure Function or create a new connection string.

:::image type="content" source="media/create-azure-function-command-palette/create-new-sql-connection-string-setting.png" alt-text="Screenshot of a prompt to select connection string setting.":::

If you select `Create new local app setting`, then the extension prompts you to enter the connection string name and value.

:::image type="content" source="media/create-azure-function-command-palette/enter-connection-string-setting-name.png" alt-text="Screenshot of a prompt to enter connection string.":::

If you're creating the `Azure Function with SQL Binding` to an existing Azure Function project, then the extension prompts you whether you would like to include the password for the connection string in the `local.settings.json` file.

:::image type="content" source="media/create-azure-function-command-palette/password-prompt.png" alt-text="Screenshot of a prompt to save the password to the SQL connection string.":::

If `Yes`, then the password is saved to the `local.settings.json` file. If `No` then the extension warns you that the password won't be saved to the `local.settings.json` file (shown here), and you need to manually add the password later to the `local.settings.json` file.

:::image type="content" source="media/create-azure-function-command-palette/do-not-save-password.png" alt-text="Screenshot of a warning to add password to SQL connection string later manually.":::

The extension then prompts you to provide the namespace for the Azure Function.  
:::image type="content" source="media/create-azure-function-command-palette/namespace-for-function.png" alt-text="Screenshot of a prompt for namespace for the Azure Function.":::

If you're creating a brand new Azure Function project with SQL binding, then the extension prompts whether you would like to include the password for the connection string in the `local.settings.json` file.

A progress notification appears to indicate that the Azure Function has completed.

:::image type="content" source="media/create-azure-function-command-palette/finished-creating-project.png" alt-text="Screenshot of an information message indicating finished creating Azure Function Project.":::

Once the Azure Function is created, the extension generates the code either for an `Input` or `Output` binding. For more information, see [Generated code for Azure functions with SQL bindings](create-azure-function.md#generated-code-for-azure-functions-with-sql-bindings).

### Open an Azure Function

Open the C# Azure Function in an editor and then run the `MS SQL: Add SQL Binding` command from the command palette to add a SQL binding to an existing function.

:::image type="content" source="media/create-azure-function-command-palette/add-sql-binding-command-palette.png" alt-text="Screenshot of a Visual Studio Code command palette command `MS SQL: Add SQL Binding (preview)." lightbox="media/create-azure-function-command-palette/add-sql-binding-command-palette.png":::

The extension then prompts you to select Azure function in the current file to add the SQL binding to.
:::image type="content" source="media/create-azure-function-command-palette/select-azure-functions-in-file.png" alt-text="Screenshot of Azure Functions found in project.":::

If you're creating an Azure Function with SQL binding from a table, the extension prompts you to select the binding type to use, either an `Input` (Retrieves data from a database) or `Output` (Save data to a database) binding.

If you already have connection strings stored in the local.settings.json, then the extension prompts you to select the connection string to use for the Azure Function or create a new connection string.

:::image type="content" source="media/create-azure-function-command-palette/create-new-sql-connection-string-setting.png" alt-text="Screenshot of a prompt to select or create a new connection string setting.":::

If you select `Create new local app setting`, then the extension prompts you to enter the connection string name and value.

:::image type="content" source="media/create-azure-function-command-palette/enter-connection-string-setting-name.png" alt-text="Screenshot of a prompt to enter connection string.":::

The extension then prompts you to select a connection string method to select a connection profile or enter a connection string to use for the SQL binding.

:::image type="content" source="media/create-azure-function-command-palette/select-connection-string-method.png" alt-text="Screenshot of a prompt to select connection string setting method." lightbox="media/create-azure-function-command-palette/select-connection-string-method.png":::

If you decide to select a connection profile, the extension prompts you to select the database from the selected connection to use for the Azure Function.

Once you select a database, the extension prompts you to select a table to use, or to enter a table or view to query or upsert into.

Prompt for Table:

The extension then prompts you whether you would like to include the password for the connection string in the `local.settings.json` file.

:::image type="content" source="media/create-azure-function-command-palette/password-prompt.png" alt-text="Screenshot of a prompt to save the password to the SQL connection string.":::

If `Yes`, then the password is saved to the `local.settings.json` file. If `No` then the extension warns you that the password won't be saved to the `local.settings.json` file (shown here), and you need to manually add the password later to the `local.settings.json` file.

:::image type="content" source="media/create-azure-function-command-palette/do-not-save-password.png" alt-text="Screenshot of a warning to add password to SQL connection string later manually.":::

Once the Azure Function is created, the extension generates the code either for an `Input` or `Output` binding. For more information, see [Generated code for Azure functions with SQL bindings](create-azure-function.md#generated-code-for-azure-functions-with-sql-bindings).

## Related content

- [Create Azure Functions with the SQL Bindings extension for Visual Studio Code](create-azure-function.md)
- [Learn more about SQL Bindings for Azure Functions](/azure/azure-functions/functions-bindings-azure-sql)
- [Create Azure Functions with the SQL Bindings extension for Visual Studio Code through the Object Explorer](create-azure-function-object-explorer.md)
