{{config(
    materialized='table'
)

}}

select
event_id, 
session_id,
user_id,
page_url, 
created_at as created_dtm,
event_type,
order_id,
product_id
    
FROM {{source('postgres','events')}}