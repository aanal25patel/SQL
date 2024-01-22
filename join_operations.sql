# 4th module: 

# inner join: it will only take the common records in the consideration.
select 
movie_id, title, budget, revenue, currency, unit 
from movies m
join financials f
on m.movie_id = f.movie_id;

# outer join consists of: Left join, right join, full join

# left join: 
select 
m.movie_id, title, budget, revenue, currency, unit 
from movies m
left join financials f
on m.movie_id = f.movie_id;

# similar is the case in the right join

# full join: use the keyword: UNION
select 
m.movie_id, title, budget, revenue, currency, unit 
from movies m
left join financials f
on m.movie_id = f.movie_id

UNION

select 
f.movie_id, title, budget, revenue, currency, unit 
from movies m
right join financials f
on m.movie_id = f.movie_id;


# using the 'USING' keyword
# here, as the field on which we are performing the join is same, we can use
# USING k/w : 

select 
movie_id, title, budget, revenue, currency, unit 
from movies m
right join financials f
using (movie_id);



# joining the tables using multiple cols: 
select 
movie_id, title, budget, revenue, currency, unit 
from movies m
right join financials f
using (movie_id, 2nd_col_name);

# or: 
select 
m.movie_id, title, budget, revenue, currency, unit 
from movies m
right join financials f
on m.movie_id = f.movie_id and m.col2 = f.col2;


# execrises: 
# 1. Show all the movies with their language names: 
select m.title, l.name from movies m join languages l on m.language_id = l.language_id;


# 2. Show all Telugu movie names (assuming you don't know the language
# id for Telugu)
select m.title, l.name
from movies m 
join languages l
on m.language_id = l.language_id
where l.name like '%telugu%';


# 3. Show the language and number of movies released in that language
select m.title, l.name, count(*) as 'No of movies'
from movies m 
join languages l
on m.language_id = l.language_id
group by l.name;


# cross join: similar to cartesian product: 
# working on the food_db dataset: 
select * from items;
select * from variants;


select * from items cross join variants;

select 
*, concat(name, "-", variant_name) as Full_name, 
(price + variant_price) as Full_price
from items cross join variants;


# joining more than 2 tables: 
select 
m.title, group_concat(a.name separator ' | ')
from movies m
join movie_actor ma on ma.movie_id = m.movie_id
join actors a on a.actor_id  = ma.actor_id
group by m.movie_id;


select 
a.name, group_concat(m.title separator ' | ') as Movies, 
count(m.title) as movies_count
from actors a
join movie_actor ma on ma.actor_id = a.actor_id
join movies m on m.movie_id = ma.movie_id
group by a.actor_id
order by movies_count desc;

# exercise: 
# 1. Generate a report of all Hindi movies sorted by their 
# revenue amount in millions.
# Print movie name, revenue, currency, and unit

select 
m.title, f.currency, f.unit, l.name, 
CASE
when unit = 'thousand' then revenue / 1000
when unit = 'billions' then revenue * 1000
when unit = 'millions' then revenue
END as revenue_in_millions
from  financials f 
join movies m on m.movie_id = f.movie_id
join languages l on l.language_id = m.language_id
where m.industry = "Bollywood" and l.name like '%hindi%'
order by revenue_in_millions desc;


