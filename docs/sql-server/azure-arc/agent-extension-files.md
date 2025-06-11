---
title: Azure extension for SQL Server system objects
description: Lists system objects - files, registry keys, and tables deployed and managed by the Azure extension for SQL Server.
author: MikeRayMSFT
ms.author: mikeray
ms.reviewer: nikitatakru
ms.date: 04/26/2024
ms.topic: reference
---

# Azure extension for SQL Server system objects

[!INCLUDE [SQL Server](../../includes/applies-to-version/sqlserver.md)]

This article lists system objects - files, registry keys, Windows services and tables deployed and managed by the Azure extension for SQL Server.

## Windows server files

| Path | Description |
| :----- | :----- |
| `%ProgramFiles%\AzureConnectedMachineAgent\*` | `azcmagent` CLI and instance metadata service executables |
| `%ProgramFiles%\AzureConnectedMachineAgent\GCArcService\GC\*` | Extension service executables |
| `%ProgramData%\AzureConnectedMachineAgent\*` | Configuration, log, and identity token files for `azcmagent` CLI and instance metadata service |
| `%ProgramData%\Application Data\Microsoft\Crypto\RSA\MachineKeys` | Windows certificate private keys | 

## SQL Server files

| Path | Description & notes |
| :----- | :----- |
| `%ProgramFiles%\Sql Server Extension\*` | Extension program files |
| `%SYSTEMDRIVE%\Packages\Plugins\Microsoft.AzureData.WindowsAgent.SQLServer\<extension_version>\*` | Extension executables |
| `%SYSTEMDRIVE%\Windows\system32\extensionUpload\*` | Usage files |
| `C:\Windows\System32\Tasks\Microsoft\SqlServerExtension` | XML for scheduled task for providing privileges |
| `C:\Windows\ServiceProfiles\SqlServerExtension\AppData\Local\Microsoft SQL Server Extension Agent\*` | When configured for [least privilege](configure-least-privilege.md) <br/><br/> Feature application |
| `C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft SQL Server Extension Agent\*`| When not configured for [least privilege](configure-least-privilege.md) <br/></br> Feature application |

> [!NOTE]
> [!INCLUDE [least-privilege-default](includes/least-privilege-default.md)]

## Windows Services

| Service name | Display name | Process name | Description |
| :----- | :----- | :----- | :----- |
| SqlServerExtension |Microsoft Sql Server Extension Service | SqlServerExtension.exe | Connects your SQL Server instance to Azure.  | 
| himds | Azure Hybrid Instance Metadata Service | `himds.exe` | Synchronizes metadata with Azure and hosts a local REST API for extensions and applications to access the metadata and request Microsoft Entra managed identity tokens |
| GCArcService | Machine configuration Arc Service | `gc_arc_service.exe` (gc_service.exe earlier than version 1.36) | Audits and enforces Azure machine configuration policies on the machine. |
| ExtensionService | Machine configuration Extension Service | `gc_extension_service.exe` (gc_service.exe earlier than version 1.36) | Installs, updates, and manages extensions on the machine. |

## Virtual service accounts

| Virtual Account  | Description |
|------------------|-------------|
| `NT SERVICE\himds` | Unprivileged account used to run the Hybrid Instance Metadata Service. |
| `NT Service\SQLServerExtension` | Unprivileged account used to run the SQL Server Extension Service in least privilege mode. |

## Registry keys

Base key: `HKEY_LOCAL_MACHINE`

| Key | Description & notes |
| :----- | :----- |
| `SOFTWARE\Microsoft\Microsoft SQL Server\<InstanceRegistryName>\MSSQLSERVER` | Microsoft Entra ID registry key |
| `SOFTWARE\Microsoft\Microsoft SQL Server\<InstanceRegistryName>\PurviewConfig` | Purview registry key |
| `SOFTWARE\Microsoft\SystemCertificates` | Windows certificate registry key |

## Tables

In each instance of SQL Server enabled by Azure Arc, the extension creates the following tables in `msdb`:

- `dq.arcJobTriggers00`
- `dt.arcJobDefinitions`

These tables store background job definition and execution history. Background jobs perform scheduled and user-initiated actions. These tables allow long-running jobs to automatically resume in the event that the Azure Extension for SQL Server is restarted.

## Related content

- [Configure Windows service accounts and permissions](../../database-engine/configure-windows/configure-windows-service-accounts-and-permissions.md)
