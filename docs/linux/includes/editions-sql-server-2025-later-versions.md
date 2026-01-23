---
author: rwestMSFT
ms.author: randolphwest
ms.date: 11/18/2025
ms.service: sql
ms.topic: include
ms.custom:
  - linux-related-content
---
| `MSSQL_PID` | Edition |
| --- | --- |
| `Evaluation` | SQL Server Evaluation edition |
| `Express` | SQL Server Express edition |
| `StandardDeveloper`<br /><br />(For containers, use `DeveloperStandard`) | SQL Server Standard Developer edition |
| `Standard` | SQL Server Standard edition |
| `EnterpriseDeveloper`<br /><br />(For containers, use `Developer`) | SQL Server Enterprise Developer edition |
| `Enterprise` | This legacy option represents Enterprise edition Server + Client Access License (CAL) based licensing, and is limited to a maximum of 20 cores per SQL Server instance. `Enterprise` isn't available for new agreements. You should choose `EnterpriseCore` when you wish to deploy Enterprise edition. |
| `EnterpriseCore` | SQL Server Enterprise Core edition. `EnterpriseCore` represents the core-based server licensing model with no core limits. For more information, see [Compute capacity limits by edition of SQL Server](../../sql-server/compute-capacity-limits-by-edition-of-sql-server.md). |
| `A product key` | If you specify a product key, it must be in the form of `#####-#####-#####-#####-#####`, where `#` is a number or a letter. |

For more information about these editions, see [SQL Server editions](../../sql-server/editions-and-components-of-sql-server-2025.md#sql-server-editions).
