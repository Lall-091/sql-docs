---
title: "TraceVSControl Function"
description: "TraceVSControl Function"
author: corylaban
ms.author: corylaban
ms.date: "05/07/2025"
ms.service: sql
ms.subservice: connectivity
ms.topic: reference
f1_keywords:
  - "TraceVSControl"
helpviewer_keywords:
  - "TraceVSControl [ODBC]"
apilocation: "odbctrac.dll"
apiname: "TraceVSControl"
apitype: "dllExport"
---
# TraceVSControl Function
**Conformance**  
 Version Introduced: ODBC 2.0  
  
 **Summary**  
 **TraceVSControl** toggles Visual Studio tracing.

> [!WARNING]  
> The `TraceVSControl` function is private and isn't meant to be used directly in your code.
> Microsoft doesn't support the use of this field in a production application under any circumstance.
> Follow instructions in [Setting Tracing Options](../../../odbc/admin/setting-tracing-options.md)
> to configure tracing.

## Syntax  
  
```cpp  
RETCODE SQL_API TraceVSControl(DWORD dwControl);
```  
  
## Arguments  
 *dwControl*  
 [Input] A DWORD indicating whether to enable VS tracing. Call `TraceVSControl` with `0x1L` to turn on tracing and `0x0L` to turn off tracing.
  
## Returns  
 Always returns SQL_SUCCESS.

## Related Information
  
|For information about|See|  
|---------------------------|---------|  
|Understanding ODBC tracing|[Setting Tracing Options](../../../odbc/admin/setting-tracing-options.md)|
