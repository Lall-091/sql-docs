---
title: "Refresh from Database (AccessToSQL)"
description: "Refresh from Database (AccessToSQL)"
author: nilabjaball
ms.author: niball
ms.reviewer: randolphwest
ms.date: 12/30/2025
ms.service: sql
ms.subservice: ssma
ms.topic: article
ms.collection:
  - sql-migration-content
---
# Refresh from Database (AccessToSQL)

The **Refresh from Database** dialog box in SQL Server Migration Assistant (SSMA) lets you select which objects to refresh from the Access database. Rows in the dialog box are color coded based on the state of the metadata:

- If the object metadata changed locally and in the Access database, the row is *blue*.

- If the object metadata changed in the Access database but not in SSMA, the row is *yellow*.

- If the object metadata changed locally, but not in the Access database, the row is *green*.

- If the object is new in the Access database, the row is pink.

You can specify default object refresh settings in the **Project Settings** dialog box. For more information, see [Project Settings (Loading Objects)](project-settings-loading-objects-accesstosql.md)

To access the **Refresh from Database** dialog box, right-click any **database** node in Access Metadata Explorer and select **Refresh from Database**.
