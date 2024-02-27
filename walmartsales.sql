SET SQL_SAFE_UPDATES = 0;

-- Q1
-- Add a new column named time_of_day to give insight 
-- of sales in the Morning, Afternoon and Evening. This will help 
-- answer the question on which part of the day most sales are made.
ALTER TABLE walmart.walmartsales ADD timeday VARCHAR(20); 

SELECT 	CASE WHEN left(`Time`,2) BETWEEN 06 AND 11 THEN 'Morning'
			 WHEN left(`Time`,2) BETWEEN 12 AND 17 THEN 'Afternoon'
             ELSE 'Evening' END AS timeday,`Time`
FROM walmart.walmartsales;

UPDATE walmart.walmartsales
SET timeday=(
CASE WHEN left(`Time`,2) BETWEEN 06 AND 11 THEN 'Morning'
			 WHEN left(`Time`,2) BETWEEN 12 AND 17 THEN 'Afternoon'
             ELSE 'Evening' END);
             

-- Q2
-- Add a new column named day_name that contains the extracted days of the week on which the given 
-- transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day 
-- each branch is busiest.

SELECT left(dayname(Date),3) as day_name from walmart.walmartsales;

-- new column added in the database
ALTER TABLE walmart.walmartsales ADD day_name VARCHAR(5); 

UPDATE walmart.walmartsales
SET day_name=(left(dayname(Date),3));

-- Q3
-- Add a new column named month_name that contains the extracted months of the year on which 
-- the given transaction took place (Jan, Feb, Mar). Help determine which month 
-- of the year has the most sales and profit.

SELECT left(monthname(Date),3) as month_name from walmart.walmartsales;
-- new column added in the database
ALTER TABLE walmart.walmartsales ADD month_name VARCHAR(5); 

UPDATE walmart.walmartsales
SET month_name=(left(monthname(Date),3));



-- ---------------------------- EDA --------------------------------------

-- Generic Question
-- How many unique cities does the data have?
SELECT count(distinct City) FROM walmart.walmartsales;

-- In which city is each branch?
SELECT distinct City,Branch from walmart.walmartsales;



-- Product -----

-- How many unique product lines does the data have?
SELECT count(distinct `Product line`) FROM walmart.walmartsales;


-- What is the most common payment method?
SELECT count(`Invoice ID`) as numberofpaymentsdone,
Payment FROM walmart.walmartsales
GROUP BY Payment
ORDER BY count(`Invoice ID`) DESC;


-- What is the most selling product line?
SELECT count(`Invoice ID`),`Product line` FROM walmart.walmartsales 
GROUP BY `Product line`
ORDER BY count(`Invoice ID`) DESC ;

-- What is the total revenue by month?
SELECT month_name,ROUND(SUM(total),2) FROM walmart.walmartsales GROUP BY month_name;

-- What month had the largest COGS?
SELECT month_name,SUM(cogs) FROM walmart.walmartsales GROUP BY month_name ORDER BY SUM(cogs) DESC LIMIT 1;

-- What product line had the largest revenue?
SELECT `Product Line`,ROUND(SUM(total),2) as TotalRevenue FROM walmart.walmartsales GROUP BY `Product Line` ORDER BY SUM(total) DESC LIMIT 1;


-- What is the city with the largest revenue?
SELECT `City`,ROUND(SUM(total),2) as TotalRevenue FROM walmart.walmartsales GROUP BY `City` ORDER BY SUM(total) DESC LIMIT 1;


-- What product line had the largest VAT?
SELECT `Product Line`,max(`Tax 5%`) as LargestVAT FROM walmart.walmartsales GROUP BY `Product Line` ORDER BY max(`Tax 5%`) DESC LIMIT 1;


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


-- Which branch sold more products than average product sold?
SELECT branch FROM walmart.walmartsales GROUP BY branch HAVING AVG(Quantity)>(SELECT Round(avg(Quantity),2) FROM walmart.walmartsales) ORDER BY AVG(Quantity) DESC;


-- What is the most common product line by gender?

SELECT gender,`Product line`,COUNT(`Invoice ID`)
FROM walmart.walmartsales
GROUP BY gender,`Product line`
ORDER BY COUNT(`Invoice ID`) DESC;

-- What is the average rating of each product line?
SELECT`Product line`,ROUND(AVG(rating),2)
FROM walmart.walmartsales
GROUP BY `Product line`
ORDER BY AVG(rating) DESC;

-- Number of sales made in each time of the day per weekday

SELECT timeday,day_name,sum(Quantity)
FROM walmart.walmartsales
GROUP BY day_name,timeday
ORDER BY sum(Quantity);

-- Which of the customer types brings the most revenue?
SELECT distinct `Customer type`,ROUND(SUM(total),0) AS MaxRevenue
FROM walmart.walmartsales
group by `Customer type`
order by ROUND(SUM(total),0) DESC LIMIT 1;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?

ALTER TABLE walmart.walmartsales ADD VAT varchar(20);

UPDATE walmart.walmartsales
SET VAT=(ROUND(0.05*(`Unit price`*Quantity),2));


SELECT City,max(VAT) as MaxVat 
FROM walmart.walmartsales
GROUP BY City
ORDER BY max(VAT) DESC
LIMIT 1;

-- How many unique customer types does the data have?

SELECT distinct `Customer type` FROM walmart.walmartsales;
 
-- How many unique payment methods does the data have?
SELECT distinct `Payment` FROM walmart.walmartsales;
 
 
 -- What is the most common customer type?
SELECT distinct `Customer type`,COUNT(*)
FROM walmart.walmartsales
GROUP BY `Customer type`;

-- Which customer type buys the most?
SELECT distinct `Customer type`,ROUND(SUM(Total),2) as TotalSpending
FROM walmart.walmartsales
GROUP BY `Customer type`;


-- What is the gender of most of the customers?
SELECT Gender,count(Gender) 
FROM walmart.walmartsales
group by Gender;

-- What is the gender distribution per branch?
SELECT Branch,Gender,count(*)
FROM walmart.walmartsales
group by Branch,Gender
ORDER BY Branch ASC;


-- Which time of the day do customers give most ratings?
SELECT timeday,COUNT(Rating)
FROM walmart.walmartsales
GROUP BY timeday
ORDER BY COUNT(Rating) DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT timeday,Branch,COUNT(Rating)
FROM walmart.walmartsales
GROUP BY timeday,Branch
ORDER BY timeday DESC;

-- Which day fo the week has the best avg ratings?
SELECT day_name,AVG(Rating)
FROM walmart.walmartsales
GROUP BY day_name
ORDER BY AVG(Rating) DESC limit 1;

-- Which day of the week has the best average ratings per branch?
SELECT day_name,Branch,AVG(Rating)
FROM walmart.walmartsales
GROUP BY day_name,Branch
ORDER BY AVG(Rating) DESC limit 1;
