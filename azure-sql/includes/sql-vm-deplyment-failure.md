---
author: MashaMSFT
ms.author: mathoma
ms.date: 10/07/2025
ms.service: sql
ms.topic: include
---
> [!WARNING]
> SQL Server isn't currently supported on VM sizes that deploy with an uninitialized ephemeral disk. Deployments in the Azure portal can fail, and SQL Server can fail to start. Either use a different VM size, or place `tempdb` on non-ephemeral storage both when you deploy the SQL Server image through the Azure portal, and when you install SQL Server manually. To learn more, review [VM deployment and SQL Server failures](/troubleshoot/sql/azure-sql/sql-deployment-fails-drive-not-ready).