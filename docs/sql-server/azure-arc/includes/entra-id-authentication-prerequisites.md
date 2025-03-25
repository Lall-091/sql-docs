---
author: nitinvbhartiM
ms.author: nitinbharti
ms.date: 03/24/2025
ms.topic: include
---

Enabling Entra ID authentication for [!INCLUDE [ssnoversion-md](../../../includes/ssnoversion-md.md)] enabled by Azure Arc requires some URLs to be allowed explicitly if a firewall blocks outbound URLs. Add the following URLs to the allowlist:

- `https://login.microsoftonline.com/`
- `https://<azure-keyvault-name>.vault.azure.net/`
- `https://graph.microsoft.com/`
