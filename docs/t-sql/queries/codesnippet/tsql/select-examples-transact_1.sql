USE AdventureWorks2025;
GO

SELECT *
FROM Production.Product
ORDER BY Name ASC;

-- Alternate way.
USE AdventureWorks2025;
GO

SELECT p.*
FROM Production.Product AS p
ORDER BY Name ASC;
GO
