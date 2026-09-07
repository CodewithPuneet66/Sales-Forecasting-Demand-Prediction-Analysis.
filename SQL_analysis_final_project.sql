CREATE DATABASE retail;


-- ============================================================
-- FINAL PROJECT
-- SALES FORECASTING & DEMAND PREDICTION ANALYSIS
-- SQL DATA ANALYSIS
-- ============================================================


-- ============================================================
-- 1. SELECT DATABASE
-- ============================================================

USE retail;


-- ============================================================
-- 2. CHECK DATA
-- ============================================================

SELECT *
FROM inventory_data
LIMIT 10;


-- ============================================================
-- 3. TOTAL NUMBER OF RECORDS
-- ============================================================

SELECT
    COUNT(*) AS total_records
FROM inventory_data;


-- ============================================================
-- 4. TOTAL UNITS SOLD
-- ============================================================

SELECT
    SUM(units_sold) AS total_units_sold
FROM inventory_data;


-- ============================================================
-- 5. TOTAL SALES / REVENUE
-- ============================================================

SELECT
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data;


-- ============================================================
-- 6. AVERAGE DAILY SALES
-- ============================================================

SELECT
    ROUND(AVG(revenue), 2) AS average_daily_sales
FROM inventory_data;


-- ============================================================
-- 7. MONTHLY SALES TREND
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
ORDER BY
    year,
    month_number;


-- ============================================================
-- 8. YEARLY SALES TREND
-- ============================================================

SELECT
    YEAR(date) AS year,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY
    YEAR(date)
ORDER BY
    year;


-- ============================================================
-- 9. MONTH-WISE SALES PERFORMANCE
--    Compare same month across years
-- ============================================================

SELECT
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY
    MONTH(date),
    MONTHNAME(date)
ORDER BY
    total_sales DESC;


-- ============================================================
-- 10. TOP 10 MONTHS BY SALES
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
ORDER BY
    total_sales DESC
LIMIT 10;


-- ============================================================
-- 11. LOWEST 10 MONTHS BY SALES
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
ORDER BY
    total_sales ASC
LIMIT 10;


-- ============================================================
-- 12. PRODUCT-WISE SALES PERFORMANCE
-- ============================================================

SELECT
    product_id,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY product_id
ORDER BY total_sales DESC;


-- ============================================================
-- 13. TOP 10 PRODUCTS BY SALES
-- ============================================================

SELECT
    product_id,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 14. TOP 10 PRODUCTS BY DEMAND
-- ============================================================

SELECT
    product_id,
    SUM(units_sold) AS total_units_sold
FROM inventory_data
GROUP BY product_id
ORDER BY total_units_sold DESC
LIMIT 10;


-- ============================================================
-- 15. PRODUCT-WISE AVERAGE DEMAND
-- ============================================================

SELECT
    product_id,
    ROUND(AVG(units_sold), 2) AS average_demand,
    SUM(units_sold) AS total_units_sold
FROM inventory_data
GROUP BY product_id
ORDER BY average_demand DESC;


-- ============================================================
-- 16. CATEGORY-WISE SALES PERFORMANCE
-- ============================================================

SELECT
    category,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY category
ORDER BY total_sales DESC;


-- ============================================================
-- 17. TOP CATEGORIES BY SALES
-- ============================================================

SELECT
    category,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY category
ORDER BY total_sales DESC;


-- ============================================================
-- 18. SEASONAL DEMAND PATTERN
-- ============================================================

SELECT
    seasonality,
    SUM(units_sold) AS total_units_sold,
    ROUND(AVG(units_sold), 2) AS average_demand,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY seasonality
ORDER BY total_units_sold DESC;


-- ============================================================
-- 19. SEASON-WISE SALES PERFORMANCE
-- ============================================================

SELECT
    seasonality,
    ROUND(SUM(revenue), 2) AS total_sales
FROM inventory_data
GROUP BY seasonality
ORDER BY total_sales DESC;


-- ============================================================
-- 20. MONTHLY DEMAND PATTERN
-- ============================================================

SELECT
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    SUM(units_sold) AS total_demand,
    ROUND(AVG(units_sold), 2) AS average_demand
FROM inventory_data
GROUP BY
    MONTH(date),
    MONTHNAME(date)
ORDER BY
    month_number;


-- ============================================================
-- 21. PEAK DEMAND MONTHS
-- ============================================================

SELECT
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    SUM(units_sold) AS total_demand
FROM inventory_data
GROUP BY
    MONTH(date),
    MONTHNAME(date)
ORDER BY
    total_demand DESC
LIMIT 5;


