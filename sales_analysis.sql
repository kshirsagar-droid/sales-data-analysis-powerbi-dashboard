-- union all country tables in one Sales data table

CREATE TABLE public."Sales Data" as 
select * from public."sales_canada"
UNION ALL
SELECT * FROM public."sales_china"
union all
select * from public."sales_india"
union all
select * from public."sales_nigeria"
union all
select * from public."sales_uk"
union all
select * from public."sales_us"


ALTER TABLE "Sales Data" RENAME TO sales_data;

-- Cleaning and Processing data

select * from public.Sales_data
where 
	country is null
	or price_per_unit is null
	or Quantity_purchased is null
	or Cost_price is null
	or Discount_Applied is null;



update public.sales_data
set Quantity_Purchased = 3
where transaction_id = '00a30472-89a0-4688-9d33-67ea8ccf7aea'

update public.sales_data
set Price_per_unit = (
	select avg(price_per_unit)
			  from public.sales_data
			  where price_per_unit is not null
)
where transaction_id = '001898f7-b696-4356-91dc-8f2b73d09c63'

select transaction_id, count(*)
from public.sales_data
group by transaction_id
having count(*)>1;

alter table public.sales_data add
column "total_amount" numeric(10,2);

update public.sales_data
set "total_amount"= ("price_per_unit" * "quantity_purchased") - "discount_applied";

select * from sales_data

alter table public.sales_data add
column profit numeric(10,2);

update public.sales_data
set profit = total_amount - (cost_price + quantity_purchased);

-- analyze and generate business insights
--Q1. Sales Revenue and Profit by Country
select
	country,
	sum(total_amount) as total_revenue,
	sum(profit) as total_profit
from public.sales_data
where date between '2025-02-10' and '2025-02-14'
group by country
order by total_revenue;

--Q2. Top 5 Best-selling Products

select 
	product_name,
	sum(quantity_purchased) as total_unit_sold
from public.sales_data
where date between '2025-02-10' and '2025-02-14'
group by product_name
order by total_unit_sold desc
limit 5;

--Q3. Best Sales Representatives
select 
	sales_rep,
	sum(total_amount) as total_sales
from public.sales_data
where date between '2025-02-10' and '2025-02-14'
group by sales_rep
order by total_sales desc
limit 5;

--Q4. Which store locations generated the highest sales?

select 
	store_location,
	sum(total_amount) as total_sales,
	sum(profit) as total_profit
from public.sales_data
where date between '2025-02-10' and '2025-02-14'
group by store_location
order by total_sales desc
limit 5;
	

--Q5. What are the key sales and profit insights for the selected period?

select 
	min(total_amount) as min_sales_value,
	max(total_amount) as max_sales_value,
	avg(total_amount) as avg_sales_value,
	sum(total_amount) as total_sales_value,
	min(profit) as min_profit,
	max(profit) as max_profit,
	avg(profit) as avg_profit
from public.sales_data
where date between '2025-02-10' and '2025-02-14'
	
-- Improted the cleaned SQL dataset into Power BI
















