{{
    config(
        materialized='incremental',
        unique_key = 'COACHID'
    )
}}

select * from {{ ref('stg_coeches') }}