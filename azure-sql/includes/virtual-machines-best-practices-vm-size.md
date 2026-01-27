---
author: MashaMSFT
ms.author: mathoma
ms.reviewer: randolphwest
ms.date: 06/16/2025
ms.service: virtual-machines
ms.topic: include
ms.custom:
  - ignite-2024
---
- Identify workload performance characteristics to determine the appropriate VM size for your business.
- If you're migrating to Azure, use the [Azure SQL migration extension for Azure Data Studio](/azure/dms/migration-using-azure-data-studio) to find the right VM size for your existing SQL Server workload, and then migrate with [Azure Data Studio](/azure/dms/tutorial-sql-server-to-virtual-machine-online-ads). 
- Use Azure Marketplace images to deploy your SQL Server VMs as the SQL Server settings and storage options are configured for optimal performance.
- Use VM sizes with 4 or more vCPUs.
- Use memory optimized virtual machine sizes for the best performance of SQL Server workloads. 
   - The [Edsv5-series](../virtual-machines/windows/performance-guidelines-best-practices-vm-size.md#edsv5-series), and the [Msv3 and Mdsv3-series](../virtual-machines/windows/performance-guidelines-best-practices-vm-size.md#msv3-and-mdsv3-series) offer an optimal memory-to-vCore ratio recommended for OLTP workloads.
   - The [Mbdsv3-series VMs](../virtual-machines/windows/performance-guidelines-best-practices-vm-size.md#mbsv3-and-mbdsv3-series) offer the best performance for SQL Server workloads on Azure VMs. Consider this series first for mission critical OLTP and data warehouse SQL Server workloads.
   - The [Ebdsv5-series](../virtual-machines/windows/performance-guidelines-best-practices-vm-size.md#ebdsv5-series) provides a high I/O throughput-to-vCore ratio, along with a memory-to-vCore ratio of 8:1. This series offers the best price-performance for SQL Server workloads on Azure VMs. Consider these VMs first for most SQL Server workloads.  
   - The [M-series family](../virtual-machines/windows/performance-guidelines-best-practices-vm-size.md#memory-optimized-m-series-vms) offers VMs with the highest memory allocation in Azure. 
   - The [Mbsv3 and Mbdsv3 series](../virtual-machines/windows/performance-guidelines-best-practices-vm-size.md#mbsv3-and-mbdsv3-series) VMs provide a high memory allocation and the highest I/O throughput-to-vCore ratio amongst the M-series family, along with a consistent memory-to-vCore ratio of at least 8:1. 
- Start development environments with the lower-tier D-Series, B-Series, or Av2-series and grow your environment over time.
- Check [VM supportability](../virtual-machines/windows/performance-guidelines-best-practices-vm-size.md#supportability) to avoid unsupported configurations.
- Use [VM vCore customization](../virtual-machines/windows/performance-guidelines-best-practices-vm-size.md#vm-vcore-customization) to appropriately allocate vCPUs for your workload and VM and reduce SQL Server licensing costs.
