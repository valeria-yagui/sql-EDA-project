USE DataWarehouse;

-- Explore Objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES;
-- Comment: This shows like a "catalog" with the table schemas, names and type.

-- Explore Columns in the database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;
-- Comment: This shows like a "catalog" with the table schemas, names and type.


--==================================================== TABLE CUSTOMERS ====================================================
SELECT * 
FROM gold.dim_customers;

-- What is the total number of customers?
SELECT COUNT (DISTINCT customer_number) AS total_n_customers
FROM gold.dim_customers;


-- Where are the customers from?
SELECT
	country,
	COUNT(DISTINCT customer_number) AS total_customers,
	ROUND(COUNT(DISTINCT customer_number) * 1.0 /SUM(COUNT(DISTINCT customer_number)) OVER() *100,2) AS percentage_of_total
	-- 1.0 -> allows to keep the decimals
	-- OVER() so the resuls are not groupd together.
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC			
-- Comment: Canada and Australia are the countries with the most customers


-- Customer by gender
SELECT
	gender,
	COUNT(DISTINCT customer_number) AS total_customers,
	ROUND(COUNT(DISTINCT customer_number) * 1.0 /SUM(COUNT(DISTINCT customer_number)) OVER() *100,2) AS percentage_of_total
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;


--==================================================== TABLE PRODUCTS ====================================================
SELECT*
FROM gold.dim_products;


-- How many products does the store offer?
SELECT COUNT(DISTINCT product_number) AS total_product_offer
FROM gold.dim_products;


-- What are the categories, subcategories and products?
SELECT DISTINCT category, subcategory,product_name
FROM gold.dim_products
ORDER BY category, subcategory,product_name;


-- N° of products per category
SELECT
	category,
	COUNT (DISTINCT product_name) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;


-- N° of products per subcategory
SELECT
	category,
	subcategory,
	COUNT (DISTINCT product_name) AS total_products
FROM gold.dim_products
GROUP BY category,subcategory
ORDER BY category, subcategory, total_products DESC;


--Average cost per category
SELECT
	category,
	AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC;


-----Exploring dates-----
SELECT
	MIN(order_date) AS first_order_date, 
	MAX(order_date) AS last_order_date, 
	DATEDIFF(month,MIN(order_date),MAX(order_date)) AS order_range_months,
	DATEDIFF(year,MIN(order_date),MAX(order_date)) AS order_range_years
FROM gold.fact_sales;
-- Comment: our data set contains data from 37 months or 4 years


-- Exploring birthdate dates
SELECT
	MIN(birthdate) AS oldest_birthday,
	MAX(birthdate) AS youngest_birthday,
	DATEDIFF(year,MIN(birthdate),GETDATE()) AS oldest_age,
	DATEDIFF(year,MAX(birthdate),GETDATE()) AS youngest_age
FROM gold.dim_customers;


--==================================================== TABLE FACT SALES ====================================================
SELECT *
FROM gold.fact_sales;

-- Sales per country
SELECT
	c.country,
	SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sales DESC;


-- Sales, Cost and Profit per Category
SELECT 
    p.category,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity * p.cost) AS total_cost,
    SUM(f.sales_amount - (f.quantity * p.cost)) AS total_profit
FROM gold.dim_products AS p
INNER JOIN gold.fact_sales AS f
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_profit DESC;

-- Total Sales, Cost and Profit
SELECT 
	SUM(f.sales_amount) AS total_sales,
	SUM(f.quantity*p.cost) AS total_costs,
    SUM(f.sales_amount - (f.quantity * p.cost)) AS total_profit
FROM gold.dim_products AS p
INNER JOIN gold.fact_sales AS f
ON p.product_key = f.product_key;


--Detail table showing profit per order and products
SELECT
	f.order_number,
	p.product_key,
	p.product_name,
	f.sales_amount AS revenue,
	f.quantity*p.cost AS costs,
	(f.sales_amount-(f.quantity*p.cost)) AS profit
FROM gold.dim_products AS p
LEFT JOIN gold.fact_sales AS f
ON p.product_key = f.product_key
ORDER BY order_number DESC;	


-- Total items sold
SELECT SUM(quantity) AS total_quantity
FROM gold.fact_sales;


-- Distribution of quantity sold per country
SELECT
	c.country,
	SUM(f.quantity) AS total_quantity,
	ROUND(SUM(f.quantity) * 100.00/ SUM(SUM(f.quantity)) OVER(),2) AS percentage_contribution
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_quantity DESC;


