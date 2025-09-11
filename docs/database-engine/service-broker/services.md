---
title: Services
description: "A Service Broker service is a name for a specific business task or set of business tasks."
author: rwestMSFT
ms.author: randolphwest
ms.reviewer: mikeray, maghan
ms.date: 09/10/2025
ms.service: sql
ms.subservice: configuration
ms.topic: conceptual
---

# Services

[!INCLUDE [sql-asdbmi](../../includes/applies-to-version/sql-asdbmi.md)]

A Service Broker service is a name for a specific business task or set of business tasks. Conversations occur between services. Service Broker uses the name of the service to:

- deliver messages to the correct queue within a database
- route messages
- enforce the contract for a conversation
- determine the remote security for a new conversation.

## Remarks

Each service specifies a queue to hold incoming messages. The contracts associated with the service define the specific tasks that the service accepts new conversations for. Therefore, a target service specifies one or more contracts that conversations with the service must follow. A service that initiates conversations but doesn't receive new conversations from other services doesn't need to specify contracts. If the service can receive messages on the `DEFAULT` contract, the `DEFAULT` contract must be included in the service definition.

## Related content

- [CREATE SERVICE (Transact-SQL)](../../t-sql/statements/create-service-transact-sql.md)
- [ALTER SERVICE (Transact-SQL)](../../t-sql/statements/alter-service-transact-sql.md)
- [DROP SERVICE (Transact-SQL)](../../t-sql/statements/drop-service-transact-sql.md)
- [Service Broker routing](service-broker-routing.md)
- [Understanding when activation occurs](understanding-when-activation-occurs.md)
- [Create Service Broker services](creating-service-broker-services.md)
