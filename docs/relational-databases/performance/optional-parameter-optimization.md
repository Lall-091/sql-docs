---
title: Optional Parameter Plan Optimization
description: Optional parameter plan optimization improvement.
author: thesqlsith
ms.author: derekw
ms.reviewer: randolphwest
ms.date: 08/19/2025
ms.service: sql
ms.topic: concept-article
ms.custom:
  - ignite-2025
# CustomerIntent: As a database engineer, I want to understand the capabilities of the Optional parameter plan optimization feature in SQL Server 2025 so that I can effectively implement and support this technology.
monikerRange: "=sql-server-ver17 || =sql-server-linux-ver17"
---

# Optional parameter plan optimization (OPPO)

**Applies to:** [!INCLUDE [sqlserver2025-asdb-fabricsqldb](../../includes/applies-to-version/sqlserver2025-asdb-fabricsqldb.md)]

The term *optional parameters* refers to a specific variation of the [parameter-sensitive plan](../query-processing-architecture-guide.md#parameter-sensitivity) (PSP) problem in which the sensitive, parameter value that exists during query execution, controls whether we need to perform a seek into or scan a table. A simple example would be something like:

```sql
SELECT column1,
       column2
FROM Table1
WHERE (column1 = @p
      OR @p IS NULL);
```

In this example, SQL Server always chooses a plan that scans table `Table1`, even if there's an index on `Table1(col1)`. A seek plan might not be possible with NULLs. Query hinting techniques, like `OPTIMIZE FOR`, might not be useful for this type of PSP problem because there isn't currently an operator that dynamically changes an index seek into a scan during execution. This kind of seek->scan combination at runtime might also not be effective, because the cardinality estimates on top of that operator would likely be inaccurate. The result is inefficient plan choices and excessive memory grants for more complex queries with similar query patterns.

The Optional Parameter Plan optimization (OPPO) feature uses the adaptive plan optimization (Multiplan) infrastructure that was introduced with the Parameter Sensitive Plan optimization improvement, which generates multiple plans from a single statement. This allows the feature to make different assumptions depending on the parameter values used in the query. During query execution time, OPPO selects the appropriate plan:

- where the parameter value `IS NOT NULL`, it uses a seek plan or something more optimal than a full scan plan.
- where the parameter value is `NULL`, it uses a scan plan.

As part of the adaptive plan optimization feature family which includes [Parameter Sensitive Plan optimization](parameter-sensitive-plan-optimization.md), OPPO provides a solution to the second component of the Multiplan feature set, which covers dynamic search capabilities.

- Equality predicates

  ```sql
  WHERE column1 = @p
  ```

- Dynamic search

  ```sql
  WHERE (column1 = @p1 OR @p1 IS NULL)
    AND (column2 = @p2 OR @p2 IS NOT NULL)
  ```

## Terminology and how it works

| Term | Description |
| --- | --- |
| **Dispatcher expression** | This expression evaluates cardinality of predicates based on runtime parameter values, and routes execution to different query variants. |
| **Dispatcher plan** | A plan containing the dispatcher expression is cached for the original query. The dispatcher plan is essentially a collection of the predicates that were selected by the feature, with a few extra details. For each predicate that is selected some of the details that are included in the dispatcher plan are the *high* and *low* boundary values. These values are used to divide parameter values into different buckets or ranges. The dispatcher plan also contains the statistics that were used to calculate the boundary values. |
| **Query variant** | As dispatcher plan evaluates the cardinality of predicates based on runtime parameter values, it *bucketizes* them and generates separate child queries to run. These child queries are called query variants. Query variants have their own plans in the plan cache and the Query Store. In other words, by using different query variants, we achieve the goal of multiple plans for a single query. |

As an example, consider an application web form for a realty company that allows for optional filtering on the number of bedrooms for a particular listing. A common antipattern could be to express the optional filter as:

```sql
SELECT * FROM Properties
WHERE bedrooms = @bedrooms
      OR @bedrooms IS NULL;
```

Even if parameter `@bedrooms = 10` is sniffed by the use of [parameter markers](../query-processing-architecture-guide.md#parameters-and-execution-plan-reuse), and we know that the cardinality for the number of bedrooms is likely to be very low, the optimizer doesn't produce a plan that seeks on an index which exists on the bedroom column because that isn't a valid plan for the case where `@bedrooms` is `NULL`. The generated plan doesn't include a scan of the index.

Imagine if this could be rewritten as two separate statements. Depending on the runtime value of the parameter, we could evaluate something like this:

```sql
IF @bedrooms IS NULL
    SELECT * FROM Properties;
ELSE
    SELECT * FROM Properties
    WHERE bedrooms = @bedrooms;
```

We can achieve this by using the adaptive plan optimization infrastructure, which allows a creation of a dispatcher plan that dispatches two query variants.

Similar to the [predicate cardinality range](parameter-sensitive-plan-optimization.md#predicate-cardinality-range) that PSP optimization uses, OPPO embeds a system usable query hint with the query text of the plan. This hint isn't valid for use by an application or if you attempt to use it yourself.

Continuing with the previous example,

```sql
SELECT * FROM Properties
WHERE bedrooms = @bedrooms
      OR @bedrooms IS NULL;
```

OPPO can generate two query variants that might have the following attributes added to them within the Showplan XML:

- `@bedrooms` is `NULL`. The query variant *folded* the original query to achieve a scan plan.

  SELECT * FROM Properties PLAN PER VALUE(ObjectID = 1234, QueryVariantID = *1*, *optional_predicate*(@bedrooms is NULL))

- `@bedrooms IS NOT NULL`

  SELECT * FROM Properties WHERE bedrooms = @bedrooms PLAN PER VALUE(ObjectID = 1234, QueryVariantID = *2*, *optional_predicate*(@bedrooms is NULL))

## Use optional parameter plan optimization

To enable OPPO for a database, the following prerequisites are required:

- The database must use compatibility level 170.
- The `OPTIONAL_PARAMETER_OPTIMIZATION` database-scoped configuration must be enabled.

The `OPTIONAL_PARAMETER_OPTIMIZATION` database-scoped configuration is enabled by default. This means that a database using compatibility level 170 (the default in SQL Server 2025) uses OPPO by default.

You can ensure that a database uses OPPO in SQL Server 2025 by executing the following statements:

```sql
ALTER DATABASE [<database-name-placeholder>] SET COMPATIBILITY_LEVEL = 170;
ALTER DATABASE SCOPED CONFIGURATION SET OPTIONAL_PARAMETER_OPTIMIZATION = ON;
```

To disable optional parameter plan optimization for a database, disable the `OPTIONAL_PARAMETER_OPTIMIZATION` database-scoped configuration:

```sql
ALTER DATABASE SCOPED CONFIGURATION SET OPTIONAL_PARAMETER_OPTIMIZATION = OFF;
```

#### Use optional parameter plan optimization via query hints

You can use the `DISABLE_OPTIONAL_PARAMETER_OPTIMIZATION` query hint to disable optional parameter plan optimization for a given query. The hints must be specified via the `USE HINT` clause. For more information, see [Query hints](../../t-sql/queries/hints-transact-sql-query.md#use_hint).

The hints work under any compatibility level, and override the `OPTIONAL_PARAMETER_OPTIMIZATION` database-scoped configuration.

The `DISABLE_OPTIONAL_PARAMETER_OPTIMIZATION` query hint can be specified directly in the query, or via [Query Store hints](query-store-hints.md).

### Extended Events

- `optional_parameter_optimization_skipped_reason`: Occurs when OPPO decides that a query isn't eligible for optimization. This extended event follows the same pattern as the parameter_sensitive_plan_optimization_skipped_reason event that is used by PSP optimization. Since a query can generate both PSP optimization and OPPO query variants, you should check both events to understand why one or neither feature engaged.

  The following query shows all of the possible reasons why PSP was skipped:

  ```sql
  SELECT map_value
  FROM sys.dm_xe_map_values
  WHERE [name] = 'opo_skipped_reason_enum'
  ORDER BY map_key;
  ```

- `query_with_optional_parameter_predicate`: The extended event follows the same pattern as the query_with_parameter_sensitivity event that is used by PSP optimization. It includes the additional fields that are available in the improvements for PSP optimization which consist of displaying the number of predicates that the feature found interesting, more details in json format regarding the interesting predicates, as well as if OPPO is supported for the predicate or predicates.

## Remarks

- The ShowPlan XML for a query variant would look similar to the following example, where the predicates that were selected have their respective information added to the PLAN PER VALUE, optional_predicate hint.

```xml
<Batch>
  <Statements>
    <StmtSimple StatementCompId="4" StatementEstRows="1989" StatementId="1" StatementOptmLevel="FULL" StatementOptmEarlyAbortReason="GoodEnoughPlanFound" CardinalityEstimationModelVersion="170" StatementSubTreeCost="0.0563916" StatementText="SELECT PropertyId, AgentId, ListingPrice, ZipCode, SquareFootage, &#xD;&#xA;           Bedrooms, Bathrooms, ListingDescription&#xD;&#xA;    FROM dbo.Property &#xD;&#xA;    WHERE (@AgentId IS NULL OR AgentId = @AgentId)&#xD;&#xA;      AND (@ZipCode IS NULL OR ZipCode = @ZipCode)&#xD;&#xA;      AND (@MinPrice IS NULL OR ListingPrice &gt;= @MinPrice)&#xD;&#xA;      AND (@HasDescription IS NULL OR &#xD;&#xA;           (@HasDescription = 1 AND ListingDescription IS NOT NULL) OR&#xD;&#xA;           (@HasDescription = 0 AND ListingDescription IS NULL)) option (PLAN PER VALUE(ObjectID = 1269579561, QueryVariantID = 7, optional_predicate(@MinPrice IS NULL),optional_predicate(@ZipCode IS NULL),optional_predicate(@AgentId IS NULL)))" StatementType="SELECT" QueryHash="0x2F701925D1202A9F" QueryPlanHash="0xBA0B2B1A18AF1033" RetrievedFromCache="true" StatementSqlHandle="0x09000033F4BE101B2EE46B1615A038D422710000000000000000000000000000000000000000000000000000" DatabaseContextSettingsId="1" ParentObjectId="1269579561" StatementParameterizationType="1" SecurityPolicyApplied="false">
      <StatementSetOptions ANSI_NULLS="true" ANSI_PADDING="true" ANSI_WARNINGS="true" ARITHABORT="true" CONCAT_NULL_YIELDS_NULL="true" NUMERIC_ROUNDABORT="false" QUOTED_IDENTIFIER="true" />
      <Dispatcher>
        <OptionalParameterPredicate>
          <Predicate>
            <ScalarOperator ScalarString="[@MinPrice] IS NULL">
              <Compare CompareOp="IS">
                <ScalarOperator>
                  <Identifier>
                    <ColumnReference Column="@MinPrice" />
                  </Identifier>
                </ScalarOperator>
                <ScalarOperator>
                  <Const ConstValue="NULL" />
                </ScalarOperator>
              </Compare>
            </ScalarOperator>
          </Predicate>
        </OptionalParameterPredicate>
        <OptionalParameterPredicate>
          <Predicate>
            <ScalarOperator ScalarString="[@ZipCode] IS NULL">
              <Compare CompareOp="IS">
                <ScalarOperator>
                  <Identifier>
                    <ColumnReference Column="@ZipCode" />
                  </Identifier>
                </ScalarOperator>
                <ScalarOperator>
                  <Const ConstValue="NULL" />
                </ScalarOperator>
              </Compare>
            </ScalarOperator>
          </Predicate>
        </OptionalParameterPredicate>
        <OptionalParameterPredicate>
          <Predicate>
            <ScalarOperator ScalarString="[@AgentId] IS NULL">
              <Compare CompareOp="IS">
                <ScalarOperator>
                  <Identifier>
                    <ColumnReference Column="@AgentId" />
                  </Identifier>
                </ScalarOperator>
                <ScalarOperator>
                  <Const ConstValue="NULL" />
                </ScalarOperator>
              </Compare>
            </ScalarOperator>
          </Predicate>
        </OptionalParameterPredicate>
      </Dispatcher>
      <QueryPlan DegreeOfParallelism="1" CachedPlanSize="40" CompileTime="1" CompileCPU="1" CompileMemory="376" QueryVariantID="7">
```

- Example output from the `query_with_optional_parameter_predicate` extended event

| Field | Value |
| --- | --- |
| optional_parameter_optimization_supported | True |
| optional_parameter_predicate_count | 3 |
| predicate_details | {"Predicates":[{"Skewness":1005.53},{"Skewness":1989.00},{"Skewness":1989.00}]} |
| query_type | 193 |

## Related content

- [Query processing architecture guide](../query-processing-architecture-guide.md)
- [Recompiling execution plans](../query-processing-architecture-guide.md#recompiling-execution-plans)
- [Parameters and execution plan reuse](../query-processing-architecture-guide.md#parameters-and-execution-plan-reuse)
- [Simple parameterization](../query-processing-architecture-guide.md#simple-parameterization)
- [Forced parameterization](../query-processing-architecture-guide.md#forced-parameterization)
- [Query hints (Transact-SQL)](../../t-sql/queries/hints-transact-sql-query.md)
- [Intelligent query processing in SQL databases](intelligent-query-processing.md)
- [Parameter Sensitivity](../query-processing-architecture-guide.md#parameter-sensitivity)
- [ALTER DATABASE SCOPED CONFIGURATION (Transact-SQL)](../../t-sql/statements/alter-database-scoped-configuration-transact-sql.md)
