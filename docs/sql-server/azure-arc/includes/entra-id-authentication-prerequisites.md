---
author: nitinvbhartiM
ms.author: nitinbharti
ms.date: 03/24/2025
ms.topic: include
---

Enabling Microsoft Entra authentication for [!INCLUDE [ssnoversion-md](../../../includes/ssnoversion-md.md)] enabled by Azure Arc requires some URLs to be allowed explicitly if a firewall blocks outbound URLs. Add the following URLs to the allowlist:

- `https://login.microsoftonline.com/`
- `https://login.microsoft.com/`
- `https://enterpriseregistration.windows.net/`
- `https://graph.microsoft.com/`
- `https://<azure-keyvault-name>.vault.azure.net/` (Required only if you're using certificates for Microsoft Entra authentication)

Additionally, you might need to allow [Azure portal authentication URLs](/azure/azure-portal/azure-portal-safelist-urls#azure-portal-authentication).
