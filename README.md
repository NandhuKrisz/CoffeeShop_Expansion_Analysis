# Coffee_Shop_Expansion_Analysis

![Coffee Shop Expansion](https://github.com/NandhuKrisz/CoffeeShop_Expansion_Analysis/blob/main/Monday%20Coffee%20Cover.png)

### Objective

The goal of this project is to analyze the sales data of Monday Coffee, a company that has been selling its products online since January 2023, and to recommend the top three major cities in India for opening new coffee shop locations based on consumer demand and sales performance.

### Key Questions
#### 1. How many people in each city are estimated to consume coffee, given that 25% of the population does?

```sql
SELECT 
    city_name,
    FORMAT((population * 0.25) / 1000000, '0.0 M') AS coffee_consumers
FROM city
ORDER BY 2 DESC;
```
#### Output
![image](https://github.com/user-attachments/assets/9e711638-c6d5-4a66-96cd-2fe8acac957b)

#### 2. What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

```sql
SELECT FORMAT(SUM(total),'#,0') AS last_qtr_23_sales
FROM sales
WHERE DATEPART(quarter,sale_date) = 4
AND YEAR(sale_date) = 2023
```

#### Output
![image](https://github.com/user-attachments/assets/9bdeb4b0-ab99-4470-9a2a-aafd7b483557)

#### 3. How many units of each coffee product have been sold?

```sql
SELECT p.product_name, COUNT(s.sale_id) AS units_sold
FROM sales s
LEFT JOIN products p
ON s.product_id= p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC
```
#### Output
![image](https://github.com/user-attachments/assets/4a933cda-86b7-430f-ad87-75fc1635f17d)


#### 4. What is the average sales amount per customer in each city?

```sql
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
```
#### Output
![image](https://github.com/user-attachments/assets/f76bbc96-c998-4058-9a36-afa8df814bbb)



#### 5. Provide a list of cities along with their populations and estimated coffee consumers.

```sql
SELECT 
	city_name,
	FORMAT((population) / 1000000, '0.0 M') AS total_population,
	FORMAT((population * 0.25) / 1000000, '0.0 M') AS coffee_consumers
FROM city
ORDER BY 2 DESC
```
#### Output
![image](https://github.com/user-attachments/assets/14363181-a829-4513-bd37-e6865eda4b34)


#### 6. What are the top 3 selling products in each city based on sales volume?

```sql
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
```
#### Output
![image](https://github.com/user-attachments/assets/1f5a879f-ddf5-4c43-bcfb-998d365a819a)


#### 7. How many unique customers are there in each city who have purchased coffee products?

```sql
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
```
#### Output
![image](https://github.com/user-attachments/assets/aadd20d2-b839-4b81-94f1-52d32732b5d5)


#### 8. Find each city and their average sale per customer and avg rent per customer

```sql
SELECT t.city_name, t.estimated_rent,
	SUM(total)/COUNT(DISTINCT s.customer_id) AS avg_sales_per_cus,
	t.estimated_rent / COUNT(DISTINCT s.customer_id) AS avg_rent_per_cus
FROM sales s
LEFT JOIN customers c
ON s. customer_id = c.customer_id
LEFT JOIN city t
ON t.city_id= c.city_id
GROUP BY t.city_name, t.estimated_rent
ORDER BY t.city_name 
```
#### Output
![image](https://github.com/user-attachments/assets/dc73295f-5a01-405e-a914-dfe788a2a0e2)


#### 9. Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).

```sql
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
SELECT *, FORMAT((CAST((total_sales - prev_sales) AS NUMERIC(10,2))/ CAST(prev_sales AS NUMERIC (10,2))),'0.00,%') AS growth_percent
FROM prev_sales
WHERE prev_sales IS NOT NULL
```
#### Output
![image](https://github.com/user-attachments/assets/ccd29483-584b-44b9-bc45-9ca7040c2928)



#### 10. Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer

```sql
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
```
#### Output
![Uploading image.png…]()


### Insights
#### Top Coffee Consumer Cities:

**Delhi**: 7.8 million coffee consumers
**Mumbai**: 5.1 million coffee consumers
**Kolkata**: 3.7 million coffee consumers
These three cities collectively represent a significant portion of the coffee market, indicating a **strong demand** for coffee-related products and services.

**Pune's Performance:**
Pune stands out with the highest average sales per customer at **24,197**.
Total sales in Pune amount to **1,258,290** indicating a healthy market presence.

### Recommendations
**Target Marketing in Major Cities:**

**Delhi, Mumbai, and Kolkata** are prime locations for targeted marketing campaigns. Consider launching promotions, coffee events, or loyalty programs to engage consumers in these cities and boost sales.

**Focus on Pune's Customer Engagement:**
Given Pune's high average sales per customer, analyze what factors contribute to this figure (e.g., product offerings, customer service, promotions). Consider enhancing the customer experience further through personalized services, exclusive offers, or unique product bundles.



