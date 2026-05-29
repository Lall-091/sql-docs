---
title: Connect to SQL Server with strict encryption
description: This article describes how to connect to SQL Server using the strict encryption type
author: VanMSFT
ms.author: vanto
ms.date: 05/29/2026
ms.service: sql
ms.subservice: security
ms.topic: how-to
monikerRange: ">= sql-server-ver16||>= sql-server-linux-ver16"
ms.custom: sfi-image-nochange
ai-usage: ai-assisted
---

# Connect to SQL Server with strict encryption

[!INCLUDE [SQL Server 2022](../../../includes/applies-to-version/sqlserver2022-and-later.md)]

Strict connection encryption enforces good security practices and makes SQL Server traffic manageable by standard network appliances. Strict encryption uses Tabular Data Stream (TDS) 8.0, which wraps the TDS session in Transport Layer Security (TLS) for end-to-end encryption.

In this article, learn how to connect to [!INCLUDE [sssql22-md](../../../includes/sssql22-md.md)] and later versions using the strict connection type.

## Prerequisite

- [!INCLUDE [sssql22-md](../../../includes/sssql22-md.md)] or later
- ODBC or OLE DB Driver for SQL Server
  - [ODBC Driver for SQL Server](../../../connect/odbc/download-odbc-driver-for-sql-server.md) version 18.1.2.1 or higher
  - [OLE DB Driver for SQL Server](../../../connect/oledb/download-oledb-driver-for-sql-server.md) version 19.2.0 or higher
- Create and install a Transport Layer Security (TLS) certificate to SQL Server. For more information, see [Enable encrypted connections to the Database Engine](../../../database-engine/configure-windows/configure-sql-server-encryption.md)

## Connect to SQL Server using a .NET application

