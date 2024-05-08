use country;

-- Q1.Get the list of the 3 most populated cities.

select name,population from cities
order by population desc
limit 3;
-- answer. new york, buffalo and albany 

-- Q2.Get the list of the 3 cities with the smallest surface.

select * from cities
order by surface
limit 3;

-- answer. 'San Bruno','Buffalo' and 'SAN-Francisco'

-- Q3.Get the list of states whose department number starts with “97”.

SELECT * FROM states
WHERE state_code LIKE '97%';

-- answer. florida and indiana

-- Q4.Get the names of the 3 most populated cities, as well as the name of the associated state.

select c.name as city_name,s.state_name
from cities c
join states s 
on s.state_code = c.city_state
order by c.population
limit 3;

-- answer.city_name is 'New York','Buffalo' and 'Albany'. state_name name is New york.

-- Q5.Get the list of the name of each State, associated with its code and the number of cities within these States, 
-- by sorting in order to get in priority the States which have the largest number of cities.

SELECT s.state_name, s.state_code, COUNT(c.id) AS city_count
FROM states s
JOIN cities c ON s.state_code = c.city_state
GROUP BY s.state_name, s.state_code
ORDER BY city_count DESC;

-- answer. New york, California, Texas and Illinois

-- Q6.Get the list of the 3 largest States, in terms of surface area.

SELECT state_name, state_code, SUM(surface) AS total_surface
FROM states s
JOIN cities c ON s.state_code = c.city_state
GROUP BY state_name, state_code
ORDER BY total_surface DESC
LIMIT 3;

-- answer. New york, california and illinois

-- Q7.Count the number of cities whose names begin with “San”.

select count(name) city_name 
from cities
where name like 'San%';

-- answer. 3

-- Q8.Get the list of cities whose surface is greater than the average surface.

SELECT * FROM cities
WHERE surface > (SELECT AVG(surface) FROM cities);

-- answer. albany,san-diego, houston and chicago

-- Q9.Get the list of States with more than 1 million residents.

SELECT s.state_name, s.state_code
FROM states s 
JOIN cities  c ON s.state_code = c.city_state
GROUP BY s.state_name, s.state_code
HAVING SUM(c.population) > 1000000;

-- answer. new york

-- Q10.Replace the dashes with a blank space, for all cities beginning with “SAN-” (inside the column containing the upper case names).

UPDATE cities
SET name = REPLACE(name, 'SAN-', 'SAN ')
WHERE UPPER(name) LIKE 'SAN-%';

-- answer. 'SAN Francisco','SAN Diego'