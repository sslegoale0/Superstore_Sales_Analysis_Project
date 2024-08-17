SET sql_safe_update = 0;

SET sql_mode = "Traditional";

/* ---------------------------------------------------------------------------------------------------------------------------- */

/* Superstore Sales Data Cleaning */

CREATE DATABASE superstore_sales;



USE superstore_sales;



SELECT *
FROM orders;



SELECT *
FROM people;



SELECT *
FROM `returns`;



DESCRIBE orders;


DESCRIBE people;


DESCRIBE `returns`;


/* 1. Removal of duplicate rows. */

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Row ID`
ORDER BY `Row ID`) AS "Row Number"
FROM orders;

WITH duplicate_orders AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Row ID`
ORDER BY `Row ID`) AS "Row Number"
FROM orders)
SELECT *
FROM duplicate_orders
WHERE `Row Number` > 1
ORDER BY `Row ID`;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY
`Order ID`,
`Order Date`,
`Ship Date`,
`Ship Mode`,
`Customer ID`,
`Customer Name`,
`Segment`,
`Country/Region`,
`City`,
`State/Province`,
`Postal Code`,
`Region`,
`Product ID`,
`Category`,
`Sub-Category`,
`Product Name`,
`Sales`,
`Quantity`,
`Discount`,
`Profit`
ORDER BY `Row ID`
) AS "Row Number"
FROM orders
ORDER BY `Row ID`;

WITH duplicate_orders AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY
`Order ID`,
`Order Date`,
`Ship Date`,
`Ship Mode`,
`Customer ID`,
`Customer Name`,
`Segment`,
`Country/Region`,
`City`,
`State/Province`,
`Postal Code`,
`Region`,
`Product ID`,
`Category`,
`Sub-Category`,
`Product Name`,
`Sales`,
`Quantity`,
`Discount`,
`Profit`
ORDER BY `Row ID`
) AS "Row Number"
FROM orders)
SELECT *
FROM duplicate_orders
WHERE `Row Number` > 1
ORDER BY `Row ID`;

SELECT *
FROM orders
WHERE `Order ID` IN ('US-2019-150119', 'CA-2019-153623')
ORDER BY `Row ID`;

DELETE
FROM orders
WHERE `Row ID` IN (392, 1700);



SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Returned`,
`Order ID`
ORDER BY `Order ID`) AS "Row Number"
FROM `returns`;

WITH duplicate_returns AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Returned`,
`Order ID`
ORDER BY `Order ID`) AS "Row Number"
FROM `returns`)
SELECT *
FROM duplicate_returns
WHERE `Row Number` > 1
ORDER BY `Order ID`;

