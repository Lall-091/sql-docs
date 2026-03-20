---
title: AppContext switches in SqlClient
description: Learn about the AppContext switches available in SqlClient and how to use them to modify some default behaviors.
author: cheenamalhotra
ms.author: cmalhotra
ms.date: 03/17/2026
ms.service: sql
ms.subservice: connectivity
ms.topic: concept-article
dev_langs:
  - "csharp"
ms.custom: sfi-ropc-nochange
ai-usage: ai-assisted
---

# AppContext switches in SqlClient

[!INCLUDE [dotnet-all](../../includes/products/applies-full/dotnet-all.md)]

[!INCLUDE [Driver_ADONET_Download](../../includes/driver_adonet_download.md)]

The AppContext class allows SqlClient to provide new functionality while continuing to support callers who depend on the previous behavior. Users can opt out of a change in behavior by setting specific AppContext switches.

## Enable MultiSubnetFailover by default

[!INCLUDE [dotnet-all](../../includes/products/applies-plain/dotnet-all.md)]

(Available starting with version 7.0)

To set `MultiSubnetFailover=true` globally without modifying individual connection strings, you can set the AppContext switch **"Switch.Microsoft.Data.SqlClient.EnableMultiSubnetFailoverByDefault"** to `true` at application startup:  

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.EnableMultiSubnetFailoverByDefault", true);
```

You can also enable this switch in your App.Config:

```xml
<runtime>
  <AppContextSwitchOverrides value="Switch.Microsoft.Data.SqlClient.EnableMultiSubnetFailoverByDefault=true" />
</runtime>
```

When enabled, all connections behave as if `MultiSubnetFailover=true` is set in the connection string. This switch is disabled by default.

## Enable packet multiplexing for async reads

[!INCLUDE [dotnet-all](../../includes/products/applies-plain/dotnet-all.md)]

(Available starting with version 7.0)

Packet multiplexing improves performance for large async read operations such as `ExecuteReaderAsync` with big result sets, streaming scenarios, or bulk data retrieval. This feature is controlled by two opt-in AppContext switches. Setting both switches to `false` enables the new async processing path:

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.UseCompatibilityAsyncBehaviour", false);
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.UseCompatibilityProcessSni", false);
```

By default, both switches are `true`, which preserves the existing (compatible) behavior.

## Enable User Agent feature extension

[!INCLUDE [dotnet-all](../../includes/products/applies-plain/dotnet-all.md)]

(Available starting with version 7.0)

When the AppContext switch **"Switch.Microsoft.Data.SqlClient.EnableUserAgent"** is enabled, the driver sends user agent details to the server as part of the connection. This information assists with troubleshooting and quantifying driver usage by version and operating system. This switch is disabled by default. To enable it, set the AppContext switch to `true` at application startup:  

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.EnableUserAgent", true);
```

## Enabling decimal truncation behavior

[!INCLUDE [dotnet-all](../../includes/products/applies-plain/dotnet-all.md)]

Starting with Microsoft.Data.SqlClient 2.0, decimal data is rounded by default, as is done by SQL Server. To enable the previous behavior of truncation, you can set the AppContext switch **"Switch.Microsoft.Data.SqlClient.TruncateScaledDecimal"** to `true` at application startup:

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.TruncateScaledDecimal", true);
```

## Enabling managed networking on Windows

[!INCLUDE [dotnet-modern](../../includes/products/applies-plain/dotnet-modern.md)]

(Available starting with version 2.0)

