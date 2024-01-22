CREATE DEFINER=`root`@`localhost` PROCEDURE `get_market_badge`(
	IN in_year int,
    IN in_market varchar(50),
    OUT out_badge varchar(10)
)
BEGIN
	declare qty int default 0;
    
    # setting default value of market to India:
    if in_market = "" then 
		set in_market = "India"; 
    end if;
    
    # retrieving the total quantity and storing it in qty. 
    
	select 
		sum(sm.sold_quantity) into qty
	from fact_sales_monthly sm
	join dim_customer c
	on c.customer_code = sm.customer_code
	where 
		get_fiscal_yr(sm.date) = in_year and
		c.market = in_market
	group by market;
    
    # now we have to determine the badge:
    if qty > 5000000 then
		set out_badge = "Gold";
	else
		set out_badge = "Silver";
	end if;
END