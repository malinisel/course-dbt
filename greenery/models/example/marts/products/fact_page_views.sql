with events as
(
    select * from {{ref('stg_postgres__events')}}
),

order_items as
(
    select * from {{ref('stg_postgres__order_items')}}
),

session_time as 
(
select * from {{ref('int_session_timings')}}
)
{% set event_types = dbt_utils.get_column_values(table=ref('stg_postgres__events'), column='event_type') %}

select 

e.session_id, 
e.user_id,
coalesce(e.product_id, i.product_id) as product_id,
--e.product_name,
session_start_dtm,
session_end_dtm,
{% for event_type in event_types %}
{{ sum_of ('e.event_type', event_type) }} as {{ event_type }}s,
{% endfor %}
/* sum(case when e.event_type = 'page_view' then 1 else 0 end) as page_views,
sum(case when e.event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts,
sum(case when e.event_type = 'checkout' then 1 else 0 end) as checkouts,
sum(case when e.event_type = 'package_shipped' then 1 else 0 end) as packages_shipped, */
datediff('minute',session_start_dtm,session_end_dtm) as session_length_minutes

from events e
left outer join order_items i 
on i.order_item_id=e.order_id
left outer join session_time s 
on s.session_id=e.session_id
group by 1,2,3,4,5
