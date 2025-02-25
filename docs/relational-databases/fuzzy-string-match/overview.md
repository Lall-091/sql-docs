---
title: Fuzzy String Match
description: "Look up data with fuzzy or approximate values."
author: MikeRayMSFT
ms.author: mikeray
ms.service: sql
ms.topic: overview #Don't change
ms.date: 01/21/2025
monikerRange: "=azuresqldb-current || =fabric"

#customer intent: As a database engineer, I want design solutions that can search on approximate values.

---

# What is fuzzy string matching?

[!INCLUDE [asdb-fabricsqldb](../../includes/applies-to-version/asdb-fabricsqldb.md)]

[!INCLUDE [preview](../../includes/preview.md)]

Use fuzzy, or approximate, string matching to check if two strings are similar, and calculate the difference between two strings. Use this capability to identify strings that may be different because of character corruption. Corruption causes may include spelling errors, transposed characters, missing characters, or abbreviations. Fuzzy string matching uses algorithms to detect similar sounding strings.

## Fuzzy functions

| Function | Description |
| --- | --- |
| [EDIT_DISTANCE](../../t-sql/functions/edit-distance-transact-sql.md) | Calculates the number of insertions, deletions, substitutions, and transpositions needed to transform one string to another. |
| [EDIT_DISTANCE_SIMILARITY](../../t-sql/functions/edit-distance-similarity-transact-sql.md) | Calculates a similarity value ranging from 0 (indicating no match) to 100 (indicating full match). |
| [JARO_WINKLER_DISTANCE](../../t-sql/functions/jaro-winkler-distance-transact-sql.md) | Calculates the edit distance between two strings giving preference to strings that match from the beginning for a set prefix length. |
| [JARO_WINKLER_SIMILARITY](../../t-sql/functions/jaro-winkler-similarity-transact-sql.md) | Calculates a similarity value ranging from 0 (indicating no match) to 1 (indicating full match). |

> [!NOTE]
> Currently, the functions do not adhere to the comparison semantics defined by collation settings, such as case-insensitivity and other collation-specific rules. Once support for collation rules is implemented, the functions' output will reflect these semantics and may change accordingly. 

## Examples

The following examples demonstrate the fuzzy string matching functions.

### Example table

Before you can run example queries, create and populate an example table.

To create and populate the example table, connect to a non-production user database, and run the following script:

```sql
-- Step 1: Create the table
CREATE TABLE WordPairs (
    WordID INT IDENTITY(1,1) PRIMARY KEY, -- Auto-incrementing ID
    WordUK NVARCHAR(50), -- UK English word
    WordUS NVARCHAR(50)  -- US English word
);

-- Step 2: Insert the data
INSERT INTO WordPairs (WordUK, WordUS) VALUES
('Colour', 'Color'),
('Flavour', 'Flavor'),
('Centre', 'Center'),
('Theatre', 'Theater'),
('Organise', 'Organize'),
('Analyse', 'Analyze'),
('Catalogue', 'Catalog'),
('Programme', 'Program'),
('Metre', 'Meter'),
('Honour', 'Honor'),
('Neighbour', 'Neighbor'),
('Travelling', 'Traveling'),
('Grey', 'Gray'),
('Defence', 'Defense'),
('Practise', 'Practice'), -- Verb form in UK
('Practice', 'Practice'), -- Noun form in both
('Aluminium', 'Aluminum'),
('Cheque', 'Check'); -- Bank cheque vs. check
```

### Example *EDIT_DISTANCE*

```sql
SELECT WordUK, WordUS, EDIT_DISTANCE(WordUK, WordUS) AS Distance
FROM WordPairs
WHERE EDIT_DISTANCE(WordUK, WordUS) <= 2
ORDER BY Distance ASC;
```

Returns:

```output
WordUK                         WordUS                         Distance
------------------------------ ------------------------------ -----------
Practice                       Practice                       0
Aluminium                      Aluminum                       1
Honour                         Honor                          1
Neighbour                      Neighbor                       1
Travelling                     Traveling                      1
Grey                           Gray                           1
Defence                        Defense                        1
Practise                       Practice                       1
Colour                         Color                          1
Flavour                        Flavor                         1
Organise                       Organize                       1
Analyse                        Analyze                        1
Catalogue                      Catalog                        2
Programme                      Program                        2
Metre                          Meter                          2
Centre                         Center                         2
Theatre                        Theater                        2
```

### Example *EDIT_DISTANCE_SIMILARITY*

```sql
SELECT WordUK, WordUS, EDIT_DISTANCE_SIMILARITY(WordUK, WordUS) AS Similarity
FROM WordPairs
WHERE EDIT_DISTANCE_SIMILARITY(WordUK, WordUS) >=75
ORDER BY Similarity DESC;
```

