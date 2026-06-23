---
title: "Provision enclave-enabled keys"
description: "Provision enclave-enabled keys"
author: PieterVanhove
ms.author: pivanho
ms.reviewer: vanto
ms.date: 6/17/2026
ms.service: sql
ms.subservice: security
ms.topic: how-to
ms.custom:
  - devx-track-azurepowershell
  - sfi-ropc-nochange
---
# Provision enclave-enabled keys

[!INCLUDE [sqlserver2019-windows-only-asdb](../../../includes/applies-to-version/sqlserver2019-windows-only-asdb.md)]

This article describes how to provision enclave-enabled keys that support computations inside server-side secure enclaves used for [Always Encrypted with secure enclaves](always-encrypted-enclaves.md). 

The general guidelines and processes for [managing Always Encrypted keys](overview-of-key-management-for-always-encrypted.md) apply when you provision enclave-enabled keys. This article addresses details specific to Always Encrypted with secure enclaves.

To provision an enclave-enabled column master key using SQL Server Management Studio or PowerShell, make sure the new key supports enclave computations. This will cause the tool (SSMS or PowerShell) to generate the `CREATE COLUMN MASTER KEY` statement that sets the `ENCLAVE_COMPUTATIONS` in the columns master key metadata in the database. For more information, see [CREATE COLUMN MASTER KEY (Transact-SQL)](../../../t-sql/statements/create-column-master-key-transact-sql.md).

The tool will also digitally sign the column master properties with the column master key, and it will store the signature in the database metadata. The signature prevents malicious tampering with the `ENCLAVE_COMPUTATIONS` setting. The SQL client drivers verify the signatures before allowing the enclave use. This provides security administrators with control over which column data can be computed inside the enclave.

After you define the column master key in the metadata, the `ENCLAVE_COMPUTATIONS` property is immutable and you can't change it. To enable enclave computations by using a column encryption key that an existing column master key encrypts, rotate the column master key and replace it with an enclave-enabled column master key. See [Rotate enclave-enabled keys](always-encrypted-enclaves-rotate-keys.md).

> [!NOTE]
> Currently, both SSMS and PowerShell support enclave-enabled column master keys stored in Azure Key Vault or Windows Certificate Store. Hardware security modules (using CNG or CAPI) aren't supported.

To create an enclave-enabled column encryption key, you need to ensure that you select an enclave-enabled column master key to encrypt the new key. 

The following sections provide more details on how to provision enclave-enabled keys using SSMS and PowerShell.

## Provision enclave-enabled keys using SQL Server Management Studio

In SQL Server Management Studio you can provision:

- An enclave-enabled column master key using the **New Column Master Key** dialog.
- An enclave-enabled column encryption key using the **New Column Encryption Key** dialog.

The [Always Encrypted Wizard](always-encrypted-wizard.md) also allows you to create an enclave-enabled column master key and an enclave-enabled column encryption key. 

Install the latest version of [SQL Server Management Studio (SSMS)](/ssms/install/install).

### Provision enclave-enabled column master keys with the New Column Master Key dialog

