---
title: "Omitting Values for Optional Web Service Objects"
description: Some properties of Report Server Web service complex types support the Specified property, which allows you to omit a value for some writable properties.
ms.date: 01/07/2026
ms.service: reporting-services
ms.subservice: report-server-web-service
ms.topic: reference
ms.custom:
  - updatefrequency5
helpviewer_keywords:
  - "Web service [Reporting Services], omitted values"
  - "XML Web service [Reporting Services], omitted values"
  - "Report Server Web service, omitted values"
  - "omitting values [Reporting Services]"
---
# Omitting values for optional Web service objects

Properties of several Report Server Web service complex types include an accompanying property known as the `Specified` property. The name of this property consists of the original property name with the word `Specified` appended to it. The presence of this property indicates that you can sometimes omit a value for the original property. This property results from the translation of the Web Service Description Language (WSDL) to a [!INCLUDE [dnprdnshort](../../../includes/dnprdnshort-md.md)] proxy class. For example, the Web service property <xref:ReportService2010.DataSourceDefinition.Enabled%2A> of the complex type <xref:ReportService2010.DataSourceDefinition> has an accompanying property named <xref:ReportService2010.DataSourceDefinition.EnabledSpecified%2A>.

If you're building an application and don't want to set a value for the <xref:ReportService2010.DataSourceDefinition.Enabled%2A> property, you don't have to supply a value for <xref:ReportService2010.DataSourceDefinition.Enabled%2A>; the default value of **true** is used. However, you still need to set <xref:ReportService2010.DataSourceDefinition.EnabledSpecified%2A> to **false**. If you supply a value for the <xref:ReportService2010.DataSourceDefinition.Enabled%2A> property, set <xref:ReportService2010.DataSourceDefinition.EnabledSpecified%2A> to **true**. This rule applies to writable properties. For read-only properties, you don't need to take any action.

> [!IMPORTANT]  
> Failure to specify a property by using the preceding technique can result in unpredictable Web service behavior.

The data types that usually require you to handle the additional `Specified` property are **Boolean**, **DateTime**, and **Enumeration**.

For an example, see <xref:ReportService2010.ReportingService2010.CreateDataSource%2A> method.

## Related content

- [Building Applications Using the Web Service and the .NET Framework](building-applications-using-the-web-service-and-the-net-framework.md)
- [Technical reference (SSRS)](../../technical-reference-ssrs.md)
