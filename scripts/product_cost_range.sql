/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/
WITH product_segments AS(
SELECT
  product_key,
  product_name,
  cost,
CASE WHEN cost < 100 THEN 'below 100'
	WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	WHEN cost BETWEEN 500 and 1000 THEN '500-1000'
	ELSE 'Above 1000'
END cost_range
FROM gold.dim_products)

SELECT
  cost_range,
  COUNT(product_key) AS total_products
  FROM product_segments
  GROUP BY cost_range
  ORDER BY total_products DESC

/*Group customers into three segments based on the spending behavior:
-vip, regular, and new
total number of customers by each group  */
WITH customer_spending AS (
SELECT
  c.customer_key,
  SUM(f.sales_amount) AS total_spending,
  MIN(Order_date) AS first_order,
  MAX(Order_date) AS last_order,
  DATEDIFF (month, MIN(order_date), MAX(order_date)) AS lifespan

FROM gold_fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT
  customer_segment,
  COUNT(customer_key) AS total_customers
FROM (
SELECT
customer_key,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'regular'
	ELSE 'New'
END customer_segment
FROM customer_spending
)t
GROUP BY customer_segment
ORDER BY total_customers DESC
