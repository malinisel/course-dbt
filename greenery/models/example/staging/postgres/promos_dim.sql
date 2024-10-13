{{config(
    materialized='table'
)

}}

select
promo_id, 
discount,
status
    
FROM {{source('postgres','promos')}}