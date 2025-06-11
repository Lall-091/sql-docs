---
title: Auditing Microsoft Support Operations
titleSuffix: Azure SQL Database & Azure Synapse Analytics
description: How to use Auditing to audit Microsoft support operations.
author: sravanisaluru
ms.author: srsaluru
ms.reviewer: mathoma
ms.date: 06/10/2025
ms.service: azure-sql-database
ms.subservice: security
ms.topic: conceptual
---
# Auditing Microsoft support operations

[!INCLUDE[appliesto-sqldb-asa](../includes/appliesto-sqldb-asa.md)]

Auditing of Microsoft support operations for your [logical server](logical-servers.md) in Azure SQL Database allows you to audit Microsoft support engineers' operations when they need to access your server during a support request. The use of this capability, along with your auditing, enables more transparency into your workforce and allows for anomaly detection, trend visualization, and data loss prevention.

Auditing of Microsoft support operations includes the following set of action groups, which audit all queries executed against the database, as well as successful and failed logins by Microsoft support engineers:

- BATCH_COMPLETED_GROUP
- SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP
- FAILED_DATABASE_AUTHENTICATION_GROUP

## Enable auditing

To enable auditing of Microsoft support operations, Go to the [Azure portal](https://portal.azure.com).Navigate to **Auditing** under the **Security** heading in your Azure **SQL server** pane, and switch **Enable Auditing of Microsoft support operations** to **ON**.

To review the audit logs of Microsoft support operations in your Log Analytics workspace, use the following query:

```kusto
AzureDiagnostics
| where Category == "DevOpsOperationsAudit"
```

You have the option of choosing a different storage destination for this auditing log, or use the same auditing configuration for your server.

## Related content

- [Auditing for Azure SQL Database and Azure Synapse Analytics](auditing-overview.md)
- [What's New in Azure SQL Auditing](/Shows/Data-Exposed/Whats-New-in-Azure-SQL-Auditing)
- [Get started with Azure SQL Managed Instance auditing](../managed-instance/auditing-configure.md)
- [Auditing for SQL Server](/sql/relational-databases/security/auditing/sql-server-audit-database-engine)
