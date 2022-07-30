{{
    config(
        materialized = 'table',
    )
}}

with fct_reviews as (
    select * from {{ ref('fct_reviews') }}
),
full_moon_dates as (
    select * from {{ ref('seed_full_moon_dates') }}
)
 
select
    r.*,
    CASE
        when fm.full_moon_date is null then 'not full moon'
        else 'full moon'
    end as is_full_moon


from 
    fct_reviews r
left join full_moon_dates fm 
on (TO_DATE(r.review_date) = DATEADD(day, 1, fm.full_moon_date))   -- 加一秒钟 DATEADD(second, 1, '2019-12-31 23:59:59') result
                                                                    -- to_date() 去掉了原来的时间只留下日期     

