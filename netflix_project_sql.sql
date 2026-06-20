-- SCHEMAS of Netflix

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(7),
	type    VARCHAR(10),
	title	VARCHAR(150),
	director VARCHAR(450),
	casts	VARCHAR(1050),
	country	VARCHAR(150),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT 
	COUNT(*) AS total_content
FROM netflix;

SELECT 
	DISTINCT type 
FROM netflix;

SELECT * FROM netflix;

--15 Business Problems & their Solutions

--1. Count the number of Movies vs TV Shows
SELECT type, COUNT(*) AS total_content
FROM netflix
GROUP BY type;

--2. Find the most common rating for movies and TV shows
select type, rating
from
(select type, rating, count(*),
rank() over(partition by type order by count(*)desc) as rank
from netflix
group by type, rating) 
where rank = 1;

--3. List all movies released in a specific year (e.g., 2020)
select * 
from netflix 
where release_year = 2020
and type = 'Movie';

--4. Find the top 5 countries with the most content on Netflix
select unnest(string_to_array(country,',')) as new_country,
count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;

5. Identify the longest movie
select * 
from netflix
where 
	type = 'Movie'
	and 
	duration = (select max(duration) from netflix);

--6. Find content added in the last 5 years
select * from netflix
where 
	to_date(date_added, 'month date, year') >= current_date - interval '5 years';

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select director, title
from netflix
where director like '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons
select title, duration from netflix
	where type = 'TV Show'
and
	split_part(duration, ' ', 1)::numeric > 5 ;

--9. Count the number of content items in each genre
select unnest(string_to_array(listed_in, ',')) as genre, count(*) 
from netflix
group by genre;

--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

select 
extract(year from to_date(date_added,'month date, year')) as year, count(*),
count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric * 100 as avg_content_per_year
from netflix
where country = 'India'
group by year;

--11. List all movies that are documentaries

select * from netflix
where listed_in ilike '%documentaries%';

--12. Find all content without a director
select * from netflix
where director is null;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where
	casts like '%Salman Khan%';
	and 
	release_year > extract(year from current_date) - 10 ;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select unnest(string_to_array(casts, ',')) as actors, count(*) as amount_of_movies_done
from netflix
where country = 'India'
group by actors
order by count(*) desc
limit 10;

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

select category, type, count(category) as content_amount
from
(select  
case  when description ilike '%kill%' or description ilike '%violence%' then 'BAD' 
	  else 'GOOD' end as category,
	  type
from netflix
group by type, description)
group by type,category
order by 2;


































































































































































































