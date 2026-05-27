---
title: Configurable retry logic
description: Use the JDBC driver's configurable retry logic (CRL) to automatically retry failed statements or login attempts based on SQL Server error numbers, with timing parameters you control.
author: dlevy-msft-sql
ms.author: dlevy
ms.date: 05/22/2026
ms.service: sql
ms.subservice: connectivity
ms.topic: concept-article
ai-usage: ai-assisted
---

# Configurable retry logic (JDBC)

[!INCLUDE[Driver_JDBC_Download](../../includes/driver_jdbc_download.md)]

Configurable retry logic (CRL) is a rule-based mechanism that automatically retries failed statements or initial connection attempts based on SQL Server error numbers that you choose, with timing parameters that you control. CRL was introduced in Microsoft JDBC Driver 12.10 for SQL Server.

CRL is separate from [idle connection resiliency and the `connectRetryCount` / `connectRetryInterval` properties](connection-resiliency.md). Idle resiliency transparently recovers broken connections, and `connectRetryCount` retries the initial login on a fixed schedule for a built-in list of transient errors. CRL lets you decide *which* errors are retryable, *how many times*, and *how long* to wait between attempts. You can use all three mechanisms together.

## What CRL retries

CRL handles two distinct scenarios, each controlled by its own connection property:

| Scenario | Property | When the retry runs | Triggered by |
| --- | --- | --- | --- |
| Statement execution failure | `retryExec` | While executing a statement (for example, `executeQuery`, `executeUpdate`, `execute`, or batch execution) | A `SQLServerException` whose error number matches a configured statement rule |
| Initial connection or login failure | `retryConn` | Inside the driver's connect-retry loop (which is gated by `connectRetryCount` and `loginTimeout`) | A `SQLServerException` during login whose error number matches a configured connection rule, or by default, any transient error already covered by the built-in retry list |

For statements, only the failing command is retried. The driver doesn't reset the current transaction state, so design your rules around errors that leave the session usable, such as deadlock victim (1205), lock timeout (1222), or online-index errors.

For connections, CRL augments or replaces the driver's built-in list of transient login errors. See [Connection retry rules](#connection-retry-rules-retryconn) for the `+` prefix semantics.

## Enable CRL

CRL is off by default. Both `retryExec` and `retryConn` are empty strings unless you set them. You can enable CRL through the JDBC URL, a `Properties` object, or a `SQLServerDataSource`.

### In the JDBC URL

Each rule (or the whole list of rules) must be wrapped in braces (`{...}`) because the JDBC URL uses `;` as a separator:

```text
jdbc:sqlserver://server;databaseName=db;retryExec={1205,1222:3,2*2:select,update}
jdbc:sqlserver://server;databaseName=db;retryConn={+<customLoginErrorNumber>}
```

### With a `Properties` object

The `{...}` wrappers are optional with `Properties`. The driver strips them either way:

```java
Properties props = new Properties();
props.setProperty("user", "...");
props.setProperty("password", "...");
props.setProperty("retryExec", "1205,1222:3,2*2:select,update");
props.setProperty("retryConn", "+<customLoginErrorNumber>");
Connection c = DriverManager.getConnection("jdbc:sqlserver://server;databaseName=db", props);
```

### With `SQLServerDataSource`

The same setters exist on the `ISQLServerDataSource` interface:

```java
SQLServerDataSource ds = new SQLServerDataSource();
ds.setServerName("server");
ds.setDatabaseName("db");
ds.setRetryExec("1205,1222:3,2*2:select,update");
ds.setRetryConn("+<customLoginErrorNumber>");
```

## Rule syntax

A single rule has up to three colon-separated sections:

```text
<errorNumbers> : <retryTimings> : <queryFilter>
```

| Section | Required? | Meaning |
| --- | --- | --- |
| `errorNumbers` | Yes | One SQL Server error number, or several separated by commas (for example, `1205` or `1205,1222`). For connection rules, an optional leading `+` controls whether the existing transient errors are kept. |
| `retryTimings` | Required for **statement** rules. Omit for connection rules. | `retryCount[,initialRetryTime[<op>retryChange]]` where `<op>` is `+` (additive) or `*` (multiplicative). |
| `queryFilter` | Optional, statement rules only | Comma-separated list of SQL keywords. The driver lowercases the value at parse time and lowercases the previously executed SQL at runtime. The rule fires when the joined filter list contains the first token of the executed SQL. Omit the third section to disable filtering. |

To use multiple rules in the same property, separate them with `;` and wrap each rule with `{...}` when placing them in a JDBC URL.

### Timing parameters

For a statement rule with timings `retryCount, initialRetryTime <op> retryChange`:

