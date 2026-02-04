---
title: "Tutorial: Integrate SSIS with SQL Database in Microsoft Fabric"
description: Learn how to integrate SSIS with Fabric SQL Database
author: chugugrace
ms.author: chugu
ms.reviewer: randolphwest
ms.date: 02/02/2026
ms.service: sql
ms.subservice: integration-services
ms.topic: tutorial
ms.custom:
  - intro-deployment
  - sfi-image-nochange
---
# Integrate SSIS with SQL database in Microsoft Fabric

This tutorial shows how to connect an SSIS package to [!INCLUDE [fabric-sqldb](../../includes/fabric-sqldb.md)] using Microsoft Entra service principal authentication with the [Microsoft OLE DB Driver for SQL Server](../../connect/oledb/download-oledb-driver-for-sql-server.md).

## Authentication

Use Microsoft Entra service principal authentication for SSIS packages because they typically run non-interactively under agents. This approach provides secure app-only access without user prompts or multifactor authentication (MFA). It lets you apply least-privilege access through Fabric workspace and item permissions.

Service principal authentication aligns with `Authentication=ActiveDirectoryServicePrincipal` support in Microsoft OLE DB Driver for SQL Server version 18.5.0 and later versions, and improves auditability and secret hygiene when you store client secrets in SSIS Catalog environments or Azure Key Vault.

## Prerequisites

- A Fabric workspace with a SQL database.
- Register a service principal (app registration).
- Enable service principal access to Fabric workspace.
- Microsoft OLE DB Driver for SQL Server version 18.5.0 or later versions, including MSOLEDBSQL19.
- Outbound network access to Fabric SQL Database (Default connection policy).

## Configure SSIS OLE DB Connection Manager

Use the Microsoft OLE DB Driver for SQL Server (MSOLEDBSQL) and configure:

- **Authentication**: `ActiveDirectoryServicePrincipal`
- **User name (User ID)**: Application (client) ID of your service principal
- **Password**: Client secret associated with the app registration
- **Initial Catalog**: Fabric SQL Database name (from Settings → Connection strings)
- **Server name (Data Source)**: Fabric SQL host (for example, `<server-unique-identifer>.database.fabric.microsoft.com`)

  :::image type="content" source="media/ole-db-connection-1.png" alt-text="Screenshot of OLE DB Connection Manager part 1.":::

  :::image type="content" source="media/ole-db-connection-2.png" alt-text="Screenshot of OLE DB Connection Manager part 2." lightbox="media/ole-db-connection-2.png":::

## References

- [Authentication in SQL database in Microsoft Fabric](/fabric/database/sql/authentication)
- [Use Microsoft Entra ID](../../connect/oledb/features/using-azure-active-directory.md)
- [Connect to your SQL database in Microsoft Fabric](/fabric/database/sql/connect)
- [Download Microsoft OLE DB Driver for SQL Server](../../connect/oledb/download-oledb-driver-for-sql-server.md)
