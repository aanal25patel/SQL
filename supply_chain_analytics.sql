# getting the 'forecast quantity' and the 'sold quantity' in one table. 

# getting the max date for both the tables: 
select max(date) from fact_forecast_monthly;
select max(date) from fact_sales_monthly;

# getting the count of rows for both the tables:
select count(*) from fact_forecast_monthly; # 1885943
select count(*) from fact_sales_monthly;    # 1425707

# so, when we join, there will be some extra records in the table: 

select 
	s.*, 
    f.forecast_quantity
from fact_sales_monthly s
join fact_forecast_monthly f
using (date, product_code, customer_code);

# here, when we dont specify which join to perform: it will take 
# inner join by default. lets see what are the no. of common rows:

select 
	count(*)
from fact_sales_monthly s
join fact_forecast_monthly f
using (date, product_code, customer_code);
# 1390839

# lets do left and right join: 
select 
	count(*)
from fact_sales_monthly s
left join fact_forecast_monthly f
using (date, product_code, customer_code);
# 1425708

select 
	count(*)
from fact_sales_monthly s
right join fact_forecast_monthly f
using (date, product_code, customer_code);
# 1885943

# difference:
# sales: 1425708 - 1390839 = 34869 (additional rows in sales)
# forecast: 1885943 - 1390839 = 495104 (additional rows in forecast)

# considering all the null quantities to be 0. 
# performing full outer join: 

select 
	s.*, 
    f.forecast_quantity
from fact_sales_monthly s
left join fact_forecast_monthly f
using (date, product_code, customer_code)

union

select 
	s.*, 
    f.forecast_quantity
from fact_sales_monthly s
right join fact_forecast_monthly f
using (date, product_code, customer_code);

# the above query is throwing an error of 
# "Lost Connection to MySQL server"
# created a separate table names fact_act_est_1. 

# replaced the null by 0, using following query: 

update fact_act_est_1
set sold_quantity = 0 
where sold_quantity is null;



with forecast_err_table as (
             select
                  s.customer_code as customer_code,
                  c.customer as customer_name,
                  c.market as market,
                  sum(s.sold_quantity) as total_sold_qty,
                  sum(s.forecast_quantity) as total_forecast_qty,
                  sum(s.forecast_quantity-s.sold_quantity) as net_error,
                  round(sum(s.forecast_quantity-s.sold_quantity)*100/sum(s.forecast_quantity),1) as net_error_pct,
                  sum(abs(s.forecast_quantity-s.sold_quantity)) as abs_error,
                  round(sum(abs(s.forecast_quantity-sold_quantity))*100/sum(s.forecast_quantity),2) as abs_error_pct
             from fact_act_est s
             join dim_customer c
             on s.customer_code = c.customer_code
             where s.fiscal_year=2021
             
             
             group by customer_code
	)
	select 
            *,
            if (abs_error_pct > 100, 0, 100.0 - abs_error_pct) as forecast_accuracy
	from forecast_err_table
        order by forecast_accuracy desc;