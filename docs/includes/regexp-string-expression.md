---
author: MikeRayMSFT
ms.author: mikeray
ms.date: 12/23/2024
ms.service: sql
ms.topic: include
ms.custom:
  - build-2025
---

An expression of a character string.

Can be a constant, variable, or column of character string.

Data types: **char**, **nchar**, **varchar**, or **nvarchar**.

> [!NOTE]  
> The `REGEXP_LIKE`, `REGEXP_COUNT`, `REGEXP_INSTR`, and `REGEXP_SUBSTR` functions support LOB types (**varchar(max)** and **nvarchar(max)**) up to 2 MB for the *string_expression* parameter.
