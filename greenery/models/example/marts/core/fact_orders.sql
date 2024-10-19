with orders as
(
    select * from {{ref('stg_postgres__orders')}}
),

addresses as
(
    select * from {{ref('stg_postgres__addresses')}}
),

products_in_orders as 
(
    select 
    order_item_id as order_id,
    count(product_id) as products_in_orders
from {{ref('stg_postgres__order_items')}}
group by 1
)

select 
o.order_id,
o.user_id,
o.PROMO_ID,
o.ADDRESS_ID,
a.country,
a.state,
o.created_dtm,
o.ORDER_COST,
o.SHIPPING_COST,
o.ORDER_TOTAL,
o.TRACKING_ID,
o.SHIPPING_SERVICE,
o.estimated_delivery_dtm,
o.delivered_dtm,
o.STATUS as order_status,
p.products_in_orders

from orders o 
left outer join addresses a 
on a.ADDRESS_ID=o.ADDRESS_ID
left outer join products_in_orders p 
on p.order_id = o.order_id