use swiggy_data;
-- Q1. HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5? 

select restaurant_name,count(distinct restaurant_name) from swiggy
where rating > 4.5
group by restaurant_name;

-- answer.2 restauratns name HAVE A RATING GREATER THAN 4.5.

-- Q2. WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?

select city, count(distinct restaurant_name) as restaurant
from swiggy 
group by city 
order by restaurant desc 
limit 1;

-- answer. Bangalore - 39

-- Q3. HOW MANY RESTAURANTS HAVE THE WORD "PIZZA" IN THEIR NAME?
select count(restaurant_name) from swiggy
where restaurant_name like "%Pizza%";

-- answer - 0 

-- Q4.  WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?
select cuisine,count(*) as count_cuisine
from swiggy
group by cuisine
order by count_cuisine desc
limit 1;

-- answer.North Indian,Chinese

-- Q5. WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?

select city, avg(rating) as average_rating
from swiggy group by city;

 -- answer. 'Bangalore' rating 4.1

-- Q6.  WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?

select restaurant_name,menu_category,max(price) as highest_price 
from swiggy
where menu_category = "recommended"
group by restaurant_name,menu_category
order by highest_price desc;

-- answer. 'Mani''s Dum Biryani' - highest_price 2599.

-- Q7.FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE.

select distinct restaurant_name,cost_per_person
from swiggy where cuisine<>'Indian'
order by cost_per_person desc
limit 5;

-- answer. top 5 restaurant name 'Anupam''s Coast II Coast','Parika','24th Main','Noodle Bar' and 'Via Milano'

-- Q8. FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER.
 
 select distinct restaurant_name,cost_per_person
from swiggy where cost_per_person>(select avg(cost_per_person) from swiggy);

-- answer.cost_per_person - 600

-- Q9. RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.

select distinct t1.restaurant_name,t1.city,t2.city
from swiggy t1 join swiggy t2 
on t1.restaurant_name=t2.restaurant_name and
t1.city<>t2.city;

-- answer. alot of restaurant_name are located many city

-- Q10.WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?

select distinct restaurant_name,menu_category
,count(item) as no_of_items from swiggy
where menu_category='Main Course' 
group by restaurant_name,menu_category
order by no_of_items desc limit 1;

-- answer. 'Spice Up'RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY.

-- Q11. LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.
SELECT restaurant_name
FROM swiggy
WHERE veg_or_non_veg = 'Veg'
GROUP BY restaurant_name
ORDER BY restaurant_name ASC;

-- answer. a lot of RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME.

-- Q12.WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?

select distinct restaurant_name,
avg(price) as average_price
from swiggy group by restaurant_name
order by average_price limit 1;

-- answer. 'Urban Kitli'RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS.

-- Q13. WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?

select distinct restaurant_name,
count(distinct menu_category) as no_of_categories
from swiggy
group by restaurant_name
order by no_of_categories desc limit 5;

-- answer.'Imperial Restaurant','Asha Sweet Center','Udupi Palace','Hotel Empire' and 'Bangaliana'.

-- Q14. WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?

select distinct restaurant_name,
(count(case when veg_or_non_veg='Non-veg' then 1 end)*100
/count(*)) as nonvegetarian_percentage
from swiggy
group by restaurant_name
order by nonvegetarian_percentage desc limit 1;

-- answer.'Donne Biryani House' RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD.
