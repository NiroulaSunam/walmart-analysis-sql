-- EDA
SELECT * 
FROM waldata;


DESCRIBE waldata;


-- no of rows
SELECT COUNT(*)
FROM waldata;

-- sample data
SELECT *
FROM waldata
LIMIT 144;

-- no of stores
SELECT COUNT(DISTINCT Store_Number)
FROM waldata;

-- no of data from each stores
SELECT Store_Number, COUNT(Store_Number)
FROM waldata
GROUP BY Store_Number;

-- no of data by date 
SELECT `date`, COUNT(`Store_Number`)
FROM waldata
GROUP BY `date`;

-- Can be inferred that the all the stores data were taken at the same dates and intervals.




-- Sales Overall , max, min, avg


-- looking at maximum sales of each stores with when it occured
WITH Store_max AS 
(
SELECT Store_Number, max(Weekly_Sales) AS Maxx_amt
FROM waldata
GROUP BY Store_Number
)
SELECT w.Store_Number, w.Weekly_Sales AS Max_Amt, w.`Date`
FROM waldata AS w
JOIN Store_max
ON w.Store_Number = Store_max.Store_Number
AND w.Weekly_Sales = Store_max.Maxx_amt
ORDER BY Weekly_Sales DESC;

-- Store 14 has the maximum sales closely followed by 20, 10, 4 and 13. 
-- And we can see that almost most of the sales at the top range is done in Christmas Eve. (Mostly in 2010 followed by 2011)


-- looking at minimum sales of each stores with when it occured 
WITH Store_min AS 
(
SELECT Store_Number, min(Weekly_Sales) AS Minn_amt
FROM waldata
GROUP BY Store_Number
)
SELECT w.Store_Number, w.Weekly_Sales AS Min_Amt, w.`Date`
FROM waldata AS w
JOIN Store_min
ON w.Store_Number = Store_min.Store_Number
AND w.Weekly_Sales = Store_min.Minn_amt
ORDER BY MONTH(`date`);

-- Since the data was jumbled while sorting with Store number and the date, used the sort by date. 
-- Thought i saw a pattern in the months so, Used date order by month. 
-- And it can be seen that the lowest sales are a the time of end of month and till 2-3 months. People spend less at the walmart.


-- Looking into which store had the most sells in the week

SELECT w.`date`, w.Store_Number, w.Weekly_Sales
FROM waldata w
INNER JOIN (
    SELECT `date`, MAX(Weekly_Sales) AS max_sales
    FROM waldata
    GROUP BY `date`
) AS sub
ON w.`date` = sub.`date` AND w.Weekly_Sales = sub.max_sales
ORDER BY w.`date`;

-- It can be seen that 14 had the most sales starting but as time went on 20 started beating it and then followed by 4. 

-- Average Sales of Store in every year. 
-- (can change it to give only the top 5 of each year)

SELECT Store_Number, YEAR(`date`),  AVG(Weekly_Sales) AS avg_sales
FROM waldata
GROUP BY Store_Number, YEAR(`date`)
ORDER BY YEAR(`date`) ASC, avg_sales DESC;





-- -- --- --- ---- ----
SELECT *
FROM waldata;

-- Sales by Holiday time (Date) for each stores 

SELECT Store_Number, Holiday_Flag, MAX(Weekly_Sales)
FROM waldata
GROUP BY Store_Number, Holiday_Flag;
-- Shows that the non holiday makes more sales than the holiday days at most places in terms of maximum sales. (???)

SELECT Store_Number, Holiday_Flag, MIN(Weekly_Sales)
FROM waldata
GROUP BY Store_Number, Holiday_Flag;
-- Majoritily the holiday makes more sales than non-holidays even on the least amount. 

SELECT Store_Number, Holiday_Flag, AVG(Weekly_Sales)
FROM waldata
GROUP BY Store_Number, Holiday_Flag;
-- On average holiday makes more sales than non-holidays 



-- ----- ---- ----
-- Sales based on Temperature (need a chart for this for better visualization)

-- creating a new table with the range changed to some values for better understanding
-- then finding the average sales on that temperature 
-- it shows the no of weeks it was cold, mild, ward, hot etc. and the average sales during that time 

SELECT 
  CASE 
    WHEN Temperature < 30 THEN 'Very Cold'
    WHEN Temperature BETWEEN 30 AND 50 THEN 'Cold'
    WHEN Temperature BETWEEN 51 AND 70 THEN 'Mild'
    WHEN Temperature BETWEEN 71 AND 85 THEN 'Warm'
    ELSE 'Hot'
  END AS temp_category,
  AVG(Weekly_Sales) AS avg_sales,
  COUNT(*) AS num_weeks
FROM waldata
GROUP BY temp_category
ORDER BY avg_sales DESC;




-- Maximum sales for a particular temperature range. 
-- (utilizing the temporary column from the above but this time getting the max amount for the temperature range and at what date and temperature it was on)

WITH Temp_max AS 
(
SELECT
-- instead of copy pasting the table from above, could create a permanent table for this as it is used a lot 
 CASE
	WHEN Temperature < 30 THEN 'Very Cold'
    WHEN Temperature BETWEEN 30 AND 50 THEN 'Cold'
    WHEN Temperature BETWEEN 51 AND 70 THEN 'Mild'
    WHEN Temperature BETWEEN 71 AND 85 THEN 'Warm'
    ELSE 'Hot'
END AS temp_category, 
MAX(Weekly_Sales) AS max_sales
FROM waldata
GROUP BY temp_category
)
SELECT w.Weekly_Sales AS Max_Amt,w.Temperature, w.`Date`
FROM waldata AS w
JOIN Temp_max
ON w.Weekly_Sales = Temp_max.max_sales
ORDER BY Weekly_Sales DESC;

-- Sales Change by Temperature over time 
SELECT 
  YEAR(`Date`) AS year,
  -- using a simple version of the above table to do fast analysis 
  CASE 
    WHEN Temperature < 50 THEN 'Cold'
    WHEN Temperature BETWEEN 50 AND 75 THEN 'Moderate'
    ELSE 'Hot'
  END AS temp_band,
  AVG(Weekly_Sales) AS avg_sales
FROM waldata
GROUP BY year, temp_band
ORDER BY year, temp_band;

-- Average sales of a store depending upon their temperature range (average temperature of the store and how it impacts sales)
SELECT 
  Store_Number,
  ROUND(AVG(Temperature), 1) AS avg_temp,
  ROUND(AVG(Weekly_Sales), 2) AS avg_sales
FROM waldata
GROUP BY Store_Number
ORDER BY avg_temp;
-- can be used if more information or context like location, dates and others are included


SELECT 
  YEAR(Date) AS year,
  ROUND(AVG(CPI), 2) AS avg_cpi,
  ROUND(AVG(Weekly_Sales), 2) AS avg_sales
FROM waldata
GROUP BY YEAR(Date)
ORDER BY year;
-- it shows that as inflation increases, sales decreases. But due to the mix of other data, 
-- we cannot dirrectly coorelate with it without furtur analysis. 
