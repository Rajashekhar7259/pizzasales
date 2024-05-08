USE `pizza`;

ALTER TABLE pizza_sales             -- ADDING COLUMNS TO THE TABLE
ADD COLUMN order_date_new DATE AFTER `quantity`;

UPDATE pizza_sales
SET order_date_new=STR_TO_DATE(order_date,'%d-%m-%Y');

ALTER TABLE pizza_sales DROP COLUMN order_date;

ALTER TABLE pizza_sales CHANGE COLUMN order_date_new order_date date;

# A. KPI’s
# 1. Total Revenue:
SELECT round(SUM(total_price),2) AS Total_Revenue FROM pizza_sales;

# 2. Average Order Value
SELECT (SUM(total_price)/COUNT(DISTINCT order_id)) AS Avg_order_Value FROM pizza_sales;

# 3. Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold FROM pizza_sales;

# 4. Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales;

# 5. Average Pizzas Per Order
SELECT 
    CAST(
        CAST(SUM(quantity) AS DECIMAL(10,2)) / 
        CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2))
        AS DECIMAL(10,2)
    ) AS Avg_Pizzas_per_order
FROM pizza_sales;

# B. Hourly Trend for Total Pizzas Sold    
SELECT 
    HOUR(order_time) AS order_hours,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);

# C. Weekly Trend for Orders
SELECT
    WEEK(order_date, 3) AS WeekNumber,
    YEAR(order_date) AS Year,
    COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY WEEK(order_date, 3), YEAR(order_date)
ORDER BY Year, WeekNumber;

# D. % of Sales by Pizza Category
SELECT
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category;

# E. % of Sales by Pizza Size
SELECT
    pizza_size,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

# F. Total Pizzas Sold by Pizza Category
SELECT
    pizza_category,
    SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;

# G. Top 5 Pizzas by Revenue
SELECT
    pizza_name,
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;

# H. Bottom 5 Pizzas by Revenue
SELECT
    pizza_name,
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
LIMIT 5;

# I. Top 5 Pizzas by Quantity
SELECT
    pizza_name,
    SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

# J. Bottom5 Pizzas by Quantity
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;

# K. Top 5 Pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC
LIMIT 5;

# L. Borrom 5 Pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
WHERE pizza_category = 'Classic'
GROUP BY pizza_name
ORDER BY Total_Orders ASC
LIMIT 5;








    
