SELECT 
    	   s.date, 
           s.product_code, 
           p.product, 
		   p.variant, 
           s.sold_quantity, 
           g.gross_price as gross_price_per_item,
           ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total,
           pre.pre_invoice_discount_pct
           
	FROM fact_sales_monthly s
	JOIN dim_product p
            ON s.product_code=p.product_code
	JOIN fact_gross_price g
    	    ON g.fiscal_year=get_fiscal_yr(s.date)
    	    AND g.product_code=s.product_code
	JOIN fact_pre_invoice_deductions as pre
            ON pre.customer_code = s.customer_code AND
            pre.fiscal_year=get_fiscal_yr(s.date)
	WHERE 
	    s.customer_code=90002002 AND 
    	    get_fiscal_yr(s.date)=2021     
	LIMIT 1000000;
    
    
    
    
# the problem here is: we cannot use a derived col in the query.
# hence, we need to use CTE or subquery. 
# hence, using CTE: 


with cte1 as (
	SELECT 
    	   s.date, 
           s.product_code, 
           p.product, 
		   p.variant, 
           s.sold_quantity, 
           g.gross_price as gross_price_per_item,
           ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total,
           pre.pre_invoice_discount_pct
           
	FROM fact_sales_monthly s
	JOIN dim_product p
            ON s.product_code=p.product_code
	JOIN fact_gross_price g
    	    ON g.fiscal_year=get_fiscal_yr(s.date)
    	    AND g.product_code=s.product_code
	JOIN fact_pre_invoice_deductions as pre
            ON pre.customer_code = s.customer_code AND
            pre.fiscal_year=get_fiscal_yr(s.date)
	WHERE 
	    s.customer_code=90002002 AND 
    	    get_fiscal_yr(s.date)=2021     
)
select 
	*, 
    (gross_price_total - gross_price_total * pre_invoice_discount_pct) as net_invoice_sales
from cte1;

# CTE creates a temporary view, or a table for that particular session. 
# View: Creates the table for all the sessions.
# after creating a view named: sales_prein_discount: 
select 
	*, 
    (gross_price_total - gross_price_total * pre_invoice_discount_pct) as net_invoice_sales
from sales_prein_discount;


# 