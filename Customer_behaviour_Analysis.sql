--Q1compare the average purchase amount between the standard and Express shipping

select shipping_type,
ROUND(avg(purchase_amount),2) as avg_purchase
from customer
where shipping_type in ('Standard','Express')
group by shipping_type
order by avg_purchase desc;

--Q2 Do subscribed customer spends more? Compare sverage spend and total revenue bw subscribers and non
select subscription_status,
count(customer_id) as total_customers,
ROUND(avg(purchase_amount),2) as avg_spend,
ROUND(sum(purchase_amount),2) as total_revenue
from customer

group by subscription_status
order by total_customers desc;

--Q3 which 5 products are have the highest percentages of purchases with discounts applied ?
select item_purchased ,
ROUND(100*sum(case when discount_applied = 'Yes' then 1 else 0 End)/count(*) ,2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;
--Q4 Segment customer into New, Returning and loyal based on their total number of previous purchases,and show the count of each segment.
with customer_type as (
select customer_id,previous_purchases,
case when previous_purchases =1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	Else 'Loyal'
	end as customer_segment
from customer
)

select customer_segment,count(*) as "Number of customers"
from customer_type
group by customer_segment

--Q5 What are the top 3 most purchased products within wach category
with item_counts as(
select category,
item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category,item_purchased
)
select item_rank,category,item_purchased,total_orders
from item_counts
where item_rank <=3
)

--Q6 Are customers who are repeat buyers also likely to subscribers ?
select subscription_status , count(customer_id) as repeat_buyers
from customer
where previous_purchases >5
group by subscription_status

--Q7 what is the revenue cintibution of each age group ?
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc