Explain analyze
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
    

# how to do performance optimization of the query ? 
# fetch time: the time taken to retrieve the data from the database. 
# Duration time: the time needed to execute the query. 
# to see the performance analysis of the query, we can use: 'Explain Analyze', before a 
# query.

# calling the function repeatitively increases the duration time of the query. 
	