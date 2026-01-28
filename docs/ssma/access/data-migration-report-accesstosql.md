---
title: "Data Migration Report (AccessToSQL)"
description: "Data Migration Report (AccessToSQL)"
author: nilabjaball
ms.author: niball
ms.reviewer: randolphwest
ms.date: 12/30/2025
ms.service: sql
ms.subservice: ssma
ms.topic: concept-article
ms.collection:
  - sql-migration-content
f1_keywords:
  - "ssma.access.datamigrationreport.f1"
---
# Data Migration Report (AccessToSQL)

The **Data Migration Report** dialog box appears after you migrate data to [!INCLUDE [ssNoVersion](../../includes/ssnoversion-md.md)].

## Options

#### Status

Shows the status of the data migration from the source to the target database.

#### From

The source table.

#### To

The target table.

#### Total Number of Rows

The number of rows of data in the source table.

#### Number of Successfully Migrated Rows

The number of rows of data successfully migrated to the target table.

#### Ratio

The percentage of rows successfully migrated.

#### Details

If any data migration failed, select to display migration details for the selected row in the report. SSMA displays the reason for the failure.

#### Save Report

Saves the report to a CSV (comma-separated values) file, which can be examined using Excel.
