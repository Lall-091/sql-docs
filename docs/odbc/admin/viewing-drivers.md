---
title: "Viewing Drivers"
description: Learn how to open the ODBC Data Source Administrator and view the ODBC drivers installed on your Windows system.
author: dlevy-msft-sql
ms.author: dlevy
ms.reviewer: davidengel, sunilbs, mcimfl
ms.date: 03/25/2026
ms.service: sql
ms.subservice: connectivity
ms.topic: concept-article
helpviewer_keywords:
  - "viewing drivers [ODBC]"
  - "ODBC data source administrator [ODBC], viewing drivers"
---
# Viewing drivers

To view installed ODBC drivers on your system, first open the ODBC Data Source Administrator, then select the **Drivers** tab.

## Open the ODBC Data Source Administrator

Use one of the following methods to open the ODBC Data Source Administrator on Windows:

- **Windows Search**: Select **Start**, type **ODBC Data Sources**, and select **ODBC Data Sources (64-bit)** or **ODBC Data Sources (32-bit)**.
- **Run dialog**: Press **Windows+R**, type `odbcad32.exe`, and select **OK**. This command opens the 64-bit version on x64 systems.
- **Control Panel**: Open **Control Panel** > **Administrative Tools** > **ODBC Data Sources**.

> [!NOTE]
> On 64-bit systems, two versions of the ODBC Data Source Administrator exist. The 64-bit version is located at `C:\Windows\System32\odbcad32.exe`. The 32-bit version is located at `C:\Windows\SysWOW64\odbcad32.exe`. Use the version that matches your driver architecture.

## View the installed drivers

The **Drivers** tab in the ODBC Data Source Administrator lists all drivers installed on your computer, including the name, version, company, file name, and file creation date of each driver.

To configure data sources, you must have at least one driver installed on your system. Use the driver's setup program to add or delete a driver from your system. For more information about modifying drivers, see [Managing Data Sources](../../odbc/admin/managing-data-sources.md).
