{{
    config(
        materialized='ephemeral'
    )
}}

with eph_check as (
    select * from {{ ref('stg_coeches') }}
)

select * from eph_check