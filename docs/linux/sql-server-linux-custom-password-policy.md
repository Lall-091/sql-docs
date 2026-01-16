---
title: Use Custom Password Policy for SQL Logins on Linux
description: Learn how to use a custom password policy for SQL logins with SQL Server on Linux.
author: Madhumitatripathy
ms.author: matripathy
ms.reviewer: mikeray, randolphwest
ms.date: 01/16/2026
ms.service: sql
ms.subservice: linux
ms.topic: how-to
ms.custom:
  - build-2025
  - linux-related-content
# customer intent: As a database professional, I want enforce password policy for SQL logins on SQL Server on Linux so that the configuration more closely aligns with secure practices.
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17"
---

# Set custom password policy for SQL logins in SQL Server on Linux

[!INCLUDE [sqlserver2022-and-later-linux](../includes/applies-to-version/sqlserver2022-and-later-linux.md)]

This article describes how you can set up and manage SQL login password policies, starting with [!INCLUDE [sssql22-md](../includes/sssql22-md.md)] Cumulative Update (CU) 23, and [!INCLUDE [sssql25-md](../includes/sssql25-md.md)].

Password policies are a crucial aspect of securing any database environment. They enforce:

- Complexity
- Expiration
- Changes

This enforcement ensures that logins that use SQL Server authentication are secure.

> [!NOTE]  
> Password policies are available on Windows. For more information, see [Password policy](../relational-databases/security/password-policy.md).

## Custom policy settings

In [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] and later versions on Linux, you can set the following configuration parameters in the `mssql.conf` file to enforce a custom password policy.

| Configuration option | Description |
| --- | --- |
| `passwordpolicy.passwordminimumlength` | Sets the minimum number of characters required for a password. Passwords can be up to 128 characters long. |
| `passwordpolicy.passwordhistorylength` | Sets the number of previous passwords that the system remembers. |
| `passwordpolicy.passwordminimumage` | Sets the minimum duration a user must wait before changing their password again. |
| `passwordpolicy.passwordmaximumage` | Sets the maximum duration a password can be used before it must be changed. |

> [!NOTE]  
> You can currently set the `passwordminimumlength` to fewer than eight characters. [!INCLUDE [password-complexity](includes/password-complexity.md)]

You can configure custom password policies for SQL authentication logins in SQL Server on Linux in two ways:

- [Enforce custom password policy](#adutil) with **adutil**
- [Manually configure the `mssql.conf` file](#manual) using the **mssql-conf** tool

<a id="adutil"></a>

## Set custom password policy with adutil

In environments where policy management is centralized in an Active Directory (AD) server, domain administrators set and modify the password policy values in the AD server. The Linux machine running SQL Server must also be part of the Windows domain.

Use [adutil](sql-server-linux-ad-auth-adutil-introduction.md) to fetch the password policy from the AD server and write it to the `mssql.conf` file. This method offers the benefit of centralized management, and ensures consistent application of policies across the SQL Server environment.

### Requirements for adutil

1. Establish a Kerberos authenticated session:

   - Run `kinit` with `sudo` to get or renew the Kerberos ticket-granting ticket (TGT).

   - Use a privileged account for the `kinit` command. The account needs permission to connect to the domain.

   In the following example, replace `<user>` with an account that has elevated privileges in the domain.

   ```bash
   sudo kinit <user>@CONTOSO.COM
   ```

1. Verify that the ticket is granted:

   ```bash
   sudo klist
   ```

1. To update the password policy, query the domain with **adutil**:

   ```bash
   sudo adutil updatepasswordpolicy
   ```

   If the command is successful, the output looks similar to the following example:

   ```output
   Successfully updated password policy in mssqlconf.
   Restart SQL Server to apply the changes.
   ```

   Optionally, you can add the `--path` option to the previous command. You might use this option if you have the **mssql-conf** tool in a different location from the default path. The default path is `/opt/mssql/bin/mssql-conf`.

1. Restart SQL Server service:

   ```bash
   sudo systemctl restart mssql-server
   ```

<a id="manual"></a>

## Manually set a custom password policy using mssql-conf

You can set the SQL authentication login password policy by updating the parameters in the `mssql.conf` file with **mssql-conf**. This approach provides simplicity and direct control over the policy settings.

Use this method when the Linux host running SQL Server isn't part of the domain, and there's no domain controller to get the password policies from.

Run the following **mssql-conf** commands to set each policy configuration property.

1. Set the minimum password length to 14 characters, adhering to the complexity requirements outlined in the [Password policy](../relational-databases/security/password-policy.md).

   ```bash
   sudo /opt/mssql/bin/mssql-conf set passwordpolicy.passwordminimumlength 14
   ```

1. Set the minimum password age to one day. Users can change their password after one day.

   ```bash
   sudo /opt/mssql/bin/mssql-conf set passwordpolicy.passwordminimumage 1
   ```

1. Set the password history length to 8. Users must use eight unique passwords before reusing an old one.

   ```bash
   sudo /opt/mssql/bin/mssql-conf set passwordpolicy.passwordhistorylength 8
   ```

1. Set the maximum password age to 45 days. A user can use a password for up to 45 days before the user must change it.

   ```bash
   sudo /opt/mssql/bin/mssql-conf set passwordpolicy.passwordmaximumage 45
   ```

1. Restart SQL Server service.

   ```bash
   sudo systemctl restart mssql-server
   ```

## Limitations

Currently, the `passwordminimumlength` can't be set to more than 14 characters.

After updating the group password policy in Active Directory, you must manually run the `adutil updatepasswordpolicy` command to update `mssql.conf`. This command doesn't run automatically. Ensure the Linux machine running SQL Server is part of the domain, or manually set it using **mssql-conf**.

In Active Directory, you can define or undefine each group-level password policy using a checkbox.

:::image type="content" source="media/sql-server-linux-custom-password-policy/password-length-properties.png" alt-text="Screenshot of minimum password length security policy setting.":::

However, unchecking the policy doesn't disable it in SQL Server on Linux. To avoid applying the custom password policy, update the settings in **mssql-conf** instead of relying on the checkbox.

## Related content

- [Password policy](../relational-databases/security/password-policy.md)
- [Strong passwords](../relational-databases/security/strong-passwords.md)