-- Total N° of Orders
SELECT COUNT (DISTINCT order_number) AS total_number_orders
FROM gold.fact_sales;


-- Average N° of items sold per order
SELECT 
	SUM(quantity)/ COUNT (DISTINCT order_number)AS average_items_per_order
FROM gold.fact_sales;


-- Average ticket price (Average Order Value)
SELECT 
	SUM(sales_amount)/ COUNT (DISTINCT order_number)AS average_price_per_order
FROM gold.fact_sales;


-- Average item price
SELECT AVG(price) as average_item_price
FROM gold.fact_sales;

-- Total N° of customer that have placed an order
SELECT COUNT (DISTINCT customer_key) AS total_customers_w_orders
FROM gold.fact_sales;
-- vs
SELECT COUNT (DISTINCT customer_key) AS total_customers_w_orders
FROM gold.dim_customers;
-- Comment: All customers that are registered in the dim_customer have actually placed and order.


--==================================================== REPORT WITH METRICS ====================================================
SELECT 
	'Total sales' AS measure_name,
	SUM(sales_amount) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 
	'Total cost' AS measure_name,
	SUM(f.quantity*p.cost) AS costs
FROM gold.dim_products AS p
LEFT JOIN gold.fact_sales AS f
ON p.product_key = f.product_key
UNION ALL
SELECT 
	'Total profit' AS measure_name,
	SUM(f.sales_amount - (f.quantity * p.cost)) AS total_profit
FROM gold.dim_products AS p
INNER JOIN gold.fact_sales AS f
ON p.product_key = f.product_key
UNION ALL
SELECT 
	'Total quantity sold' AS measure_name,
	SUM(quantity) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 
	'Total N° of customers' AS measure_name,
	COUNT (DISTINCT customer_number) AS measure_value 
FROM gold.dim_customers
UNION ALL
SELECT
	'Total N° of orders' AS measure_name,
	COUNT (DISTINCT order_number) AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 
	'Total N° of products offered' AS measure_name,
	COUNT(DISTINCT product_number) AS measure_value
FROM gold.dim_products
UNION ALL
SELECT 
	'Average N° of items sold per order' AS measure_name,
	SUM(quantity)/ COUNT (DISTINCT order_number)AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 
	'Average order value' AS measure_name,
	SUM(sales_amount)/ COUNT (DISTINCT order_number)AS measure_value
FROM gold.fact_sales
UNION ALL
SELECT 
	'Average item price' AS measure_name,
	AVG(price) AS measure_value 
FROM gold.fact_sales;


--==================================================== RANKINGS ====================================================
--Top 10 customers (sales OR orders)
SELECT TOP 10
	c.customer_id,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue,
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales  AS f
LEFT JOIN  gold.dim_customers AS c
ON c.customer_key = f.customer_key
GROUP BY c.customer_id,	c.first_name,c.last_name
--ORDER BY total_revenue DESC;
ORDER BY total_orders DESC;


-- Top 5 products (sales)
SELECT TOP 5
	p.product_key,
	p.category,
	p.subcategory,
	p.product_name,
	SUM(f.sales_amount) AS total_sales,
	SUM(f.sales_amount - (f.quantity * p.cost)) AS total_profit
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.product_key,	p.category, p.subcategory, p.product_name
ORDER BY total_profit DESC;


-- Top 5 subcategories (sales)
SELECT *
FROM (
	SELECT 
		p.category,
		p.subcategory,
		SUM(f.sales_amount) AS total_sales,
		SUM(f.sales_amount - (f.quantity * p.cost)) AS total_profit,
		ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount - (f.quantity * p.cost)) DESC) AS rank_products
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON p.product_key = f.product_key
	GROUP BY p.category, p.subcategory) AS subquery
WHERE rank_products <= 5;


-- Worst 5 products (sales)
SELECT TOP 5
	p.product_key,
	p.category,
	p.subcategory,
	p.product_name,
	SUM(f.sales_amount) AS total_sales,
	SUM(f.sales_amount - (f.quantity * p.cost)) AS total_profit
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.product_key,	p.category, p.subcategory, p.product_name
ORDER BY total_profit ASC;


-- Worst 5 subcategories (sales)
SELECT TOP 5
	p.category,
	p.subcategory,
	SUM(f.sales_amount) AS total_sales,
	SUM(f.sales_amount - (f.quantity * p.cost)) AS total_profit
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
GROUP BY p.category, p.subcategory
ORDER BY total_profit ASC;