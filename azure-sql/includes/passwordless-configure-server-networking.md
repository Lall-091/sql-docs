---
author: WilliamDAssafMSFT
ms.author: wiassaf
ms.reviewer: rotabor, alexwolf
ms.date: 01/13/2026
ms.service: azure-sql-database
ms.topic: include
---

Secure, passwordless connections to Azure SQL Database require certain database configurations. Verify the following settings on your [logical server in Azure](../database/logical-servers.md) to properly connect to Azure SQL Database in both local and hosted environments:

1. For local development connections, make sure your Azure SQL logical server is configured to allow your local machine IP address and other Azure services to connect:

    1. In the Azure portal, in the resource menu, under **Security**, select **Networking**.
    1. Select the **Selected networks** button to show additional configuration options.
    1. Select **Add your client IPv4 address(xx.xx.xx.xx)** to add a firewall rule that will enable connections from your local machine IPv4 address. Alternatively, you can also select **+ Add a firewall rule** to enter a specific IP address of your choice.
    1. Make sure the **Allow Azure services and resources to access this server** checkbox is selected.

        :::image type="content" source="../database/media/passwordless-connections/configure-firewall.png" lightbox="../database/media/passwordless-connections/configure-firewall.png" alt-text="Screenshot from the Azure portal showing how to configure the Azure SQL logical server firewall rules.":::

        > [!WARNING]
        > Enabling the **Allow Azure services and resources to access this server** setting is not a recommended security practice for production scenarios. Real applications should implement more secure approaches, such as stronger firewall restrictions or virtual network configurations.
        >
        > You can read more about database security configurations on the following resources:
        >
        > - [Configure Azure SQL Database firewall rules](/azure/azure-sql/database/firewall-configure).
        > - [Configure a virtual network with private endpoints](/azure/private-link/tutorial-private-endpoint-sql-portal).

1. The server must also have Microsoft Entra authentication enabled and have a Microsoft Entra admin account assigned. For local development connections, the Microsoft Entra admin account should be an account you can also log into Visual Studio or the Azure CLI with locally. You can verify whether your server has Microsoft Entra authentication enabled on the **Microsoft Entra ID** page of your logical server.

    :::image type="content" source="../database/media/passwordless-connections/enable-active-directory.png" lightbox="../database/media/passwordless-connections/enable-active-directory.png" alt-text="A screenshot showing how to enable Microsoft Entra authentication.":::

1. If you're using a personal Azure account, make sure you have [Microsoft Entra setup and configured for Azure SQL Database](../database/authentication-aad-configure.md) in order to assign your account as a server admin. If you're using a corporate account, Microsoft Entra ID will most likely already be configured for you.