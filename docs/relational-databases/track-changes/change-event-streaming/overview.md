---
title: "What is change event streaming (preview)"
description: "Provides an overview of change event streaming"
author: nzagorac-ms
ms.author: nzagorac
ms.reviewer: mathoma, mikeray
ms.date: 11/18/2025
ms.service: sql
ms.topic: overview
ms.custom:
  - ignite-2025
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17"
---

# What is change event streaming (preview)?
[!INCLUDE [sqlserver2025](../../../includes/applies-to-version/sqlserver2025-asdb.md)]

This article describes the change event streaming (CES) feature introduced in [!INCLUDE [sssql25-md](../../../includes/sssql25-md.md)] and Azure SQL Database. 

To get started with the feature, see [Configure change event streaming](configure.md).

[!INCLUDE [change-event-streaming-preview](../../../includes/change-event-streaming-preview.md)]

## Overview

Change event streaming (CES) is a modern data integration capability that streams SQL Server data changes directly into [Azure Event Hubs](/azure/event-hubs/event-hubs-about) - a high throughput data streaming service. CES captures and publishes incremental changes of data to an Azure Event Hubs destination in near real-time. Captured changes include updates, inserts, and deletes (DML). Details of the data changes (such as the schema, previous values, and new values) are sent to Azure Event Hubs in the form of a CloudEvent. The CloudEvent is serialized to JSON (native) or Avro Binary, and then streamed into an Azure Event Hubs destination.

## Use cases

Use CES to:

- Build event-driven systems on top of your relational databases, with minimal overhead and easy data integration.
- Synchronize data across systems. More specifically, synchronize data between microservices or keep distributed systems synchronized.
- Implement real-time analytics on top of your relational data.
- Audit and monitor. Track changes of sensitive data or logging specific events.

The main advantages for using an event streaming service such as Azure Event Hubs, and SQL Server's change event streaming are:

- **Scalability**:  Event streaming services are designed to handle high-throughput and can scale independently from a database.
- **Decoupling**: Systems downstream from a database and streaming service are loosely coupled, enabling greater flexibility and easier maintenance.
- **Multi-consumer support**:  Azure Event Hubs allows multiple consumers to process the same data stream, enabling varied use cases from a single source.
- **Real-time integration**: Enables seamless integration between OLTP systems and downstream systems for real-time data flow.

## Use change event streaming

To use CES, create a streaming group that defines what tables you want to track, and how to access the streaming destination. The streaming group designates the endpoint, provides authentication details, defines partitioning (if any), and determines which tables to track. After CES is configured, all data changes made by INSERT, UPDATE, and DELETE commands within the tables in the streaming group are streamed as CloudEvents towards the streaming destination.

In the context of CES, an object is the table that is being tracked. A streaming group defines all the objects (that is, tables) that are tracked.

To get started with the feature, see [Configure change event streaming](configure.md). For frequently asked questions, see [Change event streaming FAQ](frequently-asked-questions-faq.yml).

## Consume change event streaming events from Azure Event Hubs

To learn how to consume change events from Azure Event Hubs with a .NET Core console application that receives events from an event hub using an event processor, review [Quickstart: Send or receive events using .NET](/azure/event-hubs/event-hubs-dotnet-standard-getstarted-send#receive-events-from-the-event-hub).

## CES in Azure SQL Database

CES is also available for all service tiers of Azure SQL Database (including Hyperscale), but the following differences between SQL Server and Azure SQL Database apply:

- The preview feature database scoped configuration isn't required to use CES in Azure SQL Database.
- Azure SQL Database supports Microsoft Entra authentication for CES, while SQL Server only supports key-value authentication and shared access signatures (SAS) authentication.
- xEvent debugging in Azure SQL Database isn't currently available.

## Limitations

To learn more, review [limitations with the CES feature](configure.md#limitations).

## Related content

- [Configure change event streaming](configure.md)
- [CES frequently asked questions](frequently-asked-questions-faq.yml)
- [Message format for change event streaming](message-format.md)
