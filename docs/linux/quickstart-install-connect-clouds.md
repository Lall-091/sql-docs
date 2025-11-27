---
title: "Get Started with SQL Server (On Linux) in the Cloud"
titleSuffix: SQL Server
description: Learn how to install SQL Server on Red Hat Enterprise Linux (RHEL), SUSE Linux Enterprise Server (SLES), or Ubuntu in the cloud of your choice.
author: rwestMSFT
ms.author: randolphwest
ms.date: 08/07/2025
ms.service: sql
ms.subservice: linux
ms.topic: get-started
ms.custom:
  - intro-get-started
  - linux-related-content
  - build-2025
---
# Quickstart: Run SQL Server in the cloud

[!INCLUDE [SQL Server - Linux](../includes/applies-to-version/sql-linux.md)]

In this quickstart, you install [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] on Red Hat Enterprise Linux (RHEL), SUSE Linux Enterprise Server (SLES), or Ubuntu in the cloud of your choice. To run [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] on Linux in Azure, see [Provision a Linux virtual machine running SQL Server in the Azure portal](/azure/azure-sql/virtual-machines/linux/sql-vm-create-portal-quickstart).

> [!NOTE]  
> If you choose to run a paid edition of [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)], then you need to bring your own license (BYOL).

## Amazon Web Services

1. Create a Linux AMI with at least 2 GB of memory from the marketplace
   - [RHEL 9](https://aws.amazon.com/marketplace/pp/prodview-b5psjqk4f5f3k)
   - [SLES v15](https://aws.amazon.com/marketplace/pp/prodview-o5wqlcnuzvyv2)
   - [Ubuntu 22.04](https://aws.amazon.com/marketplace/pp/prodview-f2if34z3a4e3i)
1. Connect to the AMI with **ssh**
1. Follow the quickstart for the Linux distribution you chose:
   - [Red Hat Enterprise Linux](quickstart-install-connect-red-hat.md)
   - [SUSE Linux Enterprise Server](quickstart-install-connect-suse.md)
   - [Ubuntu](quickstart-install-connect-ubuntu.md)
   - [Windows Subsystem for Linux (WSL 2)](quickstart-install-connect-wsl-2.md)
1. Configure for remote connections:
   - Open the [Amazon EC2 console](https://console.aws.amazon.com/ec2/)
   - In the navigation pane, choose **Security Groups**.
   - Choose **Inbound, Edit, Add Rule**
   - Add an inbound rule to allow traffic on the port on which [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] listens (default TCP port 1433)

## Digital Ocean

1. Sign in to the [control panel](https://cloud.digitalocean.com/login) and select **Create a droplet**
1. Choose an Ubuntu 22.04 droplet with at least 2 GB of memory
1. Connect to the droplet with **ssh**
1. Follow the [Ubuntu quickstart](quickstart-install-connect-ubuntu.md)
1. Configure for remote connections:
   - At the top of the Control Panel, follow the **Networking** link and then select **Firewalls**
   - Add an inbound rule to allow traffic on the port on which [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] listens (default TCP port 1433)

## Google Cloud Platform

1. Create a Linux image with at least 2 GB of memory from the Cloud Launcher
   - [RHEL 9](https://console.cloud.google.com/marketplace/details/rhel-cloud/rhel-9)
   - [SLES v15](https://console.cloud.google.com/marketplace/details/suse-cloud/sles-15)
   - [Ubuntu 22.04](https://console.cloud.google.com/marketplace/details/ubuntu-os-cloud/ubuntu-jammy)
1. Connect to the image with **ssh**
1. Follow the quickstart for the Linux distribution you chose:
   - [Red Hat Enterprise Linux](quickstart-install-connect-red-hat.md)
   - [SUSE Linux Enterprise Server](quickstart-install-connect-suse.md)
   - [Ubuntu](quickstart-install-connect-ubuntu.md)
1. Configure for remote connections:
   - Go to the [Firewall Rules](https://console.cloud.google.com/networking/firewalls)
   - Add an inbound rule to allow traffic on the port on which [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] listens (default TCP port 1433)
