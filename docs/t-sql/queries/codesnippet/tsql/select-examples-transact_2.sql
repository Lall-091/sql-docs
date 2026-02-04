USE AdventureWorks2025;
GO

SELECT Name,
    ProductNumber,
    ListPrice AS Price
FROM Production.Product
ORDER BY Name ASC;
GO
