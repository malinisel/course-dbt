What is our user repeat rate?
Repeat Rate = Users who purchased 2 or more times / users who purchased

select count_if(is_frequent_buyer)/count(*)
from fact_user_orders
where is_buyer= TRUE;

Answer: 0.798387

What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Likely - order counts of an user, repeat rate. Not likely to purchase - can be based on users whose sessions didnt move to purchase after page_view and adding to cart.
More data to introduce an user's purchase rate, time spent on a product in the page view.


Part 3. dbt Snapshots

Which products had their inventory change from week 1 to week 2? 

select * from DEV_DB.DBT_MALINISJOBSGMAILCOM.INVENTORY_SNAPSHOT where dbt_valid_to is not null
group by all;

Answer- Pothos
Philodendron
Monstera
String of pearls

Link to docs - https://8080-malinisel-coursedbt-vfk5fmcpfl1.ws-us116.gitpod.io/#!/overview/greenery