- `retryCount`: How many additional attempts the driver makes after the first failure. A value of `0` disables retry. Negative values are invalid.
- `initialRetryTime`: How long, in seconds, to wait before the first retry. Default is `0`.
- `<op>`: `+` or `*`. Default is `+`.
- `retryChange`: Amount applied to compute subsequent wait times. Default is `2`. When the operand is `*` and `retryChange` is omitted from the rule, the driver sets `retryChange = initialRetryTime`.

> [!IMPORTANT]
> If you supply `initialRetryTime` without an explicit operand (for example, `3,5`), the driver leaves the operand and `retryChange` at their defaults (`+` and `2`). The waits aren't constant. They grow by 2 every retry. To get a constant wait, use the explicit form `retryCount,N+0` (for example, `3,5+0`).

The driver computes the wait time for attempt *i* (0-based) at parse time:

| Operand | Wait for attempt *i* |
| --- | --- |
| `+` (additive) | `initialRetryTime + (retryChange * i)` |
| `*` (multiplicative) | `initialRetryTime * (retryChange ^ i)` |

Examples of timing strings:

| String | retryCount | initialRetryTime | operand | retryChange | Wait sequence (seconds) |
| --- | --- | --- | --- | --- | --- |
| `3` | 3 | 0 (default) | `+` (default) | 2 (default) | 0, 2, 4 |
| `3,5` | 3 | 5 | `+` (default) | 2 (default) | 5, 7, 9 |
| `3,5+5` | 3 | 5 | `+` | 5 | 5, 10, 15 |
| `3,2*2` | 3 | 2 | `*` | 2 | 2, 4, 8 |
| `4,1*` | 4 | 1 | `*` | 1 (equals `initialRetryTime` because the operand is `*` and `retryChange` is omitted) | 1, 1, 1, 1 |

A `retryTimings` section can contain at most one comma. More than one raises `R_invalidParameterNumber`.

## Statement retry rules (`retryExec`)

Statement rules retry failed statement execution. When a statement throws a `SQLServerException`, the driver:

