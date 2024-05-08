use salesdatawalmart; 

-- data cleaning ----------------------------
-- -----------------------------------------

-- Add the time_of_day column
select time from walmart;

select 
	  time,
      (case 
          when time between '00:00:00' and '12:00:00' then "Morning"
          when time between '12:01:00' and '16:00:00' then "Afternoon"
          else 'Evening'
	   end
      ) as time_of_date
from walmart;

alter table walmart add column time_of_day varchar(20);

update walmart
set time_of_day =(
		   case 
			   when time between '00:00:00' and '12:00:00' then "Morning"
			   when time between '12:01:00' and '16:00:00' then "Afternoon"
               else 'Evening'
		  end);

-- add day_name column

select date,dayname(date) from walmart;

alter table walmart add column day_name varchar(20);

update walmart
set day_name = dayname(date);

-- add month_name column

SELECT
	date,
	MONTHNAME(date)
FROM walmart;

ALTER TABLE walmart ADD COLUMN month_name VARCHAR(10);

UPDATE walmart
SET month_name = MONTHNAME(date);

-- ----------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- Q1.How many unique product lines does the data have?

select count(distinct product_line) from walmart;

-- answer. 6

-- Q2.What is the most common payment method?

select Payment,count(payment) as payment_type from walmart
group by Payment
order by payment_type desc;

-- answer. Ewallet

-- Q3.What is the most selling product line?

SELECT
	SUM(quantity) as qty,
    product_line
FROM walmart
GROUP BY product_line
ORDER BY qty DESC;

-- answer.'Electronic accessories'

-- Q4.What is the total revenue by month?

SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM walmart
GROUP BY month_name 
ORDER BY total_revenue desc;

-- answer. January

-- Q5.What month had the largest COGS?

SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM walmart
GROUP BY month_name 
ORDER BY cogs desc;

-- answer. january

-- Q6.What product line had the largest revenue?

SELECT
	product_line,
	SUM(total) as total_revenue
FROM walmart
GROUP BY product_line
ORDER BY total_revenue DESC;

-- answer.'Food and beverages'

-- Q7.What is the city with the largest revenue?

SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM walmart
GROUP BY city, branch 
ORDER BY total_revenue;

-- answer. 'Mandalay', 'Yangon' and 'Naypyitaw'

-- Q8.What product line had the largest VAT?

SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM walmart
GROUP BY product_line
ORDER BY avg_tax DESC;

-- answer. 'Home and lifestyle'
-- Q9.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales. 

SELECT 
	AVG(quantity) AS avg_qnty
FROM walmart;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM walmart
GROUP BY product_line;

-- answer. 'Health and beauty'

-- Q10.Which branch sold more products than average product sold?

SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM walmart
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM walmart);

-- answer. A, C and B

-- Q11.What is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM walmart
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- answer. 'Fashion accessories'.

-- Q12.What is the average rating of each product line?

SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM walmart
GROUP BY product_line
ORDER BY avg_rating DESC;

-- answer. 'Food and beverages' ,rating-7.1

--                    Sales

-- Q1.Number of sales made in each time of the day per weekday.
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM walmart
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- answer. evening time 58, afternoon time 53, and morning time 22

-- Q2.Which of the customer types brings the most revenue?

SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM walmart
GROUP BY customer_type
ORDER BY total_revenue;

-- answer. normal and member

-- Q3.Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM walmart
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- answer. 'Naypyitaw'

-- Q4.Which customer type pays the most in VAT?

SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM walmart
GROUP BY customer_type
ORDER BY total_tax;

-- answer. normal - 15.14

--   ------------            Customer           ------------------

-- Q1.How many unique customer types does the data have?

SELECT
	DISTINCT customer_type
FROM walmart;

-- answer. member and normal

-- Q2.How many unique payment methods does the data have?

SELECT
	DISTINCT payment
FROM walmart;

-- answer . 3 mathed have payment. ewallet, cash,credit card



-- Q3.Which customer type buys the most?

SELECT
	customer_type,
    COUNT(*)
FROM walmart
GROUP BY customer_type;

-- answer. member - 501

-- Q4.What is the gender of most of the customers?

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart
GROUP BY gender
ORDER BY gender_cnt DESC;

-- answer. female and male

-- Q5.What is the gender distribution per branch?

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM walmart
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- answer. mostly female

-- Q6.Which time of the day do customers give most ratings?

SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmart
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- answer. afternoon - 7

-- Q7.Which time of the day do customers give most ratings per branch?

SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM walmart
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- answer. every branch in afternoon.
-- Q8.Which day fo the week has the best avg ratings?

SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM walmart
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- answer. monday

