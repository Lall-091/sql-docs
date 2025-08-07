---
title: Migrate TDE certificate from SQL Server
description: Learn how to migrate a SQL Server TDE certificate when you're migrating your SQL Server database to Azure SQL Managed Instance. 
author: MladjoA
ms.author: mlandzic
ms.reviewer: mathoma, jovanpop
ms.date: 02/27/2025
ms.service: azure-sql-managed-instance
ms.subservice: security
ms.topic: how-to
ms.custom:
  - sqldbrb=1
  - devx-track-azurepowershell
  - sfi-image-nochange
---

# Migrate a SQL Server TDE certificate to Azure SQL Managed Instance
[!INCLUDE[appliesto-sqlmi](../includes/appliesto-sqlmi.md)]

In this article, learn how to migrate the certificate before you migrate your TDE-protected SQL Server database to Azure SQL Managed Instance by using the native restore option. 

When you migrate a database protected by [Transparent Data Encryption (TDE)](/sql/relational-databases/security/encryption/transparent-data-encryption) from SQL Server to Azure SQL Managed Instance using the _native restore option_, you must first migrate the corresponding certificate before you restore the database to SQL managed instance. 

Alternatively, you can use the fully managed [Azure Database Migration Service](/data-migration/sql-server/managed-instance/database-migration-service) to seamlessly migrate both a TDE-protected database and the corresponding certificate.

This article focuses on migrating databases from SQL Server to Azure SQL Managed Instance. To move databases between SQL managed instances, review: 
- [Copy-only backups](/sql/relational-databases/backup-restore/copy-only-backups-sql-server)
- [Point-in-time restore](point-in-time-restore.md)
- [Copy or move a database](database-copy-move-how-to.md)

## Prerequisites

To complete the steps in this article, you need the following prerequisites:

* [Pvk2Pfx](/windows-hardware/drivers/devtest/pvk2pfx) command-line tool installed on the on-premises server or other computer with access to the certificate exported as a file. The Pvk2Pfx tool is part of the [Enterprise Windows Driver Kit](/windows-hardware/drivers/download-the-wdk), a self-contained command-line environment.
* [Windows PowerShell](/powershell/scripting/install/installing-windows-powershell) version 5.0 or higher installed.

# [PowerShell](#tab/azure-powershell)

Make sure you have the following:

