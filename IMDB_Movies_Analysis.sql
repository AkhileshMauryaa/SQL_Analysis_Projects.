
-- Q1. Find the total number of rows in each table of the schema?

-- Number of rows = 3867
select count(*) from director_mapping;

-- Number of rows = 14662
select count(*) from genre;

-- Number of rows = 7997
select count(*) from movie;

-- Number of rows = 25135
select count(*) from names;

-- Number of rows = 7997
select count(*) from ratings;

-- Number of rows = 15615
select count(*) from role_mapping;

-- Q2. Which columns in the movie table have null values?

select count(*) from movie where id is null;
select count(*) from movie where title is null;
select count(*) from movie where date_published is null;
select count(*) from movie where duration is null;
select count(*) from movie where country is null;
select count(*) from movie where worlwide_gross_income is null;
select count(*) from movie where languages is null;
select count(*) from movie where production_company is null;

-- Country, worlwide_gross_income, languages and production_company columns have NULL values

-- second rule find the null values 

select sum(case
when id is null then 1
else 0
end) as id_null_count,
sum(case
when title is null then 1
else 0
end) as title_null_count,
sum(case 
when year is null then 1
else 0
end) as year_null_count,
sum(case
when date_published is null then 1
else 0
end) as date_published_null_count,
sum(case
when duration is null then 1
else 0
end) as duration_null_count,
sum(case
when country is null then 1
else 0
end) as country_null_count,
sum(case 
when worlwide_gross_income is null then 1
else 0
end) as worlwide_gross_income_null_count,
sum(case
when languages is null then 1
else 0
end) as languages_null_count,
sum(case
when production_company is null then 1
else 0
end) as production_company_null_count
from movie;

-- Q3. Find the total number of movies released each year? How does the trend look month wise?

-- number of movies released each year
select year, count(title) as number_of_movies 
from movie
group by year;

-- Number of movies released each month 
select month(date_published) as month_num,count(*) as number_of_movies
from movie
group by month_num
order by month_num;

-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(*) as number_of_movies,year from movie
where (country like "%USA%" or country like "%India%") and year = 2019;

-- Q5. Find the unique list of the genres present in the data set?

select distinct genre from genre;
-- Movies belong to 13 genres in the dataset.

-- Q6.Which genre had the highest number of movies produced overall?
select genre,count(m.id) as number_of_movies
from movie as m 
inner join genre as g 
on m.id = g.movie_id
group by genre
order by number_of_movies desc 
limit 1;

-- 4285 Drama movies were produced in total and are the highest among all genres. 

-- Q7. How many movies belong to only one genre?
WITH movies_with_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_with_one_genre
FROM   movies_with_one_genre;
 
 -- 3289 movies belong to only one genre
 
 -- Q8.What is the average duration of movies in each genre? 
 select genre,avg(duration) as avg_duartion 
from movie m 
join genre g 
on m.id = g.movie_id 
group by genre
order by avg_duartion desc;

-- Action genre has the highest duration of 112.88 seconds followed by romance and crime genres.

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 

with genre_summary as
(
SELECT genre,count(movie_id) as movie_count,
rank() over(order by count(movie_id) desc) as genre_rank
from genre
group by genre)

select * from genre_summary where genre ="thriller";

-- Thriller has rank=3 and movie count of 1484

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?

select
 min(avg_rating) as min_avg_rating,
 max(avg_rating) as max_avg_rating,
 Min(total_votes)   as min_total_votes,
 Max(total_votes)   as max_total_votes,
 Min(median_rating) as min_median_rating,
 Max(median_rating) as min_median_rating
 from ratings;
 
 -- Q11. Which are the top 10 movies based on average rating?
 
 select title,avg_rating,
 rank() over(order by avg_rating desc) as movie_rank
 from ratings r 
 join movie m 
 on r.movie_id = m.id
 limit 10;
 
 -- Top 3 movies have average rating >= 9.8
 
 -- Q12. Summarise the ratings table based on the movie counts by median ratings.
 
 select median_rating, count(movie_id) as movie_count
 from ratings
 group by median_rating
 order by movie_count desc;
 
 -- Movies with a median rating of 7 is highest in number.
 
 
 -- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
 
WITH production_company_hit_movie_summary
as (select production_company,Count(movie_id) as MOVIE_COUNT,
rank() over(ORDER BY Count(movie_id) desc ) as PROD_COMPANY_RANK
from   ratings as R
join movie as M
on M.id = R.movie_id
where  avg_rating > 8
and production_company is not null
group by production_company)
select *
from   production_company_hit_movie_summary
where  prod_company_rank = 1; 

-- Dream Warrior Pictures and National Theatre Live production houses has produced the most number of hit movies (average rating > 8)


 
 -- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
 
 select genre,count(m.id) as movie_count 
 from movie m 
 join genre g 
 on m.id = g.movie_id
 join ratings r 
 on g.movie_id = r.movie_id
 where year = 2017
 and month(date_published) = 3
 and country like "%USA%"
 and total_votes > 1000
 group by genre
 order by movie_count desc;
 
 -- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
 
 -- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
 
 select title, avg_rating, genre
 from movie m 
 join ratings r 
 on m.id = r.movie_id
 join genre g
 on r.movie_id = g.movie_id
 where avg_rating > 8 and title like "The%"
 order by avg_rating desc;
 
 -- The Brighton Miracle has highest average rating of 9.5.
 
 -- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
 
 select median_rating, count(*) as movie_count
 from movie m 
 join ratings r 
 on m.id =  r.movie_id
 where median_rating = 8
 and date_published between '2018-04-01' and '2019-4-01'
 group by median_rating;
 
 -- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8
 
 -- Q17. Do German movies get more votes than Italian movies? 
 select sum(total_votes), country
from movie m
join ratings r 
on r.movie_id = m.id
where country in( 'Germany', 'Italy')
GROUP BY country;

-- Answer is YES if German votes > Italian votes
-- Answer is NO if German votes <= Italian votes