-- ============================================================
-- 22. DAILY SALES TREND
-- ============================================================

SELECT
    date,
    ROUND(SUM(revenue), 2) AS daily_sales
FROM inventory_data
GROUP BY date
ORDER BY date;


-- ============================================================
-- 23. DAILY DEMAND TREND
-- ============================================================

SELECT
    date,
    SUM(units_sold) AS daily_demand
FROM inventory_data
GROUP BY date
ORDER BY date;


-- ============================================================
-- 24. YEAR-OVER-YEAR SALES GROWTH
-- ============================================================

WITH yearly_sales AS (
    SELECT
        YEAR(date) AS year,
        SUM(revenue) AS total_sales
    FROM inventory_data
    GROUP BY YEAR(date)
),

sales_comparison AS (
    SELECT
        year,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY year
        ) AS previous_year_sales
    FROM yearly_sales
)

SELECT
    year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(previous_year_sales, 2) AS previous_year_sales,
    ROUND(
        (
            (total_sales - previous_year_sales)
            / NULLIF(previous_year_sales, 0)
        ) * 100,
        2
    ) AS growth_percentage
FROM sales_comparison
ORDER BY year;


-- ============================================================
-- 25. MONTH-OVER-MONTH SALES GROWTH
-- ============================================================

WITH monthly_sales AS (
    SELECT
        YEAR(date) AS year,
        MONTH(date) AS month_number,
        MONTHNAME(date) AS month_name,
        SUM(revenue) AS total_sales
    FROM inventory_data
    GROUP BY
        YEAR(date),
        MONTH(date),
        MONTHNAME(date)
),

sales_comparison AS (
    SELECT
        year,
        month_number,
        month_name,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY year, month_number
        ) AS previous_month_sales
    FROM monthly_sales
)

SELECT
    year,
    month_number,
    month_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(
        (
            (total_sales - previous_month_sales)
            / NULLIF(previous_month_sales, 0)
        ) * 100,
        2
    ) AS growth_percentage
FROM sales_comparison
ORDER BY
    year,
    month_number;


-- ============================================================
-- 26. SALES INCREASE / DECLINE IDENTIFICATION
-- ============================================================

WITH monthly_sales AS (
    SELECT
        YEAR(date) AS year,
        MONTH(date) AS month_number,
        MONTHNAME(date) AS month_name,
        SUM(revenue) AS total_sales
    FROM inventory_data
    GROUP BY
        YEAR(date),
        MONTH(date),
        MONTHNAME(date)
),

sales_comparison AS (
    SELECT
        year,
        month_number,
        month_name,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY year, month_number
        ) AS previous_month_sales
    FROM monthly_sales
)

SELECT
    year,
    month_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(previous_month_sales, 2) AS previous_month_sales,

    CASE
        WHEN previous_month_sales IS NULL
            THEN 'First Month'

        WHEN total_sales > previous_month_sales
            THEN 'Sales Increased'

        WHEN total_sales < previous_month_sales
            THEN 'Sales Declined'

        ELSE 'No Change'
    END AS sales_trend

FROM sales_comparison
ORDER BY
    year,
    month_number;


-- ============================================================
-- 27. HIGHEST GROWTH MONTH
-- ============================================================

WITH monthly_sales AS (
    SELECT
        YEAR(date) AS year,
        MONTH(date) AS month_number,
        MONTHNAME(date) AS month_name,
        SUM(revenue) AS total_sales
    FROM inventory_data
    GROUP BY
        YEAR(date),
        MONTH(date),
        MONTHNAME(date)
),

growth_analysis AS (
    SELECT
        year,
        month_number,
        month_name,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY year, month_number
        ) AS previous_month_sales
    FROM monthly_sales
)

SELECT
    year,
    month_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        (
            (total_sales - previous_month_sales)
            / NULLIF(previous_month_sales, 0)
        ) * 100,
        2
    ) AS growth_percentage
FROM growth_analysis
WHERE previous_month_sales IS NOT NULL
ORDER BY growth_percentage DESC
LIMIT 10;


-- ============================================================
-- 28. HIGHEST SALES DECLINE MONTH
-- ============================================================

WITH monthly_sales AS (
    SELECT
        YEAR(date) AS year,
        MONTH(date) AS month_number,
        MONTHNAME(date) AS month_name,
        SUM(revenue) AS total_sales
    FROM inventory_data
    GROUP BY
        YEAR(date),
        MONTH(date),
        MONTHNAME(date)
),

decline_analysis AS (
    SELECT
        year,
        month_number,
        month_name,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY year, month_number
        ) AS previous_month_sales
    FROM monthly_sales
)

