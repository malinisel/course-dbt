{{config(
    materialized='table'
)

}}

select
user_id,
first_name, 
last_name,
email,
phone_number,
created_at as user_created_dtm,
updated_at as user_updated_dtm,
address_id
    
FROM {{source('postgres','users')}}