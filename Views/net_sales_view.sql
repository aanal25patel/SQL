CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `gdb041`.`net_sales` AS
    SELECT 
        `gdb041`.`sales_postinv_discount`.`date` AS `date`,
        `gdb041`.`sales_postinv_discount`.`fiscal_year` AS `fiscal_year`,
        `gdb041`.`sales_postinv_discount`.`customer_code` AS `customer_code`,
        `gdb041`.`sales_postinv_discount`.`market` AS `market`,
        `gdb041`.`sales_postinv_discount`.`product_code` AS `product_code`,
        `gdb041`.`sales_postinv_discount`.`product` AS `product`,
        `gdb041`.`sales_postinv_discount`.`variant` AS `variant`,
        `gdb041`.`sales_postinv_discount`.`sold_quantity` AS `sold_quantity`,
        `gdb041`.`sales_postinv_discount`.`gross_price_total` AS `gross_price_total`,
        `gdb041`.`sales_postinv_discount`.`pre_invoice_discount_pct` AS `pre_invoice_discount_pct`,
        `gdb041`.`sales_postinv_discount`.`net_invoice_sales` AS `net_invoice_sales`,
        `gdb041`.`sales_postinv_discount`.`post_invoice_deduction` AS `post_invoice_deduction`,
        (`gdb041`.`sales_postinv_discount`.`net_invoice_sales` - (`gdb041`.`sales_postinv_discount`.`net_invoice_sales` * `gdb041`.`sales_postinv_discount`.`post_invoice_deduction`)) AS `Net_Sales`
    FROM
        `gdb041`.`sales_postinv_discount`