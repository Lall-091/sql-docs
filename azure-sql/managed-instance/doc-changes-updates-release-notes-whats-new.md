---
title: What's new?
titleSuffix: Azure SQL Managed Instance
description: Learn about the new features and documentation improvements for Azure SQL Managed Instance.
author: MashaMSFT
ms.author: mathoma
ms.reviewer: wiassaf, mathoma
ms.date: 11/18/2025
ms.service: azure-sql-managed-instance
ms.subservice: service-overview
ms.topic: whats-new
ms.custom:
  - ignite-2025
---
# What's new in Azure SQL Managed Instance?
[!INCLUDE [appliesto-sqldb-sqlmi](../includes/appliesto-sqlmi.md)]

> [!div class="op_single_selector"]
> * [Azure SQL Database](../database/doc-changes-updates-release-notes-whats-new.md?view=azuresql&preserve-view=true)
> * [Azure SQL Managed Instance](doc-changes-updates-release-notes-whats-new.md?view=azuresql&preserve-view=true)
> * [SQL Server on Azure VMs](../virtual-machines/windows/doc-changes-updates-release-notes-whats-new.md?view=azuresql&preserve-view=true)

This article summarizes the documentation changes associated with new features and improvements in the recent releases of [Azure SQL Managed Instance](https://azure.microsoft.com/updates/?product=sql-database&query=sql%20managed%20instance). To learn more about Azure SQL Managed Instance, see [What is Azure SQL Managed Instance?](sql-managed-instance-paas-overview.md)

[!INCLUDE [entra-id](../includes/entra-id.md)]

## Preview

The following table lists the features of Azure SQL Managed Instance that are currently in preview.

> [!NOTE]  
> Features currently in preview are available under [supplemental terms of use](https://azure.microsoft.com/support/legal/preview-supplemental-terms/), review for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability. Azure SQL Managed Instance provides previews to give you a chance to evaluate and [share feedback with the product group](https://feedback.azure.com/d365community/forum/a99f7006-3425-ec11-b6e6-000d3a4f0f84) on features before they become generally available (GA).

| Feature | Details |
| ---| --- |
|[Approximate or fuzzy string matching](/sql/relational-databases/fuzzy-string-match/overview)| Check if two strings are similar, and calculate the difference between two strings. Use this capability to identify strings that might be different because of character corruption.|
|[Database watcher for Azure SQL](../database-watcher-overview.md) | Database watcher is a managed monitoring solution for database services in the Azure SQL family. Database watcher collects in-depth workload monitoring data to give you a detailed view of database performance, configuration, and health. Learn more about [database watcher](https://aka.ms/dbwatcher-preview-announcement).|
|[DATEADD number allows bigint](/sql/t-sql/functions/dateadd-transact-sql) | For `DATEADD (datepart, number, date)`, number can be expressed as a **bigint**.|
|[Endpoint policies](./service-endpoint-policies-configure.md) | Configure which Azure Storage accounts can be accessed from a SQL Managed Instance subnet. Grants an extra layer of protection against inadvertent or malicious data exfiltration.|
|[Modernization Advisor](../virtual-machines/modernization-advisor.md) | Use the Modernization Advisor in the Azure portal to help you determine if migrating to Azure SQL Managed Instance from a SQL Server VM saves you money or optimizes performance. |
|[SDK-style SQL project](/sql/azure-data-studio/extensions/sql-database-project-extension-sdk-style-projects) | Use [Microsoft.Build.Sql](https://www.nuget.org/packages/Microsoft.Build.Sql) for SDK-style SQL projects in the SQL Database Projects extension in Visual Studio Code. SDK-style SQL projects are especially advantageous for applications shipped through pipelines or built in cross-platform environments.|
|[Service Broker](/sql/database-engine/configure-windows/sql-server-service-broker) | Support for cross-instance message exchange using Service Broker between instances of Azure SQL Managed Instance, and between SQL Server and Azure SQL Managed Instance. |
|[SQL Server 2025 update policy](update-policy.md#sql-server-2025-update-policy) | Align your SQL managed instance database format with the SQL Server 2025 database engine. | 
|[Vector data type and functions](/sql/t-sql/data-types/vector-data-type?view=azuresqlmi-current&preserve-view=true) | Working with vector data is now easier in Azure SQL Managed Instance with the introduction of a new [vector data type](/sql/t-sql/data-types/vector-data-type?view=azuresqlmi-current&preserve-view=true) and [vector functions](/sql/t-sql/functions/vector-functions-transact-sql?view=azuresqlmi-current&preserve-view=true). For more information, see [Intelligent applications with Azure SQL Managed Instance](ai-artificial-intelligence-intelligent-applications.md#vectors). |


## General availability (GA)

The following table lists features of Azure SQL Managed Instance that have been made generally available (GA) within the last 12 months:

| Feature | GA Month | Details |
| ---| --- |--- |
|[Regular expression functions](/sql/relational-databases/regular-expressions/overview) | November 2025 | Regular expression (REGEX) functions return text based on values in a search pattern. |
|[Flexible memory](resource-limits.md#flexible-memory) | November 2025 | Save on cost by choosing the memory allocation for your [Next-gen General Purpose](service-tiers-next-gen-general-purpose-use.md) instance based on your workload needs.|
|[Next-gen General Purpose](service-tiers-next-gen-general-purpose-use.md) | November 2025 | An architectural upgrade of the General Purpose service tier that uses [Elastic SAN storage](/azure/storage/elastic-san/elastic-san-introduction) for greater resource flexibility, and improved performance while maintaining the same baseline cost as the General Purpose service tier.  |
|[Migrate SQL Server to Azure](/sql/sql-server/azure-arc/migrate-to-azure-sql-managed-instance) | October 2025 | Migrate your SQL Server enabled by Azure Arc instance to Azure SQL Managed Instance through the Azure portal.|
|[Optimized locking](/sql/relational-databases/performance/optimized-locking)| July 2025 | Azure SQL Managed Instance with the **Always-up-to-date** and **SQL Server 2025** [update policy](update-policy.md) now has optimized locking enabled for all user databases. |
|[UNISTR (Transact-SQL)](/sql/t-sql/functions/unistr-transact-sql) | July 2025 | Azure SQL Managed Instance now supports the `UNISTR` T-SQL syntax for Unicode string literals.|
|[\|\| (String concatenation)](/sql/t-sql/language-elements/string-concatenation-pipes-transact-sql?view=azuresqlmi-current&preserve-view=true) and [\|\|= (Compound assignment)](/sql/t-sql/language-elements/compound-assignment-pipes-transact-sql?view=azuresqlmi-current&preserve-view=true) syntax support | July 2025 |Azure SQL Managed Instance now supports [\|\| (String concatenation)](/sql/t-sql/language-elements/string-concatenation-pipes-transact-sql?view=azuresqlmi-current&preserve-view=true) and [\|\|= (Compound assignment)](/sql/t-sql/language-elements/compound-assignment-pipes-transact-sql?view=azuresqlmi-current&preserve-view=true) Transact-SQL syntax.|
|[Degrees of parallelism (DOP) feedback](/sql/relational-databases/performance/intelligent-query-processing-degree-parallelism-feedback?view=azuresqldb-mi-current&preserve-view=true) | July 2025|  DOP feedback improves query performance by identifying parallelism inefficiencies for repeating queries, based on elapsed time and waits. For more information, see the [Smarter Parallelism: Degree of parallelism feedback in SQL Server 2025](https://techcommunity.microsoft.com/blog/sqlserver/smarter-parallelism-degree-of-parallelism-feedback-in-sql-server-2025/4431318) blog. |
| Vector data type and functions | June 2025 | Working with vector data is now easier in Azure SQL Managed Instance with the Always-up-to-date policy, with the introduction of a new [vector data type](/sql/t-sql/data-types/vector-data-type?view=azuresqlmi-current&preserve-view=true) and [vector functions](/sql/t-sql/functions/vector-functions-transact-sql?view=azuresqlmi-current&preserve-view=true). For more information, see [Intelligent applications with Azure SQL Database](ai-artificial-intelligence-intelligent-applications.md#vectors).|
|[Zone redundancy for General Purpose](high-availability-sla-local-zone-redundancy.md#zone-redundant-availability) | June 2025|  Deploy your General Purpose SQL Managed Instance to multiple availability zones to improve the availability of your instance in the event of a disaster. | 
|[Invoke an HTTPS REST endpoint SP](/sql/relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql) | June 2025 | Use the `sp_invoke_external_rest_endpoint` stored procedure to invoke an HTTPS REST endpoint provided as an input argument to the procedure. | 
|[TLS 1.3 support for replication](replication-transactional-overview.md#tls-13-support) | May 2025 | Configure Azure SQL Managed Instance replication agents to use TLS 1.3. |
|[Free SQL Managed Instance](free-offer.md) | May 2025 | Try Azure SQL Managed Instance for free for the first 12 months after an instance is created.  |
|[JSON native data type](/sql/t-sql/data-types/json-data-type?view=azuresqlmi-current&preserve-view=true) | May 2025 | The **json** data type provides new capabilities for handling semistructured data in Azure SQL Managed Instance. |
|[JSON aggregate functions](/sql/relational-databases/json/json-data-sql-server?view=azuresqlmi-current&preserve-view=true#json-data-from-aggregates) | May 2025 | Two **json** aggregate functions (`JSON_OBJECTAGG` and `JSON_ARRAYAGG`) enable construction of JSON objects or arrays based on an aggregate from SQL data. |
|[MI link from SQL Server 2017](managed-instance-link-feature-overview.md#prerequisites) | March 2025 | Configure a link from SQL Server 2017 to Azure SQL Managed Instance. |
|[Native Windows principals](native-windows-principals.md) | February 2025 | Use the new **Windows** authentication metadata mode to allow Windows authentication or Microsoft Entra authentication (using a Windows principal metadata) with Azure SQL Managed Instance. |
|[Instance pools](instance-pools-overview.md) | November 2024 | Save on costs and share resources between multiple instances in a pool within a single virtual machine. A convenient and cost-efficient way to migrate smaller SQL Server instances to the cloud, and the only way to deploy a 2-vCore managed instance. |
|[Microsoft Entra nonunique name support](../database/authentication-microsoft-entra-create-users-with-nonunique-names.md) | November 2024 | The [CREATE USER](/sql/t-sql/statements/create-user-transact-sql) Transact-SQL (T-SQL) syntax has been extended to include `WITH OBJECT_ID` to [support creating Microsoft Entra logins and users in Azure SQL Managed Instance](../database/authentication-microsoft-entra-create-users-with-nonunique-names.md) that have nonunique names. |


## Documentation changes

Learn about significant changes to the Azure SQL Managed Instance documentation. For previous years, see the [What's new archive](doc-changes-updates-release-notes-whats-new-archive.md).

### November

| Changes | Details |
| --- | --- |
| **Regular expression functions preview** | Regular expression (REGEX) functions return text based on values in a search pattern.  Regular expression (REGEX) functions are now generally available for Azure SQL Managed Instance. For more information, see [Regular expressions](/sql/relational-databases/regular-expressions/overview) or [General Availability Announcement: Regex Support in SQL Server 2025 & Azure SQL](https://devblogs.microsoft.com/azure-sql/general-availability-announcement-regex-support-in-sql-server-2025-azure-sql/). |
|**Flexible memory GA** | Save on cost by choosing the memory allocation for your [Next-gen General Purpose](service-tiers-next-gen-general-purpose-use.md) instance based on your workload needs. This capability is now generally available. To learn more, review [Flexible memory](resource-limits.md#flexible-memory). |
|**Next-gen General Purpose GA** | An architectural upgrade of the General Purpose service tier that uses [Elastic SAN storage](/azure/storage/elastic-san/elastic-san-introduction) for greater resource flexibility, and improved performance while maintaining the same baseline cost as the General Purpose service tier. This upgrade to the service tier is now generally available (GA). To learn more, review [Next-gen General Purpose](service-tiers-next-gen-general-purpose-use.md).|

### October 

| Changes | Details |
| --- | --- |
| **Database migration GA** | Migrate your SQL Server enabled by Azure Arc instance to Azure SQL Managed Instance through the Azure portal. This feature is now generally available (GA). Review [Migrate SQL Server instance to Azure SQL Managed Instance](/sql/sql-server/azure-arc/migrate-to-azure-sql-managed-instance) to learn more. |
| **Redirect connection type default** | The [redirect connection type](connection-types-overview.md#redirect-connection-type-default) is now default for all new and existing instances. The redirect connection type has better latency and throughput performance compared to the legacy proxy connection type. SQL managed instances with the `proxyOverride` value set to `Default` before October 2025 are converted to the legacy `Proxy` connection type, which you can change to `Redirect` manually using the Azure portal or PowerShell. |

### September 

| Changes | Details |
| --- | --- |
| **New Azure SQL hub** | Choosing the right Azure SQL service can be challenging. To make this easier, we built the [Azure SQL hub at aka.ms/azuresqlhub](https://aka.ms/azuresqlhub), a new home for everything related to Azure SQL in the Azure portal. For more information, read the blog post [Introducing the Azure SQL hub: A simpler, guided entry into Azure SQL](https://aka.ms/azuresqlhubblog). | 
|**SQL Server 2025 update policy preview**|  Align your SQL managed instance database format with the SQL Server 2025 database engine. This capability is now in preview. To learn more, review [SQL Server 2025 update policy](update-policy.md#sql-server-2025-update-policy). | 


### July 2025

| Changes | Details |
| --- | --- |
| **Degrees of parallelism (DOP) feedback GA** |  DOP feedback improves query performance by identifying parallelism inefficiencies for repeating queries, based on elapsed time and waits. DOP feedback is now generally available for Azure SQL Managed Instance. To learn more, see [Degrees of parallelism (DOP) feedback](/sql/relational-databases/performance/intelligent-query-processing-degree-parallelism-feedback?view=azuresqldb-mi-current&preserve-view=true). For additional information, see the [Smarter Parallelism: Degree of parallelism feedback in SQL Server 2025](https://techcommunity.microsoft.com/blog/sqlserver/smarter-parallelism-degree-of-parallelism-feedback-in-sql-server-2025/4431318) blog. |
|**Migrate SQL Server instance to Azure preview** | Migrate your SQL Server instance enabled by Azure Arc to Azure SQL Managed Instance through the Azure portal. This feature is currently in preview. Review [Migrate SQL Server instance to Azure SQL Managed Instance](/sql/sql-server/azure-arc/migrate-to-azure-sql-managed-instance) to learn more. |
| **TLS 1.0 and 1.1 retirement FAQ** | Azure has announced that support for older TLS versions (TLS 1.0, and 1.1) ends August 31, 2025. For more information, see [TLS 1.0 and 1.1 deprecation frequently asked questions](minimal-tls-version-configure.md#upcoming-tls-10-and-11-retirement-changes-faq). Starting August 2025, versions below TLS 1.2 won't be available. |
|**Optimized locking GA**| The [optimized locking](/sql/relational-databases/performance/optimized-locking) feature is generally available for Azure SQL Managed Instance configured with the Always-up-to-date or SQL Server 2025 [update policy](update-policy.md) and enabled for all user databases.|
| **UNISTR (Transact-SQL) GA** | Azure SQL Managed Instance now supports the `UNISTR` T-SQL syntax for Unicode string literals. This capability is now generally available for Azure SQL Managed Instance. For more information, see [UNISTR (Transact-SQL)](/sql/t-sql/functions/unistr-transact-sql).|
| **\|\| (String concatenation) and \|\|= (Compound assignment) syntax support GA** | Azure SQL Managed Instance now supports [\|\| (String concatenation)](/sql/t-sql/language-elements/string-concatenation-pipes-transact-sql) and [\|\|= (Compound assignment)](/sql/t-sql/language-elements/compound-assignment-pipes-transact-sql) Transact-SQL syntax. This capability is now generally available in an Azure SQL Managed Instance.|


### June 2025

| Changes | Details |
| --- | --- |
|**Faster management operations** | The duration of management operations have improved! To learn more, review [Management operations overview](management-operations-overview.md) and [Management operations duration](management-operations-duration.md). |
| **Flexible memory preview** | Save on cost by choosing the memory allocation for your [Next-gen General Purpose](service-tiers-next-gen-general-purpose-use.md) instance based on your workload needs. This feature is currently in preview. Review [Flexible memory](resource-limits.md#flexible-memory) to learn more. |
|**Invoke an HTTPS REST endpoint SP GA** | Use the `sp_invoke_external_rest_endpoint` stored procedure to invoke an HTTPS REST endpoint provided as an input argument to the procedure. This feature is now generally available (GA). Review [Invoke an HTTPS REST endpoint SP](/sql/relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql) to learn more. | 
|**Reservations discount for zone redundancy** | Take advantage of a reservations discount for the zone redundancy addon for instances in the Business Critical service tier. Review [Reserved instance discount for zone redundancy](../database/reservations-discount-overview.md#reservations-for-zone-redundant-resources) to learn more. |
|**Zone redundancy for General Purpose GA**|  Deploy your General Purpose SQL Managed Instance to multiple availability zones to improve the availability of your instance in the event of a disaster. This capability is now generally available (GA). Review [Zone redundancy for General Purpose](high-availability-sla-local-zone-redundancy.md#zone-redundant-availability) to learn more. | 


### May 2025

| Changes | Details |
| --- | --- |
| **Approximate or fuzzy string matching preview**| Check if two strings are similar, and calculate the difference between two strings. Use this capability to identify strings that might be different because of character corruption. This capability is currently in preview for Azure SQL Managed Instance. [What is fuzzy string matching?](/sql/relational-databases/fuzzy-string-match/overview)|
| **DATEADD number allows bigint preview** | For `DATEADD (datepart, number, date)`, number can be expressed as a **bigint**. This capability is currently in preview for Azure SQL Managed Instance. For more information, see [DATEADD (Transact-SQL)](/sql/t-sql/functions/dateadd-transact-sql).|
| **Free instance GA** | The free Azure SQL Managed Instance offer is now generally available (GA), allowing you to try SQL managed instance for free, for the first 12 months after you create your instance. Review [Free SQL Managed Instance](free-offer.md) to learn more. |
| **JSON native data type GA** |  The  [**json** data type](/sql/t-sql/data-types/json-data-type?view=azuresqlmi-current&preserve-view=true) provides new capabilities for handling semistructured data in Azure SQL Managed Instance. This data type is now generally available. |
| **JSON aggregate functions GA** | Two [**json** aggregate functions `JSON_OBJECTAGG` and `JSON_ARRAYAGG`](/sql/relational-databases/json/json-data-sql-server?view=azuresqlmi-current&preserve-view=true#json-data-from-aggregates) enable construction of JSON objects or arrays based on an aggregate from SQL data. These JSON functions are now generally available. |
| **Regular expression functions preview** | Regular expression (REGEX) functions return text based on values in a search pattern. This capability is currently in preview for Azure SQL Managed Instance. For more information, see [Regular expressions](/sql/relational-databases/regular-expressions/overview). |
| **TLS 1.3 support for replication GA** | Configure Azure SQL Managed Instance replication agents to use TLS 1.3. This capability is generally available. Review [TLS 1.3 support for replication](replication-transactional-overview.md#tls-13-support) to learn more.  |
| **UNISTR (Transact-SQL) preview** | Azure SQL Managed Instance now supports the `UNISTR` T-SQL syntax for Unicode string literals. This capability is currently in preview. For more information, see [UNISTR (Transact-SQL)](/sql/t-sql/functions/unistr-transact-sql).|
| **\|\| (String concatenation) and \|\|= (Compound assignment) syntax support preview** | Azure SQL Managed Instance now supports [\|\| (String concatenation)](/sql/t-sql/language-elements/string-concatenation-pipes-transact-sql) and [\|\|= (Compound assignment)](/sql/t-sql/language-elements/compound-assignment-pipes-transact-sql) Transact-SQL syntax. This capability is currently in preview.|


### April 2025

| Changes | Details |
| --- | --- |
| **Vector data type and functions preview** | Working with vector data is now easier in Azure SQL Managed Instance with the introduction of a new [vector data type](/sql/t-sql/data-types/vector-data-type) and [vector functions](/sql/t-sql/functions/vector-functions-transact-sql). This feature is now in preview. For more information, see [Intelligent applications with Azure SQL Managed Instance](ai-artificial-intelligence-intelligent-applications.md#vectors). |


### March 2025

| Changes | Details |
| --- | --- |
|**MI link from SQL Server 2017 GA** | Configure a link from SQL Server 2017 to Azure SQL Managed Instance. This feature is generally available. Review [Managed Instance link from SQL Server 2017](managed-instance-link-feature-overview.md#) to learn more. |


### February 2025

| Changes | Details |
| --- | --- |
|**Invoke an HTTPS REST endpoint SP preview** | Use the [sp_invoke_external_rest_endpoint](/sql/relational-databases/system-stored-procedures/sp-invoke-external-rest-endpoint-transact-sql) stored procedure to invoke an HTTPS REST endpoint provided as an input argument to the procedure. This stored procedure is currently in preview for Azure SQL Managed Instance.  | 
|**Native Windows principals GA** |  Use the  **Windows** authentication metadata mode to allow Windows authentication or Microsoft Entra authentication (using a Windows principal metadata) with Azure SQL Managed Instance. This feature is now generally available (GA). Review [Native Windows principals](native-windows-principals.md) to learn more. |


### January 2025

| Changes | Details |
| --- | --- |
| **SQL Insights retired** | SQL Insights has been retired and is no longer available. Use [database watcher](../database-watcher-overview.md) or another monitoring solution to monitor Azure SQL Managed Instance. |
| **Modernization Advisor preview** | Use the **Modernization Advisor** in the Azure portal for your SQL Server on Azure VM to determine if you can save on cost or optimize your performance by migrating your workload to Azure SQL Managed Instance. This feature is currently in preview. Review [Modernization Advisor](../virtual-machines/modernization-advisor.md) to learn more. |


### November 2024

| Changes | Details |
| --- | --- |
|**Free instance offer updates** | The free offer has a few new updates, such as dramatically simplifying the upgrade of your free instance to a paid version, and viewing how many free vCore hours remain for the month. Additionally, the free offer is now available in another nine subscription types. This feature is still in preview. Review [Free offer](free-offer.md) to learn more. |
|**Instance pools GA** | Save on costs and share resources between multiple instances in a pool within a single virtual machine. A convenient and cost-efficient way to migrate smaller SQL Server instances to the cloud, and the only way to deploy a 2-vCore managed instance. And now, with [reservations support](../database/reservations-discount-overview.md), you can save significantly more on your compute by allocating your reservations to an instance pool. Instance pools are now generally available. Review [Instance pools](instance-pools-overview.md) to learn more.  |
| **Microsoft Entra nonunique name support GA** |  The [CREATE USER](/sql/t-sql/statements/create-user-transact-sql) Transact-SQL (T-SQL) syntax has been extended to include `WITH OBJECT_ID` to support creating Microsoft Entra logins and users in Azure SQL Managed Instance that have nonunique names. This feature is now generally available. For more information, see [Microsoft Entra nonunique name support](../database/authentication-microsoft-entra-create-users-with-nonunique-names.md). |

### October 2024 

| Changes | Details |
| --- | --- |
|**Fail over a link with T-SQL GA** |  You can now fail over a [Managed Instance link](managed-instance-link-feature-overview.md) by using Transact-SQL (T-SQL) commands. This feature is now generally available. Review [Fail over a link with T-SQL](managed-instance-link-failover-how-to.md?tabs=tsql#fail-over-a-database) to learn more. |
|**Link from SQL MI to SQL Server GA** |  Configure a link *from* Azure SQL Managed Instance to SQL Server 2022. This feature is now generally available. Review [Link from SQL MI to SQL Server](managed-instance-link-feature-overview.md)  to learn more.  |
|**Two-way DR with SQL Server 2022 GA** | In the event of a disaster, you can fail your SQL Server 2022 workloads to Azure SQL Managed Instance using the link, and then, once the disaster is mitigated, you can fail back to SQL Server. This feature is now generally available. Review [Two-way DR with SQL Server 2022](managed-instance-link-disaster-recovery.md) to learn more.|

### August 2024

| Changes | Details |
| --- | --- |
| **CURRENT_DATE Transact-SQL GA** | The `CURRENT_DATE` Transact-SQL (T-SQL) function returns the current database system date as a date value, without the database time and time zone offset. This function is now generally available. For more information, see [CURRENT_DATE (Transact-SQL)](/sql/t-sql/functions/current-date-transact-sql). |
| **JSON native data type preview** | The new [**JSON** native data type](/sql/t-sql/data-types/json-data-type) is currently in preview. For more information, see [JSON Type and aggregates preview](https://aka.ms/json-type-aggregates-public-preview). Your SQL managed instance must be configured with the [Always-up-to-date update policy](update-policy.md#always-up-to-date-update-policy).|
| **JSON aggregate functions preview** | Two new **JSON** aggregate functions [JSON_OBJECTAGG and JSON_ARRAYAGG](/sql/relational-databases/json/json-data-sql-server#json-data-from-aggregates) enable construction of JSON objects or arrays based on an aggregate from SQL data. For more information, see [JSON Type and aggregates preview](https://aka.ms/json-type-aggregates-public-preview).|
| **Fail over link with T-SQL preview** | You can now fail over a [Managed Instance link](managed-instance-link-feature-overview.md) by using Transact-SQL (T-SQL) commands. This capability is currently in preview starting with [SQL Server 2022 CU13 (KB5036432)](/troubleshoot/sql/releases/sqlserver-2022/cumulativeupdate13). To learn more, review [fail over a database](managed-instance-link-failover-how-to.md?tabs=tsql#fail-over-a-database). |

## Archive

For previous news, see the [What's new archive](doc-changes-updates-release-notes-whats-new-archive.md).

## Known issues

The known issues content has moved to a dedicated [known issues in SQL Managed Instance](doc-changes-updates-known-issues.md) article. 


## Contribute to content

To contribute to the Azure SQL documentation, see the [Docs contributor guide](/contribute/).
