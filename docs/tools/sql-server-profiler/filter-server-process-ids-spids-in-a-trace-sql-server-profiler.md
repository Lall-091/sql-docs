---
title: Filter Session IDs in a Trace File
titleSuffix: SQL Server Profiler
description: Learn how to limit trace output in SQL Server Profiler by applying a filter on the Session ID (SPID).
author: markingmyname
ms.author: maghan
ms.date: 03/01/2017
ms.service: sql
ms.subservice: profiler
ms.topic: how-to
---

# Filter session IDs in a trace (SQL Server Profiler)
 [!INCLUDE [SQL Server Azure SQL Managed Instance](../../includes/applies-to-version/sql-asdbmi.md)]
  This topic describes how to filter session identifiers (SPIDs) in a trace by using [!INCLUDE[ssSqlProfiler](../../includes/sssqlprofiler-md.md)].  
  
### To filter system IDs in a trace  
  
1.  On the **File** menu, click **New Trace**, and then connect to an instance of SQL Server.  
  
     The **Trace Properties** dialog box appears.  
  
    > [!NOTE]  
    >  if **Start tracing immediately after making connection** is selected, the **Trace Properties** dialog box fails to appear, and the trace begins instead. To turn off this setting, on the **Tools** menu, click **Options**, and clear the **Start tracing immediately after making connection** check box.  
  
2.  In the **Trace name** box, type a name for the trace.  
  
3.  In the **Use the template** name list, select a trace template.  
  
4.  Optionally, specify a destination file or table in which to save the trace results.  
  
5.  On the **Events Selection** tab, click the **SPID** column heading to launch the **Edit Filter** dialog box. You can also right-click the column heading and choose **Edit Column Filter**. If the **SPID** column does not appear, check the **Show all columns** box.  
  
6.  In the **Edit Filter** dialog box, expand the appropriate comparison operator, and enter a session ID as a value for the comparison.  
  
## See Also  
 [SQL Server Profiler](../../tools/sql-server-profiler/sql-server-profiler.md)  
  
  
