select 
session_id,
min(created_dtm) as session_start_dtm,
max(created_dtm) as session_end_dtm
from {{ref('stg_postgres__events')}}
group by 1