WITH duplicate_returns AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Returned`,
`Order ID`
ORDER BY `Order ID`) AS "Row Number"
FROM `returns`)
DELETE
FROM duplicate_returns
WHERE `Row Number` > 1



/* 2. Data formatting and standardisation. */

SELECT DISTINCT `Row ID`
FROM orders
ORDER BY `Row ID` ASC;



SELECT DISTINCT `Order ID`
FROM orders
ORDER BY `Order ID` ASC;



SELECT DISTINCT `Order Date`
FROM orders
ORDER BY `Order Date` ASC;

SELECT DISTINCT `Order Date`,
STR_TO_DATE(`Order Date`, "%m/%d/%Y", "%Y-%m-%d")
FROM orders
ORDER BY `Order Date` ASC;

UPDATE orders
SET `Order Date` = STR_TO_DATE(`Order Date`, "%m/%d/%Y", "%Y-%m-%d");

ALTER TABLE orders
MODIFY COLUMN `Order Date` DATE;



SELECT DISTINCT `Ship Date`
FROM orders
ORDER BY `Ship Date` ASC;

UPDATE orders
SET `Ship Date` = STR_TO_DATE(`Ship Date`, "%m/%d/%Y", "%Y-%m-%d");

ALTER TABLE orders
MODIFY COLUMN `Ship Date` DATE;



SELECT DISTINCT `Ship Mode`
FROM orders
ORDER BY `Ship Mode` ASC;



SELECT DISTINCT `Customer ID`
FROM orders
ORDER BY `Customer ID` ASC;



SELECT DISTINCT `Segment`
FROM orders
ORDER BY `Segment` ASC;



SELECT DISTINCT `Country/Region`
FROM orders
ORDER BY `Country/Region` ASC;



SELECT DISTINCT `City`
FROM orders
ORDER BY `City` ASC;



SELECT DISTINCT `State/Province`
FROM orders
ORDER BY `State/Province` ASC;



SELECT DISTINCT `Postal Code`
FROM orders
ORDER BY `Postal Code` ASC;



SELECT DISTINCT `Region`
FROM orders
ORDER BY `Region` ASC;



SELECT DISTINCT `Product ID`
FROM orders
ORDER BY `Product ID` ASC;



SELECT DISTINCT `Category`
FROM orders
ORDER BY `Category` ASC;

SELECT DISTINCT `Category`,
`Product ID`
FROM Orders
WHERE LEFT(`Category`, 3) <> LEFT(`Product ID`, 3);



SELECT DISTINCT `Sub-Category`
FROM orders
ORDER BY `Sub-Category` ASC;



SELECT DISTINCT `Product Name`
FROM orders
ORDER BY `Product Name` ASC;



SELECT DISTINCT `Sales`
FROM orders
ORDER BY `Sales` ASC;

ALTER TABLE orders
MODIFY COLUMN `Sales` FLOAT;



SELECT DISTINCT `Quantity`
FROM orders
ORDER BY `Quantity` ASC;



SELECT DISTINCT `Discount`
FROM orders
ORDER BY `Discount` ASC;

ALTER TABLE orders
MODIFY COLUMN `Discount` FLOAT;



SELECT DISTINCT `Profit`
FROM orders
ORDER BY `Profit` ASC;

ALTER TABLE orders
MODIFY COLUMN `Profit` FLOAT;



/* ----------------------------------------------------------------------------------------------------------------- */

/* 1. Key Performance Indicators by Year. */

SELECT YEAR(`Order Date`) AS "Year",
ROUND(SUM(`Sales`), 0) AS "Total Sales",
SUM(`Quantity`) AS "Total Quantity",
ROUND(SUM(`Profit`), 0) AS "Total Profit",
COUNT(DISTINCT `Order ID`) AS "Total Orders",
COUNT(DISTINCT `Customer ID`) AS "Total Customers"
FROM orders
WHERE `Country/Region` = 'United States'
GROUP BY YEAR(`Order Date`)
ORDER BY `Year` DESC;



/* 2. Year over year differences of key performance indicators */

CREATE TEMPORARY TABLE Yearly_KPIs (
`Year` INT,
`Total Sales` FLOAT,
`Total Quantity` FLOAT,
`Total Profit` FLOAT,
`Total Orders` FLOAT,
`Total Customers` FLOAT);

INSERT INTO Yearly_KPIs
SELECT YEAR(`Order Date`) AS "Year",
ROUND(SUM(`Sales`), 0) AS "Total Sales",
SUM(`Quantity`) AS "Total Quantity",
ROUND(SUM(`Profit`), 0) AS "Total Profit",
COUNT(DISTINCT `Order ID`) AS "Total Orders",
COUNT(DISTINCT `Customer ID`) AS "Total Customers"
FROM orders
WHERE `Country/Region` = 'United States'
GROUP BY YEAR(`Order Date`)
ORDER BY `Year` ASC;

SELECT *
FROM Yearly_KPIs;

SELECT `Year`,
`Total Sales` AS "CY Sales",
LAG(`Total Sales`) OVER (ORDER BY `Year`) AS "PY Sales",
ROUND((`Total Sales` - LAG(`Total Sales`) OVER (ORDER BY `Year`)) * 100
/
LAG(`Total Sales`) OVER (ORDER BY `Year`), 1) AS "YoY Sales (%)"
FROM Yearly_KPIs;



SELECT `Year`,
`Total Quantity` AS "CY Quantity",
LAG(`Total Quantity`) OVER (ORDER BY `Year`) AS "PY Quantity",
ROUND((`Total Quantity` - LAG(`Total Quantity`) OVER (ORDER BY `Year`)) * 100
/
LAG(`Total Quantity`) OVER (ORDER BY `Year`), 1) AS "YoY Quantity (%)"
FROM Yearly_KPIs;



SELECT `Year`,
`Total Profit` AS "CY Profit",
LAG(`Total Profit`) OVER (ORDER BY `Year`) AS "PY Profit",
ROUND((`Total Profit` - LAG(`Total Profit`) OVER (ORDER BY `Year`)) * 100
/
LAG(`Total Profit`) OVER (ORDER BY `Year`), 1) AS "YoY Profit (%)"
FROM Yearly_KPIs;



SELECT `Year`,
`Total Orders` AS "CY Orders",
LAG(`Total Orders`) OVER (ORDER BY `Year`) AS "PY Orders",
ROUND((`Total Orders` - LAG(`Total Orders`) OVER (ORDER BY `Year`)) * 100
/
LAG(`Total Orders`) OVER (ORDER BY `Year`), 1) AS "YoY Orders (%)"
FROM Yearly_KPIs;



SELECT `Year`,
`Total Customers` AS "CY Customers",
LAG(`Total Customers`) OVER (ORDER BY `Year`) AS "PY Customers",
ROUND((`Total Customers` - LAG(`Total Customers`) OVER (ORDER BY `Year`)) * 100
/
LAG(`Total Customers`) OVER (ORDER BY `Year`), 1) AS "YoY Customers (%)"
FROM Yearly_KPIs;



/* 3. Key performance indicators by Year and Month */

SELECT YEAR(`Order Date`) AS "Year",
DATENAME(MONTH, `Order Date`) AS "Month",
ROUND(SUM(`Sales`), 0) AS "Total Sales",
SUM(`Quantity`) AS "Total Quantity",
ROUND(SUM(`Profit`), 0) AS "Total Profit",
COUNT(DISTINCT `Order ID`) AS "Total Orders",
COUNT(DISTINCT `Customer ID`) AS "Total Customers"
FROM orders
WHERE `Country/Region` = 'United States'
GROUP BY YEAR(`Order Date`), DATEPART(MONTH, `Order Date`), DATENAME(MONTH, `Order Date`)
ORDER BY `Year` DESC, DATEPART(MONTH, `Order Date`) ASC;



/* 4. Key performance indicators by Year, Region and State. */

SELECT YEAR(`Order Date`) AS "Year",
`Region`,
`State/Province`,
ROUND(SUM(`Sales`), 0) AS "Total Sales",
SUM(`Quantity`) AS "Total Quantity",
ROUND(SUM(`Profit`), 0) AS "Total Profit",
COUNT(DISTINCT `Order ID`) AS "Total Orders",
COUNT(DISTINCT `Customer ID`) AS "Total Customers"
FROM orders
WHERE `Country/Region` = 'United States'
GROUP BY YEAR(`Order Date`), `Region`, `State/Province`
ORDER BY `Year` DESC;



/* 5. Key performance indicators by Year, Category and Sub-category. */

SELECT YEAR(`Order Date`) AS "Year",
`Category`,
`Sub-Category`,
ROUND(SUM(`Sales`), 0) AS "Total Sales",
SUM(`Quantity`) AS "Total Quantity",
ROUND(SUM(`Profit`), 0) AS "Total Profit",
COUNT(DISTINCT `Order ID`) AS "Total Orders",
COUNT(DISTINCT `Customer ID`) AS "Total Customers"
FROM orders
WHERE `Country/Region` = 'United States'
GROUP BY YEAR(`Order Date`), `Category`, `Sub-Category`
ORDER BY `Year` DESC;



/* 6. Key performance indicators by Year and Segment */

SELECT YEAR(`Order Date`) AS "Year",
`Segment`,
ROUND(SUM(`Sales`), 0) AS "Total Sales",
SUM(`Quantity`) AS "Total Quantity",
ROUND(SUM(`Profit`), 0) AS "Total Profit",
COUNT(DISTINCT `Order ID`) AS "Total Orders",
COUNT(DISTINCT `Customer ID`) AS "Total Customers"
FROM orders
WHERE `Country/Region` = 'United States'
GROUP BY YEAR(`Order Date`), `Segment`
ORDER BY `Year` DESC;



/* 7. Key performance indicators by Year and Ship Mode */

SELECT YEAR(`Order Date`) AS "Year",
`Ship Mode`,
ROUND(SUM(`Sales`), 0) AS "Total Sales",
SUM(`Quantity`) AS "Total Quantity",
ROUND(SUM(`Profit`), 0) AS "Total Profit",
COUNT(DISTINCT `Order ID`) AS "Total Orders",
COUNT(DISTINCT `Customer ID`) AS "Total Customers"
FROM orders
WHERE `Country/Region` = 'United States'
GROUP BY YEAR(`Order Date`), `Ship Mode`
ORDER BY `Year` DESC;	
	