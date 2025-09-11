---
title: "How To: Activate Service Broker Message Delivery in Databases (Transact-SQL)"
description: "By default, Service Broker message delivery is active in a database when the database is created."
author: rwestMSFT
ms.author: randolphwest
ms.reviewer: mikeray, maghan
ms.date: 08/29/2025
ms.service: sql
ms.subservice: configuration
ms.topic: how-to
---

# How to: Activate Service Broker message delivery in databases (Transact-SQL)

[!INCLUDE [sql-asdbmi](../../includes/applies-to-version/sql-asdbmi.md)]

By default, Service Broker message delivery is active in a database when the database is created. When message delivery isn't active, messages remain in the transmission queue. To determine whether Service Broker is active for a database, check the `is_broker_enabled` column of the `sys.databases` catalog view.

> [!NOTE]  
> Activating Service Broker allows messages to be delivered to the database. You must create a Service Broker endpoint to send and receive messages from outside of the instance.

## Activate Service Broker in a database

- Alter the database to set the `ENABLE_BROKER` option.

## Examples

```sql
USE master;
GO

ALTER DATABASE AdventureWorks2008R2
    SET ENABLE_BROKER;
GO
```

[!INCLUDE [SQL Server Service Broker AdventureWorks2008R2](../../includes/service-broker-adventureworks-2008-r2.md)]

## Related content

- [How to: Deactivate Service Broker message delivery in databases (Transact-SQL)](how-to-deactivate-service-broker-message-delivery-in-databases-transact-sql.md)
- [How to: Activate Service Broker networking (Transact-SQL)](how-to-activate-service-broker-networking-transact-sql.md)
- [ALTER DATABASE (Transact-SQL)](../../t-sql/statements/alter-database-transact-sql.md)
- [sys.databases (Transact-SQL)](../../relational-databases/system-catalog-views/sys-databases-transact-sql.md)
- [sys.transmission_queue (Transact-SQL)](../../relational-databases/system-catalog-views/sys-transmission-queue-transact-sql.md)
