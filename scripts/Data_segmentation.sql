/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

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

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

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
