CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_markets_by_net_sales`(
	in_fiscal_year int,
    in_n_years int
)
BEGIN
	select 
	market, 
    round(sum(Net_Sales)/1000000,2) as 'Net_Sales_Mln'
	from net_sales
	where fiscal_year = in_fiscal_year
	group by market
	order by Net_Sales desc
	limit in_n_years;
END