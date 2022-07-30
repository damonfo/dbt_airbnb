
-- auto-incremental set up--
{{
    config(
        materialized = 'incremental',
        on_schema_change='fail'
    )
}}
-------------------------------
with src_reviews as (
    select * from {{ ref('src_reviews') }}
)
 
select 
    {{ dbt_utils.surrogate_key(['listing_id', 'review_date','review_text']) }} as review_id,  /*这个是扩展包里的surrogate_key*/
    * 
from src_reviews
where review_text is not null

--------------------------------
--tell pc how to incremental--

{% if is_incremental() %}
    and review_date > (select max(review_date) from {{ this }})
{% endif %}

