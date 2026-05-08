---
title: "include file"
description: "include file"
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: rotabor, alexwolf, dlevy
ms.service: azure-sql-database
ms.topic: include
ms.date: 02/03/2026
ms.custom: include file
---

For local development, make sure you're signed in with the same Microsoft Entra account you want to use to access Azure SQL Database. You can authenticate via popular development tools, such as the Azure CLI or Azure PowerShell. The development tools with which you can authenticate vary across languages.

### [Azure CLI](#tab/sign-in-azure-cli)

Sign in to Azure through the Azure CLI using the following command. This works on Windows, macOS, and Linux.

```azurecli
az login
```

### [Visual Studio](#tab/sign-in-visual-studio)

Select the **Sign in** button in the top right of Visual Studio.

:::image type="content" source="../../database/media/passwordless-connections/sign-in-visual-studio-small.png" alt-text="Screenshot showing the button to sign in to Azure using Visual Studio.":::

Sign in using the Microsoft Entra account you assigned a role to previously.

:::image type="content" source="../../database/media/passwordless-connections/sign-in-visual-studio-account-small.png" alt-text="Screenshot showing the account selection.":::

### [Visual Studio Code](#tab/sign-in-visual-studio-code)

For Visual Studio Code, sign in using the Azure CLI in the integrated terminal:

1. Open the terminal in VS Code (**Terminal > New Terminal**).
1. Sign in to Azure with the following command:

    ```azurecli
    az login
    ```

This method works reliably across Windows, macOS, and Linux.

### [PowerShell](#tab/sign-in-powershell)

Sign in to Azure using PowerShell via the following command:

```azurepowershell
Connect-AzAccount
```

---
