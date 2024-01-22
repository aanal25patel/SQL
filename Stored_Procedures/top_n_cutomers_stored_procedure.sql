CREATE DEFINER=`root`@`localhost` PROCEDURE `top_n_products`(
	in_fiscal_year int,
    in_n_years int
)
BEGIN
	select
	product,
    round(sum(Net_Sales)/1000000,2) as 'Net_Sales_Mln'
	from net_sales
	where fiscal_year = in_fiscal_year
	group by product
	order by Net_Sales_Mln desc
	limit in_n_years;
END