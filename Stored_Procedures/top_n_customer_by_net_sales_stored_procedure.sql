CREATE DEFINER=`root`@`localhost` PROCEDURE `top_n_customer_by_net_sales`(
	in_market varchar(50),
    in_fiscal_year int,
    in_top_n int
)
BEGIN
	select
	c.customer,
    round(sum(Net_Sales)/1000000,2) as 'Net_Sales_Mln'    
	from net_sales n
	join dim_customer c
	on c.customer_code = n.customer_code
	where fiscal_year = in_fiscal_year and n.market = in_market
	group by c.customer
	order by Net_Sales_Mln desc
	limit in_top_n;
END