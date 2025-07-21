# walmart-analysis-sql

# 🛒 Walmart Sales SQL EDA Project

An exploratory data analysis (EDA) project using SQL to uncover patterns, trends, and insights in Walmart's weekly sales across multiple stores. The analysis covers key factors such as **holidays**, **temperature**, **fuel prices**, **unemployment**, and **inflation (CPI)**.

---

## 📁 Dataset Description

The dataset `waldata` contains weekly sales data from multiple Walmart stores with the following columns:

- `Store_Number`: Store ID
- `Date`: Weekly timestamp
- `Weekly_Sales`: Sales amount for that week
- `Holiday_Flag`: 1 if the week includes a holiday, else 0
- `Temperature`: Recorded temperature for the store's region
- `Fuel_Price`: Average fuel price in that region
- `CPI`: Consumer Price Index (inflation indicator)
- `Unemployment`: Unemployment rate in the region

---

## 🔍 Analysis Summary

### 🏪 General Overview

- The dataset covers **multiple stores** over a **uniform time interval**.
- Each date has entries from all stores, ensuring a **consistent time-series**.

---

### 📈 Sales Performance

- **Store 14** recorded the **highest single-week sales**, followed by stores 20, 10, and 4.
- These peak sales often occurred around **Christmas (especially 2010 & 2011)**.
- **Lowest sales** were clustered between **January and March**, likely due to post-holiday slowdown.
- Weekly top-selling stores varied over time: Store 14 led early on, but Store 20 gained dominance later.

---

### 📆 Yearly Store Averages

- Calculated average sales for each store by year.
- Store rankings changed yearly, indicating **shifts in local performance or customer behavior**.

---

### 🎉 Holiday Effects

- On **average**, **holiday weeks** resulted in **higher sales** across most stores.
- Although **maximum sales** were not always on flagged holiday weeks (e.g., Christmas Eve often isn't flagged), holidays generally boost sales.
- Even **minimum holiday sales** tend to be higher than minimum non-holiday sales.

---

### 🌡️ Temperature-Based Sales

- Categorized temperature into ranges (Very Cold, Cold, Mild, Warm, Hot).
- **"Mild" (51–70°F)** temperature range saw **highest average sales**.
- Cold and hot extremes led to slightly lower sales, suggesting customers shop more comfortably in mild weather.

---

### 🛢️ Fuel Price Trends

- Analyzed average fuel prices and sales by year.
- Fuel price increases did not show a clear negative correlation with sales, indicating **fuel prices may not significantly deter Walmart shopping**.

---

### 👷 Employment Rate vs Sales

- Grouped stores by average unemployment rate:
  - **High employment (low unemployment)** stores saw **higher average sales**.
  - Suggests stronger local economies contribute to stronger store performance.

---

### 💰 CPI (Inflation) Trends

- Compared **yearly average CPI and sales**.
- CPI increased over time, while sales fluctuated.
- Indicates inflation **may reduce purchasing power**, but more analysis is needed to isolate its impact due to overlapping variables.

---

## 🧾 SQL Code Used

### General Exploration

```sql
SELECT * FROM waldata;
DESCRIBE waldata;
SELECT COUNT(*) FROM waldata;
SELECT COUNT(DISTINCT Store_Number) FROM waldata;
```

### Store-Wise Data Count

```sql
SELECT Store_Number, COUNT(*)
FROM waldata
GROUP BY Store_Number;

SELECT `date`, COUNT(Store_Number)
FROM waldata
GROUP BY `date`;
```

### Max and Min Sales Per Store

```sql
WITH Store_max AS (
  SELECT Store_Number, MAX(Weekly_Sales) AS Maxx_amt
  FROM waldata
  GROUP BY Store_Number
)
SELECT w.Store_Number, w.Weekly_Sales AS Max_Amt, w.`Date`
FROM waldata w
JOIN Store_max ON w.Store_Number = Store_max.Store_Number AND w.Weekly_Sales = Store_max.Maxx_amt
ORDER BY Weekly_Sales DESC;
```

```sql
WITH Store_min AS (
  SELECT Store_Number, MIN(Weekly_Sales) AS Minn_amt
  FROM waldata
  GROUP BY Store_Number
)
SELECT w.Store_Number, w.Weekly_Sales AS Min_Amt, w.`Date`
FROM waldata w
JOIN Store_min ON w.Store_Number = Store_min.Store_Number AND w.Weekly_Sales = Store_min.Minn_amt
ORDER BY MONTH(`date`);
```

### Weekly Top Seller

```sql
SELECT w.`date`, w.Store_Number, w.Weekly_Sales
FROM waldata w
INNER JOIN (
  SELECT `date`, MAX(Weekly_Sales) AS max_sales
  FROM waldata
  GROUP BY `date`
) sub
ON w.`date` = sub.`date` AND w.Weekly_Sales = sub.max_sales
ORDER BY w.`date`;
```

### Yearly Average Sales

```sql
SELECT Store_Number, YEAR(`date`) AS year, AVG(Weekly_Sales) AS avg_sales
FROM waldata
GROUP BY Store_Number, YEAR(`date`)
ORDER BY year, avg_sales DESC;
```

### Holiday-Based Sales

```sql
SELECT Store_Number, Holiday_Flag, AVG(Weekly_Sales)
FROM waldata
GROUP BY Store_Number, Holiday_Flag;
```

### Temperature Impact

```sql
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
```

### Sales vs Fuel Price

```sql
SELECT
  YEAR(Date) AS year,
  ROUND(AVG(Fuel_Price), 2) AS avg_fuel_price,
  ROUND(AVG(Weekly_Sales), 2) AS avg_sales
FROM waldata
GROUP BY year
ORDER BY year;
```

### Employment and Sales

```sql
SELECT
  Store_Number,
  ROUND(AVG(Unemployment), 2) AS avg_unemployment,
  ROUND(AVG(Weekly_Sales), 2) AS avg_sales,
  CASE
    WHEN AVG(Unemployment) < 6 THEN 'High Employment'
    ELSE 'Low Employment'
  END AS employment_group
FROM waldata
GROUP BY Store_Number
ORDER BY avg_unemployment;
```

### CPI and Sales

```sql
SELECT
  YEAR(Date) AS year,
  ROUND(AVG(CPI), 2) AS avg_cpi,
  ROUND(AVG(Weekly_Sales), 2) AS avg_sales
FROM waldata
GROUP BY YEAR(Date)
ORDER BY year;
```

---

## 🧑‍💻 Author

Made by \[Sunam Niroula]
📧 [sunamniroula1@gmail.com](mailto:sunamniroula1@gmail.com)
🐙 GitHub: [Sunam Niroula](https://github.com/niroulasunam)

---
