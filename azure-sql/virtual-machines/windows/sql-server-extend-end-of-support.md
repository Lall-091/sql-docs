---
title: Extend support for SQL Server
description: Extend support for SQL Server 2014 by migrating your SQL Server instance to Azure, or purchasing extended support to keep instances on-premises.
author: dplessMSFT
ms.author: dpless
ms.reviewer: mathoma, randolphwest
ms.date: 12/20/2025
ms.service: azure-vm-sql-server
ms.subservice: management
ms.topic: concept-article
tags: azure-service-management
---
# Extend support for SQL Server with Azure

[!INCLUDE[appliesto-sqlvm](../../includes/appliesto-sqlvm.md)]

SQL Server 2014 reached the [end of its support (EOS) life cycle](/lifecycle/products/sql-server-2014). This article describes how you can extend support for SQL Server 2014 at no extra cost by migrating your workload to SQL Server on Azure Virtual Machines (VMs). 

Unlike with Azure SQL Managed Instance and Azure SQL Database, migrating to an Azure VM doesn't require your applications to be recertified. 

For more information about end of support options, see [End of support](/sql/sql-server/end-of-support/sql-server-end-of-support-overview).

## Provisioning

Customers who use an earlier version of SQL Server need to either self-install or upgrade to SQL Server 2014. Likewise, customers who use an earlier version of Windows Server need to either deploy their VM from a custom VHD or upgrade to Windows Server 2012 R2.

Images deployed through Azure Marketplace come with the SQL IaaS Agent extension preinstalled. The SQL IaaS Agent extension is a requirement for flexible licensing and automated patching. Customers who deploy self-installed VMs need to manually install the SQL IaaS Agent extension.

## Licensing

You can convert pay-as-you-go SQL Server 2014 deployments to [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit/).
To convert a Software Assurance (SA)-based license to pay-as-you-go, register with the [SQL IaaS Agent extension](sql-agent-extension-manually-register-single-vm.md). After registration, the SQL license type is interchangeable between Azure Hybrid Benefit and pay-as-you-go.

You can register self-installed SQL Server 2014 instances on an Azure VM with the SQL IaaS Agent extension and convert their license type to pay-as-you-go.

## Migration

You can migrate end of support SQL Server instances to an Azure VM by using manual backup and restore methods. This method is the most common migration method from on-premises to an Azure VM.

### Azure Site Recovery

For bulk migrations, use the [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) service. By using Azure Site Recovery, you can replicate the whole VM, including SQL Server, from on-premises to an Azure VM.

SQL Server requires app-consistent Azure Site Recovery snapshots to guarantee recovery. Azure Site Recovery supports app-consistent snapshots with a minimum 1-hour interval. The minimum recovery point objective (RPO) possible for SQL Server with Azure Site Recovery migrations is 1 hour. The recovery time objective (RTO) is 2 hours plus SQL Server recovery time.

### Database Migration Service

Use the [Azure Database Migration Service](/azure/dms/dms-overview) if you're migrating from on-premises to an Azure VM and upgrading SQL Server to the 2014 version or later.

## Disaster recovery

Disaster recovery solutions for end of support SQL Server on an Azure VM are as follows:

- **SQL Server backups**: Use Azure Backup to help protect your end of support SQL Server 2014 instances against ransomware, accidental deletion, and corruption with a 15-minute RPO and point-in-time recovery. For more information, see [this article](/azure/backup/sql-support-matrix#scenario-support).

- **Log shipping**: You can create a log shipping replica in another zone or Azure region with continuous restores to reduce the RTO. You need to manually configure log shipping.

- **Azure Site Recovery**: You can replicate your VM between zones and regions through Azure Site Recovery replication. SQL Server requires app-consistent snapshots to guarantee recovery if there's a disaster. Azure Site Recovery offers a minimum 1-hour RPO and a 2-hour (plus SQL Server recovery time) RTO for end of support SQL Server disaster recovery.

## Security patching

After you register a SQL Server VM with the [SQL IaaS Agent extension](sql-agent-extension-manually-register-single-vm.md), Microsoft delivers extended security updates for SQL Server VMs through the Microsoft Windows Update channels. You can manually or automatically download patches.

*Automated patching* is enabled by default. By using automated patching, Azure automatically patches SQL Server and the operating system. You can specify a day of the week, time, and duration for a maintenance window if the SQL Server IaaS extension is installed. Azure performs patching during this maintenance window. The maintenance window schedule uses the VM locale for time. For more information, see [Automated patching for SQL Server on Azure Virtual Machines](automated-patching.md).

For improved patching management, which also includes Cumulative Updates, try the integrated [Azure Update Manager](../azure-update-manager-sql-vm.md) experience. 

> [!NOTE]
> You don't need to register with the [SQL IaaS Agent extension](sql-agent-extension-manually-register-single-vm.md) for _manual_ installation of extended security updates on Azure virtual machines. Microsoft Update automatically detects the VM is running in Azure and presents relevant updates for download even if the extension isn't installed.

As of today, [Azure Update management](/azure/automation/update-management/overview) doesn't detect patches for SQL Server Marketplace images. You should look under Windows Updates to apply SQL Server updates in this case.

## Next steps

- [Migration guide: SQL Server to SQL Server on Azure Virtual Machines](../../migration-guides/virtual-machines/sql-server-to-sql-on-azure-vm-individual-databases-guide.md)
- [Create a SQL Server VM in the Azure portal](sql-vm-create-portal-quickstart.md)
- [FAQ for SQL Server on Azure Virtual Machines](frequently-asked-questions-faq.yml)

Find out more about [end of support](/sql/sql-server/end-of-support/sql-server-end-of-support-overview) options and [Extended Security Updates](/sql/sql-server/end-of-support/sql-server-extended-security-updates).
