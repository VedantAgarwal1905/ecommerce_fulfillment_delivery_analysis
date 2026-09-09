use ecommerce_fulfillment;
select s.seller_id, 
p.product_category_name,
count(distinct o.order_id) as total_orders,
sum(distinct case when o.delivery_delay_days>0 then 1 else 0 end) as late_delivered_orders,
round(sum(distinct case when o.delivery_delay_days>0 then 1 else 0 end) * 100 / count(distinct o.order_id),2) as percentage_late 
from sellers s
inner join order_items oi 
on oi.seller_id=s.seller_id 
inner join products p
on p.product_id=oi.product_id
inner join orders o 
on o.order_id=oi.order_id
where o.order_status='delivered'
group by p.product_category_name, s.seller_id
having count(distinct o.order_id) >= 50
order by percentage_late desc
limit 20;

select
    s.seller_id,
    p.product_category_name,
    count(distinct o.order_id) as total_orders,
    count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_delivered_orders,
    round(
        count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0
        / count(distinct o.order_id),
        2
    ) as percentage_late
from sellers s
inner join order_items oi
    on oi.seller_id = s.seller_id
inner join products p
    on p.product_id = oi.product_id
inner join orders o
    on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by p.product_category_name, s.seller_id
having count(distinct o.order_id) >= 50
order by percentage_late desc
limit 20;

select case
when oi.freight_value < 20 then '< 20'
when oi.freight_value < 50 then '20–50'
when oi.freight_value < 100 then '50–100'
when oi.freight_value < 200 then '100–200'
else '> 200'
end as freight_group,
count(*) as total_items,
round(avg(o.delivery_delay_days), 2) as average_delay
from order_items oi
inner join orders o
on oi.order_id = o.order_id
where o.order_status = 'delivered'
group by freight_group
order by average_delay desc;

select year(o.order_purchase_timestamp) as purchase_year,
month(o.order_purchase_timestamp) as purchase_month,
count(distinct o.order_id) as total_delivered_orders,
count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_orders,
round(count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0/ count(distinct o.order_id),2) as late_percentage
from orders o
where o.order_status = 'delivered'
group by month(o.order_purchase_timestamp)
order by purchase_year, purchase_month;

select year(o.order_purchase_timestamp) as purchase_year,
month(o.order_purchase_timestamp) as purchase_month,
count(distinct o.order_id) as total_delivered_orders,
count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_orders,
round(count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0/ count(distinct o.order_id),2) as late_percentage
from orders o
where o.order_status = 'delivered'
group by
year(o.order_purchase_timestamp),
month(o.order_purchase_timestamp)
order by late_percentage desc limit 10;

select case
when processing_time_hours < 24 then '< 1 day'
when processing_time_hours < 72 then '1–3 days'
when processing_time_hours < 168 then '3–7 days'
when processing_time_hours < 336 then '7–14 days'
else '> 14 days'
end as processing_group,
count(distinct order_id) as total_delivered_orders,
count(distinct case when delivery_delay_days > 0 then order_id end) as late_orders,
round(count(distinct case when delivery_delay_days > 0 then order_id end) * 100.0/ count(distinct order_id),2) as late_percentage
from orders
where order_status = 'delivered'
group by processing_group
order by late_percentage desc;

select oi.seller_id, 
count(distinct o.order_id) as total_orders,
round(avg(o.processing_time_hours), 2) as average_processing_hours
from order_items oi
inner join orders o
on oi.order_id = o.order_id
where o.order_status = 'delivered'
group by oi.seller_id
having count(distinct o.order_id) >= 50
order by average_processing_hours desc
limit 20;


select oi.seller_id, 
count(distinct o.order_id) as total_orders,
round(avg(o.processing_time_hours), 2) as average_processing_hours
from order_items oi
count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_orders,
round(count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0/ count(distinct o.order_id), 2) as late_percentage
inner join orders o
on oi.order_id = o.order_id
where o.order_status = 'delivered'
group by oi.seller_id
having count(distinct o.order_id) >= 50
order by average_processing_hours desc
limit 20;

select
    oi.seller_id,
    count(distinct o.order_id) as total_orders,
    round(avg(o.processing_time_hours), 2) as average_processing_hours,
    count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_orders,
    round(
        count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0
        / count(distinct o.order_id), 2
    ) as late_percentage
from order_items oi
inner join orders o
    on oi.order_id = o.order_id