* Azure PowerShell module [installed and updated](/powershell/azure/install-az-ps).
* [Az.Sql module](https://www.powershellgallery.com/packages/Az.Sql).


Run the following commands in PowerShell to install/update the module:

```azurepowershell
Install-Module -Name Az.Sql
Update-Module -Name Az.Sql
```

* * *

## Export the TDE certificate to a .pfx file

The certificate can be exported directly from the source SQL Server instance, or from the certificate store if it's being kept there.

### Export the certificate from the source SQL Server instance

Use the following steps to export the certificate with SQL Server Management Studio and convert it into .pfx format. The generic names *TDE_Cert* and *full_path* are being used for certificate and file names and paths through the steps. They should be replaced with the actual names.

1. In SSMS, open a new query window and connect to the source SQL Server instance.

1. Use the following script to list TDE-protected databases and get the name of the certificate protecting encryption of the database to be migrated:

   ```sql
   USE master
   GO
   SELECT db.name as [database_name], cer.name as [certificate_name]
   FROM sys.dm_database_encryption_keys dek
   LEFT JOIN sys.certificates cer
   ON dek.encryptor_thumbprint = cer.thumbprint
   INNER JOIN sys.databases db
   ON dek.database_id = db.database_id
   WHERE dek.encryption_state = 3
   ```

   ![Screenshot in SSMS showing a List of TDE certificates.](./media/tde-certificate-migrate/onprem-certificate-list.png)

1. Execute the following script to export the certificate to a pair of files (.cer and .pvk), keeping the public and private key information:

   ```sql
   USE master
   GO
   BACKUP CERTIFICATE TDE_Cert
   TO FILE = 'c:\full_path\TDE_Cert.cer'
   WITH PRIVATE KEY (
     FILE = 'c:\full_path\TDE_Cert.pvk',
     ENCRYPTION BY PASSWORD = '<SomeStrongPassword>'
   )
   ```

   ![Screenshot in SSMS that shows the backed up TDE certificate.](./media/tde-certificate-migrate/backup-onprem-certificate.png)

1. Use the PowerShell console to copy certificate information from a pair of newly created files to a .pfx file, using the Pvk2Pfx tool:

   ```cmd
   .\pvk2pfx -pvk c:/full_path/TDE_Cert.pvk  -pi "<SomeStrongPassword>" -spc c:/full_path/TDE_Cert.cer -pfx c:/full_path/TDE_Cert.pfx
   ```

### Export the certificate from a certificate store

If the certificate is kept in the SQL Server local machine certificate store, it can be exported using the following steps:

1. Open the PowerShell console and execute the following command to open the Certificates snap-in of Microsoft Management Console:

   ```cmd
   certlm
   ```

2. In the Certificates MMC snap-in, expand the path Personal > Certificates to see the list of certificates.

3. Right-click the certificate and click **Export**.

4. Follow the wizard to export the certificate and private key to a .pfx format.

## Upload the certificate to Azure SQL Managed Instance using an Azure PowerShell cmdlet

> [!IMPORTANT]
> A migrated certificate is only used to restore the TDE-protected database. Shortly after the restore completes, the migrated certificate is replaced by a different protector, either a service-managed certificate or an asymmetric key from the key vault, depending on the type of TDE you set on the instance.

# [PowerShell](#tab/azure-powershell)

1. Start with preparation steps in PowerShell:

   ```azurepowershell
   # import the module into the PowerShell session
   Import-Module Az
   # connect to Azure with an interactive dialog for sign-in
   Connect-AzAccount
   # list subscriptions available and copy id of the subscription target the managed instance belongs to
   Get-AzSubscription
   # set subscription for the session
   Select-AzSubscription <subscriptionId>
   ```

2. Once all preparation steps are done, run the following commands to upload base-64 encoded certificate to the target managed instance:

   ```azurepowershell
   # If you are using PowerShell 6.0 or higher, run this command:
   $fileContentBytes = Get-Content 'C:/full_path/TDE_Cert.pfx' -AsByteStream
   # If you are using PowerShell 5.x, uncomment and run this command instead of the one above:
   # $fileContentBytes = Get-Content 'C:/full_path/TDE_Cert.pfx' -Encoding Byte
   $base64EncodedCert = [System.Convert]::ToBase64String($fileContentBytes)
   $securePrivateBlob = $base64EncodedCert  | ConvertTo-SecureString -AsPlainText -Force
   $password = "<password>"
   $securePassword = $password | ConvertTo-SecureString -AsPlainText -Force
   Add-AzSqlManagedInstanceTransparentDataEncryptionCertificate -ResourceGroupName "<resourceGroupName>" `
       -ManagedInstanceName "<managedInstanceName>" -PrivateBlob $securePrivateBlob -Password $securePassword
   ```

* * *

The certificate is now available to the specified managed instance, and the backup of the corresponding TDE-protected database can be restored successfully.

> [!NOTE]
> Uploaded certificate is not visible in the sys.certificates catalog view. To confirm successful upload of the certificate you can run [RESTORE FILELISTONLY](/sql/t-sql/statements/restore-statements-filelistonly-transact-sql) command.

## Next steps

In this article, you learned how to migrate a certificate protecting the encryption key of a database with Transparent Data Encryption, from the on-premises or IaaS SQL Server instance to Azure SQL Managed Instance.

See [Restore a database backup to an Azure SQL Managed Instance](restore-sample-database-quickstart.md) to learn how to restore a database backup to Azure SQL Managed Instance.
