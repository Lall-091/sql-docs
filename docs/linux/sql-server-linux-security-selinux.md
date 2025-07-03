---
title: Get Started with SQL Server on SELinux
description: Learn about installing and configuring SQL Server on SELinux, using a Red Hat Enterprise Linux distribution.
author: rwestMSFT
ms.author: randolphwest
ms.date: 07/03/2025
ms.service: sql
ms.subservice: linux
ms.topic: how-to
ms.custom:
  - linux-related-content
---
# Get started with SQL Server on SELinux

This article guides you in getting started with [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] as a *confined service* on a Security-Enhanced Linux (SELinux) distribution based on Red Hat Enterprise Linux (RHEL).

## What is Security-Enhanced Linux?

Security-Enhanced Linux (SELinux) is a security architecture for Linux systems. It helps define access controls for applications, processes, and files on a system. SELinux uses a set of rules, or *security policies*, to define what can or can't be accessed. SELinux provides administrators more control over who can access the system. For more information, see [What is SELinux (Security-Enhanced Linux)](https://www.redhat.com/en/topics/linux/what-is-selinux).

For details about how to enable SELinux for Red Hat systems, see [SELinux Architecture](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/sect-security-enhanced_linux-introduction-selinux_architecture). You can also get started with an [SELinux-enabled operating system](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux/server/trial) for free.

[SQL Server 2022 on Linux](sql-server-linux-overview.md) is officially certified with RHEL 9 (as of July 2024), and is now generally available on the [Red Hat Ecosystem Catalog](https://catalog.redhat.com/software/applications/detail/253877).

## SQL Server and SELinux

A *confined service* with SELinux means that it's restricted by security rules, explicitly defined in the SELinux policy. For [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)], the SELinux custom policies are defined in the `mssql-server-selinux` package.

## Prerequisites

1. SELinux should be enabled and in `enforcing` mode. You can check the SELinux status by running the command `sestatus`.

   ```bash
   sestatus
   ```

   Here's the expected output.

   ```output
   SELinux status:                 enabled
   SELinuxfs mount:                /sys/fs/selinux
   SELinux root directory:         /etc/selinux
   Loaded policy name:             targeted
   Current mode:                   enforcing
   Mode from config file:          enforcing
   Policy MLS status:              enabled
   Policy deny_unknown status:     allowed
   Memory protection checking:     actual (secure)
   Max kernel policy version:      33
   ```

1. Install the `mssql-server-selinux` package that defines the required custom policies.

> [!NOTE]  
> If any of the prerequisites aren't met, [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] runs as an *unconfined service*.

## Install SQL Server as a confined service

By default, the `mssql-server` package installs [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] without the SELinux policy, and [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] runs as an unconfined service. The `mssql-server` package installation automatically enables the `selinux_execmode` Boolean. You can verify that [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] is running unconfined using the following command:

```bash
ps -eZ | grep sqlservr
```

Here's the expected output.

```output
system_u:system_r:unconfined_service_t:s0 48265 ? 00:00:02 sqlservr
```

Once you install the `mssql-server-selinux` package, it enables a custom SELinux policy that confines the `sqlservr` process. When you install this policy, the `selinuxuser_execmod` Boolean is reset, and is replaced by a policy named `mssql`, which confines the `sqlservr` process in the new `mssql_server_t` domain.

```bash
ps -eZ | grep sqlservr
```

Here's the expected output.

```output
system_u:system_r:mssql_server_t:s0 48941 ?      00:00:02 sqlservr
```

## SQL Server and SELinux types

When the optional SELinux policy is installed with the `mssql-server-selinux` package, some new types are defined:

| SELinux policy | Description |
| --- | --- |
| `mssql_opt_t` | Install files of mssql-server to `/opt/mssql` |
| `mssql_server_exec_t` | Executable files at `/opt/mssql/bin/` |
| `mssql_paldumper_exec_t` | Executables and scripts which require special permissions to manage core dumps |
| `mssql_conf_exec_t` | Management tool at `/opt/mssql/bin/mssql-conf` |
| `mssql_var_t` | Label for files at `/var/opt/mssql` |
| `mssql_db_t` | Label for the database files at `/var/opt/mssql/data` |

## Examples

The following example demonstrates changing the database location when [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] is running as a confined service.

1. Create the desired directories and label them as `mssql_db_t`.

   ```bash
   sudo mkdir -p /opt/mydb/
   sudo chown mssql:mssql /opt/mydb
   sudo semanage fcontext -a -t mssql_db_t "/opt/mydb(/.*)?"
   sudo restorecon -R -v /opt/mydb
   ```

   The command `semanage fcontext` manages the SELinux file context mapping. The `-a` parameter adds a new file context rule, and the `-t` parameter defines the SELinux type to be applied, which in this case is `mssql_db_t` for [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] database files. Finally, the path pattern is specified, which is `/opt/mydb` in this example, and all the files and subdirectories within it.

1. Set the default database location using **mssql-conf**, and run the setup.

   ```bash
   sudo /opt/mssql/bin/mssql-conf set filelocation.defaultdatadir /opt/mydb/data
   sudo systemctl restart mssql-server
   ```

1. Verify by creating a new database using Transact-SQL:

   ```sql
   CREATE DATABASE TestDatabase;
   GO
   ```

1. Verify the new database was created with the appropriate labels.

   ```bash
   sudo ls -lZ /opt/mydb/data/
   ```

   Here's the expected output.

   ```output
   total 16384
   -rw-rw----. 1 mssql mssql system_u:object_r:mssql_db_t:s0 8388608 Aug  2 14:27 TestDatabase_log.ldf
   -rw-rw----. 1 mssql mssql system_u:object_r:mssql_db_t:s0 8388608 Aug  2 14:27 TestDatabase.mdf
   ```

   In the previous example, you can see the file has the `mssql_db_t` (type) associated with the new files created.

## Related content

- [Security limitations for SQL Server on Linux](sql-server-linux-security-overview.md)
- [Walkthrough for the security features of SQL Server on Linux](sql-server-linux-security-get-started.md)
- [Quickstart: Install SQL Server and create a database on Red Hat](quickstart-install-connect-red-hat.md)
