--Database & Table Creation

Create table zepto(
	sku_id SERIAL PRIMARY KEY,
	category varchar(120),
	name varchar(150) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(5,2),
	availableQuantity INTEGER,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outofStock BOOLEAN,
	quantity INTEGER
);

--data exploration

--count of rows
Select count(*) from zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--NULL Values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedSellingPrice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
order by category;

--products in stock vs out of stock
SELECT outofstock, count(sku_id)
from zepto
group by outofstock;

--product names present multiple times
SELECT name, count(sku_id)
from zepto
Group by name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--Data cleaning

--products with price = 0
SELECT * From zepto
where mrp = 0 OR discountedSellingPrice = 0;

DELETE From zepto
where mrp = 0 OR discountedSellingPrice = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.00,
discountedSellingPrice = discountedSellingPrice/ 100.00;

SELECT mrp, discountedSellingPrice from zepto;

--data analysis

--Q1.Find the top 10 best-value products based on the discount percentage
SELECT DISTINCT name, mrp, discountPercent
from zepto
order by discountPercent desc
limit 10;

--Q2.What are the Products with High MRP but Out of Stock
Select DISTINCT name, mrp
from zepto
where outofstock = TRUE and mrp > 300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
Select category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
from zepto
group by category
order by total_revenue;

--Q4.Find all the products where MRP is greater than 500 Rupee and discount is less than 10%
Select DISTINCT name, mrp, discountPercent
from zepto
where mrp > 500 and discountPercent <10
order by mrp desc, discountpercent desc;

--Q5.Identify the top 5 categories offering the highest average discount percentage
Select category, ROUND(avg(discountPercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5; 

--Q6.Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms>100
order by price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk
Select DISTINCT name, weightInGms,
CASE When weightInGms < 1000 then 'LOW'
	 When weightInGms < 5000 then 'Medium'
	 ELSE 'Bulk'
	 End as weight_category
From zepto;

--Q8.What is the Total Inventory Weight Per Category
Select category,
sum(weightInGms * availableQuantity) AS total_weight
from zepto
group by category
order by total_weight;