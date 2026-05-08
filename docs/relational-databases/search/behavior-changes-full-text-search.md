---
title: "Behavior Changes in Full-Text Search"
titleSuffix: SQL Server Full-Text Search
description: Learn about behavior changes in SQL Server full-text search features.
author: rwestMSFT
ms.author: randolphwest
ms.date: 01/12/2026
ms.service: sql
ms.subservice: search
ms.topic: concept-article
helpviewer_keywords:
  - "full-text search [SQL Server], word breakers"
  - "full-text search [SQL Server], filters"
  - "filters [full-text search]"
  - "word breakers [full-text search]"
monikerRange: ">=sql-server-linux-ver17 || >=sql-server-ver17"
---

# Behavior changes in Full-Text Search

This article describes behavior changes in full-text search. Behavior changes affect how features work or interact in recent versions of [!INCLUDE [ssnoversion-md](../../includes/ssnoversion-md.md)] as compared to earlier versions.

## Behavior changes in Full-Text Search in SQL Server 2025

[!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] replaces legacy word breakers and filters with new and enhanced binaries. To use the new components, rebuild your existing full-text indexes.

### Support for new languages

[!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] adds support for full-text indexing in three new languages:

- Finnish (LCID 1035)
- Hungarian (LCID 1038)
- Estonian (LCID 1061)

### Support for default document extension indexing

[!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] adds support for indexing the following document extensions by default.

| Filter | Extension |
| --- | --- |
| `msgfilt02.dll` | `.msg` |
| `odffilt02.dll` | `.odp`, `.ods`, `.odt` |
| `offfilt02.dll` | `.doc`, `.dot`, `.obd`, `.obt`, `.pot`, `.pps`, `.ppt`, `.xlb`, `.xlc`, `.xls`, `.xlt` |
| `offfiltx02.dll` | `.docm`, `.docx`, `.dotx`, `.pptm`, `.pptx`, `.xlsb`, `.xlsm`, `.xlsx`, `.zip` |
| `onfilter02.dll` | `.one` |

### Unexpected results

New components in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] might return unexpected results to applications. For example, consider the English (LCID 1033) word breaker:

| Term | Results with previous word breaker | Results with new word breaker |
| --- | --- | --- |
| `cat_dog` | `cat_dog` | `cat_dog`<br />`cat`<br />`dog` |
| `$100` | `$100`<br />`nn100usd` | `\$100`<br />`nn100\$` |
| `2026-01-09` | `2026-01-09`<br />`2026`<br />`nn2026`<br />`01`<br />`09` | `2026-01-09`<br />`dd20260109`<br />`2026`<br />`01`<br />`09` |

## Related content

- [View or change registered filters and word breakers (SQL Server Search)](view-or-change-registered-filters-and-word-breakers.md)
- [Configure and Manage Filters for Search](configure-and-manage-filters-for-search.md)
- [Configure and manage word breakers and stemmers for search (SQL Server)](configure-and-manage-word-breakers-and-stemmers-for-search.md)
