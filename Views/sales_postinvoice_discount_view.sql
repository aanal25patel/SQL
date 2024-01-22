CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `gdb041`.`sales_postinv_discount` AS
    SELECT 
        `gdb041`.`s`.`date` AS `date`,
        `gdb041`.`s`.`fiscal_year` AS `fiscal_year`,
        `gdb041`.`s`.`customer_code` AS `customer_code`,
        `gdb041`.`s`.`market` AS `market`,
        `gdb041`.`s`.`product_code` AS `product_code`,
        `gdb041`.`s`.`product` AS `product`,
        `gdb041`.`s`.`variant` AS `variant`,
        `gdb041`.`s`.`sold_quantity` AS `sold_quantity`,
        `gdb041`.`s`.`Gross_Price_Total` AS `gross_price_total`,
        `gdb041`.`s`.`pre_invoice_discount_pct` AS `pre_invoice_discount_pct`,
        (`gdb041`.`s`.`Gross_Price_Total` - (`gdb041`.`s`.`pre_invoice_discount_pct` * `gdb041`.`s`.`Gross_Price_Total`)) AS `net_invoice_sales`,
        (`po`.`discounts_pct` + `po`.`other_deductions_pct`) AS `post_invoice_deduction`
    FROM
        (`gdb041`.`sales_prein_discount` `s`
        JOIN `gdb041`.`fact_post_invoice_deductions` `po` ON (((`po`.`customer_code` = `gdb041`.`s`.`customer_code`)
            AND (`po`.`product_code` = `gdb041`.`s`.`product_code`)
            AND (`po`.`date` = `gdb041`.`s`.`date`))))