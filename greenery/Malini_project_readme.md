--Malini Selvam Week 1 Project questions

--How many users do we have?

select count(distinct user_id) from
users_dim; -- Answer is 130

--On average, how many orders do we receive per hour?

with orders_per_hour as
(
select date_trunc(hour, created_dtm), count(distinct(order_id)) as numberoforders 
from orders_dim
group by all
)

select avg(numberoforders) from orders_per_hour;
--answer is 7.520833

--On average, how long does an order take from being placed to being delivered?

with ordertime
as
(
select order_id, datediff('day',created_dtm, delivered_dtm) as numberofdays-- count(distinct(order_id)) as numbersofdays
from 
orders_dim
group by order_id, created_dtm, delivered_dtm
)

select avg(numberofdays) from ordertime;
--answer 3.891803

--On average, how many unique sessions do we have per hour?
with uniqsessionhour as
(

select date_trunc('hour', created_dtm) as session_day_hour, count(distinct(event_id)) as uniquesessions,
       
from events_dim
group by all
)
select avg(uniquesessions) from uniqsessionhour;
--answer is 61.258621

--How many users have only made one purchase? Two purchases? Three+ purchases?
--Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.


select count(*) from
(select distinct user_id, count(distinct order_id) as ordercount-- o.user_id, e.product_id

from orders_dim 

group by (user_id)
order by count(distinct order_id) desc)
where ordercount=1;
--answer is 25

select count(*) from
(select distinct user_id, count(distinct order_id) as ordercount-- o.user_id, e.product_id

from orders_dim 

group by (user_id)
order by count(distinct order_id) desc)
where ordercount=2;
--answer is 28

select count(*) from
(select distinct user_id, count(distinct order_id) as ordercount-- o.user_id, e.product_id

from orders_dim 

group by (user_id)
order by count(distinct order_id) desc)
where ordercount >=3;

--answer is 71
