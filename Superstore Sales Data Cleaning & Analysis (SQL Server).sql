/* Superstore Sales Data Cleaning */

CREATE DATABASE superstore_sales;



USE superstore_sales;



SELECT *
FROM orders;



SELECT *
FROM people;



SELECT *
FROM [returns];



EXEC sp_columns orders;



EXEC sp_columns people;



EXEC sp_columns [returns];



/* 1. Removal of duplicate rows. */

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY [Row ID]
ORDER BY [Row ID]) AS "Row Number"
FROM orders;

WITH duplicate_orders AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY [Row ID]
ORDER BY [Row ID]) AS "Row Number"
FROM orders)
SELECT *
FROM duplicate_orders
WHERE [Row Number] > 1
ORDER BY [Row ID];

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY
[Order ID],
[Order Date],
[Ship Date],
[Ship Mode],
[Customer ID],
[Customer Name],
[Segment],
[Country/Region],
[City],
[State/Province],
[Postal Code],
[Region],
[Product ID],
[Category],
[Sub-Category],
[Product Name],
[Sales],
[Quantity],
[Discount],
[Profit]
ORDER BY [Row ID]
) AS "Row Number"
FROM orders
ORDER BY [Row ID];

WITH duplicate_orders AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY
[Order ID],
[Order Date],
[Ship Date],
[Ship Mode],
[Customer ID],
[Customer Name],
[Segment],
[Country/Region],
[City],
[State/Province],
[Postal Code],
[Region],
[Product ID],
[Category],
[Sub-Category],
[Product Name],
[Sales],
[Quantity],
[Discount],
[Profit]
ORDER BY [Row ID]
) AS "Row Number"
FROM orders)
SELECT *
FROM duplicate_orders
WHERE [Row Number] > 1
ORDER BY [Row ID];

SELECT *
FROM orders
WHERE [Order ID] IN ('US-2019-150119', 'CA-2019-153623')
ORDER BY [Row ID];

DELETE
FROM orders
WHERE [Row ID] IN (392, 1700);



SELECT *,
ROW_NUMBER() OVER(
PARTITION BY [Returned],
[Order ID]
ORDER BY [Order ID]) AS "Row Number"
FROM [returns];

WITH duplicate_returns AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY [Returned],
[Order ID]
ORDER BY [Order ID]) AS "Row Number"
FROM [returns])
SELECT *
FROM duplicate_returns
WHERE [Row Number] > 1
ORDER BY [Order ID];

WITH duplicate_returns AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY [Returned],
[Order ID]
ORDER BY [Order ID]) AS "Row Number"
FROM [returns])
DELETE
FROM duplicate_returns
WHERE [Row Number] > 1



/* 2. Data formatting and standardisation. */

SELECT DISTINCT [Row ID]
FROM orders
ORDER BY [Row ID] ASC;



SELECT DISTINCT [Order ID]
FROM orders
ORDER BY [Order ID] ASC;



SELECT DISTINCT [Order Date]
FROM orders
ORDER BY [Order Date] ASC;

SELECT DISTINCT [Order Date],
CONVERT(DATE, [Order Date], 101)
FROM orders
ORDER BY [Order Date] ASC;

UPDATE orders
SET [Order Date] = CONVERT(DATE, [Order Date], 101)
ALTER TABLE orders
ALTER COLUMN [Order Date] DATE;



SELECT DISTINCT [Ship Date]
FROM orders
ORDER BY [Ship Date] ASC;

UPDATE orders
SET [Ship Date] = CONVERT(DATE, [Ship Date], 101)
ALTER TABLE orders
ALTER COLUMN [Ship Date] DATE;



SELECT DISTINCT [Ship Mode]
FROM orders
ORDER BY [Ship Mode] ASC;



SELECT DISTINCT [Customer ID]
FROM orders
ORDER BY [Customer ID] ASC;



SELECT DISTINCT [Segment]
FROM orders
ORDER BY [Segment] ASC;



SELECT DISTINCT [Country/Region]
FROM orders
ORDER BY [Country/Region] ASC;



SELECT DISTINCT [City]
FROM orders
ORDER BY [City] ASC;



SELECT DISTINCT [State/Province]
FROM orders
ORDER BY [State/Province] ASC;



SELECT DISTINCT [Postal Code]
FROM orders
ORDER BY [Postal Code] ASC;



SELECT DISTINCT [Region]
FROM orders
ORDER BY [Region] ASC;



SELECT DISTINCT [Product ID]
FROM orders
ORDER BY [Product ID] ASC;



SELECT DISTINCT [Category]
FROM orders
ORDER BY [Category] ASC;

SELECT DISTINCT [Category],
[Product ID]
FROM Orders
WHERE LEFT([Category], 3) <> LEFT([Product ID], 3);



SELECT DISTINCT [Sub-Category]
FROM orders
ORDER BY [Sub-Category] ASC;



SELECT DISTINCT [Product Name]
FROM orders
ORDER BY [Product Name] ASC;



SELECT DISTINCT [Sales]
FROM orders
ORDER BY [Sales] ASC;

ALTER TABLE orders
ALTER COLUMN [Sales] FLOAT;



SELECT DISTINCT [Quantity]
FROM orders
ORDER BY [Quantity] ASC;



SELECT DISTINCT [Discount]
FROM orders
ORDER BY [Discount] ASC;

ALTER TABLE orders
ALTER COLUMN [Discount] FLOAT;



SELECT DISTINCT [Profit]
FROM orders
ORDER BY [Profit] ASC;

ALTER TABLE orders
ALTER COLUMN [Profit] FLOAT;



-----------------------------------------------------------------------------------------------------------------

/* 1. Key Performance Indicators by Year. */

SELECT YEAR([Order Date]) AS "Year",
ROUND(SUM([Sales]), 0) AS "Total Sales",
SUM([Quantity]) AS "Total Quantity",
ROUND(SUM([Profit]), 0) AS "Total Profit",
COUNT(DISTINCT [Order ID]) AS "Total Orders",
COUNT(DISTINCT [Customer ID]) AS "Total Customers"
FROM orders
WHERE [Country/Region] = 'United States'
GROUP BY YEAR([Order Date])
ORDER BY [Year] DESC;



/* 2.  */
	
	