Returns:

```output
WordUK                         WordUS                         Similarity
------------------------------ ------------------------------ -----------
Practice                       Practice                       100
Travelling                     Traveling                      90
Aluminium                      Aluminum                       89
Neighbour                      Neighbor                       89
Organise                       Organize                       88
Practise                       Practice                       88
Defence                        Defense                        86
Analyse                        Analyze                        86
Flavour                        Flavor                         86
Colour                         Color                          83
Honour                         Honor                          83
Catalogue                      Catalog                        78
Programme                      Program                        78
Grey                           Gray                           75
```

### Example *JARO_WINKLER_DISTANCE*

```sql
SELECT WordUK, WordUS, JARO_WINKLER_DISTANCE(WordUK, WordUS) AS Distance
FROM WordPairs
WHERE JARO_WINKLER_DISTANCE(WordUK, WordUS) <= .05
ORDER BY Distance ASC;
```

Returns:

```output
WordUK                         WordUS                         Distance
------------------------------ ------------------------------ -----------
Practice                       Practice                       0
Travelling                     Traveling                      0.01999998
Neighbour                      Neighbor                       0.02222222
Aluminium                      Aluminum                       0.02222222
Theatre                        Theater                        0.02857143
Flavour                        Flavor                         0.02857143
Centre                         Center                         0.03333336
Colour                         Color                          0.03333336
Honour                         Honor                          0.03333336
Catalogue                      Catalog                        0.04444444
Programme                      Program                        0.04444444
Metre                          Meter                          0.04666668
```

### Example *JARO_WINKLER_SIMILARITY*

```sql
SELECT WordUK, WordUS, JARO_WINKLER_SIMILARITY(WordUK, WordUS) AS Similarity
FROM WordPairs
WHERE JARO_WINKLER_SIMILARITY(WordUK, WordUS) > 0.9
ORDER BY  Similarity DESC;
```

Returns:

```output
WordUK                         WordUS                         Similarity
------------------------------ ------------------------------ -----------
Practice                       Practice                       1
Travelling                     Traveling                      0.98
Neighbour                      Neighbor                       0.9777778
Aluminium                      Aluminum                       0.9777778
Flavour                        Flavor                         0.9714286
Theatre                        Theater                        0.9714286
Centre                         Center                         0.9666666
Colour                         Color                          0.9666666
Honour                         Honor                          0.9666666
Catalogue                      Catalog                        0.9555556
Programme                      Program                        0.9555556
Metre                          Meter                          0.9533333
Organise                       Organize                       0.95
Practise                       Practice                       0.95
Defence                        Defense                        0.9428572
Analyse                        Analyze                        0.9428572
```

### Example query with all functions

The following query demonstrates all of the regular expression functions currently available.

```sql
SELECT	T.source_string,
		T.target_string,
		EDIT_DISTANCE(T.source_string, T.target_string) as ED_Distance,
		JARO_WINKLER_DISTANCE(T.source_string, T.target_string) as JW_Distance,

		EDIT_DISTANCE_SIMILARITY(T.source_string, T.target_string) as ED_Similarity,
		CAST(JARO_WINKLER_SIMILARITY(T.source_string, T.target_string)*100 as int) as JW_Similarity
FROM (VALUES('Black', 'Red'),
			('Colour', 'Yellow'),
			('Colour', 'Color'),
			('Microsoft', 'Msft'),
			('Regex', 'Regex')) as T(source_string, target_string);
```

Returns:

```output
source_string  target_string  ED_Distance    JW_Distance    ED_Similarity  JW_Similarity
-------------- -------------- -------------- -------------- -------------- -------------- 
Black	        Red	            5	           1	            0	        0
Colour	        Yellow	        5	           0.4444444	    17	        55
Colour	        Color	        1	           0.03333336	    83	        96
Microsoft	    Msft	        5	           0.4916667	    44	        50
Regex	        Regex	        0	           0	            100	        100
```

## Clean up

After you are done using the example data, delete the example table.

```sql
IF OBJECT_ID('dbo.WordPairs', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.WordPairs;
END
```

## Related content

- [EDIT_DISTANCE](../../t-sql/functions/edit-distance-transact-sql.md)
- [EDIT_DISTANCE_SIMILARITY](../../t-sql/functions/edit-distance-similarity-transact-sql.md)
- [JARO_WINKLER_DISTANCE](../../t-sql/functions/jaro-winkler-distance-transact-sql.md)
- [JARO_WINKLER_SIMILARITY](../../t-sql/functions/jaro-winkler-similarity-transact-sql.md)