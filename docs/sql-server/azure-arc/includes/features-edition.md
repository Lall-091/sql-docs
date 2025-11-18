---
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: randolphwest
ms.date: 11/18/2025
ms.topic: include
ms.custom:
  - ignite-2025
---

The following table identifies features available by [!INCLUDE [ssnoversion-md](../../../includes/ssnoversion-md.md)] edition:

::: moniker range="<=sql-server-ver16 || <=sql-server-linux-ver16"

| Feature | Enterprise | Standard | Web | Express | Developer | Evaluation |
| --- | --- | --- | --- | --- | --- | --- |
| [Azure pay-as-you-go billing](../manage-configuration.md) | Yes | Yes | Not applicable | Not applicable | Not applicable | Not applicable |
| [Best practices assessment](../assess.md) | Yes | Yes | Yes | Yes | Yes | Yes |
| [Migration readiness](../migration-assessment.md) | Yes | Yes | Yes | Yes | Yes | Yes |
| [Database migration](../migrate-to-azure-sql-managed-instance.md) | LRS & <br />MI link | LRS & <br />MI link | LRS only | LRS only | LRS & <br />MI link | LRS only |
| [Detailed inventory](../view-inventory.md#inventory-databases) | Yes | Yes | Yes | Yes | Yes | Yes |
| [Microsoft Entra authentication](../../../relational-databases/security/authentication-access/azure-ad-authentication-sql-server-overview.md) | Yes | Yes | Yes | Yes | Yes | Yes |
| [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-sql-usage) | Yes | Yes | Yes | Yes <sup>1</sup> | Yes | Yes |
| [Microsoft Purview: Govern using DevOps and data owner policies](/azure/purview/tutorial-register-scan-on-premises-sql-server) | Yes | Yes | Yes | Yes | Yes | Yes |
| [Automated backups to local storage (preview)](../backup-local.md) | Yes | Yes | Yes | Yes | Yes | Yes |
| [Point-in-time-restore](../point-in-time-restore.md) | Yes | Yes | Yes | Yes | Yes | Yes |
| [Automatic updates](../update.md) | Yes | Yes | Yes | Yes | Yes | Yes |
| [Failover cluster instances](../support-for-fci.md) | Yes | Yes | Not applicable | Not applicable | Yes | Not applicable |
| [Always On availability groups](../manage-availability-group.md) | Yes | Yes | Not applicable | Not applicable | Yes | Not applicable |
| [Monitoring (preview)](../sql-monitoring.md) | Yes | Yes | No | No | No | No |
| [Client connection summary](../sql-connection-summary.md) | Yes | Yes | Yes | Yes | Yes | Yes |
| [Operate with least privilege](../configure-least-privilege.md) | Yes | Yes | Yes | Yes | Yes | Yes |

<sup>1</sup> [Express LocalDB isn't supported.](/azure/purview/register-scan-on-premises-sql-server#supported-capabilities)

::: moniker-end

::: moniker range=">=sql-server-ver17 || >=sql-server-linux-ver17"

| Feature | Enterprise <sup>1</sup> | Standard <sup>1</sup> | Express | Evaluation |
| --- | --- | --- | --- | --- |
| [Azure pay-as-you-go billing](../manage-configuration.md) | Yes | Yes | Not applicable | Not applicable |
| [Best practices assessment](../assess.md) | Yes | Yes | Yes | Yes |
| [Migration readiness (preview)](../migration-assessment.md) | Yes | Yes | Yes | Yes |
| [Detailed inventory](../view-inventory.md#inventory-databases) | Yes | Yes | Yes | Yes |
| [Microsoft Entra authentication](../../../relational-databases/security/authentication-access/azure-ad-authentication-sql-server-overview.md) | Yes | Yes | Yes | Yes |
| [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-sql-usage) | Yes | Yes | Yes <sup>2</sup> | Yes |
| [Microsoft Purview: Govern using DevOps and data owner policies](/azure/purview/tutorial-register-scan-on-premises-sql-server) | Yes | Yes | Yes | Yes |
| [Automated backups to local storage (preview)](../backup-local.md) | Yes | Yes | Yes | Yes |
| [Point-in-time-restore](../point-in-time-restore.md) | Yes | Yes | Yes | Yes |
| [Automatic updates](../update.md) | Yes | Yes | Yes | Yes |
| [Failover cluster instances](../support-for-fci.md) | Yes | Yes | Not applicable | Not applicable |
| [Always On availability groups](../manage-availability-group.md) | Yes | Yes | Not applicable | Not applicable |
| [Monitoring (preview)](../sql-monitoring.md) | Yes | Yes | No | No |
| [Client connection summary (preview)](../sql-monitoring.md) | Yes | Yes | Yes | Yes |
| [Operate with least privilege](../configure-least-privilege.md) | Yes | Yes | Yes | Yes |

<sup>1</sup> SQL Server 2025 (17.x) introduces separate Enterprise Developer and Standard Developer editions of SQL Server.

<sup>2</sup> [Express LocalDB isn't supported.](/azure/purview/register-scan-on-premises-sql-server#supported-capabilities)

::: moniker-end
