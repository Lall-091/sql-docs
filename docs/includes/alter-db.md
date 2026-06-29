---
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: erinstellato
ms.date: 06/29/2026
ms.service: sql
ms.topic: include
---
  > [!NOTE] 
  > Many `ALTER DATABASE` operations invalidate the plan cache for the affected database, including changes to database options, collation, compatibility level, database-scoped configurations, and filegroup properties. After the operation clears the plan cache, subsequent query executions require recompilation, which might affect system performance.
