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
'''
### Output
![image](https://github.com/user-attachments/assets/032c082d-be92-4a2e-a1b9-7a6541b65b1d)


