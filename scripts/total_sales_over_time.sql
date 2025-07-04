---Calculating the toatal sales per month
-- running the total sales over time

SELECT
  order_date,
  total_sales,
  SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales,
  AVG(avg_price) OVER(ORDER BY order_date) AS running_average_price
FROM
(
SELECT
  DATETRUNC(year, order_date) AS order_date,
  SUM(sales_amount) AS total_sales,
  AVG(price) AS avg_price
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year, order_date)
)t
