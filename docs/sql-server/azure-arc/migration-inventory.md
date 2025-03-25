---
title: Migration Dashboard
description: Track the SQL Server estate migration journey in Azure Arc center.
author: ajithkr-ms
ms.author: ajithkr
ms.reviewer: 
ms.date: 03/31/2025
ms.topic: how-to
---

# Track migration journey of SQL Server instances at scale using migration dashboard - SQL Server enabled by Azure Arc (preview)

[!INCLUDE [sqlserver](../../includes/applies-to-version/sqlserver.md)]

The migration dashboard is a convenient view that shows all instances of [!INCLUDE [ssazurearc](../../includes/ssazurearc.md)] and their migration readiness. [!INCLUDE [ssazurearc](../../includes/ssazurearc.md)] automatically produces an assessment for migration to Azure. This assessment plays a vital role in the success of your cloud migration and modernization journey. With this dashboard, you can track the migration journey at scale.

[!INCLUDE [azure-arc-sql-preview](includes/azure-arc-sql-preview.md)]

The dashboard provides:

- An overview of discovered SQL Server instances and databases.
- An overview of the SQL Server instances with generated assessments.
- A migration readiness summary for each Azure SQL offering.
- Rich filtering capabilities that enable you to tailor the view to your needs.

:::image type="content" source="media/migration-assessment/migration-dashboard.png" alt-text="Screenshot of the migration dashboard for SQL Server enabled by Azure Arc." lightbox="media/migration-assessment/migration-dashboard.png":::
  
## Summary of discovered SQL Server instances and databases

The first section of the dashboard provides an overview of all SQL Server instances and databases accessible to you. You can also see the distribution of the instances by version and edition.
:::image type="content" source="media/migration-assessment/dashboard-inventory.png" alt-text="Screenshot of the first section of migration dashboard for SQL Server enabled by Azure Arc. It shows the inventory of SQL Server instances and databases and distribution by version and edition." lightbox="media/migration-assessment/dashboard-inventory.png":::

## Summary of SQL Server migration assessment

This section of the dashboard provides you with an overview of the migration assessment and migration readiness of the instances of [!INCLUDE [ssazurearc](../../includes/ssazurearc.md)]. You can see how many instances have assessments available. The migration readiness for each Azure SQL offering is separately shown.

:::image type="content" source="media/migration-assessment/dashboard-assessment-overview.png" alt-text="Screenshot of the second section of migration dashboard for SQL Server enabled by Azure Arc. It shows the overview of migration assessments and migration readiness of instances and databases for each of the Azure SQL offerings." lightbox="media/migration-assessment/dashboard-assessment-overview.png":::

## Related content

- [Assess migration readiness (preview) - SQL Server enabled by Azure Arc](migration-assessment.md)
- [Assessment rules for SQL Server to Azure SQL Managed Instance migration](/azure/azure-sql/migration-guides/managed-instance/sql-server-to-sql-managed-instance-assessment-rules)
- [Assessment rules for SQL Server to Azure SQL Database migration](/azure/azure-sql/migration-guides/database/sql-server-to-sql-database-assessment-rules)
- [Migrate SQL Server to Azure SQL](/azure/dms/dms-overview)
- [SQL Server enabled by Azure Arc](overview.md)
- [Automatically connect SQL Server machines to Azure Arc](automatically-connect.md)
