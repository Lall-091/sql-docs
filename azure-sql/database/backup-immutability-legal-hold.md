---
title: Configure Legal Hold Backup Immutability for Long-Term Retention Backups
titleSuffix: Azure SQL Database
description: Learn how to configure legal hold backup immutability for long-term retention backups.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: dinethi
ms.date: 11/06/2025
ms.service: azure-sql-database
ms.subservice: backup-restore
ms.topic: how-to
ms.custom:
  - ignite-2025
monikerRange: "=azuresql || =azuresql-db"
---
# Configure legal hold backup immutability for long-term retention backups in Azure SQL Database

[!INCLUDE [appliesto-sqldb](../includes/appliesto-sqldb.md)]

In this article, learn how to configure **legal hold backup immutability** for long-term retention (LTR) backups in Azure SQL Database.

[Backup immutability for long-term retention backups](backup-immutability.md) is available in two modes: time-based immutability and legal hold immutability.

Once locked with legal hold backup immutability, backups can't be deleted or modified until legal hold backup immutability is manually removed.

> [!NOTE]
> Legal hold backup immutability is a preview feature. [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Prerequisites

1. An active Azure subscription.
1. An existing Azure SQL Database.
1. Existing long-term retention (LTR) backups.

## Permissions

You need to be a member of the Subscription Contributor role or higher permissions for the logical server of the Azure SQL Database to configure backup immutability for LTR backups and delete LTR backups.

For permissions to view, managed, and delete LTR backups, see [Manage Azure SQL Database long-term backup retention](long-term-backup-retention-configure.md#permissions).

## Enable legal hold immutability for existing LTR backups

You can enable legal hold immutability on any existing backups in the Azure portal, PowerShell, and Azure CLI. These backups are protected from any edits or deletes until the legal hold is explicitly removed.

> [!IMPORTANT]
> Legal hold backup immutability can apply only to existing backups. To make future backups automatically immutable, instead use [time-based immutability](backup-immutability-time-based.md).

#### [Azure portal](#tab/azure-portal)

**To enable legal hold backup immutability from the Azure portal:**

1. Navigate to your Azure SQL Database logical server.
1. Under **Data management**, navigate to the **Backups** tab.
1. For the desised database, under **Available LTR Backups**, select **Manage**.
1. Select one or more available backups.
1. Select **Enable Legal Hold** to enable legal hold immutability.

   :::image type="content" source="media/backup-immutability-legal-hold/enable-legal-hold.png" alt-text="Screenshot from the Azure portal showing how to enable Legal Hold backup immutability on a backup." lightbox="media/backup-immutability-legal-hold/enable-legal-hold.png":::

#### [PowerShell](#tab/azure-powershell)

**To enable legal hold backup immutability with PowerShell:**

Replace `<backup name>` with the unique identifier of the desired backup.

```powershell
Set-AzSqlDatabaseLongTermRetentionBackupLegalHold
    -Location southeastasia
    -ServerName myAzureSQL
    -DatabaseName mysqldb
    -BackupName '<backup name>'
```

#### [Azure CLI](#tab/azure-cli)

**To enable legal hold backup immutability with the Azure CLI:**

Replace `<backup name>` with the unique identifier of the desired backup.

```azurecli
az sql db ltr-backup set-legal-hold-immutability --resource-group mygroup --location southeastasia --server myserver --database mydb --name "<backup name>"
```

---

## Remove legal hold immutability

Legal hold immutability on specific backups can be disabled in the Azure portal, PowerShell, and Azure CLI.

#### [Azure portal](#tab/azure-portal)

**To remove legal hold immutability from a backup from the Azure portal:**

1. Navigate to your Azure SQL Database logical server.
1. Under **Data management**, navigate to the **Backups** tab.
1. Go to the **Manage** section under **Available LTR Backups**.
1. Select one or more backups.
1. Select **Disable Legal Hold** to remove legal hold immutability.

#### [PowerShell](#tab/azure-powershell)

**To remove legal hold immutability from a backup with PowerShell:**

Replace `<backup name>` with the unique identifier of the desired backup.

```powershell
Remove-AzSqlDatabaseLongTermRetentionBackupLegalHold
    -Location southeastasia
    -ServerName myAzureSQL
    -DatabaseName mysqldb
    -BackupName '<backup name>'
```

#### [Azure CLI](#tab/azure-cli)

**To remove legal hold immutability from a backup with the Azure CLI:**

Replace `<backup name>` with the unique identifier of the desired backup.

```azurecli
az sql db ltr-backup remove-legal-hold-immutability --resource-group mygroup --location southeastasia --server myserver --database mydb --name "<backup name>"
```

---

## Related content

- [Configure time-based backup immutability for long-term retention backups in Azure SQL Database](backup-immutability-time-based.md)
- [Backup immutability for long-term retention backups in Azure SQL Database](backup-immutability.md)
- [Automated backups in Azure SQL Database](automated-backups-overview.md)
