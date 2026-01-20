---
author: David-Engel
ms.author: davidengel
ms.date: 01/16/2026
ms.service: sql
ms.topic: include
---

> [!NOTE]
> The ActiveDirectoryPassword authentication option (Microsoft Entra ID Password authentication) is deprecated.

Microsoft Entra ID password is based on the [OAuth 2.0 Resource Owner Password Credentials (ROPC) grant](/entra/identity-platform/v2-oauth-ropc), which allows an application to sign in the user by directly handling their password.

Microsoft recommends you don't use the ROPC flow; it's incompatible with multifactor authentication (MFA). In most scenarios, more secure alternatives are available and recommended. This flow requires a high degree of trust in the application, and carries risks that aren't present in other flows. You should only use this flow when more secure flows aren't viable. Microsoft is moving away from this high-risk authentication flow to protect users from malicious attacks. For more information, see [Planning for mandatory multifactor authentication for Azure](/entra/identity/authentication/concept-mandatory-multifactor-authentication).

When user context is available, use ActiveDirectoryInteractive authentication.

When user context isn't available and your app is running on Azure infrastructure, use ActiveDirectoryMSI (or ActiveDirectoryManagedIdentity in some drivers). Managed Identity eliminates the overhead of maintaining and rotating secrets and certificates. If you can't use Managed Identity, use ActiveDirectoryServicePrincipal authentication.

> [!WARNING]
> Don't use Service Principal authentication when a user context is available. App-only access is inherently high-privilege, often granting tenant-wide access and potentially allowing a bad actor to access customer data for any user.
