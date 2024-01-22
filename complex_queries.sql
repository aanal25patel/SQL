# select a movie with maximum imdb_rating: 

select max(imdb_rating) from movies;
select * from movies where imdb_rating = 9.3; 

# alternative: 
select * from movies where imdb_rating = 
(select max(imdb_rating) from movies);


# sub query returing a list of values: 
select * from movies 
where imdb_rating in (
(select max(imdb_rating) from movies), 
(select min(imdb_rating) from movies));


# returning a table: 
# select all the actors whose age > 70 and < 85
 select name, year(curdate())-birth_year as Age from actors
 having Age > 70 and Age < 85;
 
 # derived cols gets executed at the last.
 
 # or, we can also use sub query: 
 select * from 
 (select name, year(curdate())-birth_year as Age from actors) as actor_age
 where age > 70 and age<85;
 
 
 # Common Table Expressions: 
 
 # get all the actors whose age is between 70 and 85:
select actor_name, age
from 
(select name as actor_name, 
year(curdate()) - birth_year as Age
from actors) as actor_age 
where age > 70 and age<85;
 
#in the above query, the query inside the brackets indicate a temporary table. 
# another way to write this statement is using CTE: 

with actor_age as (
	select name as actor_name, 
	year(curdate()) - birth_year as Age
	from actors
)
select actor_name, age
from actor_age
where age > 70 and age < 85;
 
# CTE are more readable as compared to the subqueries. 
# there can be multiple CTEs that can be applied in a query. 

# movie that produced 500 % profit and their rating was less than the average
# rating for all the movies: 

# the approach to solve this query is to use divide and conquer rule: 
# 1: movies that produced 500 % profit 
select *,(revenue - budget)*100/budget as Profit 
from financials
having Profit >= 500; 

select avg(imdb_rating) from movies;

# 2: their rating was less than the average rating for all the movies: 
select m.title, m.imdb_rating 
from movies m
join financials f
on m.movie_id = f.movie_id
where imdb_rating < (select avg(imdb_rating) from movies);

# using CTE: 
with
	x as (
		select *,(revenue - budget)*100/budget as Profit 
		from financials
		having Profit >= 500
    ), 
    
    y as (
		select * from movies where imdb_rating < 
        (select avg(imdb_rating) from movies)
    )
select 
	x.movie_id, x.Profit, 
    y.title, y.imdb_rating
from x
join y
on x.movie_id = y.movie_id
where Profit >= 500


# practice having multiple ctes in one query!!

# explore: recursive subquery: IMP! 

# exercise: Select all Hollywood movies released after the year 2000 
# that made more than 500 million $ profit or more profit. 
# Note that all Hollywood movies have millions as a unit hence you 
# don't need to do the unit conversion. Also, you can write this query 
# without CTE as well but you should try to write this using CTE only. 


# 3 popular relational databases: oracle, microsoft server, MySQL.
# in nosql databases, there are no set cols and the data structure is 
# loosely defined. e.g: mongoDB, CouchDB, Apache Cassandra, etc. 



 
 
 
 
 
 
 
 