1. Looks up the failing error number in the parsed statement rule set.
1. If a rule exists and the current attempt count is less than `retryCount`, optionally checks the last executed SQL against the rule's `queryFilter`.
1. If everything matches, the driver waits for `waitTimes[retryAttempt]` seconds (subject to `queryTimeout`, see [Interaction with queryTimeout and connectRetryCount](#interaction-with-querytimeout-and-connectretrycount)) and reruns the statement.
1. If no rule matches, the driver rethrows the exception.

### Format (statements)

```text
{errorNumber(s):retryCount[,initialRetryTime[<op>retryChange]][:queryFilter]}
```

Statement rules **must** include a timings section. `retryCount` is mandatory. A rule that contains only an error number is interpreted as a *connection* rule, so for statements always supply at least `retryCount`.

### Examples (statements)

| Rule | Effect |
| --- | --- |
| `{1205:3}` | Retry deadlock victim (1205) up to 3 times, no wait between retries. |
| `{1205,1222:3,5+5}` | Retry deadlock victim and lock timeout up to 3 times, waiting 5, 10, and 15 seconds. |
| `{2714:2,1*2}` | Retry "object already exists" up to 2 times, waiting 1 and 2 seconds. |
| `{1205:4,2+2:select,update}` | Retry only when the failing statement starts with `select` or `update`. |
| `{1205:3,5+5};{1222:2,2}` | Two independent rules, separated by `;`. |

Listing several error numbers (for example, `1205,1222`) is shorthand. The driver expands the rule into one entry per error, all sharing the same timing and query filter.

## Connection retry rules (`retryConn`)

Connection rules participate in the existing connect-retry loop, which is **only active when `connectRetryCount > 0`** (the default is 1). The loop already retries a built-in list of transient login errors at `connectRetryInterval` seconds apart, up to `connectRetryCount` extra attempts, bounded by `loginTimeout`.

A connection rule supplies only an error number section. It has no timings or query filter:

```text
{[+]errorNumber(s)}
```

- Without `+`, the configured rules **replace** the built-in transient error list. Only errors you list are retried.
- With `+` (for example, `{+4060}`), the configured rules are **added** to the built-in list. Both your errors and the driver defaults are retried.

Replace-or-append mode is global for the entire `retryConn` value. If any rule in that value omits `+`, the driver switches to replace mode for all rules in that value. For example, `retryConn={+4060};{40143}` doesn't append 4060 and 40143 to the built-in list. The `40143` rule omits `+`, so the built-in list is dropped and only 4060 and 40143 are retried. To append both, write `retryConn={+4060};{+40143}` (or `retryConn={+4060,40143}`).

The connect loop continues to use `connectRetryInterval` and `connectRetryCount` for pacing and bounding. The CRL rule expands or replaces the set of errors that are eligible for retry.

### Examples (connections)

| Rule | Effect |
| --- | --- |
| `{+<customLoginErrorNumber>}` | Add a custom login error number to the built-in transient error list. |
| `{+<customLoginError1>,<customLoginError2>}` | Add multiple custom login error numbers to the built-in transient error list. |
| `{4060}` | Retry **only** error 4060. Built-in transient errors are no longer retried by CRL. |

> [!NOTE]
> Even when CRL retries are exhausted, the driver still enforces `loginTimeout`. If the next interval would push elapsed time past `loginTimeout`, the driver rethrows the original exception immediately.

### Built-in transient login error list

The connect-retry loop already retries the following errors without any CRL configuration, as long as `connectRetryCount > 0`. Listing any of these in a `retryConn` rule with `+` is a no-op (they're already covered). Use a `retryConn` rule when you need to add an error that *isn't* in this list, or when you need to drop the list entirely with the no-`+` replace form.

> [!NOTE]
> You don't need to append common Azure SQL transient login errors such as 40197, 40501, 40613, 49918, 49919, or 49920. They're already retried by the built-in list.

| Error | Description |
| --- | --- |
| 64 | A connection was successfully established with the server, but then an error occurred during the login process. |
| 233 | The client was unable to establish a connection because of an error during connection initialization. |
| 4060 | Cannot open database requested by the login. The login failed. |
| 4221 | Login to read-secondary failed due to long wait on `HADR_DATABASE_WAIT_FOR_TRANSITION_TO_VERSIONING`. |
| 10053 | A transport-level error has occurred when sending the request to the server (TCP existing connection forcibly closed). |
| 10054 | A transport-level error has occurred when sending the request to the server (TCP existing connection forcibly closed). |
| 10928 | Resource ID limit for the database has been reached. |
| 10929 | Resource ID minimum guarantee, server currently too busy to support requests above the configured limit. |
| 40020 | Embedded code from 40197 (failover or upgrade). |
| 40143 | Embedded code from 40197 (failover or upgrade). |
| 40166 | Embedded code from 40197 (failover or upgrade). |
| 40197 | Service down due to software or hardware upgrade, hardware failure, or other failover. Embedded error codes include 40020, 40143, 40166, and 40540. |
| 40501 | The service is currently busy. Retry the request. |
| 40540 | Embedded code from 40197 (failover or upgrade). |
| 40613 | Database on server is not currently available. Retry the connection. |
| 42108 | Can't connect to the SQL pool because it's paused. |
| 42109 | The SQL pool is warming up. |
| 49918 | Cannot process request. Not enough resources to process request. |
| 49919 | Cannot process create or update request. Too many create or update operations in progress for subscription. |
| 49920 | Cannot process request. Too many operations in progress for subscription. |

The list is sourced from the [Azure SQL transient errors article](/azure/azure-sql/database/troubleshoot-common-connectivity-issues) and the [.NET SqlClient transient error set](https://github.com/dotnet/SqlClient/blob/main/src/Microsoft.Data.SqlClient/src/Microsoft/Data/SqlClient/SqlInternalConnectionTds.cs). Statement-level errors (such as deadlock victim 1205 or lock-request timeout 1222) aren't in this list, because the connect-retry loop only fires during initial login. To retry those, use a `retryExec` rule.

## Load rules from a properties file

If you don't set `retryExec` or `retryConn` on the connection, CRL looks for a file named `mssql-jdbc.properties` next to the driver JAR on the classpath. The file uses simple `key=value` parsing. Lines that start with `retryExec=` or `retryConn=` are picked up. Values use the same syntax described in this article, with `;` separating multiple rules.

Example `mssql-jdbc.properties`:

```properties
retryExec=1205:3,5+5;1222:2,2
retryConn=+4060,40143
```

If the file is missing, CRL logs a `FINE` message under the `com.microsoft.sqlserver.jdbc.ConfigurableRetryLogic` logger and continues with no rules. The file path used for the lookup is included in that log message.

Connection string values take precedence. If `retryExec` or `retryConn` are nonempty on the connection, the driver doesn't consult the file for that property.

## Rule refresh behavior

CRL maintains a single, JVM-wide rule set. After construction, the driver refreshes the rules lazily:

- The driver checks for a refresh every time a statement runs or a connection retry is evaluated.
- A refresh actually happens only after 30 seconds have elapsed since the previous read.
- If the rules originally came from `mssql-jdbc.properties`, the driver compares the file's last-modified timestamp to the timestamp it recorded on the previous read. If the file changed, the driver reparses it.
- If the rules originally came from a connection string, the driver reapplies the previously stored connection-string value.

This behavior means that edits to `mssql-jdbc.properties` are picked up automatically within about 30 seconds without restarting the application.

> [!IMPORTANT]
> Because the rule set is a JVM-wide singleton, opening a second connection that sets a different `retryExec` or `retryConn` value replaces the rules for the first connection too. Treat CRL configuration as a process-level setting, not a per-connection setting, when multiple connections in the same JVM disagree.

## Interaction with queryTimeout and connectRetryCount

### Statement retries and `queryTimeout`

When a statement rule fires, the driver compares the next wait time against the connection-level `queryTimeout`:

- If `queryTimeout >= 0` *and* `timeToWait > queryTimeout`, the driver raises `R_InvalidRetryInterval` instead of retrying. The driver doesn't rethrow the original error. It throws the configuration error.
- The `queryTimeout` connection property defaults to `-1`, so by default the comparison is skipped and any wait is allowed.
- Setting `queryTimeout=0` does **not** disable this check, because `0 >= 0` is true. Any `timeToWait > 0` raises `R_InvalidRetryInterval`.

When you set `queryTimeout` to a positive value, keep `initialRetryTime + (retryCount - 1) * retryChange` (additive) or `initialRetryTime * retryChange^(retryCount-1)` (multiplicative) below it.

### Connection retries and `connectRetryCount` and `loginTimeout`

`retryConn` doesn't by itself enable login retries. The existing properties remain in charge:

- `connectRetryCount` (default 1, range 0-255) is the number of extra login attempts. Set it to `0` to disable login retries. `retryConn` has no effect when `connectRetryCount = 0`, because the driver throws on the first failure.
- `connectRetryInterval` (default 10 seconds, range 1-60) is the wait between attempts. The first retry runs immediately.
- `loginTimeout` is the overall bound. The driver gives up early if the next interval would push elapsed time past `loginTimeout`.

For more information, see [Connection resiliency](connection-resiliency.md).

## Examples

### Survive deadlocks and lock timeouts on writes

```text
jdbc:sqlserver://server;databaseName=db;retryExec={1205,1222:4,2*2:insert,update,delete,merge}
```

Up to 4 retries for deadlock victim (1205) or lock timeout (1222), with backoff of 2, 4, 8, and 16 seconds, but only for write statements.

### Rerun schema creation under online operations

```text
retryExec={2714:2,1+1};{3702:2,1+1}
```

Retries error 2714 (`object already exists`) and 3702 (`cannot drop database currently in use`) twice each, with 1 and 2 second waits.

### Add a custom login error to the transient-error list

```text
retryConn={+<customLoginErrorNumber>}
```

Adds a custom login error number that isn't already in the built-in list. If you append a built-in Azure SQL transient error such as 40197, 40501, 40613, 49918, 49919, or 49920, nothing changes because the driver already retries it.

### Configure CRL through a properties file

Place `mssql-jdbc.properties` next to the driver JAR:

```properties
retryExec=1205:3,5+5:select,update
retryConn=+<customLoginErrorNumber>
```

Don't set `retryExec` or `retryConn` on the connection. The driver reads the rules from the file and rereads after each modification (checked once every 30 seconds).

## Troubleshoot CRL

Enable `FINE` (or finer) logging on the `com.microsoft.sqlserver.jdbc.ConfigurableRetryLogic` logger to see file-read attempts and parsing decisions:

```properties
com.microsoft.sqlserver.jdbc.ConfigurableRetryLogic.level=FINE
```

Common configuration errors:

| Error message key | Cause |
| --- | --- |
| `R_invalidParameterNumber` | A nonnumeric token appeared where the driver expected an error number or a timing parameter, or `retryTimings` contained more than one comma. |
| `R_InvalidRuleFormat` | The rule had more than 3 colon-separated sections, or 0 sections after the braces were stripped. |
| `R_InvalidRetryInterval` | A statement rule's computed wait time exceeds `queryTimeout`. Shorten the wait or raise `queryTimeout`. |
| `R_PathInvalid` or `R_URLInvalid` | The driver couldn't resolve a path to look for `mssql-jdbc.properties`. |
| `R_errorReadingStream` | I/O error while reading `mssql-jdbc.properties`. |

Things to check when a rule doesn't fire:

1. The exception's `SQLServerError.getErrorNumber()` actually matches the number in your rule. SQL Server can wrap some failures into different numbers depending on context (for example, deadlock vs. lock timeout).
1. For statement rules with a `queryFilter`, the first whitespace-delimited token of the SQL you executed (lowercased) is in the filter list. Comments and `WITH` CTEs change the first token.
1. `retryCount` retries are *additional* attempts. The first execution doesn't count.
1. For connection rules, `connectRetryCount` is greater than 0 and `loginTimeout` leaves room for at least one more `connectRetryInterval`.
1. The rule has the right shape. Statement rules need a timings section. Connection rules must not.

## Related content

- [Connection resiliency](connection-resiliency.md)
- [Understanding timeouts](understand-timeouts.md)
- [Setting the connection properties](setting-the-connection-properties.md)
- [Diagnosing problems with the JDBC driver](diagnosing-problems-with-the-jdbc-driver.md)
