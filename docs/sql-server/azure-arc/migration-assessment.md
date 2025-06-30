---
title: Assess Migration Readiness
description: Select the optimal Azure SQL target using migration assessment with SQL Server enabled by Azure Arc.
author: ajithkr-ms
ms.author: ajithkr
ms.reviewer: mikeray, randolphwest
ms.date: 06/30/2025
ms.topic: how-to
---

# Assess migration readiness - SQL Server enabled by Azure Arc

[!INCLUDE [sqlserver](../../includes/applies-to-version/sqlserver.md)]

SQL Server enabled by Azure Arc, automatically produces an assessment for migration to Azure. This assessment plays a vital role in the success of your cloud migration and modernization journey. Azure Arc simplifies the discovery process and readiness assessment for migration.

The assessment:

- Provides cloud readiness, identifies risks, and offers mitigation strategies.
- Provides the specific service tier and Azure SQL configuration for each Azure SQL migration target type, that best fits the workload needs.
- Provides retail prices for the suggested configuration for each Azure SQL migration target type.
- Suggests the best Azure SQL migration target type based on migration strategy chosen.
- Is generated automatically.
- Runs continuously on a default schedule of once per week.
- Is free, and available for all SQL Server editions.

You can obtain a migration assessment for SQL Servers located anywhere:

- Your data center
- Edge site locations, such as retail stores
- Public cloud or hosting provider

The assessment is available for any instance of SQL Server enabled by Azure Arc.

## SQL Server migration assessment features

### Azure SQL readiness assessment

Evaluate and measure the readiness of SQL Servers for migration to Azure SQL. This process

- Discovers and assesses the SQL Server instance and databases
- Pinpoints SQL Server workloads that are ready for migration
- Identifies potential compatibility issues with the target environment
- Assesses migration risks
- Provides recommendations to mitigate these risks

### Azure SQL size recommendations

Provides best-fit recommendations, including the service tier and right-sizing based on performance history.

### Azure price estimates

Estimate retail cost based on the size recommendation and the following parameters

#### Fixed parameters

- Region: West US
- Currency: USD
- Uptime: 732 hours per month (24 hours * 30.5 days)

#### Configurable parameters

