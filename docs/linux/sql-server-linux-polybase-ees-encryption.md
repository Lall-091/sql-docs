---
title: PolyBase EES Encryption on Linux
description: Learn how PolyBase External Execution Service (EES) communication is encrypted on SQL Server for Linux in SQL Server 2025 CU 6 and later versions.
author: rwestMSFT
ms.author: randolphwest
ms.reviewer: hudequei, amitkh, atsingh
ms.date: 06/16/2026
ms.service: sql
ms.subservice: linux
ms.topic: concept-article
ms.custom:
  - linux-related-content
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17"
---

# PolyBase EES encryption (SQL Server on Linux)

[!INCLUDE [sqlserver2025-linux](../includes/applies-to-version/sqlserver2025-linux.md)]

This article describes how PolyBase External Execution Service (EES) communication is encrypted on [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] for Linux in [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] Cumulative Update (CU) 6 and later versions.

## Overview

PolyBase on Linux uses the External Execution Service (EES), which runs locally on the [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] host, to run the ODBC drivers required for external connectivity. Starting in [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] CU6, communication between [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] services and EES is encrypted by default.

## What's new in CU6

- Traffic between [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] services and EES is encrypted by using a certificate.

- EES uses a self-signed certificate that is generated automatically each time EES restarts.

- The generated certificate is valid for 365 days.

### Certificate details

| Item | Value |
| --- | --- |
| Certificate path | `/var/opt/mssql/polybase-ees` |
| Certificate file name | `ca.crt` |
| Certificate SAN | `subjectAltName=IP:127.0.0.1,DNS:localhost` |

## Bring your own certificate

To use your own certificate for EES, place your certificate file at the same location and with the same name that EES expects.

1. Copy your certificate to `/var/opt/mssql/polybase-ees/ca.crt`.

1. Restart the EES service to pick up the certificate.

1. Validate that PolyBase external access works as expected.

## Restart and rollback

To roll back to the default self-signed certificate (or to force regeneration), restart EES.

To restart EES on Linux, run the following command:

```bash
sudo systemctl restart mssql-ees.service
```

## Remarks

You might need to restart EES if it hasn't been restarted in the past year so that a fresh certificate can be generated.

## Fallback behavior

If the certificate file is missing or invalid, PolyBase falls back to unencrypted communication between [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] services and EES.

## Related content

- [Install PolyBase on Linux](../relational-databases/polybase/polybase-linux-setup.md)
- [Connect to ODBC data sources with PolyBase on SQL Server on Linux](sql-server-linux-polybase.md)
- [Configure PolyBase to access external data with ODBC generic types](../relational-databases/polybase/polybase-configure-odbc-generic.md)
