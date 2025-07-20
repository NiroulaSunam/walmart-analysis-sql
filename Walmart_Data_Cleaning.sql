SELECT *
FROM walmart_sales_analysis;

-- Creating a working table 
CREATE TABLE waldata
LIKE walmart_sales_analysis;

-- Inserting the raw data to the working table
insert waldata
SELECT *
FROM walmart_sales_analysis;

SELECT *
FROM waldata;

-- DATA CLEANING

-- Finding Duplicates 
-- (creating row number unique to the values and looking at row numbers greather than 1 to see if there are any duplicates)

WITH duplicates AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Store_Number, 'Date', Weekly_Sales, Holiday_Flag, Temperature, Fuel_Price, CPI, Unemployment) AS row_num
FROM waldata
)
SELECT *
FROM duplicates
WHERE row_num > 1;

-- standardizing the datas

SELECT *
FROM waldata;

-- information about the data types 
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'walmart_analysis';

SHOW databases;

-- changing the date text to a proper date fromat 

UPDATE waldata
SET `date` = str_to_date(`date`,'%m/%d/%Y');

SELECT `date`
FROM waldata;

-- changing the data type of date to DATE

ALTER TABLE waldata
MODIFY COLUMN `date` DATE;

-- Replacing the , in amount of sales to make the data standard and calculabe by converting to integer
UPDATE waldata
SET Weekly_Sales = CAST(REPLACE(Weekly_Sales,',','') AS UNSIGNED);


-- changing the data type after the changes above of the weekly sales amount from a string to an integer
ALTER TABLE waldata
MODIFY COLUMN Weekly_Sales INT;


-- Removing Null or Blank Values
-- (check if any values are null or blank and remove or replace based on the data)
SELECT *
FROM waldata
WHERE Unemployment IS NULL;

-- Cleaned Data for EDA
SELECT * 
FROM waldata;