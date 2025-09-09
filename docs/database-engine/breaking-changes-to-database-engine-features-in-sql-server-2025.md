---
title: "Database Engine: Breaking Changes"
titleSuffix: "SQL Server 2025 Preview"
description: Breaking changes to database engine features in SQL Server 2025 Preview.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: randolphwest
ms.date: 09/08/2025
ms.service: sql
ms.subservice: release-landing
ms.topic: conceptual
helpviewer_keywords:
  - "breaking changes 2017 [SQL Server]"
monikerRange: ">=sql-server-2017 || >=sql-server-linux-2017"
---
# Breaking changes to Database Engine features in SQL Server 2025 Preview

[!INCLUDE [sqlserver2025](../includes/applies-to-version/sqlserver2025.md)]

This article describes the breaking changes to features in the SQL Server Database Engine introduced with [!INCLUDE [sssql25-md](../includes/sssql25-md.md)]. These changes can break applications, scripts, or functionalities that are based on earlier versions of [!INCLUDE [ssNoVersion](../includes/ssnoversion-md.md)].

## Linked servers

[!INCLUDE [sssql25-md](../includes/sssql25-md.md)] includes changes to [encryption](../relational-databases/security/networking/tds-8.md) that introduce a breaking change to [linked servers](../relational-databases/linked-servers/linked-servers-database-engine.md#sql-server-2025-and-msoledbsql-version-19). These changes can break applications, scripts, or functionalities that are based on earlier versions of [!INCLUDE [ssNoVersion](../includes/ssnoversion-md.md)]. You might encounter these issues when you upgrade.

In [!INCLUDE [sssql25-md](../includes/sssql25-md.md)]:

- [Linked servers to instances of SQL Server 2025 Preview must use the `Encrypt` parameter in the connection string](../relational-databases/linked-servers/linked-servers-database-engine.md#sql-server-2025-and-msoledbsql-version-19)
- [When you migrate from previous editions of SQL Server to SQL Server 2025 Preview with Microsoft OLE DB Driver 19, existing linked server configurations can fail](../relational-databases/linked-servers/linked-servers-database-engine.md#updating-from-previous-oledb-versions)

For information about how to connect securely to [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] instances, see [TDS 8.0](../relational-databases/security/networking/tds-8.md).

## Replication

[!INCLUDE [sssql25-md](../includes/sssql25-md.md)] includes changes to [encryption](../relational-databases/security/networking/tds-8.md) that introduce a breaking change to [Transactional](../relational-databases/replication/transactional/transactional-replication.md#configure-tls-13-encryption), [Snapshot](../relational-databases/replication/snapshot-replication.md#configure-tls-13-encryption), [Peer to peer](../relational-databases/replication/transactional/peer-to-peer-transactional-replication.md#configure-tls-13-encryption) and [Merge](../relational-databases/replication/merge/merge-replication.md#configure-tls-13-encryption) replication.

In [!INCLUDE [sssql25-md](../includes/sssql25-md.md)]:

- [In-place upgrades to SQL Server 2025 Preview for instances with a remote distributor can fail](../sql-server/sql-server-2025-known-issues.md#in-place-upgrade-fails-due-to-replication)
- [Adding a remote distributor to a SQL Server 2025 Preview publisher can fail](../sql-server/sql-server-2025-known-issues.md#adding-a-remote-replication-distributor-fails)

For information about how to connect securely to [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] instances, see [TDS 8.0](../relational-databases/security/networking/tds-8.md).

## Log shipping

[!INCLUDE [sssql25-md](../includes/sssql25-md.md)] includes changes to [encryption](../relational-databases/security/networking/tds-8.md) that introduce a breaking change to [log shipping](log-shipping/about-log-shipping-sql-server.md#enforce-tls-13-encryption). You might encounter these issues when you upgrade.

Log shipping monitoring can break if the monitor is a remote [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] instance when other SQL Server instances in the log shipping topology use a previous version.

For information about how to connect securely to [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] instances, see [TDS 8.0](../relational-databases/security/networking/tds-8.md).

## PolyBase

[!INCLUDE [sssql25-md](../includes/sssql25-md.md)] includes changes to [encryption](../relational-databases/security/networking/tds-8.md) that introduce a breaking change to [PolyBase](../relational-databases/polybase/polybase-guide.md#sql-server-2025-polybase-enhancements). These changes might break applications, scripts, or functionalities that are based on earlier versions of [!INCLUDE [ssNoVersion](../includes/ssnoversion-md.md)].

In [!INCLUDE [sssql25-md](../includes/sssql25-md.md)]:

- [PolyBase component fails to start on SQL Server 2025 Preview](../relational-databases/polybase/polybase-installation.md#polybase-network-encryption)
- [SQL Server 2025 Preview PolyBase connections fail when connecting to an external SQL Server data source](../t-sql/statements/create-external-data-source-transact-sql.md#syntax-for-sql-server-2025-and-later-versions)

## Related content

- [TDS 8.0](../relational-databases/security/networking/tds-8.md)
- [Deprecated Database Engine features in SQL Server 2019 (15.x)](deprecated-database-engine-features-in-sql-server-2019.md)
- [Discontinued Database Engine functionality in SQL Server](discontinued-database-engine-functionality-in-sql-server.md)
