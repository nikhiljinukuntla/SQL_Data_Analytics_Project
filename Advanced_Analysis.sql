/* CHANGE - OVER - ANALYSIS
   [MEASURE] BY [DATE DIMENSION] 
   CHANGE OVER YEARS - WE CAN FIND THE BEST YEAR ACCORDING TO 
   CUSTOMER COUNT , DISTRIBUTION OF QUANTITY AND SALES TURNOVER
   */
   
SELECT 
    YEAR(order_date),
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM
    my_table_3
WHERE
    order_date IS NOT NULL
        AND order_date != ''
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

/*
   CHANGE OVER MONTHS - WE CAN FIND BEST MONTH ACCORDING TO 
   CUSTOMER COUNT , DISTRIBUTION OF QUANTITY AND SALES TURNOVER
   FEB IS THE WORST MONTH AND DECIS THE BEST MONTHS 
*/
SELECT 
    MONTH(order_date),
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM
    my_table_3
WHERE
    order_date IS NOT NULL
        AND order_date != ''
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);
--------------------------------------------------------------------------
SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM
    my_table_3
WHERE
    order_date IS NOT NULL
        AND order_date != ''
GROUP BY YEAR(order_date) , MONTH(order_date)
ORDER BY YEAR(order_date) , MONTH(order_date);

-- DATE FORMAT -- FOR MONTH - WISE ANALYSIS
SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM
    my_table_3
WHERE
    order_date IS NOT NULL
        AND order_date != ''
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY DATE_FORMAT(order_date, '%Y-%m-01');

-- FOR YEAR-WISE ANALYSIS
SELECT 
    DATE_FORMAT(order_date, '%Y-01-01') AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM
    my_table_3
WHERE
    order_date IS NOT NULL
        AND order_date != ''
GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
ORDER BY DATE_FORMAT(order_date, '%Y-01-01');

-- Q) HOW MANY NEW CUSTOMERS WERE ADDED EACH YEAR
SELECT 
    DATE_FORMAT(create_date, '%Y-01-01') AS create_year,
    COUNT(customer_key) AS total_customers
FROM
    my_table_2
GROUP BY DATE_FORMAT(create_date, '%Y-01-01')
ORDER BY DATE_FORMAT(create_date, '%Y-01-01');


/* CUMULATIVE ANALYSIS 
   Aggregate the date progressively over time  
   Helps to understand whether our business is growing or declining
   Calculate the total sales per month and the running total of sales over time */
select 
order_date,
total_sales,
sum(total_sales) over (order by order_date)
as running_total_sales
from
(
select 
date_format(order_date,'%Y-%m-01') as order_date,
sum(sales_amount) as total_sales
from my_table_3
where 
order_date is not null  and
order_date != ''
group by date_format(order_date,'%Y-%m-01') 
order by date_format(order_date,'%Y-%m-01') 
)t;

-- FIND RUNNING TOTAL
select 
order_date,
total_sales,
sum(total_sales) over (partition by order_date order by order_date)
as running_total_sales
from
(
select 
date_format(order_date,'%Y-01-01') as order_date,
sum(sales_amount) as total_sales
from my_table_3
where 
order_date is not null  and
order_date != ''
group by date_format(order_date,'%Y-01-01') 
order by date_format(order_date,'%Y-01-01') 
)t;

-- FIND MOVING AVERAGE 
select 
order_date,
avg_price,
avg(avg_price) over (order by order_date)as moving_average_price
from
(
select 
date_format(order_date,'%Y-01-01') as order_date,
round(avg(price),0) as avg_price
from my_table_3
where 
order_date is not null  and
order_date != ''
group by date_format(order_date,'%Y-01-01') 
order by date_format(order_date,'%Y-01-01') 
)t;
  
-- PERFORMANCE ANALYSIS 
/* Analyze the yearly performance of products by comparing their sales
to both the avg sales performance of the product and the previous years's sales*/

with yearly_product_sales AS (
select 
year(mmm.order_date) as order_year,
m.product_name,
sum(mmm.sales_amount) as current_sales
from my_table_3 mmm
left join my_table m 
on mmm.product_key = m.product_key
where order_date is not null and order_date != ''
group by year(mmm.order_date),
m.product_name 
)

select 
order_year,
product_name,
current_sales,
avg(current_sales) over (partition by product_name) avg_sales,
current_sales - avg(current_sales) over (partition by product_name) as diff_avg,
case when current_sales - avg(current_sales) over (partition by product_name) > 0 then 'Above Avg'
	 when current_sales - avg(current_sales) over (partition by product_name) < 0 then 'Below Avg'
     else 'Avg'
end avg_change,
-- YEAR-OVER-YEAR Analysis
lag(current_sales) over (partition by product_name order by order_year) previous_yr_sales,
current_sales - lag(current_sales) over (partition by product_name order by order_year) as diff_py,
case when current_sales - lag(current_sales) over (partition by product_name order by order_year) > 0 then 'Increase'
	 when current_sales - lag(current_sales) over (partition by product_name order by order_year) < 0 then 'Decrease'
     else 'No Change'
end py_change
from yearly_product_sales 
order by product_name , order_year;

-- PART TO WHOLE Proportional
-- which categories contribute the most to overall sales ? 

With category_sales as (
select
category,
sum(sales_amount) total_sales
from my_table_3 mmm
left join my_table m 
on m.product_key = mmm.product_key
group by category)

select
category,
total_sales,
sum(total_sales) over() overall_sales,
concat(round((total_sales * 100.0) / sum(total_sales) over(),2),'%') percentage_total
from category_sales
order by total_sales desc ;

-- DATA SEGMENTATION 
/* Segment products into cost ranges and 
count how many products fall into each segment */

with product_segments as (
select
product_key,
product_name,
cost,
case when cost < 100 then 'below 100'
	 when cost < 100 and 500 then '100-500'
	 when cost < 500 and 1000 then '500-1000'
	 when cost < 1000 and 1500 then '1000-1500'
	 when cost < 1200 and 1500 then '1200-1500'
     else 'Above 1500'
end cost_range
from my_table)

SELECT 
    cost_range, COUNT(product_key) AS total_products
FROM
    product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/*
Group customers into three segments based on their spending behavior :
  - VIP : Customers with at least 12 months of history and spending more than 5,000
  - Regular : Customers with at least 12 months of history but spending 5,000
  - New : Customers with a lifespan less than 12 months 
And find the total number of customer by each group
*/
with customer_spending as (
select
mm.customer_key,
coalesce(sum(mmm.sales_amount),0) as total_spending,
min(order_date) as first_order,
max(order_date) as last_order,
timestampdiff(month, min(order_date), max(order_date)) as lifespan 
from my_table_3 mmm
left join my_table_2 mm
on mm.customer_key = mmm.customer_key
group by mm.customer_key
)
select 
	case
		when lifespan >= 12 and total_spending > 5000 then 'VIP'
        when lifespan >= 12 and total_spending <= 5000 then 'Regular'
        when lifespan < 12 then 'New'
        else 'Others'
	end as customer_segment,
	count(customer_key) as total_customers 
from customer_spending
group by customer_segment
order by total_customers desc;
 





