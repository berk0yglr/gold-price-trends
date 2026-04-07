<div align="center">
  
  <h1>📈 Gold Price Trends Analysis</h1>
  
  <p>
    <b>An End-to-End SQL Data Cleaning and Time-Series Analysis Project</b>
  </p>

  <img src="https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white" alt="SQL Server" />
  <img src="https://img.shields.io/badge/Data_Engineering-005571?style=for-the-badge&logo=databricks&logoColor=white" alt="Data Engineering" />
  <img src="https://img.shields.io/badge/T--SQL-005C84?style=for-the-badge&logo=microsoft&logoColor=white" alt="T-SQL" />

</div>

<br>

## 📌 Project Overview

This repository showcases a comprehensive data analysis pipeline focused on historical gold price trends. The project demonstrates the ability to take raw, inconsistent financial data, perform rigorous data cleaning, handle structural database errors, and extract meaningful time-series insights using advanced SQL techniques.

## 🛠️ Tech Stack & Skills Demonstrated

* **RDBMS:** Microsoft SQL Server (T-SQL)
* **Data Engineering:** Schema modification, Data Normalization, Type Casting
* **Advanced SQL:** Common Table Expressions (CTEs), Window Functions, `CASE WHEN` logic, Aggregations.

---

## 🚀 Challenges & Solutions

Real-world data is rarely clean. During the initial exploration phase, two major data integrity issues were identified and resolved:

### 1. The `smallint` Overflow Issue
* **The Problem:** The `Volume` column threw an overflow error during data import (e.g., failing to insert `50896`). The column was incorrectly configured as `smallint` (max capacity: 32,767).
* **The Fix:** Executed an `ALTER TABLE` schema update, converting the column to `INT` to safely accommodate values up to 2.14 billion.

### 2. Significant Outliers & Scaling Anomalies
* **The Problem:** Price columns (`Open`, `High`, `Low`, `Close`) contained severe scaling errors. Standard market prices like `273.9` were recorded as `2739000064`.
* **The Fix:** Engineered a robust data normalization pipeline using `CASE WHEN` statements. Anomalous values ( > 10,000) were divided by `10000000.0`. Float division was strictly used to prevent integer truncation and maintain exact financial precision.

---

## 📊 Core Analysis: Yearly Price Trends

The core of the analysis is driven by optimizing query performance. Instead of running heavy cleaning logic repeatedly, a **CTE (Common Table Expression)** was utilized to clean the data in memory before performing the trend analysis.

```sql
WITH CleanedData AS (
    SELECT 
        YEAR(Date) AS TrendYear,
        CASE 
            WHEN [Close] > 10000 THEN [Close] / 10000000.0 
            ELSE [Close] 
        END AS Normalized_Close
    FROM dbo.finalgolddata
)
-- Calculating the average closing price per year to determine the macro trend
SELECT 
    TrendYear,
    ROUND(AVG(Normalized_Close), 2) AS Average_Closing_Price
FROM CleanedData
GROUP BY TrendYear
ORDER BY TrendYear;