SELECT
    year,
    month_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        (
            (total_sales - previous_month_sales)
            / NULLIF(previous_month_sales, 0)
        ) * 100,
        2
    ) AS growth_percentage
FROM decline_analysis
WHERE previous_month_sales IS NOT NULL
ORDER BY growth_percentage ASC
LIMIT 10;


-- ============================================================
-- 29. ACTUAL DEMAND VS FORECAST DEMAND
-- ============================================================

SELECT
    date,
    SUM(units_sold) AS actual_demand,
    SUM(demand_forecast) AS forecast_demand
FROM inventory_data
GROUP BY date
ORDER BY date;


-- ============================================================
-- 30. MONTHLY ACTUAL VS FORECAST DEMAND
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    SUM(units_sold) AS actual_demand,
    SUM(demand_forecast) AS forecast_demand
FROM inventory_data
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
ORDER BY
    year,
    month_number;


-- ============================================================
-- 31. PRODUCT-WISE ACTUAL VS FORECAST DEMAND
-- ============================================================

SELECT
    product_id,
    SUM(units_sold) AS actual_demand,
    SUM(demand_forecast) AS forecast_demand,
    SUM(units_sold) - SUM(demand_forecast) AS forecast_difference
FROM inventory_data
GROUP BY product_id
ORDER BY actual_demand DESC;


-- ============================================================
-- 32. FORECAST ERROR ANALYSIS
-- ============================================================

SELECT
    date,
    SUM(units_sold) AS actual_demand,
    SUM(demand_forecast) AS forecast_demand,

    SUM(units_sold) -
    SUM(demand_forecast) AS forecast_error,

    ABS(
        SUM(units_sold) -
        SUM(demand_forecast)
    ) AS absolute_error

FROM inventory_data
GROUP BY date
ORDER BY date;


-- ============================================================
-- 33. AVERAGE FORECAST ERROR
-- ============================================================

SELECT
    ROUND(
        AVG(
            ABS(units_sold - demand_forecast)
        ),
        2
    ) AS mean_absolute_error
FROM inventory_data;


-- ============================================================
-- 34. PRODUCTS WITH HIGHEST FORECAST DEMAND
-- ============================================================

SELECT
    product_id,
    SUM(demand_forecast) AS total_forecast_demand,
    SUM(units_sold) AS total_actual_demand
FROM inventory_data
GROUP BY product_id
ORDER BY total_forecast_demand DESC
LIMIT 10;


-- ============================================================
-- 35. PRODUCTS WITH HIGH FUTURE DEMAND
-- ============================================================

SELECT
    product_id,
    ROUND(AVG(demand_forecast), 2) AS average_forecast_demand,
    SUM(demand_forecast) AS total_forecast_demand
FROM inventory_data
GROUP BY product_id
ORDER BY average_forecast_demand DESC
LIMIT 10;


-- ============================================================
-- 36. CATEGORY-WISE DEMAND FORECAST
-- ============================================================

SELECT
    category,
    SUM(units_sold) AS actual_demand,
    SUM(demand_forecast) AS forecast_demand
FROM inventory_data
GROUP BY category
ORDER BY forecast_demand DESC;


-- ============================================================
-- 37. SEASON-WISE ACTUAL VS FORECAST DEMAND
-- ============================================================

SELECT
    seasonality,
    SUM(units_sold) AS actual_demand,
    SUM(demand_forecast) AS forecast_demand
FROM inventory_data
GROUP BY seasonality
ORDER BY actual_demand DESC;


-- ============================================================
-- 38. FINAL SUMMARY BY YEAR
-- ============================================================

SELECT
    YEAR(date) AS year,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue), 2) AS total_sales,
    ROUND(AVG(revenue), 2) AS average_sales
FROM inventory_data
GROUP BY YEAR(date)
ORDER BY year;


-- ============================================================
-- 39. FINAL SUMMARY BY PRODUCT
-- ============================================================

SELECT
    product_id,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue), 2) AS total_sales,
    ROUND(AVG(units_sold), 2) AS average_demand,
    SUM(demand_forecast) AS forecast_demand
FROM inventory_data
GROUP BY product_id
ORDER BY total_sales DESC;


-- ============================================================
-- 40. FINAL SUMMARY BY SEASON
-- ============================================================

SELECT
    seasonality,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(revenue), 2) AS total_sales,
    ROUND(AVG(units_sold), 2) AS average_demand,
    SUM(demand_forecast) AS forecast_demand
FROM inventory_data
GROUP BY seasonality
ORDER BY total_sales DESC;


-- ============================================================
-- END OF SQL ANALYSIS
-- ============================================================