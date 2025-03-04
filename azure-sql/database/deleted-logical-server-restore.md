---
title: Restore a deleted logical server (preview)
titleSuffix: Azure SQL Database
description: Learn about restoring a deleted logical server in Azure SQL Database.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: dinethi
ms.date: 02/28/2025
ms.service: azure-sql-database
ms.subservice: backup-restore
ms.topic: how-to
ms.custom:
  - azure-sql-split
monikerRange: "=azuresql || =azuresql-db"
ROBOTS: NOINDEX
---
# Restore a deleted logical server in Azure SQL Database (preview)

[!INCLUDE [appliesto-sqldb](../includes/appliesto-sqldb.md)]

This article provides steps to restore an Azure SQL Database server, also known as a logical server, if it was accidentally deleted.

> [!IMPORTANT]
> This feature is in preview and is currently only enabled for certain subscriptions. 

You can restore a deleted Azure SQL logical server and its underlying databases with one of the following two methods:

## Restore an Azure SQL Database logical server using PowerShell and REST API

Follow these steps to set up the variables needed to restore the deleted logical server, using PowerShell to invoke a REST API call.

1. Sign in to Azure in your PowerShell terminal.

   ```powershell
   Login-AzAccount
   ```

1. Set the proper Azure context for your subscription.

   ```powershell
   $context = Get-AzContext 
   ```

1. Replace `<subscription-id>` with your subscription name.

   ```powershell
   Select-AzSubscription -Context $context -Name <subscription-id>
   ```

1. Set variables in your PowerShell terminal.

   ```powershell
   $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile 
   $profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azProfile) 
   $token = $profileClient.AcquireAccessToken($context.Tenant.TenantId) 
   $authToken = $token.AccessToken 
   $headers = @{}  
   $headers.Add('Authorization', 'Bearer ' + $authToken)
   ```

1. Replace `<subscription-id>`, `<your-resource-group-id>`, and `<your-server-id>` with the appropriate unique IDs.

   ```powershell 
   $uri="https://management.azure.com/subscriptions/<your-subscription-id>]/resourceGroups/<your-resource-group-id>/providers/Microsoft.Sql/servers/<your-server-id>?api-version=2023-05-01-preview"
   ```

   We now have the auth header ($headers) that we need to be able to run the API.  

1. Create an API call body. Replace `<Azure region name>` with your region name, for example, `East US 2`.

    ```powershell
    $body={      
      "properties": {  
        "createMode": "Restore"  
      },  
      "location": "<Azure region name>"
    }
    ```

1. Now you're ready to run the following PowerShell command to initiate the restore of the deleted Azure SQL Database logical server:

   ```powershell
   Invoke-RestMethod -Method PUT -Headers $headers -Uri $uri -ContentType 'application/json' -Body $body  
   ```

## Restore an Azure SQL Database logical server using PowerShell

Use the following steps to restore your deleted Azure SQL logical server using [Restore-AzSqlServer](/powershell/module/az.sql/restore-azsqldatabase).

1. Open a new PowerShell window.  

1. Install the `Az.Tools.Installer` module.  

   ```powershell
   Install-Module -Name Az.Tools.Installer -Repository PSGallery  
   ```

1. Install the `Az.Accounts` module.

   ```powershell
   Install-Module Az.Accounts -Repository PSGallery  
   ```

1. Use the `Az.Tools.Installer` to install the NuGet package.
  
   ```powershell
   Install-AzModule -Path https://azposhpreview.blob.core.windows.net/public/Az.Sql.5.2.0.nupkg 
   ```

1. Sign in and connect to your Azure account.

   ```powershell
   Connect-AzAccount  
   ```

1. Select the desired subscription, replace `<subscription-id>` with the subscription name.

   ```powershell
   Select-AzSubscription -Subscription "<subscription-id>"
   ```

1. Run the restore command as follows. Replace `<your-server-name>` and `<your-resource-group-id>` with your deleted logical server's name and resource group ID.

   ```powershell
   $servername = <your-server-name>
   $resourcegroup = <your-resource-group-id>
   Restore-AzSqlServer -ServerName $servername -ResourceGroup $resourcegroup
   ```

## Restore the deleted databases

Once the logical server is restored, restoring the databases is next. Look in the **Deleted databases** tab on the **Backups** page, by browsing to the server resource in Azure portal. For more information, see [Restore a database from a backup in Azure SQL Database](recovery-using-backups.md).

## Delete the logical server without recovery

To delete an Azure SQL logical server without the possibility of recovery, contact Microsoft Support and [open a support case](https://azure.microsoft.com/support/create-ticket/).

## Related content

- [Automated backups in Azure SQL Database](automated-backups-overview.md)