- **Pricing options** - Enable [special offers and benefits](https://azure.microsoft.com/pricing/offers/#cost) that can lower and optimize your costs.

  - **Azure SQL Managed Instance and Azure SQL Database savings option**: Select between one or three year reservations and reduce your resource costs.
    - three year reserved instance (default)
    - one year reserved instance
    - None
  - **SQL Server on Azure Virtual Machines savings option**: Select between one or three year reservations for consistent resource usage or special compute specific one or three year savings plan with hourly spend commitments and reduce resource costs.
    - Three year reserved instance (default)
    - One year reserved instance
    - Three year savings plan
    - One year savings plan
    - None

- **Azure Hybrid Benefit for SQL Server**: Use existing Software Assurance-enabled SQL Server licenses on Azure and reduce your costs for [Azure SQL Databases, Azure SQL Managed Instance](/azure/azure-sql/azure-hybrid-benefit), and [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/licensing-model-azure-hybrid-benefit-ahb-change#azure-hybrid-benefit).
- **Azure Hybrid Benefit for Windows**: Use existing Software Assurance-enabled Windows Server licenses on Azure and reduce your costs for [SQL Server on Azure Virtual Machines](/azure/virtual-machines/windows/hybrid-use-benefit-licensing)
- **Dev/Test Pricing**: Reduced prices for dev/test workloads available to [active Visual Studio subscribers](https://azure.microsoft.com/pricing/offers/dev-test/). Azure Hybrid Benefits for SQL Server and Windows aren't applicable under Dev/Test Pricing.

### Migration target type recommendation

Recommends a migration target type based on the estimated costs and the selected migration strategy. You can select either of the following migration strategies

- **Modernize to PaaS (default)**: This strategy suggests PaaS target types (Azure SQL Managed Instance or Azure SQL Databases) if ready, over IaaS (SQL Server on Azure Virtual Machines). The Azure SQL PaaS target types offer automated performance tuning, backups, software patching, and high-availability, all of which entails enormous effort and cost when performing manually.
- **Minimize Cost**: Suggests a target type that has the least migration issues and is the most cost effective. This strategy prioritizes least monthly cost and doesn't take into account the inherent advantages of the Azure SQL PaaS target types.

## Prerequisites

To assess SQL Server, the SQL Server instance needs to:

- Run on Windows-based SQL Server instance is connected to Azure. Follow the instructions at [Deployment options for SQL Server enabled by Azure Arc](deployment-options.md).

- Have Azure Extension for SQL Server (`WindowsAgent.SqlServer`) version **1.1.2594.118** or later.

   Learn how to [check the ](/azure/azure-arc/servers/manage-vm-extensions-portal#upgrade-extensions)**[Azure Extension for SQL Server](/azure/azure-arc/servers/manage-vm-extensions-portal#upgrade-extensions)**[ version and update to the latest.](/azure/azure-arc/servers/manage-vm-extensions-portal#upgrade-extensions)

- The server has connectivity to telemetry.{region}.arcdataservices.com (for more information, see [Network Requirements ](/azure/azure-arc/servers/network-requirements?tabs=azure-cloud))

- To view the assessment reports in Azure portal, you must be assigned an Azure role with the action `Microsoft.AzureArcData/sqlServerInstances/getTelemetry/` assigned. For convenience, you can use the built-in role *Azure Hybrid Database Administrator - Read Only Service Role*, which includes this action. For more information, review [Learn more about Azure built-in roles](/azure/role-based-access-control/built-in-roles).

## Permissions

The Azure SQL extension for SQL Server performs the assessment data collection by default under the service account, NT AUTHORITY\SYSTEM. However, you can [configure the agent extension service to run with an account that least privilege](configure-least-privilege.md).

## View migration assessment overview

1. Sign into the [Azure portal](https://portal.azure.com/) and go to your [SQL Server enabled by Azure Arc](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/sqlServers)

1. Open your SQL Server resource and select **Assessments** under **Migration** folder in the left pane.

   :::image type="content" source="media/migration-assessment/assessment-main.png" alt-text="Screenshot showing how to get to the SQL Server migration assessment report a SQL Server resource." lightbox="media/migration-assessment/assessment-main.png":::

The *Assessment completed at* indicates when the assessment was last run. To trigger an assessment immediately, select **Run assessment**.

### Review Migration strategy

The migration strategy is shown with details of the reasoning behind the recommended migration target type. The **Recommended Target** banner indicates the target type that is suggested based on the migration strategy and the estimated costs of the recommended configurations of the different target types:
- Azure SQL Managed Instance
- SQL Server on Azure Virtual Machines
- Azure SQL Database

:::image type="content" source="media/migration-assessment/assessment-overview.png" alt-text="Screenshot showing how to get to the detailed assessment results." lightbox="media/migration-assessment/assessment-overview.png":::

### Review readiness

The assessment indicates the readiness for each of the migration target types and the Azure SQL size recommendation. The readiness is calculated from the evaluation of the SQL Server instances and databases for both compatibility and resource requirements based on the performance history.

- **Ready**: The SQL Server instance or database is ready to be migrated to the specific Azure SQL target deployment option without any migration blockers. Should there be any warnings, address these issues using the provided remediation guidance.

- **Not ready**: The assessment couldn't find a configuration to meet the compatibility, configuration, and performance characteristics on Azure Virtual Machine, Azure SQL Managed Instance, or Azure SQL Database. Select the hyperlink to review the findings and recommendations to make the SQL Server instance/databases ready for the desired migration target type.

- **Unknown**: Azure Migrate can't assess readiness. This result can happen because the discovery is in progress or there are issues during discovery that need to be fixed. Check the notifications pane. If the issue persists, contact [Microsoft support](https://support.microsoft.com/en-us).

A summary of the instance and database migration readiness information is included in the details section. Select the Readiness state hyperlink to view the full assessment details.

#### Review assessment details

The assessment results are shown for each migration target type. Choose the migration target type that you want to review from the dropdown list.

##### Assessment overview

This section shows:

- Instance migration readiness: Overall migration readiness of the instance to the migration target type selected
- Database migration readiness: Summary of the readiness of the databases in this instance.
- Monthly cost estimate: Total estimated cost for the recommended configuration of the migration target of the type selected.
- SKU recommendation: Target configuration recommended based on the size calculations. See [Performance-based size calculation details](#performance-based-azure-sql-configuration-sku-size-calculation).
- Instance compatibility: Summary of instance level compatibility issues or warnings detected as part of the assessment.
- Database compatibility: Summary of database level compatibility issues or warnings detected across all databases as part of the assessment.

##### Compatibility

This section shows details of all the issues and warnings found as part of the assessment. For each finding, select the finding hyperlink to get details of the finding, with remediation recommendations and list of affected objects.

:::image type="content" source="media/migration-assessment/not-ready.png" alt-text="Screenshot showing how to get to the details of the assessment findings and mitigation guidance." lightbox="media/migration-assessment/not-ready.png":::

##### SKU Recommendation

This section includes the monthly cost estimate with the compute and storage components of the cost. The recommended configuration (SKU) and the reasoning behind the recommendation is detailed for Azure SQL Managed Instance and SQL Server on Azure Virtual Machine target types. For Azure SQL Database, a list of all database recommendations are shown. To view the reasoning behind the configuration recommendation for each database, select the corresponding hyperlink in the *Recommendation reason* column.

### Review estimated monthly cost

The total estimated monthly cost for the instance is calculated based on the target configuration recommended. This price calculation takes into account the pricing options in the assessment settings. The compute and storage components of the estimated cost are shown in the details section.

> [!NOTE]  
> Price estimation takes some time after an assessment is computed. If an assessment was recently completed, allow some time for the price estimation to complete. If new databases are added after the last assessment ran, the assessment and prices won't include these databases. You can either trigger an immediate assessment by selecting **Run Assessment** or wait for the next scheduled assessment run.

### Review target configuration recommendation

The suggested target configuration overview for each migration target type is provided along with a compute and storage configuration summary in the details section. This configuration is calculated based on the resource requirements observed from the performance data.

### Review performance data availability

Performance history for last 30 days is aggregated to determine the resource requirements. The length of performance data history available is shown. Longer data collection generally helps provide a better representation of the resource usage across any transient high and low usage period.

### Review source properties

The properties and resource requirements of the instance are detailed in this tab. To review [client connections to this instance](sql-connection-summary.md), select the hyperlink to **SQL Server Connections**.

### Review user databases

The user databases in the instance are listed in this tab with properties and resource requirement details.

## Run migration assessment

You can trigger a fresh assessment at any time. Select **Run Assessment**.

After the new assessment is complete, it replaces the last successful assessment. Scheduled migration assessments continue on schedule every Sunday at 11:00 PM (23:00) according to the local time on the SQL Server machine.

## Change assessment settings

You can change the assessment settings by selecting **Assessment settings**. Update the **Migration strategy** and **Pricing options** to suit your needs and select **Update** to let the settings take effect. Details of the pricing options and the migration strategy are provided in the [SQL Server migration assessment features](#sql-server-migration-assessment-features) section.

## Disable migration assessment

The SQL Server migration assessment automatically gets generated for every SQL Server enabled by Arc. You can disable the assessment by using, **Disable** option on the top menu bar.

## Re-enable migration assessment

Use **Enable Assessment** button to re-enable the SQL Server migration assessment.

## Performance-based Azure SQL configuration (SKU size) calculation

The assessment aggregates all the configuration and performance data and tries to find the best match across various Azure SQL service tiers and configurations. It picks a configuration that can match or exceed the SQL instance performance requirements, optimizing the cost.

SQL Server extension for Azure collects performance data for compute settings with these steps:

1. Collect a performance data sample point every 30 seconds.
1. Aggregate the sample data points collected every 30 seconds over 10 minutes. To create the data point, the size assessment selects the peak values from all samples. It gets the max, mean, and variance for performance each counter.
1. Store all the 10-minute data points for the last month.
1. Identify the appropriate data point to use for right-sizing. Identification is based on the 95% percentile values for performance history.

  For example, if the performance history is one week, the assessment sorts the 10-minute sample points for the last week. It sorts them in ascending order and picks the 95th percentile value for right-sizing. The 95th percentile value makes sure you ignore any outliers.

The high level metrics collected to decide the optimal Azure SQL target include.

[!INCLUDE [extension-logs](includes/extension-logs.md)]

## Limitations

- SQL Server migration assessment is currently limited to SQL Server running on Windows machines, doesn't apply to SQL on Linux machines.
- SQL Server running on Windows Server 2012 R2 and older versions aren't supported.

- SQL Server version must be 2012 or higher.
- Failover cluster instances (FCI) aren't supported at this time.

## Known issues

When `xp_cmdshell` is enabled and utilized, it's recorded as a warning for SQL Managed Instance since the database can still be migrated. However, it disrupts the functionality of the object that specifically uses `xp_cmdshell`. Use the remediation guidance provided in the assessment to mitigate the issue.

<a id="troubleshooting"></a>

## Troubleshoot

Contact [Microsoft support](/azure/azure-portal/supportability/how-to-create-azure-support-request) if you run into any of the following issues.

- The assessment reports don't appear on the portal even after the scheduled time.
- Performance data availability doesn't increase after one week of data gathering.

## Related content

- [Assessment rules for SQL Server to Azure SQL Managed Instance migration](/azure/azure-sql/migration-guides/managed-instance/sql-server-to-sql-managed-instance-assessment-rules)
- [Assessment rules for SQL Server to Azure SQL Database migration](/azure/azure-sql/migration-guides/database/sql-server-to-sql-database-assessment-rules)
- [Migrate SQL Server to Azure SQL](/azure/dms/dms-overview)
- [SQL Server enabled by Azure Arc](overview.md)
- [Deployment options for SQL Server enabled by Azure Arc](deployment-options.md)
