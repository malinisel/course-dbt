{{config(
    materialized='table'
)

}}

select
order_id as order_item_id,
product_id, 
quantity
    
FROM {{source('postgres','order_items')}}