where o.order_status = 'delivered'
group by oi.seller_id
having count(distinct o.order_id) >= 50
order by average_processing_hours desc
limit 20;

select case
when delivery_time_days < 3 then '< 3 days'
when delivery_time_days < 7 then '3–7 days'
when delivery_time_days < 14 then '7–14 days'
when delivery_time_days < 21 then '14–21 days'
else '> 21 days'
end as delivery_group,
count(distinct order_id) as total_delivered_orders,
count(distinct case when delivery_delay_days > 0 then order_id end) as late_orders,
round(count(distinct case when delivery_delay_days > 0 then order_id end) * 100.0/ count(distinct order_id),2) as late_percentage
from orders
where order_status = 'delivered'
group by delivery_group
order by late_percentage desc;

select case
when delivery_time_days < 3 then '< 3 days'
when delivery_time_days < 7 then '3–7 days'
when delivery_time_days < 14 then '7–14 days'
when delivery_time_days < 21 then '14–21 days'
else '> 21 days'
end as delivery_group,
count(distinct order_id) as total_delivered_orders,
count(distinct case when delivery_delay_days > 0 then order_id end) as late_orders,
round(count(distinct case when delivery_delay_days > 0 then order_id end) * 100.0/ count(distinct order_id),2) as late_percentage
from orders
where order_status = 'delivered'
group by delivery_group
order by late_percentage desc;

select
c.customer_state,
oi.seller_id,
count(distinct o.order_id) as total_orders,
count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_orders,
round(count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0 / count(distinct o.order_id),2) as late_percentage
from customers c
inner join orders o
on c.customer_id = o.customer_id
inner join order_items oi
on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by c.customer_state, oi.seller_id
having count(distinct o.order_id) >= 50
order by late_percentage desc
limit 20;

select s.seller_state,
count(distinct o.order_id) as total_delivered_orders,
count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_orders,
round(count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0/ count(distinct o.order_id),2) as late_percentage
from customers c
inner join orders o
on c.customer_id = o.customer_id
inner join order_items oi
on o.order_id = oi.order_id
inner join sellers s
on oi.seller_id = s.seller_id
where o.order_status = 'delivered'
and c.customer_state = 'RJ'
group by s.seller_state
having count(distinct o.order_id) >= 50
order by late_percentage desc;


select c.customer_state,
count(distinct o.order_id) as total_delivered_orders,
count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_orders,
round(count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0/ count(distinct o.order_id),2) as late_percentage
from customers c
inner join orders o
on c.customer_id = o.customer_id
inner join order_items oi
on o.order_id = oi.order_id
inner join sellers s
on oi.seller_id = s.seller_id
where o.order_status = 'delivered'
and s.seller_state = 'SP'
group by c.customer_state
having count(distinct o.order_id) >= 50
order by late_percentage desc;

select s.seller_state,
c.customer_state,
count(distinct o.order_id) as total_delivered_orders,
count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_orders,
round(count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0/ count(distinct o.order_id),2) as late_percentage
from sellers s
inner join order_items oi
on s.seller_id = oi.seller_id
inner join orders o
on oi.order_id = o.order_id
inner join customers c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
group by s.seller_state, c.customer_state
having count(distinct o.order_id) >= 75
order by late_percentage desc;

select s.seller_state,
count(distinct o.order_id) as total_orders,
round(avg(o.processing_time_hours), 2) as average_processing_hours,
count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_orders,
round(count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0/ count(distinct o.order_id),2) as late_percentage
from sellers s
inner join order_items oi
on s.seller_id = oi.seller_id
inner join orders o
on oi.order_id = o.order_id
where o.order_status = 'delivered'
group by s.seller_state
order by late_percentage desc;

select
    s.seller_state,
    count(distinct o.order_id) as total_delivered_orders,
    round(avg(o.delivery_delay_days), 2) as average_delay,
    count(distinct case when o.delivery_delay_days > 0 then o.order_id end) as late_orders,
    round(
        count(distinct case when o.delivery_delay_days > 0 then o.order_id end) * 100.0
        / count(distinct o.order_id),
        2
    ) as late_percentage
from sellers s
inner join order_items oi
    on s.seller_id = oi.seller_id
inner join orders o
    on oi.order_id = o.order_id
where o.order_status = 'delivered'
group by s.seller_state
order by average_delay desc;