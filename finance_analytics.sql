# generate a report of individual product sales 
# (aggregated on monthly basis at the product code level) 
# for Croma India customer for FY = 2021
# so that I can track individual product sales and run further product analytics
# on it in excel: 



# following are the col names: 
# 1. Month
# 2. Product Name
# 3. Variant
# 4. Sold Quality
# 5. Gross Price Per item
# 6. Gross Price total

-- starting the query: 

# getting the customer id first: 
select * from dim_customer where customer like '%croma%';	

# for croma india:
SELECT COUNT(DISTINCT product_code)
FROM fact_sales_monthly
WHERE customer_code = 90002002;

select * 
from fact_sales_monthly 
where customer_code = 90002002
group by product_code;

# how do I convert calender year to fiscal year? 
# start: sept - 9
# end: aug - 8 
# hence, add 4 months to the date. 
# select YEAR(DATE_ADD(date, INTERVAL 4 MONTH))

select * from fact_sales_monthly
where
	customer_code = 90002002 and 
    year(date_add(date, Interval 4 month)) = 2021
order by date desc;

# the above query gives all the transactions in the Fiscal year 2021,
# for croma, India


# the condition is: aggregated on the monthly basis at product level.

# user_defined_function
# name: get_fiscal_year_pr

# got the cols: Month and Sold quantity. 
# now, retrieving: Product Name and Variant: 

select 
	s.date, s.product_code, 
    p.product, p.variant, s.sold_quantity
from fact_sales_monthly s
join dim_product p 
on p.product_code = s.product_code
where
	customer_code = 90002002 and 
    year(date_add(date, Interval 4 month)) = 2021
order by date desc;

# now getting: gross price per item, and gross price total: 
# now, here, in the present table and the 'fact_gross_price' table, 
# to get the above 2 cols mentioned, we have to do join based on 2 cols. 
# and for that, we have to retrieve the fiscal year from the current
# table. 

select 
	s.date, s.product_code, 
    p.product, p.variant, s.sold_quantity, 
    g.gross_price
from fact_sales_monthly s
join dim_product p 
on p.product_code = s.product_code
join fact_gross_price g 
on 
	g.product_code = s.product_code and 
	g.fiscal_year = get_fiscal_year_pr(s.date)
where
	customer_code = 90002002 and 
    year(date_add(date, Interval 4 month)) = 2021
order by date desc;


# getting: gross price total: 
# final query: 

select 
	s.date, s.product_code, 
    p.product, p.variant, s.sold_quantity, 
    g.gross_price, 
    round(s.sold_quantity * g.gross_price,2) as gross_price_total
from fact_sales_monthly s
join dim_product p 
on p.product_code = s.product_code
join fact_gross_price g 
on 
	g.product_code = s.product_code and 
	g.fiscal_year = get_fiscal_year_pr(s.date)
where
	customer_code = 90002002 and 
    year(date_add(date, Interval 4 month)) = 2021
order by date desc;


### another task: to prepare a 
# 'Gross monthly total sales report for Chroma'
# cols to include: Month, Total gross sales amt to Croma India in this month. 

select 
	s.date as Date, 
    sum(g.gross_price*s.sold_quantity) as Gross_price_total 
from fact_sales_monthly s
join fact_gross_price g 
on 
	g.product_code = s.product_code and
    g.fiscal_year = get_fiscal_yr(s.date)

where customer_code = 90002002
group by s.date
order by s.date desc;

# we want only one row for a month: use group by function. 


# Practice: 
select 
	g.fiscal_year, 
    sum(g.gross_price*s.sold_quantity) as Gross_price_total 
from fact_sales_monthly s
join fact_gross_price g 
on 
	g.product_code = s.product_code and
    g.fiscal_year = get_fiscal_yr(s.date)

where customer_code = 90002002
group by g.fiscal_year
order by s.date desc;
 
 
 















































































