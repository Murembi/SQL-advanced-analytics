/*Analyze the sales performace over time
--help for trategic reasoning*/
SELECT
  YEAR(order_date) AS order_year,
  SUM(sales_amount) AS total_sales,
  COUNT(DISTINCT customer_key) as total_customers,
  SUM(quantity) as total_quantity
FROM gold_fact_sales
WHERE Order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

---Month
SELECT
  MONTH(order_date) AS order_year,
  SUM(sales_amount) AS total_sales,
  COUNT(DISTINCT customer_key) as total_customers,
  SUM(quantity) as total_quantity
FROM gold_fact_sales
WHERE Order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)

---Year and date
SELECT
	DATETRUNC(month, order_date) AS order_year,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM gold_fact_sales
WHERE Order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)