To provision an enclave-enabled column master key, follow the steps in [Provision Column Master Keys with the New Column Master Key Dialog](configure-always-encrypted-keys-using-ssms.md#provision-column-master-keys-with-the-new-column-master-key-dialog). Make sure you select **Allow enclave computations**. See the below screenshot:

![Allow enclave computations](./media/always-encrypted-enclaves/allow-enclave-computations.png)

> [!NOTE]
> The **Allow enclave computations** checkbox appears only if a secure enclave is  configured for your database. If you're using [!INCLUDE[ssNoVersion](../../../includes/ssnoversion-md.md)], see [Configure the secure enclave in SQL Server](always-encrypted-enclaves-configure-enclave-type.md). If you're using [!INCLUDE [ssazure-sqldb](../../../includes/ssazure-sqldb.md)], see [Enable Always Encrypted with secure enclaves for your Azure SQL Database](/azure/azure-sql/database/always-encrypted-enclaves-enable).

> [!TIP]
> To check if a column master key is enclave-enabled, right-click on it in Object Explorer and select **Properties**. If the key is enclave-enabled, **Enclave Computations: Allowed** appears in the window showing the properties of the key. Alternatively, you can use the [sys.column_master_keys (Transact-SQL)](../../system-catalog-views/sys-column-master-keys-transact-sql.md) view.

### Provision enclave-enabled column encryption keys with the New Column Encryption Key dialog

To provision an enclave-enabled column encryption key, follow the steps in [Provision Column Encryption Keys with the New Column Encryption Key Dialog](configure-always-encrypted-keys-using-ssms.md#provision-column-encryption-keys-with-the-new-column-encryption-key-dialog). When selecting a column master key, make sure it's enclave-enabled.

> [!TIP]
> To check if a column encryption key is enclave-enabled, right-click on it in Object Explorer and select **Properties**. If the key is enclave-enabled, **Enclave Computations: Allowed** appears in the window showing the properties of the key.

## Provision enclave-enabled keys using PowerShell

To provision enclave-enabled keys using PowerShell, you need the SqlServer PowerShell module version 22 or higher.

> [!NOTE]
> Microsoft recommends using PowerShell 7 or later when running Always Encrypted PowerShell scripts. PowerShell 7 provides improved cross-platform support, better performance, and the latest compatibility with the SqlServer module (v22+), which is required for many Always Encrypted scenarios.

In general, PowerShell key provisioning workflows (with and without role separation) for Always Encrypted, described in [Provision Always Encrypted Keys using PowerShell](configure-always-encrypted-keys-using-powershell.md) also apply to enclave-enabled keys. This section describes details specific to enclave-enabled keys.

The SqlServer PowerShell module extends the  [**New-SqlCertificateStoreColumnMasterKeySettings**](/powershell/module/sqlserver/new-sqlcertificatestorecolumnmasterkeysettings) and [**New-SqlAzureKeyVaultColumnMasterKeySettings**](/powershell/module/sqlserver/new-sqlazurekeyvaultcolumnmasterkeysettings) cmdlets with the `-AllowEnclaveComputations` parameter to allow you to specify a column master key that is enclave-enabled during the provisioning process. Either cmdlet creates a local object containing properties of a column master key (stored in Azure Key Vault or in the Windows Certificate Store). If specified, the `-AllowEnclaveComputations` property marks the key as enclave-enabled in the local object. It also causes the cmdlet to access the referenced column master key (in Azure Key Vault or in Windows Certificate Store) to digitally sign the properties of the key. Once you create a settings object for a new enclave-enabled column master key, you can use it in a subsequent invocation of the [**New-SqlColumnMasterKey**](/powershell/module/sqlserver/new-sqlcolumnmasterkey) cmdlet to create a metadata object describing the new key in the database.

Provisioning enclave-enabled column encryption keys is no different from provisioning column encryption keys that aren't enclave-enabled. You just need to make sure that a column master key used to encrypt the new column encryption key is enclave-enabled.

> [!NOTE]
> The SqlServer PowerShell module doesn't currently support provisioning enclave-enabled keys stored in hardware security modules (using CNG or CAPI).

### Example - provision enclave-enabled keys using Windows Certificate Store

The below end-to-end example shows how to provision enclave-enabled keys, storing the column master key stored in Windows Certificate Store. The script is based on the example in [Windows Certificate Store without Role Separation (Example)](configure-always-encrypted-keys-using-powershell.md#windows-certificate-store-without-role-separation-example). Important to note is the use of the `-AllowEnclaveComputations` parameter in the [**New-SqlCertificateStoreColumnMasterKeySettings**](/powershell/module/sqlserver/new-sqlcertificatestorecolumnmasterkeysettings) cmdlet, which is the only difference between the workflows in the two examples.

```powershell
[CmdletBinding()]
param(
	[Parameter(Mandatory = $false)]
	[string]$DatabaseName = '<database name>',

	[Parameter(Mandatory = $false)]
	[string]$ServerName = "<server name>",

	[Parameter(Mandatory = $false)]
	[string]$CertificateSubject = "AlwaysEncryptedCert",

	[Parameter(Mandatory = $false)]
	[string]$CmkName = "CMK",

	[Parameter(Mandatory = $false)]
	[string]$CekName = "CEK"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Import-Module SqlServer -MinimumVersion 22.0.50 -ErrorAction Stop

Write-Host "[AE] Locating certificate '$CertificateSubject' in CurrentUser\\My"
$cert = Get-ChildItem -Path Cert:CurrentUser\My |
	Where-Object { $_.Subject -eq "CN=$CertificateSubject" } |
	Sort-Object NotAfter -Descending |
	Select-Object -First 1

if (-not $cert) {
	Write-Host "[AE] Certificate not found. Creating self-signed certificate."
	$cert = New-SelfSignedCertificate `
		-Subject $CertificateSubject `
		-CertStoreLocation Cert:CurrentUser\My `
		-KeyExportPolicy Exportable `
		-Type DocumentEncryptionCert `
		-KeyUsage DataEncipherment `
		-KeySpec KeyExchange
}

Write-Host "[AE] Connecting to SQL Server '$ServerName' / Database '$DatabaseName'"
$connStr = "Server=$ServerName;Database=$DatabaseName;Integrated Security=True;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30"

try {
	$database = Get-SqlDatabase -ConnectionString $connStr -ErrorAction Stop
}
catch {
	Write-Error "Failed to connect to '$ServerName' database '$DatabaseName'. Verify instance name SQL2025, database existence, and local permissions."
	throw
}

Write-Host "[AE] Creating CMK settings from certificate thumbprint"
$cmkSettings = New-SqlCertificateStoreColumnMasterKeySettings -CertificateStoreLocation "CurrentUser" -Thumbprint $cert.Thumbprint -AllowEnclaveComputations

Write-Host "[AE] Ensuring CMK '$CmkName' exists"
$existingCmk = Get-SqlColumnMasterKey -InputObject $database | Where-Object { $_.Name -eq $CmkName }
if (-not $existingCmk) {
	New-SqlColumnMasterKey -Name $CmkName -InputObject $database -ColumnMasterKeySettings $cmkSettings | Out-Null
}

Write-Host "[AE] Ensuring CEK '$CekName' exists"
$existingCek = Get-SqlColumnEncryptionKey -InputObject $database | Where-Object { $_.Name -eq $CekName }
if (-not $existingCek) {
	New-SqlColumnEncryptionKey -Name $CekName -InputObject $database -ColumnMasterKey $CmkName | Out-Null
}

Write-Host "Completed successfully"
```

### Example - provision enclave-enabled keys using Azure Key Vault

The below end-to-end example shows how to provision enclave-enabled keys, storing the column master key in a key vault in Azure Key Vault. The script is based on the example in [Azure Key Vault without Role Separation (Example)](configure-always-encrypted-keys-using-powershell.md#azure-key-vault-without-role-separation-example). It's important to note two differences between the workflow for enclave-enabled keys compared to the keys that aren't enclave-enabled.

- In the below script, the [**New-SqlCertificateStoreColumnMasterKeySettings**](/powershell/module/sqlserver/New-SqlAzureKeyVaultColumnMasterKeySettings) uses the `-AllowEnclaveComputations` parameter to make the new column master key enclave-enabled.
- The below script uses the [**Get-AzAccessToken**](/powershell/module/az.accounts/get-azaccesstoken) cmdlet to obtain an access token for key vaults. This is necessary, because the  **New-SqlAzureKeyVaultColumnMasterKeySettings** needs to have access to the Azure Key Vault to sign the properties of the column master key.

```powershell
param(
	[Parameter(Mandatory = $true)] [string]$SubscriptionId,
	[Parameter(Mandatory = $true)] [string]$ResourceGroupName,
	[Parameter(Mandatory = $true)] [string]$AzureLocation,
	[Parameter(Mandatory = $true)] [string]$KeyVaultName,
	[Parameter(Mandatory = $true)] [string]$KeyName,
	[Parameter(Mandatory = $true)] [string]$ServerName,
	[Parameter(Mandatory = $true)] [string]$DatabaseName,
	[string]$CmkName = "CMK",
	[string]$CekName = "CEK",
	[bool]$AssignRbacToCurrentPrincipal = $true
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Import-Module Az.Accounts -ErrorAction Stop
Import-Module Az.Resources -ErrorAction Stop
Import-Module Az.KeyVault -ErrorAction Stop
Import-Module SqlServer -ErrorAction Stop

function Get-CurrentPrincipalObjectId {
	param([string]$AccountId)

	$userSignedIn = Get-AzADUser -SignedIn -ErrorAction SilentlyContinue
	if ($userSignedIn) { return $userSignedIn.Id }

	$user = Get-AzADUser -UserPrincipalName $AccountId -ErrorAction SilentlyContinue
	if ($user) { return $user.Id }

	$sp = Get-AzADServicePrincipal -DisplayName $AccountId -ErrorAction SilentlyContinue | Select-Object -First 1
	if ($sp) { return $sp.Id }

	throw "Could not resolve Microsoft Entra object id for account '$AccountId'."
}

try {
	Write-Host "[AE] Signing in and selecting subscription"
	Connect-AzAccount | Out-Null
	$ctx = Set-AzContext -SubscriptionId $SubscriptionId

	Write-Host "[AE] Ensuring resource group exists"
	$resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
	if (-not $resourceGroup) {
		$resourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $AzureLocation
	}

	Write-Host "[AE] Ensuring key vault exists (RBAC mode)"
	$vault = Get-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
	if (-not $vault) {
		$vault = New-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName -Location $AzureLocation -EnableRbacAuthorization
	}

	if (-not $vault.EnableRbacAuthorization) {
		throw "Key Vault '$KeyVaultName' is not using RBAC authorization. Enable RBAC authorization on the vault before running this script."
	}

	if ($AssignRbacToCurrentPrincipal) {
		Write-Host "[AE] Ensuring RBAC role assignment"
		$principalSignInName = $ctx.Account.Id
		$roleName = "Key Vault Crypto Officer"
		$existingRole = Get-AzRoleAssignment -SignInName $principalSignInName -Scope $vault.ResourceId -RoleDefinitionName $roleName -ErrorAction SilentlyContinue
		if (-not $existingRole) {
			New-AzRoleAssignment -SignInName $principalSignInName -Scope $vault.ResourceId -RoleDefinitionName $roleName | Out-Null
		}
	}

	Write-Host "[AE] Ensuring column master key material exists in Key Vault"
	$akvKey = Get-AzKeyVaultKey -VaultName $KeyVaultName -Name $KeyName -ErrorAction SilentlyContinue
	if (-not $akvKey) {
		$akvKey = Add-AzKeyVaultKey -VaultName $KeyVaultName -Name $KeyName -Destination "Software"
	}

	Write-Host "[AE] Connecting to Azure SQL and creating metadata"
	$keyVaultAccessToken = (Get-AzAccessToken -ResourceUrl "https://vault.azure.net").Token
	$connStr = "Server=tcp:$ServerName.database.windows.net,1433;Database=$DatabaseName;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication=Active Directory Interactive"
	$database = Get-SqlDatabase -ConnectionString $connStr -Encrypt Mandatory
	$cmkSettings = New-SqlAzureKeyVaultColumnMasterKeySettings -KeyUrl $akvKey.Key.Kid -AllowEnclaveComputations

	$existingCmk = Get-SqlColumnMasterKey -InputObject $database | Where-Object { $_.Name -eq $CmkName }
	if (-not $existingCmk) {
		New-SqlColumnMasterKey -Name $CmkName -InputObject $database -ColumnMasterKeySettings $cmkSettings | Out-Null
	}

	$existingCek = Get-SqlColumnEncryptionKey -InputObject $database | Where-Object { $_.Name -eq $CekName }
	if (-not $existingCek) {
		New-SqlColumnEncryptionKey -Name $CekName -InputObject $database -ColumnMasterKey $CmkName -KeyVaultAccessToken $keyVaultAccessToken | Out-Null
	}

	Write-Host "Completed successfully"
}
catch {
	Write-Error "Script failed: $($_.Exception.Message)"
	throw
}
```

## Related content

- [Run Transact-SQL statements using secure enclaves](always-encrypted-enclaves-query-columns.md)
- [Configure column encryption in-place using Always Encrypted with secure enclaves](always-encrypted-enclaves-configure-encryption.md)
- [Enable Always Encrypted with secure enclaves for existing encrypted columns](always-encrypted-enclaves-enable-for-encrypted-columns.md)
- [Develop applications using Always Encrypted with secure enclaves](always-encrypted-enclaves-client-development.md)
- [Getting started using Always Encrypted with secure enclaves](/azure/azure-sql/database/always-encrypted-enclaves-getting-started)
- [Manage keys for Always Encrypted with secure enclaves](always-encrypted-enclaves-manage-keys.md)
- [CREATE COLUMN MASTER KEY (Transact-SQL)](../../../t-sql/statements/create-column-master-key-transact-sql.md)
