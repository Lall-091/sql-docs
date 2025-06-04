---
author: MikeRayMSFT
ms.author: mikeray
ms.date: 01/29/2024
ms.service: sql
ms.topic: include
ms.custom:
  - build-2025
---

Beginning with [!INCLUDE [sssql11-md](sssql11-md.md)], SQL Server and Azure SQL DB used a SHA-512 hash combined with a 32-bit random and unique salt. This method made it statistically infeasible for attackers to deduce passwords.

[!INCLUDE [sssql25-md](sssql25-md.md)] introduces an iterated hash algorithm, RFC2898, also known as a *password-based key derivation function* (PBKDF). This algorithm still uses SHA-512 but hashes the password multiple times (100,000 iterations), significantly slowing down brute-force attacks. This change enhances password protection in response to evolving security threats and helps customers comply with NIST SP 800-63b guidelines.
