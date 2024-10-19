with 
users as (
    select * from {{ref('stg_postgres__users')}}
),

user_orders as (
    select 
    user_id, 
    min(created_dtm) as first_order_created_dtm,
    max(created_dtm) as last_order_created_dtm,
    sum(ORDER_COST) as total_spend,
    count(ORDER_ID) as orders
     from {{ref('stg_postgres__orders')}}
     group by 1
),

products_purchased as (
    select
    o.user_id, 
    count(i.product_id) as products_purchased
    from {{ref('stg_postgres__order_items')}} i
    left outer join
    {{ref('stg_postgres__orders')}} o
    on o.order_id=i.order_item_id
    group by 1
)

select
u.user_id,
o.orders is not null as is_buyer,
coalesce(o.orders,0) >= 2 as is_frequent_buyer,
o.first_order_created_dtm,
o.last_order_created_dtm,
o.orders,
coalesce(o.total_spend,0) as total_spend,
coalesce(p.products_purchased,0) as products_purchased

from users u 
left outer join user_orders o 
on o.user_id=u.user_id
left outer join products_purchased p 
on p.user_id=u.user_id