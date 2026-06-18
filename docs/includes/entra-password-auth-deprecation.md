---
author: dlevy-msft-sql
ms.author: dlevy
ms.reviewer: davidengel, sumitsar, jathakkar
ms.date: 06/08/2026
ms.service: sql
ms.topic: include
---

> [!IMPORTANT]
> The ActiveDirectoryPassword authentication option (Microsoft Entra ID password authentication) is deprecated in the Microsoft SQL drivers. This high-risk authentication flow is incompatible with [mandatory Microsoft Entra multifactor authentication (MFA)](/entra/identity/authentication/concept-mandatory-multifactor-authentication) and might not work in tenants where MFA is enforced. Plan to migrate to a different Microsoft Entra authentication method.

Microsoft Entra ID password authentication is based on the [OAuth 2.0 Resource Owner Password Credentials (ROPC) grant](/entra/identity-platform/v2-oauth-ropc), which allows an application to sign in the user by directly handling their password.

Microsoft recommends that you don't use the ROPC flow because it's incompatible with MFA. In most scenarios, more secure alternatives are available and recommended. This flow requires a high degree of trust in the application, and carries risks that aren't present in other flows. Use this flow only when more secure flows aren't viable. Microsoft is moving away from this high-risk authentication flow to protect users from malicious attacks. For more information, see [Planning for mandatory multifactor authentication for Azure](/entra/identity/authentication/concept-mandatory-multifactor-authentication).

When a user is present at sign-in, use ActiveDirectoryInteractive or ActiveDirectoryIntegrated authentication so the audit trail attributes to the signed-in user and Conditional Access policies apply.

For unattended service-to-service scenarios, follow the [Microsoft Entra service account guidance](/entra/architecture/secure-service-accounts):

- If your application runs on Azure infrastructure, use ActiveDirectoryMSI (or ActiveDirectoryManagedIdentity in some drivers). Managed identities eliminate the overhead of maintaining and rotating secrets and certificates.
- If managed identity isn't available (for example, the application runs outside Azure), use ActiveDirectoryServicePrincipal. Where the driver supports it, prefer a client certificate over a client secret. With a certificate, the private key stays on the client and only a signed assertion is sent to Microsoft Entra to authenticate the client. If the key is stored in hardware (such as a TPM or HSM) or marked nonexportable, it can't be copied out as a string the way a client secret can.
- Don't use a Microsoft Entra user account as a service account.
