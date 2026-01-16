---
title: Use JSON Data Type
description: Learn about the JSON data type in the JDBC driver and how it can be used to support various operations.
author: David-Engel
ms.author: davidengel
ms.date: 08/15/2025
ms.service: sql
ms.subservice: connectivity
ms.topic: concept-article
---

# Use JSON data type with the JDBC driver

[!INCLUDE[Driver_JDBC_Download](../../includes/driver_jdbc_download.md)]

Starting with version 13.2.0, the Microsoft JDBC Driver for SQL Server supports the JSON data type. This feature allows Java applications to read from and write to SQL Server columns of type **json**, enabling seamless interaction with semi-structured data.

Following are examples of ways to interact with JSON data types using the JDBC driver.

## Populate and retrieve JSON data from a table

To work with JSON data in SQL Server, begin by creating a table with a column of type **json**:

```sql
CREATE TABLE sampleTable (data JSON);
```

Insert JSON with a statement:

```java
try (Statement stmt = connection.createStatement()) {
    stmt.execute("INSERT INTO sampleTable (data) VALUES ('{\"name\":\"John\",\"skills\":[\"Java\",\"SQL\"]}')");
}
```

Insert JSON with a prepared statement and parameters:

```java
String json = "{\"name\":\"John\",\"skills\":[\"Java\",\"SQL\"]}";
String insertSql = "INSERT INTO sampleTable (data) VALUES (?)";

try (PreparedStatement pstmt = connection.prepareStatement(insertSql)) {
    pstmt.setString(1, json);
    pstmt.executeUpdate();
}
```

Read JSON data from the table:

```java
String query = "SELECT data FROM sampleTable";

try (PreparedStatement stmt = connection.prepareStatement(query);
     ResultSet rs = stmt.executeQuery()) {
    while (rs.next()) {
        String json = rs.getString("data");
        System.out.println("JSON: " + json);
    }
}
```

## Output JSON from a stored procedure

The following example shows how to return a **json** output parameter from a stored procedure.

```java
String sql = "CREATE PROCEDURE sampleProc @p0 JSON OUTPUT AS " +
             " SELECT TOP 1 @p0 = data FROM sampleTable";
```

Retrieve the output JSON by registering the parameter and executing the procedure.

```java
try (CallableStatement callableStatement = connection.prepareCall("{call sampleProc (?) }")) {
    callableStatement.registerOutParameter(1, microsoft.sql.Types.JSON);
    callableStatement.execute();
    String outputJson = callableStatement.getString(1);
    System.out.println("Output JSON: " + outputJson);
}
```

## Table-valued parameters (TVPs) with JSON

This example inserts JSON data with a TVP.

```java
String value = "{\"severity\":\"TRACE\",\"duration\":200,\"date\":\"2024-12-17T15:45:56\"}";

SQLServerDataTable tvp = new SQLServerDataTable();
tvp.addColumnMetadata("c1", microsoft.sql.Types.JSON);
tvp.addRow(value);

try (SQLServerPreparedStatement pstmt = (SQLServerPreparedStatement) connection.prepareStatement(
        "INSERT INTO sampleTable SELECT * FROM ?")) {
    pstmt.setStructured(1, "JsonTVP", tvp);
    pstmt.execute();
}
```

## Use SQLServerBulkCopy from source table to destination table with JSON

SQLServerBulkCopy is used to copy data from a source table containing JSON columns into a destination table.

```java
try (Statement stmt = con.createStatement()) {
    stmt.executeUpdate("CREATE TABLE destinationTable (data JSON)");

    SQLServerBulkCopy bulkCopy = new SQLServerBulkCopy(con);

    bulkCopy.setDestinationTableName("destinationTable");
    bulkCopy.writeToServer(stmt.executeQuery("SELECT * FROM sourceTable"));
}
```

## Use bulk copy with JSON column from CSV

Copy and paste the following text into a CSV file named `json.csv`:

```text
c1,c2,c3
true,sample,"{""field"":""value""}"
```

Use bulk copy to insert the CSV data into a table:

```java
try (Statement stmt = con.createStatement();
     SQLServerBulkCopy bulkCopy = new SQLServerBulkCopy(con);
     SQLServerBulkCSVFileRecord fileRecord = new SQLServerBulkCSVFileRecord("json.csv", null, ",", true)) {

    stmt.executeUpdate("CREATE TABLE sampleTable (c1 JSON)");

    fileRecord.addColumnMetadata(3, "c3", microsoft.sql.Types.JSON);

    fileRecord.setEscapeColumnDelimitersCSV(true);
    bulkCopy.setDestinationTableName("sampleTable");
    bulkCopy.writeToServer(fileRecord);
}
```

## Limitations of JSON

For detailed limitations, see [JSON data type limitations](../../t-sql/data-types/json-data-type.md#limitations).

## Related content

- [Understanding the JDBC driver data types](understanding-the-jdbc-driver-data-types.md)