For information on building and connecting to SQL Server using the `strict` encryption type, see [Connection String Syntax](/dotnet/framework/data/adonet/connection-string-syntax) on how to properly build the connection string. For more information on the new connection string properties, see [Additional changes to connection string encryption properties](./tds-8.md#additional-changes-to-connection-string-encryption-properties).

## Connect using an ODBC DSN

You can test a connection with the `Strict` connection encryption type using an ODBC DSN to SQL Server.

1. Search for the **ODBC Data Sources** app in Windows.

   :::image type="content" source="media/connect-with-strict-encryption/odbc-data-sources-app.png" alt-text="Screenshot of the O D B C data sources app.":::

1. Make sure you have the latest ODBC driver by looking in the **Drivers** tab of ODBC Data Source Administrator.

   :::image type="content" source="media/connect-with-strict-encryption/odbc-drivers.png" alt-text="Screenshot of available drivers.":::

1. In the **System DSN** tab, select **Add** to create a DSN. Then select the **ODBC Driver 18 for SQL Server**. Select **Finish**. We're going to use this to test our connection.

1. In the **Create a New Data Source to SQL Server** window, provide a name for this data source, and add your [!INCLUDE [sssql22-md](../../../includes/sssql22-md.md)] server name to **Server**. Select **Next**.

   :::image type="content" source="media/connect-with-strict-encryption/create-data-source.png" alt-text="Screenshot of creating a data source using the O D B C driver.":::

1. Use all default values for all the settings until you get to the screen that has **Connection Encryption**. Select **Strict**. If the server name that you entered differs from that in the certificate or if the IP address is used instead, set **HostName in certificate** to the one used in your certificate. Select **Finish**.

   :::image type="content" source="media/connect-with-strict-encryption/connection-encryption-strict.png" alt-text="Screenshot showing the strict encryption type.":::

1. When the dialog box **ODBC Microsoft SQL Server Setup** pops up, select the **Test Data Source...** button to test the connection. This should enforce the `strict` connection to SQL Server for this test.

## Connect using Universal Data Link

You can also test the connection to SQL Server with `strict` encryption using the OLE DB Driver with Universal Data Link (UDL).

1. To create a UDL file to test your connection, right-click on your desktop, and select **New** > **Text Document**. You need to change the extension from `txt` to `udl`. You can give the file any name you want.

   > [!NOTE]
   > You need to be able to see the extension name in order to change the extension from `txt` to `udl`. If you can't see the extension, you can enable viewing the extension by opening **File Explorer** > **View** > **Show** > **File name extensions**.

1. Open the UDL file that you created, and go over to the **Provider** tab to select the **Microsoft OLE DB Driver 19 for SQL Server**. Select **Next >>**.

   :::image type="content" source="media/connect-with-strict-encryption/udl-providers.png" alt-text="Screenshot of the U D L provider screen.":::

1. On the **Connection** tab, enter your SQL Server server name, and select the authentication method you use for logging into SQL Server.

   :::image type="content" source="media/connect-with-strict-encryption/udl-connection.png" alt-text="Screenshot of the U D L connection screen.":::

1. In the **Advanced** tab, select **Strict** for **Connection encryption**. If the server name that you entered differs from that in the certificate or if the IP address is used instead, set **Host name in certificate** to the one used in your certificate. Go back to the **Connection** tab when you're done.

   :::image type="content" source="media/connect-with-strict-encryption/udl-advanced.png" alt-text="Screenshot of the U D L advanced screen.":::

1. Select **Test Connection** to test the connection with the `strict` connection encryption.

   :::image type="content" source="media/connect-with-strict-encryption/udl-test-connection.png" alt-text="Screenshot of the U D L connection screen and testing connection.":::

## Connect with SSMS 

Starting with version 20, you can enforce strict encryption in [SQL Server Management Studio (SSMS)](/ssms/install/install#step-2---determine-which-version-of-sql-server-management-studio-to-install) on the **Logins** tab of the **Connect to Server** dialog box: 

:::image type="content" source="media/connect-with-strict-encryption/enforce-encryption-ssms.png" alt-text="Screenshot of the connect to server dialog box in SQL Server Management Studio.":::

## Connect to an Always On availability group

Starting with [!INCLUDE [sssql25-md](../../../includes/sssql25-md.md)], you can encrypt communication between the Windows Server Failover Cluster and an Always On availability group replica using the `Strict` or `Mandatory` connection encryption type. Your availability group can only enforce encryption if it's based on a Windows Server Failover Cluster. Other types of availability groups don't support strict encryption.

> [!NOTE]  
> Encryption for database mirroring endpoints is configured separately, and TLS isn't supported. For more information, see [Transport security in availability groups and database mirroring](../../../database-engine/database-mirroring/transport-security-database-mirroring-always-on-availability.md).

The steps differ based on whether or not your availability already exists.

#### [New AG](#tab/new-ag)

To force strict encryption to a new availability group, follow these steps:

1. If you haven't already, [import the TLS certificate](../../../database-engine/configure-windows/configure-sql-server-encryption.md) to every replica of the availability group, as defined by [certificate requirements](../../../database-engine/configure-windows/certificate-requirements.md#always-on-availability-group). Restart each SQL Server instance after importing the certificate. 
1. Test connections to each SQL Server replica by using one of the methods mentioned in this article that enforces encryption. 
1. [CREATE AVAILABILITY GROUP](../../../t-sql/statements/create-availability-group-transact-sql.md#cluster_connection_options) with the `Encrypt` property set to `Strict` in the `CLUSTER_CONNECTION_OPTIONS` clause for the availability group. This ensures that all connections to the availability group use the specified encryption type. 
1.  If the availability group is currently online, then fail the availability group over to a secondary replica to apply the new encryption settings to the availability group. If the availability group fails to come online, it could be the `ClusterConnectionOptions` isn't set correctly. Check the [cluster.log](/powershell/module/failoverclusters/get-clusterlog) for [ODBC errors](../../../connect/odbc/connection-troubleshooting.md) related to the cluster failing to connect to the SQL Server replica. Optionally, you can fail the availability group back to the original primary replica after the new secondary replica is online and connected to the availability group.
1. (Optional) You can further enforce encryption by setting the [Force Strict Encryption](#force-strict-encryption-with-sql-server-configuration-manager) option to `Yes` in [SQL Server Configuration Manager](../../../tools/configuration-manager/sql-server-configuration-manager.md#manage-server-and-client-network-protocols) properties for the connection protocol for each replica. This setting ensures that all connections to the availability group replicas use strict encryption. Restart each SQL Server replica after changing this setting.


#### [Existing AG](#tab/existing-ag)

Before you start to configure your existing availability group for strict encryption, follow the steps in [rolling upgrades](../../../database-engine/availability-groups/windows/upgrading-always-on-availability-group-replica-instances.md#rolling-upgrade-basics-for-always-on-ags) during a maintenance window to minimize downtime and avoid data loss. 


To configure your existing availability group for strict encryption, follow these steps during a maintenance window:

1. If you haven't already, [import the TLS certificate](../../../database-engine/configure-windows/configure-sql-server-encryption.md) to every *secondary* replica of the availability group, as defined by [certificate requirements](../../../database-engine/configure-windows/certificate-requirements.md#always-on-availability-group). Restart each secondary SQL Server replica after importing the certificate.
1. Test connections to each SQL Server replica by using one of the methods mentioned in this article that enforces encryption. 
1. Fail over the availability group to one of the secondary replicas that you just connected to. This makes it the new primary replica.
1. [Import the TLS certificate](../../../database-engine/configure-windows/configure-sql-server-encryption.md) to the new secondary replica that used to be the primary replica. Restart the SQL Server instance after importing the certificate.
1. Update client application connection strings to connect to the availability group with enforced encryption.
1. [ALTER AVAILABILITY GROUP](../../../t-sql/statements/alter-availability-group-transact-sql.md#cluster_connection_options) with the `CLUSTER_CONNECTION_OPTIONS` clause to set the `Encrypt` property to `Mandatory` or `Strict`. This ensures that all connections to the availability group use the specified encryption type.
1.  If the availability group is currently online, then fail the availability group over to a secondary replica to apply the new encryption settings to the availability group. If the availability group fails to come online, it could be the `ClusterConnectionOptions` isn't set correctly. Check the [cluster.log](/powershell/module/failoverclusters/get-clusterlog) for [ODBC errors](../../../connect/odbc/connection-troubleshooting.md) related to the cluster failing to connect to the SQL Server replica. Optionally, you can fail the availability group back to the original primary replica after the new secondary replica is online and connected to the availability group.
1. (Optional) You can further enforce encryption by setting the [Force Strict Encryption](#force-strict-encryption-with-sql-server-configuration-manager) option to `Yes` in [SQL Server Configuration Manager](../../../tools/configuration-manager/sql-server-configuration-manager.md#manage-server-and-client-network-protocols) properties for the connection protocol for each replica. This setting ensures that all connections to the availability group replicas use strict encryption. Restart each SQL Server replica after changing this setting.

---

## Connect to a failover cluster instance

Starting with [!INCLUDE [sssql25-md](../../../includes/sssql25-md.md)], you can encrypt communication between your Windows Server Failover Cluster and an [Always On failover cluster instance](../../../sql-server/failover-clusters/windows/always-on-failover-cluster-instances-sql-server.md) using the `Strict` or `Mandatory` connection encryption type. To do this, follow these steps: 

1. If you haven't already, [import the TLS certificate](../../../database-engine/configure-windows/configure-sql-server-encryption.md#extra-procedure-for-failover-cluster-instances) to every node of the failover cluster, as defined by [certificate requirements](../../../database-engine/configure-windows/certificate-requirements.md#failover-cluster-instance). Restart the SQL Server instance after importing the certificate.
1. Test connections to the failover cluster instance by using one of the methods mentioned in this article that enforces encryption.
1. [ALTER SERVER CONFIGURATION](../../../t-sql/statements/alter-server-configuration-transact-sql.md#clusterconnectionoptions) with the `CLUSTER_CONNECTION_OPTIONS` clause to set the `Encrypt` property to `Mandatory` or `Strict`. This ensures that all connections to the failover cluster instance use the specified encryption type. 
1. Fail the instance over to a secondary node to apply the new encryption settings to the failover cluster instance. If the failover cluster instance fails to come online, it could be the `ClusterConnectionOptions` isn't set correctly. Check the [cluster.log](/powershell/module/failoverclusters/get-clusterlog) for [ODBC errors](../../../connect/odbc/connection-troubleshooting.md) related to the cluster failing to connect to the SQL Server instance. Optionally, you can fail the instance back to the original primary node after the new secondary node is online and connected to the failover cluster instance.
1. (Optional) You can further enforce encryption by setting the [Force Strict Encryption](#force-strict-encryption-with-sql-server-configuration-manager) option to `Yes` in [SQL Server Configuration Manager](../../../tools/configuration-manager/sql-server-configuration-manager.md#manage-server-and-client-network-protocols) properties for the connection protocol for each node in the cluster. This setting ensures that all connections to the failover cluster instance use strict encryption. Make this change on the secondary node, fail the instance over to it, and then make the change on the primary node. 

## SQL Server Agent connection encryption

Starting with [!INCLUDE [sssql25-md](../../../includes/sssql25-md.md)], SQL Server Agent uses [Microsoft ODBC Driver 18 for SQL Server](../../../connect/odbc/download-odbc-driver-for-sql-server.md), which supports TDS 8.0 and TLS 1.3. SQL Server Agent automatically adjusts its connection encryption to match how the SQL Server instance is configured.

### How SQL Server Agent determines encryption

When SQL Server Agent starts, it queries the following registry keys on the local machine to determine the encryption level configured for SQL Server:

- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL17.<InstanceName>\MSSQLServer\SuperSocketNetLib\ForceEncryption`
- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL17.<InstanceName>\MSSQLServer\SuperSocketNetLib\ForceStrict`
- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL17.<InstanceName>\MSSQLServer\SuperSocketNetLib\SubjectAlternativeName` (new in [!INCLUDE [sssql25-md](../../../includes/sssql25-md.md)])

Based on these values, SQL Server Agent selects its connection mode:

- If **Force Strict Encryption** is enabled, SQL Server Agent connects using `strict` (TDS 8.0).
- If **Force Encryption** is enabled, SQL Server Agent connects using `mandatory` (TDS 7.x).
- If neither is enabled, SQL Server Agent connects using `optional` (TDS 7.x).

Local T-SQL job steps inherit the same encryption configuration as the SQL Server Agent service. If SQL Server Agent connects with `strict`, T-SQL jobs running locally on the server use the same option.

> [!IMPORTANT]
> TLS 1.3 only works with strict encryption. If the SQL Server instance has only TLS 1.3 enabled at the OS level but only **Force Encryption** is set (not **Force Strict Encryption**), SQL Server Agent can't start because `mandatory` and `optional` modes require TDS 7.x, which isn't compatible with TLS 1.3.

### TLS and encryption configuration matrix

| TLS version enabled | Configuration setting | SQL Server Agent outcome | Notes |
|---|---|---|---|
| TLS 1.3 only | Force Strict Encryption | Connects successfully | TDS 8.0 uses strict encryption |
| TLS 1.3 only | Force Encryption | Fails to connect | TLS 1.3 requires strict |
| TLS 1.3 only | None | Fails to connect | TLS 1.3 requires strict encryption |
| TLS 1.2 only | Force Strict Encryption | Connects successfully | TDS 8.0 can use TLS 1.2 |
| TLS 1.2 only | Force Encryption | Connects successfully | TDS 7.x with mandatory |
| TLS 1.2 only | None | Connects successfully | TDS 7.x with optional |
| TLS 1.2 and TLS 1.3 | Force Strict Encryption | Connects successfully | TDS 8.0 uses strict encryption |
| TLS 1.2 and TLS 1.3 | Force Encryption | Connects successfully | TDS 7.x with mandatory |
| TLS 1.2 and TLS 1.3 | None | Connects successfully | TDS 7.x with optional |

### Verify SQL Server Agent's negotiated encryption

After SQL Server Agent connects, run the following query to confirm its encryption mode:

```sql
SELECT s.session_id, c.encrypt_option, s.program_name, s.client_interface_name, s.nt_user_name
FROM sys.dm_exec_connections AS c
INNER JOIN sys.dm_exec_sessions AS s
    ON c.session_id = s.session_id
WHERE s.program_name LIKE 'SQLAgent%';
```

The `encrypt_option` column returns `TRUE` when SQL Server Agent connected with encryption.

For an overview of SQL Server Agent itself, see [SQL Server Agent](/sql/ssms/agent/sql-server-agent#tds-80-and-strict-encryption-support).

## Force strict encryption with SQL Server Configuration Manager

You can enforce strict encryption using the SQL Server Configuration Manager starting with [!INCLUDE [sssql22-md](../../../includes/sssql22-md.md)]. To do so, follow these steps:

1. Open **SQL Server Configuration Manager**.
1. In the left pane, expand **SQL Server Network Configuration**, and select **Protocols for [InstanceName]**.
1. Right-click on **TCP/IP**, and select **Properties**.
1. In the **TCP/IP Properties** dialog, go to the **Flags** tab, and then select **Yes** for the **Force Strict Encryption** option: 

   :::image type="content" source="media/connect-with-strict-encryption/enforce-strict-encryption.png" alt-text="Screenshot of the Force Strict Encryption option in SQL Server Configuration Manager.":::

1. Restart the SQL Server instance during a maintenance window to apply the changes.

## Remarks

If you see `SSL certificate validation failed`, validate that:

- Server certificate is valid on the machine you're using for testing
- At least one of the following is true:
  - Provider SQL Server matches CA name or one of the DNS names in the certificate.
  - `HostNameInCertificate` connection string property matches CA name or one of the DNS names in the certificate.

## Related content

- [TDS 8.0](tds-8.md)
- [Configure TLS 1.3](connect-with-tls-1-3.md)
- [SQL Server Agent](/sql/ssms/agent/sql-server-agent#tds-80-and-strict-encryption-support)
