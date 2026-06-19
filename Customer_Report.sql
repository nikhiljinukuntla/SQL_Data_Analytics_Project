/*
CUSTOMER REPORT
----------------------------------------------------------------
Purpose:
  - This report consolidates key customer metrics and behaviors 
  
  HIGHLIGHTS :
	1. Gathers essential fields such as names,ages and transactions details.
    2. Segments customers into categories (VIP ,Regular, New) and age groups.
    3. Aggregates customer-level metrics 
	   - total orders
       - total sales
       - toal quantity purchased
       - total products 
       - lifespan (in months)
	4. Calculates valuable KPIs:
       - recency (Months since last order)
       - average order value
       - average monthly spend 
*/
create or replace  view `eda_project`.`report_customers` as
with base_query as 
-- 1. Base Query: Retrieves core columns from tables
(
select 
mmm.order_number,
mmm.product_key,
mmm.order_date,
mmm.sales_amount,
mmm.quantity,
mm.customer_key,
mm.customer_number,
concat(mm.first_name,' ',mm.last_name) as customer_name, -- first & last names 
timestampdiff(year,mm.birthdate,curdate()) age -- birthdate
from my_table_3 mmm 
left join my_table_2 mm 
on mm.customer_key = mmm.customer_key 
where order_date is not null and 
order_date != '' ),

customer_aggregation as
(
select 
customer_key,
customer_number,
customer_name, -- first & last names 
age, -- birthdate
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key) as total_products,
max(order_date) as last_order_date,
timestampdiff(month,min(order_date),max(order_date)) as lifespan
from base_query
group by 
customer_key,
customer_number,
customer_name,
age
)
select 
customer_key,
customer_number,
customer_name,
age,
case
	when age >= 50 then '50 and above'
    when age between 40 and 49 then '40-49'
	when age between 30 and 39 then '30-39'
    else 'under 30'
end as age_group,
case 
    when lifespan >= 12 and total_sales > 5000 then 'VIP'
    when lifespan >= 12 and total_sales <= 5000 then 'Regular'
    else 'New'
end as customer_segment,
last_order_date,
timestampdiff(month,last_order_date,curdate()) as recency,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan,
-- compuate avg order value (AVO)
case 
	when total_sales  = 0 then 0
    else total_sales / total_orders 
end as avg_order_value,
-- compuate average monthly spend
case 
	when lifespan = 0 then total_sales
    else total_sales / lifespan
end as avg_monthly_spend
from customer_aggregation;

