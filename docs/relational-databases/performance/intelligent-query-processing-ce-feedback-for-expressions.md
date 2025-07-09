---
title: Cardinality Estimation Feedback for Expressions in SQL Server 2025
description: Describes the CE feedback for expressions feature in SQL Server 2025.
author: thesqlsith
ms.author: derekw
ms.reviewer: randolphwest
ms.date: 05/05/2025
ms.service: sql
ms.topic: concept-article
# CustomerIntent: As a database engineer, I want to understand the capabilities of the CE feedback for expressions feature in SQL Server 2025 so that I can effectively implement and support this technology.
monikerRange: "=azuresqldb-current || =sql-server-ver17 || =sql-server-linux-ver17 || = fabric"
ms.custom:
  - build-2025
---

# Cardinality estimation (CE) feedback for expressions

**Applies to:** [!INCLUDE [sqlserver2025-asdb-fabricsqldb](../../includes/applies-to-version/sqlserver2025-asdb-fabricsqldb.md)]

Inaccurate cardinality estimates often cause poor performance during query optimization. Cardinality estimation (CE) feedback for expressions extends the framework started by the CE feedback feature. The goal is to improve cardinality estimates for repeating expressions. The feedback for expressions feature learns from previous executions of expressions across queries, to find appropriate CE model choices and apply what has been learned to future executions of those expressions. Like [CE feedback](intelligent-query-processing-cardinality-estimation-feedback.md), model recommendations are tested and applied automatically to future query executions.

The feedback for expressions feature identifies and uses a [model](https://techcommunity.microsoft.com/blog/azuresqlblog/cardinality-estimation-feedback-explained-by-kate-smith-akatesmith/4197930) assumption that better fits a given query's expression and data distribution, which in turn improves query execution plan quality. Currently, the feedback for expressions feature can identify plan operators where the estimated number of rows and the actual number of rows are very different. Feedback is applied to expressions within a query when significant model estimation errors occur, and there's a viable alternate model to try.

Different versions of the Database Engine use [different CE](../../relational-databases/performance/intelligent-query-processing-cardinality-estimation-feedback.md#cardinality-estimation-ce-feedback-implementation) model assumptions, based on how data is distributed and queried.

## How it works

While fingerprints aren't a new concept with the [!INCLUDE [ssdenoversion-md](../../includes/ssdenoversion-md.md)], a *fingerprint* in the context of the feedback for expressions feature refers to the combination of the computed signatures from within an expression. For example, a business analyst in a fictitious business might wish to obtain information about any of their customers' orders where those customers spent more than $10,000. A select statement that involves gathering data from a Customers table that is also joining to an Orders table might be one way to view this type of data:

```sql
SELECT *
FROM Customer AS C
     INNER JOIN Orders AS O
         ON C.custkey = O.o_custkey
WHERE O.o_totalprice > 10000;
```

For this query, the query optimizer might choose to get data from each table - `Customer`, followed by `Orders`, select all of the associated columns from both tables, and *join* the data (with a filter) where the `totalprice` of an order is greater than $10,000. Each step in this process has a signature generated which makes up the fingerprint that the feedback for expressions feature uses.

The feature focuses on expressions with consistent cardinality over-estimation/under-estimation across queries. It analyzes two different workload patterns that are currently not eligible for CE feedback:

- Workloads without repeated executions, but which do have repeated expression patterns. For example, a commonly used join pattern.

- Queries in which one part of the query might benefit from a different CE model than another portion of the same query. For example, the join between tables A and B might require simple containment, and the join between tables C and D which might require base containment.

The feedback for expressions feature applies filter and join assumptions to correct misestimation issues, such as:

Filters:

- `ASSUME_MIN_SELECTIVITY_FOR_FILTER_ESTIMATES`
- `ASSUME_PARTIAL_CORRELATION_FOR_FILTER_ESTIMATES`
- `ASSUME_FULL_INDEPENDENCE_FOR_FILTER_ESTIMATES`

Joins:

- `ASSUME_JOIN_PREDICATE_DEPENDS_ON_FILTERS`
- Base containment assumption (no hint should need to be passed)

## Use CE feedback for expressions

To enable the feedback for expressions feature for a database, the following prerequisites are required:

- The database must use compatibility level 160 or later.

- The `CE_FEEDBACK_FOR_EXPRESSIONS` database-scoped configuration must be enabled.


The `CE_FEEDBACK_FOR_EXPRESSIONS` database-scoped configuration is enabled by default.

You can ensure that a database uses the feedback for expressions feature in [!INCLUDE [sssql25-md](../../includes/sssql25-md.md)] by executing the following statements:

```sql
ALTER DATABASE SCOPED CONFIGURATION SET CE_FEEDBACK_FOR_EXPRESSIONS = ON;
```

To disable the feedback for expressions feature for a database, disable the `CE_FEEDBACK_FOR_EXPRESSIONS` database-scoped configuration:

```sql
ALTER DATABASE SCOPED CONFIGURATION SET CE_FEEDBACK_FOR_EXPRESSIONS = OFF;
```

- CE feedback for expressions activity is visible via the `adhoc_ce_feedback_query_level_telemetry`, `query_adhoc_ce_feedback_expression_hint`, and `query_adhoc_ce_feedback_hint` extended events. The CE Feedback extended events `query_ce_feedback_begin_analysis` and `query_ce_feedback_telemetry` can also be useful while tracking the activity of the feature.

- There's a new memory clerk known as `AdHocCEFeedbackCache` where the fingerprint data is cached. The cache can be accessed via a new system catalog view, `sys.dm_exec_ce_feedback_cache`.

## Limitations

The CE feedback for expressions feature currently doesn't contain the following features:

- **Persistence**: Query Store persistence of the fingerprint table and expression level hints will be available in a later CTP. Upon restart of SQL Server, the feedback for expressions feature must relearn and apply hints to the current workload.

## Related content

- [Cardinality estimation (CE) feedback](intelligent-query-processing-cardinality-estimation-feedback.md)
