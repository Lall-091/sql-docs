---
title: Overview of SQL Server on Linux
description: This article describes how SQL Server runs on Linux and provides information on how to learn more.
author: rwestMSFT
ms.author: randolphwest
ms.reviewer: amitkh, atsingh
ms.date: 02/24/2026
ms.service: sql
ms.subservice: linux
ms.topic: concept-article
ms.custom:
  - linux-related-content
  - ignite-2025
---
# What is SQL Server on Linux?

[!INCLUDE [SQL Server - Linux](../includes/applies-to-version/sql-linux.md)]

[!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] runs on Linux, starting with [!INCLUDE [sssql17-md](../includes/sssql17-md.md)]. It's the same [!INCLUDE [ssdenoversion-md](../includes/ssdenoversion-md.md)] with many similar features and services across supported operating systems.

## Get started

If you're familiar with [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] and unfamiliar with Linux, see [New to Linux resources for SQL users](new-to-linux-resources.md).

If you're familiar with Linux and unfamiliar with [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)], see [New to SQL Server: Learning resources](new-to-sql-learning-resources.yml).

## Choose your installation

The following sections help you install [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] on Linux in your preferred environment.

- Install SQL Server directly on a **[Linux machine or VM](#linux-vm)**
- Run SQL Server in a **[Linux container](#container-images)**
- Install SQL Server on **[Windows Subsystem for Linux (WSL 2)](#wsl2)** *(for development only)*

<a id="linux-vm"></a>

### Install SQL Server directly on a Linux machine or VM

The following quickstart articles describe how to install SQL Server on Linux on physical hardware or a virtual machine (VM) and create a database:

| Platform | SQL Server version supported |
| --- | --- |
| [Red Hat Enterprise Linux](quickstart-install-connect-red-hat.md) (RHEL) | 2017, 2019, 2022, and 2025 |
| [Ubuntu](quickstart-install-connect-ubuntu.md) | 2017, 2019, 2022, and 2025 |
| [SUSE Linux Enterprise Server](quickstart-install-connect-suse.md) (SLES) <sup>1</sup> | 2017, 2019, and 2022 only |
| [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/linux/sql-vm-create-portal-quickstart?toc=/sql/toc/toc.json) | 2017, 2019, 2022, and 2025 |

<sup>1</sup> SUSE Linux Enterprise Server (SLES) isn't supported on [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] and later versions.

<a id="container-images"></a>

### Run SQL Server in a Linux container

Containers are useful in local testing, continuous integration and deployment (CI/CD), and ephemeral workloads in your development environment. They're also commonly used as part of container orchestration in production environments, including Azure Kubernetes Services (AKS), Red Hat OpenShift, and DH2i DxOperator.

For instructions on how to install SQL Server in a Linux container, see [Quickstart: Run SQL Server Linux container images with Docker](quickstart-install-connect-docker.md).

The [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] container images are published and available on the Microsoft Container Registry (MCR). They're also cataloged at the following locations, based on the operating system image that was used when creating the container image:

- For both RHEL and Ubuntu based [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] container images, see [SQL Server on the Microsoft Artifact Registry](https://mcr.microsoft.com/catalog?cat=Databases).
- For RHEL-based [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] container images, see [SQL Server Red Hat containers](https://catalog.redhat.com/software/containers/mssql/rhel/server/61f2f612f385723914ed60bc).

> [!NOTE]  
> Containers are only published to MCR for the *most recent* Linux distributions. If you create your own custom [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] container image for an older supported distribution, it's still supported. For more information, see [Upcoming updates to SQL Server container images on Microsoft Artifact Registry (MCR)](https://techcommunity.microsoft.com/blog/sqlserver/upcoming-updates-to-sql-server-container-images-on-microsoft-artifact-registry-a/3573013).

<a id="wsl2"></a>

### Install SQL Server on Windows Subsystem for Linux (WSL 2)

SQL Server on WSL 2 is intended for development purposes only, and is **not** supported for production workloads. Run SQL Server in WSL environments on one of the [supported platforms](sql-server-linux-release-notes-2025.md#supported-platforms) for the version of SQL Server you intend to run.

For instructions on how to install SQL Server on WSL 2, see [Windows Subsystem for Linux (WSL 2)](quickstart-install-connect-wsl-2.md).

## Connect

After installation, connect to the [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] instance on your Linux machine. You can connect locally or remotely and with various tools and drivers. The quickstarts demonstrate how to use the [sqlcmd](sql-server-linux-setup-tools.md) command-line tool. Other tools include:

| Tool | Tutorial |
| --- | --- |
| **[sqlcmd utility](../tools/sqlcmd/sqlcmd-utility.md)** | [Connect to SQL Server with sqlcmd](../tools/sqlcmd/sqlcmd-connect-database-engine.md) |
| **[MSSQL extension for Visual Studio Code](../tools/visual-studio-code-extensions/mssql/mssql-extension-visual-studio-code.md)** | [Connect to and query a database with the MSSQL extension for Visual Studio Code](../tools/visual-studio-code-extensions/mssql/connect-database-visual-studio-code.md) |
| **[SQL Server Management Studio (SSMS)](/ssms/sql-server-management-studio-ssms)** | [Use SQL Server Management Studio on Windows to manage SQL Server on Linux](sql-server-linux-manage-ssms.md) |
| **[SQL Server Data Tools (SSDT)](../ssdt/sql-server-data-tools.md)** | [Use Visual Studio to create databases for SQL Server on Linux](sql-server-linux-develop-use-ssdt.md) |

## Explore

[!INCLUDE [sssql17-md](../includes/sssql17-md.md)] and later versions have the same underlying [!INCLUDE [ssde-md](../includes/ssde-md.md)] on all supported platforms, including Linux and containers. Therefore, many existing features and capabilities operate the same way. This area of the documentation highlights some of these features from a Linux perspective and calls out areas that have unique requirements on Linux.

If you're already familiar with [!INCLUDE [ssnoversion-md](../includes/ssnoversion-md.md)] on Linux, review the release notes for general guidelines and known issues for each release.

| SQL Server version | Release notes (Linux) | What's new (Linux) | What's new (Windows) |
| --- | --- | --- | --- |
| [!INCLUDE [sssql25-md](../includes/sssql25-md.md)] | [Release notes](sql-server-linux-release-notes-2025.md) | [SQL Server on Linux](sql-server-linux-whats-new-2025.md) | [SQL Server on Windows](../sql-server/what-s-new-in-sql-server-2025.md) |
| [!INCLUDE [sssql22-md](../includes/sssql22-md.md)] | [Release notes](sql-server-linux-release-notes-2022.md) | [SQL Server on Linux](sql-server-linux-whats-new-2022.md) | [SQL Server on Windows](../sql-server/what-s-new-in-sql-server-2022.md) |
| [!INCLUDE [sssql19-md](../includes/sssql19-md.md)] | [Release notes](sql-server-linux-release-notes-2019.md) | [SQL Server on Linux](sql-server-linux-whats-new-2019.md) | [SQL Server on Windows](../sql-server/what-s-new-in-sql-server-2019.md) |
| [!INCLUDE [sssql17-md](../includes/sssql17-md.md)] | [Release notes](sql-server-linux-release-notes-2017.md) | [SQL Server on Linux](sql-server-linux-whats-new-2017.md) | [SQL Server on Windows](../sql-server/what-s-new-in-sql-server-2017.md) |

> [!TIP]  
> For answers to frequently asked questions, see the [SQL Server on Linux FAQ](sql-server-linux-faq.yml).

[!INCLUDE [Get Help Options](../includes/paragraph-content/get-help-options.md)]
