-- CREATE OR REPLACE VIEW `eda_project`.`product_report` AS
WITH base_query AS (
    -- 1) Base Query: Get raw data
    SELECT 
        m3.order_number,
        m3.order_date,
        m3.customer_key,
        m3.sales_amount,
        m3.quantity,
        m.product_key,
        m.product_name,
        m.category,
        m.subcategory,
        m.cost
    FROM my_table_3 m3
    LEFT JOIN my_table m 
        ON m3.product_key = m.product_key
    WHERE m3.order_date IS NOT NULL
),  -- Ee comma chala important
product_aggregations AS (
    -- 2) Product Aggregations: Group by product
    SELECT 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(sales_amount / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY product_key, product_name, category, subcategory, cost
)
-- 3) Final Query: KPIs and Segments
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    TIMESTAMPDIFF(MONTH, last_sale_date, CURDATE()) AS recency_in_months,
    CASE 
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    CASE 
        WHEN total_orders = 0 THEN 0 
        ELSE ROUND(total_sales / total_orders, 2)
    END AS avg_order_revenue,
    CASE 
        WHEN lifespan = 0 THEN total_sales 
        ELSE ROUND(total_sales / lifespan, 2)
    END AS avg_monthly_revenue
FROM product_aggregations