On Windows, SqlClient uses a native implementation of the SNI network interface by default. To enable the use of a managed SNI implementation, you can set the AppContext switch **"Switch.Microsoft.Data.SqlClient.UseManagedNetworkingOnWindows"** to `true` at application startup:

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.UseManagedNetworkingOnWindows", true);
```

This switch toggles the driver's behavior to use a managed networking implementation in .NET Core 2.1+ and .NET Standard 2.0+ projects on Windows, eliminating all dependencies on native libraries for the Microsoft.Data.SqlClient library. It is for testing and debugging purposes only.

> [!NOTE]
> There are some known differences when compared to the native implementation. For example, the managed implementation does not support non-domain Windows Authentication.

## Disabling Transparent Network IP Resolution

[!INCLUDE [dotnet-framework-only](../../includes/products/applies-plain/dotnet-framework-only.md)]

Transparent Network IP Resolution (TNIR) is a revision of the existing MultiSubnetFailover feature. TNIR affects the connection sequence of the driver in the case where the first resolved IP of the hostname doesn't respond and there are multiple IPs associated with the hostname. TNIR interacts with MultiSubnetFailover to provide the following three connection sequences:

* 0: One IP is attempted, followed by all IPs in parallel
* 1: All IPs are attempted in parallel
* 2: All IPs are attempted one after another

|TransparentNetworkIPResolution|MultiSubnetFailover|Behavior|
|--------|--------|--------|
|True|True|1|
|True|False|0|
|False|True|1|
|False|False|2|

TransparentNetworkIPResolution is enabled by default. MultiSubnetFailover is disabled by default. To disable TNIR, you can set the AppContext switch **"Switch.Microsoft.Data.SqlClient.DisableTNIRByDefaultInConnectionString"** to `true` at application startup:

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.DisableTNIRByDefaultInConnectionString", true);
```

For more information about setting these properties, see the documentation for [SqlConnection.ConnectionString Property](/dotnet/api/microsoft.data.sqlclient.sqlconnection.connectionstring).

## Enable a minimum timeout during login

[!INCLUDE [dotnet-all](../../includes/products/applies-plain/dotnet-all.md)]

To prevent a login attempt from waiting indefinitely, you can set the AppContext switch **Switch.Microsoft.Data.SqlClient.UseOneSecFloorInTimeoutCalculationDuringLogin** to `true` at application startup:

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.UseOneSecFloorInTimeoutCalculationDuringLogin", false);
```

## Disable blocking behavior of ReadAsync

[!INCLUDE [dotnet-all](../../includes/products/applies-plain/dotnet-all.md)]

Starting in version 3.0, ReadAsync runs asynchronously. Previous versions run ReadAsync synchronously and block the calling thread on .NET Framework. To control this blocking behavior, you can set the AppContext switch **Switch.Microsoft.Data.SqlClient.MakeReadAsyncBlocking** to `true` or `false` at application startup:

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.MakeReadAsyncBlocking", false);
```

## Enabling rowversion null behavior

[!INCLUDE [dotnet-all](../../includes/products/applies-plain/dotnet-all.md)]

Starting in version 3.0, when a rowversion has a value of null, `SqlDataReader` returns a `DBNull` value instead of an empty `byte[]`. To enable the legacy behavior of returning an empty `byte[]`, enable the AppContext switch **Switch.Microsoft.Data.SqlClient.LegacyRowVersionNullBehavior** on application startup.

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.LegacyRowVersionNullBehavior", true);
```

## Suppress insecure TLS warning

[!INCLUDE [dotnet-all](../../includes/products/applies-plain/dotnet-all.md)]

(Available starting with version 4.0.1)

When using `Encrypt=false` in the connection string, a security warning is output to the console if the TLS version is 1.2 or lower. This warning can be suppressed by enabling the following AppContext switch on application startup:

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.SuppressInsecureTLSWarning", true);
```

## Ignore Server Provided Failover Partner

[!INCLUDE [dotnet-all](../../includes/products/applies-plain/dotnet-all.md)]

(Available starting with versions 5.1.8, 6.0.4, and 6.1.3)

Upon failover, failover partner information provided by the server is preferred over failover partner information provided in the connection string. To ignore failover partner information provided by the server and only consider failover partner information provided in the connection string, enable this AppContext switch on application startup:

```csharp
AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.IgnoreServerProvidedFailoverPartner", true);
```

## See also

[AppContext Class](/dotnet/api/system.appcontext?view=netcore-3.1&preserve-view=true)
