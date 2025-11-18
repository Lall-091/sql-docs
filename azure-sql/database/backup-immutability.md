---
title: Backup Immutability for Long-Term Retention Backups
titleSuffix: Azure SQL Database
description: Learn how Azure SQL Database immutability works for long-term retention backups and can benefit your audit environment.
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: dinethi
ms.date: 09/25/2025
ms.service: azure-sql-database
ms.subservice: backup-restore
ms.topic: concept-article
ms.custom:
  - ignite-2025
monikerRange: "=azuresql || =azuresql-db"
---
# Backup immutability for long-term retention backups in Azure SQL Database

[!INCLUDE [appliesto-sqldb](../includes/appliesto-sqldb.md)]

Backup immutability ensures that long-term retention (LTR) backups of an Azure SQL Database are stored in a **Write Once, Read Many (WORM)** state, making them non-modifiable and non-erasable for a user-defined retention period. Backup immutability provides robust protection against accidental or malicious deletion or modification—even by privileged administrators.

For more information on long-term retention for backups, see [Long-term retention backups](long-term-retention-overview.md).

When immutability is enabled, the backups are written to [Azure immutable storage](/azure/storage/blobs/immutable-storage-overview). Azure immutable storage meets all the regulatory compliance requirements, as validated by Cohasset. Azure SQL Database supports backup immutability for long-term retention (LTR) backups to help organizations meet stringent compliance and regulatory requirements such as:

- SEC Rule 17a-4(f)
- FINRA Rule 4511(c)
- CFTC Rule 1.31(c)-(d)

The Cohasset report is available in the [Microsoft Service Trust Center](https://aka.ms/AzureWormStorage). The [Azure Trust Center](https://www.microsoft.com/trust-center) contains detailed information about Microsoft's compliance certifications. To request a letter of attestation from Microsoft regarding WORM immutability compliance, contact [Azure Support](https://azure.microsoft.com/support/options/).

## Time-based and legal hold immutability

Azure SQL Database LTR backups support both **time based** and **legal hold** types of immutabilities.

**Time-based immutability** is enabled at the policy level. Once the time based immutability is enabled and **locked**, any new LTR backups taken from that point forward inherit these settings, and the backups remain immutable until the end of the configured retention period. Any changes to the LTR retention or to immutability will only apply to future backups from the time of policy change. Changes to LTR retention or immutability aren't applied retroactively to existing LTR backups.

**Legal hold immutability** is a type of immutability that can be enabled or disabled on a specific existing backup, independent of any existing time based immutability. Legal hold immutability is useful for scenarios such as auditing, legal purposes, etc. where data from specific backups must be held immutable for an unknown amount of time, typically until an audit or litigation is complete. Legal hold immutability can be enabled and disabled on a backup at any time.

> [!TIP]
> - For future backups, configure **time based immutability** at the policy level, a generally available feature.
> - For existing backups, configure **legal hold immutability**, a preview feature.

- It's possible to have both legal hold and time based immutability on a given backup.  
- Any backup can't be deleted as long as there's an immutability property on it. Even if the configured LTR retention expires, the backup is held available and immutable until any/all immutabilities are removed.

Possible actions across time based and legal hold immutability:

- When time-based immutability is in unlocked state, you either lock the immutability or disable the time-based immutability for the backups that happen while in unlocked state. Once time-based immutability is disabled for a backup/backups, it can't be enabled again for the same backups.
- To delete a backup that has immutability enabled but not locked, disable the immutability first and then delete the backup.
- As long as at least one of either time-based or legal hold immutability is in effect, the backup is held available and immutable.
- Time-based immutability is in effect until the retention of the backup expires.
- Legal hold can be applied on any backup even if already has a time-based immutability. When legal hold is applied, backups continue to be available and immutable even when the retention expires until the legal hold is removed.

## Pricing

There's no additional cost for enabling immutability on the backups.

However, once immutability is enabled and locked, the backups can't be deleted until removed. Backup storage charges continue to accrue as long as the immutable backup file exists, even if its past the configured LTR expiration date.

## Get started

To enable backup immutability for LTR backups:

- [Configure time-based backup immutability for long-term retention backups in Azure SQL Database](backup-immutability-time-based.md)
- [Configure legal hold backup immutability for long-term retention backups in Azure SQL Database](backup-immutability-legal-hold.md)

## Related content

- [Backup immutability for long-term retention backups in Azure SQL Database](backup-immutability.md)
- [Automated backups in Azure SQL Database](automated-backups-overview.md)
