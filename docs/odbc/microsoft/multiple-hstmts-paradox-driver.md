---
title: "Multiple hstmts (Paradox Driver)"
description: "Multiple hstmts (Paradox Driver)"
author: dlevy-msft-sql
ms.author: dlevy
ms.reviewer: davidengel, sunilbs, mcimfl
ms.date: "01/19/2017"
ms.service: sql
ms.subservice: connectivity
ms.topic: reference
helpviewer_keywords:
  - "multiple hstmts [ODBC]"
  - "Paradox driver [ODBC], multiple hstmts"
---
# Multiple hstmts (Paradox Driver)
When the ODBC Paradox driver is used, if you want to use more than one *hstmt* to execute queries on a table, the table must have a unique index (Paradox primary key).
