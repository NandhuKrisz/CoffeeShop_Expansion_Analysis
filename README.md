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



