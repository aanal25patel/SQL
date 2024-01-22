CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `gdb041`.`all_sales_forecasts` AS
    SELECT 
        `s`.`date` AS `date`,
        `s`.`fiscal_year` AS `fiscal_year`,
        `s`.`product_code` AS `product_code`,
        `s`.`customer_code` AS `customer_code`,
        `s`.`sold_quantity` AS `sold_quantity`,
        `f`.`forecast_quantity` AS `forecast_quantity`
    FROM
        (`gdb041`.`fact_sales_monthly` `s`
        LEFT JOIN `gdb041`.`fact_forecast_monthly` `f` ON (((`s`.`date` = `f`.`date`)
            AND (`s`.`product_code` = `f`.`product_code`)
            AND (`s`.`customer_code` = `f`.`customer_code`)))) 
    UNION SELECT 
        `s`.`date` AS `date`,
        `s`.`fiscal_year` AS `fiscal_year`,
        `s`.`product_code` AS `product_code`,
        `s`.`customer_code` AS `customer_code`,
        `s`.`sold_quantity` AS `sold_quantity`,
        `f`.`forecast_quantity` AS `forecast_quantity`
    FROM
        (`gdb041`.`fact_forecast_monthly` `f`
        LEFT JOIN `gdb041`.`fact_sales_monthly` `s` ON (((`f`.`date` = `s`.`date`)
            AND (`f`.`product_code` = `s`.`product_code`)
            AND (`f`.`customer_code` = `s`.`customer_code`))))