---
title: "Global Settings (Dialogs) (AccessToSQL)"
description: "Global Settings (Dialogs) (AccessToSQL)"
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
  - "ssma.access.globalsettingsdialogs.f1"
---
# Global Settings (Dialogs) (AccessToSQL)

Use the Dialogs page of the **Global Settings** dialog box to specify the default user action and warning settings for SSMA.

To access the dialog settings on the **Tools** menu, select **Global Settings**, select **GUI** at the bottom of the left pane, and then select **Dialogs**.

## Options

#### Show Migration Wizard on startup

In SSMA for Access, you have an option to enable or disable **Migration Wizard** on startup of SSMA application. By default this option is **True**.

- If the option is set to **True**, the migration wizard dialog is shown initially when you open SSMA for Access application.

- If the option is set to **False**, the migration wizard isn't shown and you have to manually access it from the **File** menu if necessary.

#### Warn before overwriting objects

When SSMA converts objects to SQL Server, some objects might already exist in the project's SQL Server metadata. These objects might have already been converted, or the objects might simply have the same name within the target schema as objects you're going to convert.

Use this option to specify whether SSMA should prompt you for overwriting duplicate object definitions:

- If you select **True**, SSMA displays a warning dialog box when it encounters a duplicate object. In this dialog, you can specify to overwrite individual objects or all duplicate objects, or to skip individual objects or all duplicate objects.

- If you select **False**, the **Object overwrite default action** option appears where you specify the default action.

#### Object overwrite default action

This option appears if you select **False** for the **Warn before overwriting objects** option.

Use this option to specify the default object overwrite behavior:

- If you select **True**, SSMA automatically overwrites objects in the SQL Server project metadata that have the same name and are in the same target schema as the object to be converted.

- If you select **False**, SSMA doesn't overwrite object metadata during conversion.
