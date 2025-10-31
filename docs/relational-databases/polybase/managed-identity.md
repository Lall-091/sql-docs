---
title: Configure PolyBase Support for Managed Identity
description: Learn to configure PolyBase to query Azure resources by using managed identity.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: randolphwest
ms.date: 10/31/2025
ms.service: sql
ms.topic: concept-article
---

# Connect to Azure Storage with managed identity from PolyBase

[!INCLUDE [sqlserver2025-and-later](../../includes/applies-to-version/sqlserver2025-and-later.md)]

Starting with [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)], you can use [managed identity](../../sql-server/azure-arc/managed-identity.md) to access the following Azure resources:

- Azure Blob Storage
- Azure Data Lake

## Prerequisites

- [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)]
- [SQL Server enabled by Azure Arc](../../sql-server/azure-arc/managed-identity.md)
- Enable the `allow server scoped db credentials` server configuration option
- Give the managed identity access to the Azure Blob Storage resource.

## Update the registry

> [!WARNING]  
> [!INCLUDE [ssnoteregistry-md](../../includes/ssnoteregistry-md.md)]

Update the registry subkey `\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQLServer\FederatedAuthentication`. Add the following entries for your data storage types:

| Entry | Value |
| --- | --- |
| `AADDataLakeEndPoint` | `datalake.azure.net` |
| `AADAzureStorageEndpoint` | `storage.azure.com` |

### Registry example

The following example script inserts the registry keys for a [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] named instance called `SQL25Inst`, if it doesn't already exist:

```powershell
# Change to your SQL Server instance.
$yourInstance = "MSSQL17.SQL25Inst"

# Define the registry path
$regPath = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$($yourInstance)\MSSQLServer\FederatedAuthentication"
Write-Host "Path to be updated: $regPath"

# Ensure the path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Define the values to create
$values = @{
    "AADDataLakeEndPoint" = "datalake.azure.net"
    "AADAzureStorageEndpoint" = "storage.azure.com"
}

foreach ($name in $values.Keys) {
    $existing = Get-ItemProperty -Path $regPath -Name $name -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
        New-ItemProperty -Path $regPath -Name $name -Value $values[$name] -PropertyType String -Force
        Write-Host "Created registry value '$name' with '$($values[$name])'"
    }
    else {
        Write-Host "Registry value '$name' already exists. Skipping..."
    }
}
```

Add these keys along with the keys described in [Managed identity (preview) for SQL Server enabled by Azure Arc](../../sql-server/azure-arc/managed-identity.md?tabs=manual#update-the-registry).

## Create database scoped credentials

Add a database scoped credential for managed identity.

1. Allow server scoped database credentials. Run the following Transact-SQL query:

   ```sql
   EXECUTE sp_configure 'allow server scoped db credentials', 1;
   GO
   RECONFIGURE;
   ```

1. Create a database scoped credential. This example uses the name `managed_id`:

   ```sql
   CREATE DATABASE SCOPED CREDENTIAL [managed_id]
   WITH IDENTITY = 'Managed Identity';
   ```

## Create external data source

Create the external data source with the following settings.

### [Azure Storage account (V2)](#tab/asav2)

- **Connector location prefix**
  - `abs`

- **Location path**
  - `abs://<container_name>@<storage_account_name>.blob.core.windows.net/`, or
  - `abs://<storage_account_name>.blob.core.windows.net/<container_name>`

- **Supported locations by product / service**
  - [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] enabled by Azure Arc
  - [!INCLUDE [sssql22-md](../../includes/sssql22-md.md)]: Hierarchical namespace supported

- **Authentication**
  - Shared access signature (SAS), or
  - Managed identity

### [Azure Data Lake Storage](#tab/adls)

- **Connector location prefix**
  - `adls`

- **Location path**
  - `adls://<container_name>@<storage_account_name>.dfs.core.windows.net/`, or
  - `adls://<storage_account_name>.dfs.core.windows.net/<container_name>`

- **Supported locations by product / service**
  - [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] enabled by Azure Arc
  - [!INCLUDE [sssql22-md](../../includes/sssql22-md.md)]

- **Authentication**
  - Shared access signature (SAS), or
  - Managed identity

---

## Query a Parquet file in Azure Blob Storage

[!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] supports for managed identity through Azure Arc. For instructions, see [Managed identity (preview) for SQL Server enabled by Azure Arc](../../sql-server/azure-arc/managed-identity.md).

The following example queries a Parquet file in Azure Blob Storage:

```sql
EXECUTE sp_configure 'allow server scoped db credentials', 1;
RECONFIGURE;
GO

CREATE DATABASE SCOPED CREDENTIAL [managed_id]
WITH IDENTITY = 'Managed Identity';

CREATE EXTERNAL DATA SOURCE [my_external_data_source]
WITH (
    LOCATION = 'abs://<container>@<storage_account_name>.blob.core.windows.net/',
    CREDENTIAL = managed_id
);
```

## Errors and solutions

### External table isn't accessible (Error 16562)

You might encounter error 16562 when trying to access Azure Blob Storage or Azure Data Lake if you're missing prerequisites:

```output
Msg 16562, Level 16, State 1, Line 79
External table <name> is not accessible because location does not exist or it is used by another process.
```

Check the following items:

- The SQL Server instance is properly configured for Azure Arc. For more information, see [Managed identity (preview) for SQL Server enabled by Azure Arc](../../sql-server/azure-arc/managed-identity.md).

- The required registry entries exist.

- Verify that the `allow server scoped db credentials` server configuation option is enabled.

### File can't be opened (Error 13822)

You might encounter error 13822 when you access Azure Blob Storage or Azure Data Lake if the managed identity lacks permissions on the storage account, or network access to storage is blocked.

```output
Msg 13822, Level 16, State 1, Line 9
File <file> cannot be opened because it does not exist or it is used by another process.
```

Check the following items:

- Does the managed identity have permissions to the storage container?
- Can the managed identity access the storage container outside SQL Server?
- Is the file locked exclusively?

## Related content

- [Managed identity (preview) for SQL Server enabled by Azure Arc](../../sql-server/azure-arc/managed-identity.md)
