{{config(
    materialized='table'
)

}}

select
ORDER_ID ,
	USER_ID ,
	PROMO_ID ,
	ADDRESS_ID ,
	CREATED_AT as created_dtm,
	ORDER_COST ,
	SHIPPING_COST ,
	ORDER_TOTAL ,
	TRACKING_ID ,
	SHIPPING_SERVICE ,
	ESTIMATED_DELIVERY_AT as estimated_delivery_dtm,
	DELIVERED_AT delivered_dtm,
	STATUS 
    
FROM {{source('postgres','orders')}}