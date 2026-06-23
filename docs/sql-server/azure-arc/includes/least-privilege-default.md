---
author: MashaMSFT
ms.service: azure-arc
ms.topic: include
ms.date: 08/22/2024
ms.author: mathoma
---

Currently, least privileged configuration is not applied by default.

Existing servers with extension version `1.1.2859.223` or greater will eventually have the least privileged configuration applied. This extension was released in November, 2024. To prevent the automatic application of least privilege, block extension upgrades after `1.1.2859.223`.
