---
title: Using JSON data type
description: Learn about the JSON data type in the JDBC driver and how it can be used to support various operations.
author: David-Engel
ms.author: davidengel
ms.date: 28/07/2025
ms.service: sql
ms.subservice: connectivity
ms.topic: conceptual
---

# Using JSON data type

[!INCLUDE[Driver_JDBC_Download](../../includes/driver_jdbc_download.md)]

Starting with version 13.2.0, the Microsoft JDBC Driver for SQL Server supports the JSON data type. This allows Java applications to read from and write to SQL Server columns of type JSON, enabling seamless interaction with semi-structured data.

## Populating and retrieving a table

To work with JSON data in SQL Server, begin by creating a table with a column of type JSON:

```sql
CREATE TABLE sampleTable (data JSON);
```

Inserting JSON using statement:
```java
try (Statement stmt = connection.createStatement()) {
    stmt.execute("INSERT INTO sampleTable (data) VALUES ('{\"name\":\"John\",\"skills\":[\"Java\",\"SQL\"]}')");
}
```

Inserting JSON using a prepared statement:
```java
String json = "{"name":"John","skills":["Java","SQL"]}";
String insertSql = "INSERT INTO sampleTable (data) VALUES (?)";

try (PreparedStatement pstmt = connection.prepareStatement(insertSql)) {
    pstmt.setString(1, json);
    pstmt.executeUpdate();
}
```

Reading JSON data from the table:
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

## Using stored procedures with JSON

To use a stored procedure with a JSON output parameter, define it as follows:

```java
String sql = "CREATE PROCEDURE sampleProc @p0 JSON OUTPUT AS " +
             " SELECT TOP 1 @p0 = data FROM sampleTable";
```

You can retrieve the output JSON by registering the parameter and executing the procedure:
```java
try (CallableStatement callableStatement = connection.prepareCall("{call sampleProc (?) }")) {
    callableStatement.registerOutParameter(1, microsoft.sql.Types.JSON);
    callableStatement.execute();
    String outputJson = callableStatement.getString(1);
    System.out.println("Output JSON: " + outputJson);
}
```

## Using Table-Valued Parameters (TVPs) with JSON

To insert JSON data using a TVP:
```java
String value = "{"severity":"TRACE","duration":200,"date":"2024-12-17T15:45:56"}";

SQLServerDataTable tvp = new SQLServerDataTable();
tvp.addColumnMetadata("c1", microsoft.sql.Types.JSON);
tvp.addRow(value);

try (SQLServerPreparedStatement pstmt = (SQLServerPreparedStatement) connection.prepareStatement(
        "INSERT INTO sampleTable SELECT * FROM ?")) {
    pstmt.setStructured(1, "JsonTVP", tvp);
    pstmt.execute();
}
```

## Using SQLServerBulkCopy from source table to destination table with JSON

You can use SQLServerBulkCopy to copy data from a source table containing JSON columns into a destination table:
```java
try (Statement stmt = con.createStatement()) {
    stmt.executeUpdate("CREATE TABLE destinationTable (data JSON)");

    SQLServerBulkCopy bulkCopy = new SQLServerBulkCopy(con);

    bulkCopy.setDestinationTableName("destinationTable");
    bulkCopy.writeToServer(stmt.executeQuery("SELECT * FROM sourceTable"));
}
```

## Using Bulk Copy with JSON column from CSV

Assuming a CSV file with content:

```
c1,c2,c3
true,sample,"{"field":"value"}"
```

Using Bulk Copy to insert the CSV:

```java
try (Statement stmt = con.createStatement();
     SQLServerBulkCopy bulkCopy = new SQLServerBulkCopy(con);
     SQLServerBulkCSVFileRecord fileRecord = new SQLServerBulkCSVFileRecord(fileName, null, ",", true)) {

    stmt.executeUpdate("CREATE TABLE sampleTable (c1 JSON)");

    fileRecord.addColumnMetadata(3, "c3", microsoft.sql.Types.JSON);

    fileRecord.setEscapeColumnDelimitersCSV(true);
    bulkCopy.setDestinationTableName("sampleTable");
    bulkCopy.writeToServer(fileRecord);
}
```

## Limitations of JSON

For detailed limitations, see [JSON Data Type - Limitations](../../t-sql/data-types/json-data-type.md#limitations).

## See also

- [Understanding the JDBC driver data types](understanding-the-jdbc-driver-data-types.md)
