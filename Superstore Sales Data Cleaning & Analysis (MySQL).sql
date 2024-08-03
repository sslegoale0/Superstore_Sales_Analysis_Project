SET sql_safe_updates = 0;

SET sql_mode = "Traditional";

---------------------------------------------------------------------------------------------------------------------------------------------

-- Superstore Sales Data Cleaning.

CREATE DATABASE superstore_sales;



-- Imported Superstore Sales data into MySQL using SQLAlchemy.



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



-- 1. Removal of duplicate rows.

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Id`) AS "Row Number"
FROM orders;

WITH duplicate_orders AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Id`) AS "Row Number"
FROM orders
)
SELECT *
FROM duplicate_orders
WHERE `Row Number` > 1;



-- 2. Data formatting & standardisation.

SELECT DISTINCT `Row Id`
FROM orders
ORDER BY `Row Id` ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;





-- 3. Imputation of null/blank values.




-- 4. Removal of redundant/irrelevant rows.




