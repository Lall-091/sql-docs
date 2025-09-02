---
title: "SQL Server 2025 Release Notes"
description: Find information about SQL Server 2025 (17.x) limitations, known issues, help resources, and other release notes.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: randolphwest
ms.date: 09/02/2025
ms.service: sql
ms.subservice: release-landing
ms.topic: release-notes
ms.custom:
  - build-2025
monikerRange: ">=sql-server-2016"
---

# SQL Server 2025 Preview release notes

[!INCLUDE [sqlserver2025](../includes/applies-to-version/sqlserver2025.md)]

This article describes requirements, and limitations for [!INCLUDE [sssql25-md](../includes/sssql25-md.md)].

This article is updated for release candidate (RC) 0.

## Preview features

Explore preview development features with a new `PREVIEW_FEATURES` database scoped configuration. Enable `PREVIEW_FEATURES` to test some features, such as vector indexes. This configuration lets you try select features in preview even after SQL Server reaches general availability. These features will become generally available in future cumulative updates. When a cumulative update provides general availability for a feature, the database-scoped configuration is no longer be necessary for that feature.

To use these features, enable the `PREVIEW_FEATURES` [database scoped configuration](../t-sql/statements/alter-database-scoped-configuration-transact-sql.md#preview-features).

[!INCLUDE [preview-features](../includes/paragraph-content/preview-features.md)]

All other features described in the [What's new in SQL Server 2025 Preview](what-s-new-in-sql-server-2025.md) article are aligned with the release of SQL Server. They don't require enabling the preview feature database scoped configuration.

For more information, review [Opt in for preview features - FAQ](preview-features-faq.md).

### Optimized Halloween protection not available

The Optimized Halloween protection feature is not currently available in [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] starting with RC 0. For more information, see the [SQL Server 2025: introducing optimized Halloween protection](https://aka.ms/optimized-hp-blog) blog.

## Breaking changes

[!INCLUDE [sssql25-md](../includes/sssql25-md.md)] introduces breaking changes to a few SQL Server Database Engine features. To learn more, review [Breaking changes in SQL Server 2025 preview](../database-engine/breaking-changes-to-database-engine-features-in-sql-server-2025.md).

## Build number

| Build | Version number | Date |
| --- | --- | --- |
| Preview (RC 0) | 17.0.900.7 | August 20, 2025 |
| Preview (CTP 2.1) | 17.0.800.3 | June 16, 2025 |
| Preview (CTP 2.0) | 17.0.700.9 | May 19, 2025 |

## Related content

- [What's new in SQL Server 2025 Preview](what-s-new-in-sql-server-2025.md)
- [SQL Server 2025 Preview known issues](sql-server-2025-known-issues.md)
- [Hardware and software requirements for SQL Server 2025 Preview](install/hardware-and-software-requirements-for-installing-sql-server-2025.md).
