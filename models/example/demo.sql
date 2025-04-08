

{{
    config(
        materialized='table'
    )
}}

with src as (
select * from {{ source('WALMART', 'DIM_CUST') }}
)

select * from src
