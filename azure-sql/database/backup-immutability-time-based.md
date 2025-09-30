---
title: Configure Time Based Backup Immutability for Long-Term Retention Backups
titleSuffix: Azure SQL Database
description: Learn how to configure time-based backup immutability for long-term retention backups.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: dinethi
ms.date: 09/29/2025
ms.service: azure-sql-database
ms.subservice: backup-restore
ms.topic: how-to
monikerRange: "=azuresql || =azuresql-db"
---
# Configure time-based backup immutability for long-term retention backups in Azure SQL Database

[!INCLUDE [appliesto-sqldb](../includes/appliesto-sqldb.md)]

In this article, learn how to configure **time-based backup immutability** for long-term retention (LTR) backups in Azure SQL Database.

[Backup immutability for long-term retention backups](backup-immutability.md) is available in two modes: time-based immutability and legal hold immutability.

To configure time-based backup immutability for future backups, you'll **create** an LTR policy, **enable** the policy, and then **lock** it. Once locked, backups can't be deleted or modified until the retention period expires.

## Prerequisites

1. An active Azure subscription.
1. An existing Azure SQL Database.
1. Existing long-term retention (LTR) backups.

## Permissions

You need to be a member of the Subscription Contributor role or higher permissions for the logical server of the Azure SQL Database to configure backup immutability for LTR backups and delete LTR backups.

For permissions to view, managed, and delete LTR backups, see [Manage Azure SQL Database long-term backup retention](long-term-backup-retention-configure.md#permissions).

## Create time-based immutability policy for LTR backups

> [!IMPORTANT]
> Only backups taken after enabling and locking the policy will be immutable. To make existing backups immutable, instead use [legal hold immutability](backup-immutability-legal-hold.md).

#### [Azure portal](#tab/azure-portal)

**To enable and lock time-based immutability from the Azure portal:**

1. Navigate to your Azure SQL Database logical server.
1. Under **Data management**, navigate to the **Backups** tab.
1. Select the **Retention Policies** tab.
1. Choose the database.
1. Select **Configure Policies**.

   :::image type="content" source="media/backup-immutability-time-based/azure-portal-retention-policies.png" alt-text="Screenshot from the Azure portal of the page to manage database backups." lightbox="media/backup-immutability-time-based/azure-portal-retention-policies.png":::

1. In the **Configure policies** page, under **LTR Immutability**, check the box to **Enable time-based immutability policy**.
1. Check the box to **Lock the time-based immutable policy**. Backups aren't immutable until the policy is locked. If you choose not to lock the policy, you'll need to manually [lock backups to enable immutability](#lock-immutability-for-backups).

   :::image type="content" source="media/backup-immutability-time-based/enable-or-lock.png" alt-text="Screenshot from the Azure portal of the Configure policies page. The Enable time-based immutability policy and Lock time-based immutability policy checkboxes are checked." lightbox="media/backup-immutability-time-based/enable-or-lock.png":::

#### [PowerShell](#tab/azure-powershell)

**To enable and lock time-based immutability with PowerShell:**

```powershell
Set-AzSqlDatabaseBackupLongTermRetentionPolicy
    -ServerName myAzureSQL
    -DatabaseName  mysqldb
    -ResourceGroupName myRG
    -WeeklyRetention P8D
    -TimeBasedImmutability Enabled
    -TimeBasedImmutabilityMode Locked
```



---

## Lock immutability for backups

You can choose to enable but not lock the time-based immutability policy.

For backups that have immutability enabled but not locked, there are two options:

- Lock the immutability.
- Remove immutability for each backup.

Locking immutability for specific backups can be done as follows:

#### [Azure portal](#tab/azure-portal)

**To lock time-based immutability on backups from the Azure portal:**

1. Navigate to your Azure SQL Database logical server.
1. Under **Data management**, navigate to the **Backups** tab.
1. Go to the **Manage** section under **Available LTR Backups**.
1. Select one or more backups that have time-based immutability enabled but not locked.
1. Select the **Lock** button to apply immutability.

#### [PowerShell](#tab/azure-powershell)

**To lock time-based immutability on a backup with PowerShell:**

> [!IMPORTANT]
> The command needs to be run independently for each of the LTR backups that have immutability enabled but not locked.

```powershell
Lock-AzSqlDatabaseLongTermRetentionBackupImmutability
    -Location southeastasia
    -ServerName myAzureSQL
    -DatabaseName mysqldb
    -BackupName 'myLTRbackup-1-24'
    -ResourceGroupName testrg
```


---

## Remove immutability for backups

For backups that have immutability enabled but not locked, the immutability can be removed as follows:

#### [Azure portal](#tab/azure-portal)

**To remove immutability on a backup from the Azure portal:**

1. Navigate to your Azure SQL Database logical server.
1. Under **Data management**, navigate to the **Backups** tab.
1. Go to the **Manage** section under **Available LTR Backups**.
1. Select one or more backups that have time-based immutability enabled but not locked.
1. Select the **Disable** button to remove immutability.

#### [PowerShell](#tab/azure-powershell)

**To remove immutability on a backup with PowerShell:**

```powershell
Remove-AzSqlDatabaseLongTermRetentionBackupImmutability
    -Location southeastasia
    -ServerName myAzureSQL
    -DatabaseName mysqldb
    -BackupName 'myLTRbackup-1-24'
    -ResourceGroupName testrg
```


---

## Disable immutability policy

Immutability can be disabled from the LTR policy configuration page in the Azure portal and PowerShell.

Once immutability is disabled, any new LTR backups from this point won't be protected from immutability. Any existing LTR backups however, will continue to be immutable, if already locked as immutable.

#### [Azure portal](#tab/azure-portal)

**To disable a backup immutability policy in the Azure portal:**

1. Navigate to your Azure SQL Database logical server.
1. Under **Data management**, navigate to the **Backups** tab.
1. Select the **Retention Policies** tab.
1. Choose the database.
1. Select **Configure Policies**.
1. Uncheck **Enable time-based immutability policy**.

#### [PowerShell](#tab/azure-powershell)

**To disable a backup immutability policy with PowerShell:**

```powershell
Set-AzSqlDatabaseBackupLongTermRetentionPolicy
    -ServerName myAzureSQL
    -DatabaseName  mysqldb
    -ResourceGroupName myRG
    -WeeklyRetention P8D
    -TimeBasedImmutability Disabled
```


---

## Related content

- [Configure legal hold backup immutability for long-term retention backups in Azure SQL Database](backup-immutability-legal-hold.md)
- [Backup immutability for long-term retention backups in Azure SQL Database](backup-immutability.md)
- [Automated backups in Azure SQL Database](automated-backups-overview.md)
