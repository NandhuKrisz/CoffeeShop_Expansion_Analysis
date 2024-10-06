--Coffee Consumers Count
--1. How many people in each city are estimated to consume coffee, given that 25% of the population does?

SELECT 
	city_name,
	FORMAT((population * 0.25) / 1000000, '0.0 M') AS coffe_consumers
FROM city
ORDER BY 2 DESC



--Total Revenue from Coffee Sales
--2. What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?


SELECT SUM(total) AS total_revenue
FROM sales
WHERE DATEPART(quarter,sale_date) = 4
AND YEAR(sale_date) = 2023


--Sales Count for Each Product
--3. How many units of each coffee product have been sold?

SELECT p.product_name, COUNT(s.sale_id) AS units_sold
FROM sales s
LEFT JOIN products p
ON s.product_id= p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC



--Average Sales Amount per City
--4. What is the average sales amount per customer in each city?

SELECT t.city_name, 
	COUNT(DISTINCT s.customer_id) AS total_customer,
	SUM(total) AS total_sales, 
	SUM(total)/COUNT(DISTINCT s.customer_id) AS avg_sales_per_cus
FROM sales s
LEFT JOIN customers c
ON s. customer_id = c.customer_id
LEFT JOIN city t
ON t.city_id= c.city_id
GROUP BY t.city_name
ORDER BY t.city_name 



--City Population and Coffee Consumers
--5. Provide a list of cities along with their populations and estimated coffee consumers.

SELECT 
	city_name,
	population,
	(population * 0.25) as coffee_consumers
FROM city
ORDER BY 2 DESC


--Top Selling Products by City
--6. What are the top 3 selling products in each city based on sales volume?

SELECT x.city_name,x.product_name,x.sales_vol
FROM
(
	SELECT  t.city_name,
			p.product_name,
			COUNT(s.sale_id) AS sales_vol,
			DENSE_RANK() OVER(PARTITION BY city_name ORDER BY COUNT(s.sale_id) DESC) AS rank
	FROM sales s
	JOIN customers c
	ON s.customer_id = c.customer_id
	JOIN city t
	ON t.city_id = c.city_id
	JOIN products p 
	ON p.product_id = s.product_id
	GROUP BY t.city_name,p.product_name
) x
WHERE x.rank <= 3



--Customer Segmentation by City
--7. How many unique customers are there in each city who have purchased coffee products?

SELECT c.city_name, COUNT(*) AS unique_customers,
	COUNT(DISTINCT s.customer_id) cutomers_purchased
FROM customers cu
LEFT JOIN sales s
ON s.customer_id = cu.customer_id
JOIN city c
ON cu.city_id = c.city_id
WHERE s.product_id IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14)
GROUP BY c.city_name
ORDER BY c.city_name


--Average Sale vs Rent
--8. Find each city and their average sale per customer and avg rent per customer

SELECT t.city_name, 
	SUM(total)/COUNT(DISTINCT s.customer_id) AS avg_sales_per_cus
FROM sales s
LEFT JOIN customers c
ON s. customer_id = c.customer_id
LEFT JOIN city t
ON t.city_id= c.city_id
GROUP BY t.city_name
ORDER BY t.city_name 

--Monthly Sales Growth
--9. Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).

WITH month_sales 
AS
(
	SELECT
	YEAR(sale_date) AS year,
	MONTH(sale_date) AS month,
	SUM(total) AS total_sales
	FROM sales
	GROUP BY YEAR(sale_date),MONTH(sale_date)
),
prev_sales AS
(
SELECT *,LAG(total_sales) OVER (ORDER BY year, month, total_sales DESC) AS prev_sales
FROM month_sales
)
SELECT *, ROUND((CAST((total_sales - prev_sales) AS NUMERIC(10,2))/ CAST(prev_sales AS NUMERIC (10,2))) * 100,2) AS growth_percent
FROM prev_sales
WHERE prev_sales IS NOT NULL


--Market Potential Analysis
--10. Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer

SELECT 
			t.city_name, 
			t.estimated_rent AS total_rent,
			SUM(s.total) AS total_sales, 
			COUNT(DISTINCT s.customer_id) AS total_customers,
			FORMAT((t.population * 0.25) / 1000000, '0.0 M') AS population,
			SUM(total)/COUNT(DISTINCT s.customer_id) AS avg_sales_per_cus,
			t.estimated_rent/COUNT(DISTINCT s.customer_id) AS avg_rent_per_cus
FROM sales s
LEFT JOIN customers c
ON s.customer_id = c.customer_id
JOIN city t
ON t.city_id = c.city_id
GROUP BY t.city_name,t.estimated_rent,t.population
ORDER BY total_sales DESC

SELECT *
FROM city
