-- Creating Database
CREATE DATABASE IF NOT EXISTS Walmart_Sales_Data;

-- Creating Table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

SELECT * FROM SALES;

-- Data Wrangling

-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales 
ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales 
ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales 
ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- EDA(Exploratory Data Analysis)

-- ---------------------------- Generic ------------------------------ --

-- 1. How many unique cities does the data have?
SELECT DISTINCT city 
FROM sales;

-- 2. In which city is each branch?
SELECT DISTINCT city, branch 
FROM sales;

-- ---------------------------- Product ------------------------------ --

-- 3. How many unique product lines does the data have?
SELECT DISTINCT product_line 
FROM sales;

-- 4. How is the most common payment method?
SELECT payment, count(payment) AS Total
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 5. What is the most selling product line?
SELECT product_line, SUM(quantity) AS Total
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 6. What is the total revenue by month?
SELECT month_name, ROUND(SUM(total),2) AS Total
FROM sales
GROUP BY 1 
ORDER BY 2 DESC;

-- 7. What month had the largest COGS?
SELECT month_name, SUM(cogs) AS Total
FROM sales
GROUP BY 1 
ORDER BY 2 DESC;

-- 8. What product line had the largest revenue?
SELECT product_line, ROUND(SUM(total),2) AS Total
FROM sales
GROUP BY 1 
ORDER BY 2 DESC;

-- 9. What is the city and branch with the largest revenue?
SELECT city, Branch, ROUND(SUM(total),2) AS Total
FROM sales
GROUP BY 1,2
ORDER BY 3 DESC;

-- 10. What product line had the largest TAX?
SELECT product_line, ROUND(AVG(tax_pct),2) AS Average_TAX
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 11. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales.
SELECT AVG(quantity) AS avg_qnty
FROM sales;

SELECT product_line,
CASE
		WHEN AVG(quantity) > 5.5 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- 12. Find the total quantity sold for each branch where the quantity is greater than the average quantity sold?
Select branch, Sum(quantity) AS Total
FROM sales
WHERE quantity > (Select AVG(quantity) FROM sales)
GROUP BY branch;

-- 13. What is the most common product line by gender?
SELECT gender, product_line, 
	COUNT(gender) AS total
FROM sales
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

-- 14. What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating), 2) as avg_rating
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- ---------------------------- Customers ------------------------------ --

-- 15. How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

-- 16. What is the most common customer type?
SELECT customer_type, COUNT(*) as count
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 17. Which customer type buys the most?
SELECT customer_type, COUNT(*) as Count
FROM sales
GROUP BY customer_type;

-- 18. What is the gender of most of the customers?
SELECT gender, COUNT(*) as Count
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 19. What is the gender distribution per branch?
SELECT branch, gender, COUNT(*) as Count
FROM sales
GROUP BY 1,2
ORDER BY 1,3 DESC;

-- 20. Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, COUNT(rating) as Total
FROM sales
GROUP BY 1,2
ORDER BY 1,3 DESC;

-- 21. Find the count of ratings for each day?
SELECT day_name, COUNT(rating) as Count
FROM sales 
GROUP BY 1 
ORDER BY 2 DESC;

-- ---------------------------- Sales ------------------------------ --

-- 22. Find the number of sales made in each time of the day as per weekday?
SELECT time_of_day, day_name, COUNT(*) AS Total
FROM sales
GROUP BY 1,2
ORDER BY 1,3 DESC;

-- 23. Which of the customer types brings the most revenue?
SELECT customer_type, ROUND(SUM(total),2) AS Revenue
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 24. Which city has the largest tax percent?
SELECT city, ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 25. Which customer type pays the most in VAT?
SELECT customer_type, AVG(tax_pct) AS total_tax
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- --------------------------------------------------------------------------- --

