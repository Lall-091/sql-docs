---
title: Release Notes
description: Latest release notes for SQL Server enabled by Azure Arc
author: anosov1960
ms.author: sashan
ms.reviewer: mikeray, randolphwest
ms.date: 08/15/2025
ms.topic: conceptual
ms.custom:
  - ignite-2023
---

# Release notes - SQL Server enabled by Azure Arc

[!INCLUDE [sqlserver](../../includes/applies-to-version/sqlserver.md)]

This article lists:

- Release dates
- Azure extension for SQL Server version numbers
- High level feature descriptions
- Links to additional feature documentation

Extension versions are cumulative. Higher extension versions include all of the updates from previous versions. A release might also include internal features.

Only Azure extension for SQL Server agent versions released within the last year are supported.

## September 15, 2025

**Extension version**: `1.1.3176.319`

## August

**Extension version**: `1.1.3139.313`

Certain limitations in US Government Virginia have been lifted. You can now onboard environments with:

- Always On availability groups
- Associated SQL Server services:
  [!INCLUDE [sql-server-associated-services](includes/sql-server-associated-services.md)]

## August 14, 2025

SQL Server enabled by Azure Arc is generally available in US Government Virginia. For more information, review [SQL Server enabled by Azure Arc in US Government](us-government-region.md). In addition to features announced earlier, you can:

- [Subscribe to Extended Security Updates in a production environment](extended-security-updates.md#subscribe-to-extended-security-updates-in-a-production-environment)
- [Manage licensing and billing](manage-license-billing.md)

This release announces the feature is generally available. It doesn't update extension version or other components of any agent or extension.

## July 29, 2025

**Extension version**: `1.1.3119.307`

This release updates the extension to support specific cloud environments.

## July 2025

**Extension version**: `1.1.3106.305`

This release enables the following feature:
- [Migrate to Azure SQL Managed Instance directly from the Azure portal](migrate-to-azure-sql-managed-instance.md)

## June 2025

**Extension version**: `1.1.3089.297`

This release enables the following features:

- Recurring pay-as-you-go billing
- Migration assessment
  - Released for general availability
  - Improved user interface
  - Includes retail pricing information to simplify decisions
  - Recommends a single migration target type among the Azure SQL offerings based your migration strategy selection:
    - Minimize cost
    - Modernize to Platform-as-a-Service (PaaS)
  - Introduces assessment settings experience to set pricing options and migration strategy to suit your requirements

  For details, review [Assess migration readiness - SQL Server enabled by Azure Arc](migration-assessment.md).

## June 9, 2025

SQL Server enabled by Azure Arc is available as preview feature in US Government Virginia with a limited set of features. For more information, review [SQL Server enabled by Azure Arc in US Government Preview](us-government-region.md).

This release announces the preview region availability. It doesn't update extension version or other components of any agent or extension.

## May 2025

**Extension version**: `1.1.3049.285`

This version is no longer available.

## April 30, 2025

**Extension version**: `1.1.3042.282`

This version is no longer available.

## April 14, 2025

**Extension version**: `1.1.3021.274`

## March 2025

**Extension version**: `1.1.2986.256`

This release introduces:

- SQL Server client connection summary to enable migration planning (preview).

- New Arc SQL Server properties table and stored procedure in `msdb`.

## February 2025

**Extension version**: `1.1.2971.246`

This release introduces:

- Support for Windows 10 and Windows 11.

- Support for SQL Server pay-as-you-go subscriptions and Extended Security Updates subscriptions for the following services:

  [!INCLUDE [sql-server-associated-services](includes/sql-server-associated-services.md)]

  Review [Manage licensing of SQL Server associated services](manage-license-billing.md#manage-ssxs) and [Manage SQL Server ESU subscriptions for the associated services](extended-security-updates.md#esu-subscription-ssxs)

- New documentation that describes how to connect without routing through the Internet: [Connect to Azure with a private path for SQL Server enabled by Azure Arc](configure-private-path.md).

## January 2025

**Extension version**: `1.1.2914.231`

This release includes bug fixes in the high availability and disaster recovery (HADR) detection logic. Client connections to the following system databases are allowed on the free HADR replicas:

- `tempdb`
- `msdb`
- `master`
- `model`

## November 2024

**Extension version**: `1.1.2859.223`

Minor bug fixes. This release doesn't enable or introduce new features.

## October 2024

**Extension version**: `1.1.2830.214`

### Move resources

- Move instances or databases to a different subscription or resource group - general availability. Review [Move SQL Server enabled by Azure Arc resources to a new resource group or subscription](move-resources.md).

### Additional services inventory

Inventory additional service resources in portal (preview):

[!INCLUDE [sql-server-associated-services](includes/sql-server-associated-services.md)]

### ESU update to bill-back calculation

ESU sets the bill-back date to the beginning of the current ESU year based on the timestamp when ESU was enabled, or p-core ESU license was activated. For details, review [SQL Server Extended Security Updates enabled by Azure Arc](extended-security-updates.md).

### Security improvements

Various security improvements for SQL Server enabled by Azure Arc.
