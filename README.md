📊 SQL Data Analytics Project — Customer, Product & Sales Performance Analysis
📌 Overview
This project is an end-to-end SQL analytics exercise built on a sales dataset containing customers, products, and sales transactions.Also analyzed 3+ years of sales data to identify customer segments, product performance, and growth trends. Converted raw SQL analysis into business insights.
It moves through the full analytics workflow — from raw data exploration to advanced analytics — and finishes with two production-style reporting views that consolidate customer and product KPIs for easy downstream use (BI tools, dashboards, etc.).
The goal was to simulate how a Data Analyst would explore, analyze, and report on business data using pure SQL — no external tools required.

🎯 Objective
Answer real business questions such as:
How is the business performing over time, and which periods drive the most revenue?
Which products and categories generate the most (and least) revenue?
Who are our most valuable customers, and how can we segment them?
Which customers are at risk of going inactive (recency-based churn signals)?
How can these metrics be packaged into a reusable report for ongoing use?

🗂️ Project Structure
File	Purpose
`Data_exploration.sql`	Initial EDA — database/schema exploration, dimension exploration, date ranges, core business measures, magnitude analysis, and ranking analysis
`Advanced_Analysis.sql`	Advanced analytics — time-over-time trends, cumulative/moving-average analysis, year-over-year performance, part-to-whole contribution, and customer/product segmentation
`Customer_Report.sql`	A reusable SQL `VIEW` consolidating customer-level KPIs and segments
`Product_Report.sql`	A reusable SQL `VIEW` consolidating product-level KPIs and segments

🧱 Database Schema (as used in the project)
Table	Role	Key Columns
Products table named as my_table	Product dimension	`product_key`, `product_name`, `category`, `subcategory`, `cost`
Customers table named as my_table_2	Customer dimension	`customer_key`, `customer_number`, `first_name`, `last_name`, `birthdate`, `country`, `gender`, `create_date`
Sales table named as my_table_3	Sales fact / transactions	`order_number`, `order_date`, `customer_key`, `product_key`, `sales_amount`, `quantity`, `price`

🔍 What This Project Covers
1. Data Exploration & EDA (`Data_exploration.sql`)
Explored database metadata via `information_schema`
Reviewed dimension values: countries, product categories/subcategories
Calculated date coverage (first/last order, order range in years & months) and customer age range
Computed core business measures: total sales, total quantity sold, average price, total orders, total products, total customers
Built a single summary query combining all key business metrics
Magnitude analysis — customers by country/gender, products by category, average cost by category, revenue by category, revenue by customer, quantity distribution by country
Ranking analysis — top 5 revenue-generating products, bottom 5 performing products, and top revenue-generating years
2. Advanced Analysis (`Advanced_Analysis.sql`)
Time-over-time trend analysis — sales, customer count, and quantity broken down by year and by month, surfacing seasonal patterns (e.g., December consistently outperforms, February lags behind)
Cumulative analysis — running total of monthly/yearly sales and a moving average of price to track growth trajectory
Year-over-year product performance — comparing each product's yearly sales against its own historical average and prior-year sales, flagging products as Above Average / Below Average and Increasing / Decreasing
Part-to-whole analysis — calculating each category's percentage contribution to total revenue
Customer segmentation — classifying customers into VIP / Regular / New based on tenure (lifespan) and total spend, and using order recency as an early indicator of customer churn risk
Product cost segmentation — grouping products into cost tiers to understand pricing distribution
3. Customer Report View (`Customer_Report.sql`)
A single `CREATE VIEW` that produces a clean, analysis-ready customer table with:
Demographics: name, age, age group
Behavioral segment: VIP / Regular / New
Activity metrics: total orders, total sales, total quantity, total distinct products purchased
Retention metrics: recency (months since last order) and lifespan (customer tenure)
KPIs: Average Order Value (AOV) and Average Monthly Spend
4. Product Report View (`Product_Report.sql`)
A single `CREATE VIEW` that produces a clean, analysis-ready product table with:
Product attributes: category, subcategory, cost
Performance segment: High-Performer / Mid-Range / Low-Performer based on total sales
Activity metrics: total orders, total sales, total quantity, total customers reached
KPIs: average selling price, average order revenue, and average monthly revenue
🛠️ Skills & SQL Concepts Demonstrated
Common Table Expressions (CTEs), including multi-step/nested CTEs
Window functions (`SUM() OVER`, `AVG() OVER`, `LAG()`)
`CASE` statement logic for business rule–based segmentation
Date functions (`DATE_FORMAT`, `TIMESTAMPDIFF`, `YEAR()`, `MONTH()`)
Joins across fact and dimension tables
Aggregate functions and `GROUP BY` analysis
Building reusable analytical `VIEW`s for reporting
Structuring SQL into a logical exploration → analysis → reporting workflow

📬 Connect
If you have feedback or suggestions on this project, feel free to reach out or open an issue.
[JINUKUNTLA NIKHIL]
[https://www.linkedin.com/in/jinukuntla-nikhil] · [jinukuntlanikhil@gmail.com]
