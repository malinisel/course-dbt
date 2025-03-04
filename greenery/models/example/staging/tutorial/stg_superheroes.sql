{{config(
    materialized='table'
)

}}

select
id as superhero_id,
name, 
gender,
eye_color,
race,
    hair_color,
    NULLIF(height, -99) as height,
    publisher,
    skin_color,
    alignment,
    NULLIF(weight, -99) as weight,
    {{lbs_to_kgs('weight')}} as weight_in_kg
    
FROM {{source('tutorial','superheroes')}}