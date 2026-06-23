---
title: "Example demonstrating use of Azure Key Vault provider with Always Encrypted"
description: "Learn how to use the Azure Key Vault provider with Always Encrypted in Microsoft.Data.SqlClient to access encrypted columns from .NET applications."
author: dlevy-msft-sql
ms.author: dlevy
ms.reviewer: davidengel, paulmedynski, cmalhotra
ms.date: 06/23/2026
ms.service: sql
ms.subservice: connectivity
ms.topic: tutorial
---

# Example demonstrating use of Azure Key Vault provider with Always Encrypted

[!INCLUDE [sqlserver2019-windows-only](../../../includes/applies-to-version/sqlserver2019-windows-only.md)]

This example demonstrates how to use the Azure Key Vault provider to access encrypted columns.

## AzureKeyVaultProvider v2.0+

[!code-csharp [Azure Key Vault Provider 2.0 Example#1](~/../sqlclient/doc/samples/AzureKeyVaultProviderExample_2_0.cs#1)]

## AzureKeyVaultProvider v1.x

[!code-csharp [Azure Key Vault Provider Example#1](~/../sqlclient/doc/samples/AzureKeyVaultProviderExample.cs#1)]

> [!NOTE]
>
> - To use the Always Encrypted feature without secure enclaves for a .NET Standard application, you need **Microsoft.Data.SqlClient** 2.1.0 or later. .NET Standard 2.0 or later is supported.
>
> - To use the Always Encrypted feature on Linux and macOS, you need **Microsoft.Data.SqlClient** 2.1.0 or later.

## Related content

- [Example demonstrating use of Azure Key Vault provider with Always Encrypted enabled with secure enclaves](azure-key-vault-enclave-example.md)
- [Tutorial: Develop a .NET application using Always Encrypted with secure enclaves](tutorial-always-encrypted-enclaves-develop-net-apps.md)
- [Using Always Encrypted with the Microsoft .NET Data Provider for SQL Server](sqlclient-support-always-encrypted.md)
