{{
  config(
    materialized='view'
  )
}}

with purchase_sessions as (
select 'cnt' as key, count(distinct session_id) as purchase_event_session_count
from {{ ref('stg_postgres__events') }} 
where event_type='checkout' and order_id is not null
group by 1
),

overall_sessions as (
select 'cnt' as key, count(distinct session_id) as total_session_count
from {{ ref('stg_postgres__events') }}
group by 1
)
select 
ds.purchase_event_session_count, 
os.total_session_count,
round((round((ds.purchase_event_session_count/os.total_session_count),2)* 100)) as overall_conversion_rate
from purchase_sessions ds
left outer join
overall_sessions os
on ds.key=os.key