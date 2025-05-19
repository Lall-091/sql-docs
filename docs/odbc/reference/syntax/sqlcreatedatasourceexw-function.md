---
title: "SQLCreateDataSourceExW Function"
description: "SQLCreateDataSourceExW Function"
author: corylaban
ms.author: corylaban
ms.date: "05/07/2025"
ms.service: sql
ms.subservice: connectivity
ms.topic: reference
f1_keywords:
  - "SQLCreateDataSourceExW"
helpviewer_keywords:
  - "SQLCreateDataSourceExW function [ODBC]"
apilocation: "odbccp32.dll"
apiname: "SQLCreateDataSourceExW"
apitype: "dllExport"
---
# SQLCreateDataSourceExW Function
**Conformance**  
 Version Introduced: ODBC 2.0  
  
 **Summary**  
 **SQLCreateDataSourceExW** adds a data source programmatically.

> [!WARNING]  
> The `SQLCreateDataSourceExW` function is private and isn't meant to be used directly in your code.
> Microsoft doesn't support the use of this field in a production application under any circumstance.

## Syntax  

```cpp
typedef enum tagDSNType
{
	evCreateAnyDSN,
	evCreateMachineDSN,
	evCreateUserDSN,
	evCreateSystemDSN,
	evCreateFileDSN
} DSN_TYPE;

#define		DSNC_ATTEMPT_CONN		0x00000001
#define		DSNC_DRIVER_ONLY		0x00000002

typedef struct tagODBCDSNCreationInfoW
{
	DWORD		dwSize;
	HWND		hwndParent;
	DSN_TYPE	DSNType;
	DSN_TYPE	DSNRestrictType;
	DWORD 		dwCIFlags;
	WCHAR		szDSNName[_MAX_PATH + 1];
	LPWSTR		szParentDir;
} ODBC_CREATE_DATASOURCE_INFOW;

BOOL INSTAPI SQLCreateDataSourceExW(
	ODBC_CREATE_DATASOURCE_INFOW * pCreateDSInfoW);
```  

## Arguments  
*pCreateDSInfoW*  
[Input] A struct of type `ODBC_CREATE_DATASOURCE_INFOW` see comments for descriptions.

## Returns  
**SQLCreateDataSourceExW** returns TRUE if the data source is created. Otherwise, it returns FALSE. See [SqlCreateDataSource](./sqlcreatedatasource-function.md#diagnostics) for diagnostic info about error codes when this function returns FALSE.

## Comments
The `ODBC_CREATE_DATASOURCE_INFOW` has the following fields:

*dwSize*  
A `DWORD` containing the size of the struct.

*hwndParent*  
A handle to the parent directory of the data source.

*DSNType*  
The type of DSN to create. See [About Drivers and Data Sources](../../admin/about-drivers-and-data-sources.md) to understand what these enums map to.

*DSNRestrictType*  
The least restricted DSN type allowed. 

*dwCIFlags*  
A mask with bits for either `DSNC_ATTEMPT_CONN` or `DSNC_DRIVER_ONLY`.

*szDSNName*  
Data source name.

*szParentDir*  
The parent directory of the data source.

## Related Functions  

|For information about|See|  
|---------------------------|---------|  
|Creating data sources|[SQLCreateDataSource](./sqlcreatedatasource-function.md)|
