{{
  config(
    materialized='view'
  )
}}

WITH products AS (
SELECT 
    product_id,
    name,
    price,
    inventory
FROM {{ source('postgres', 'products') }}
),

order_items AS (
    SELECT        
        order_id,
        product_id,
        quantity    
FROM {{ source('postgres', 'order_items') }}
),

events AS (
    SELECT        
    event_id,
    session_id,
    user_id,
    page_url,
    created_at,
    event_type,
    order_id,
    product_id   
    FROM {{ source('postgres', 'events') }}
),
orders AS (  
    SELECT 
        order_id,
        user_id,
        promo_id,
        address_id,
        created_at,
        order_cost,
        shipping_cost,
        order_total,
        tracking_id,
        shipping_service,
        estimated_delivery_at,
        delivered_at,
        status
    FROM {{ source('postgres', 'orders') }}
),
purchase_sessions_by_product AS (
    SELECT 
        DISTINCT oi.product_id,
        COUNT (DISTINCT e.session_id) AS purchase_sessions
    FROM events e
    JOIN orders o
        ON o.order_id = e.order_id
    JOIN order_items oi
        ON oi.order_id = o.order_id           
    WHERE 
        e.event_type = 'checkout'
        AND e.order_id IS NOT NULL
    GROUP BY 1
),
overallsessionbyproducts as 
(
SELECT 
        DISTINCT e.product_id,
        COUNT (DISTINCT e.session_id) AS overall_sessions
    FROM events e           
    WHERE 
    e.event_type='page_view' and 
        e.product_id IS NOT NULL
    GROUP BY 1
)
select p.product_id,
    p.name as product_name,
    p.price,
    p.inventory,
    sum(oi.quantity) as total_quantity_ordered,
    round((round((psp.purchase_sessions/osp.overall_sessions),2)* 100)) as conversion_rate_product

    from products p
    left outer join
    order_items oi
    on p.product_id=oi.product_id
    left outer join 
    overallsessionbyproducts osp
    on p.product_id=osp.product_id
    left outer join
    purchase_sessions_by_product psp
    on p.product_id=psp.product_id
    group by all