CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monthly_gross_sales`(
	in_customer_code text
)
BEGIN
	SELECT 
		s.date,
		sum(s.sold_quantity*g.gross_price) as 'Gross_price_total'
	FROM gdb041.fact_sales_monthly s
	join fact_gross_price g
	on 
		g.product_code = s.product_code and
		g.fiscal_year = get_fiscal_yr(s.date)
	where 
		find_in_set(s.customer_code, in_customer_code)>0
	group by date;
END