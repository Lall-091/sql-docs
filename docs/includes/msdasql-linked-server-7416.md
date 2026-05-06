---
author: rwestMSFT
ms.author: randolphwest
ms.date: 05/01/2026
ms.service: sql
ms.topic: include
---

Linked server queries that use the Microsoft OLE DB Provider for ODBC (`MSDASQL`) and specify a provider string (*@provstr*) might fail with the following error:

```output
Msg 7416, Level 16
Access to the remote server is denied because no login-mapping exists.
```

This issue affects logins that aren't members of the **sysadmin** fixed server role. It can occur even when the linked server and login mappings are configured correctly.

In certain linked server configurations that use the `MSDASQL` provider, a stricter connection validation check in the Database Engine can reject connections that were allowed in previous builds.

**Workaround**: Use one of the following options:

- Remove *@provstr* from the linked server definition, if your configuration doesn't require it.

- Add `User ID=<value>` to *@provstr*. The login must still supply `UID` in the provider string.

Granting the affected login **sysadmin** also prevents the error, but isn't recommended.
