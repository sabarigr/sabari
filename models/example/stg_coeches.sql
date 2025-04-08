{{
    config(
        materialized='view'
    )
}}

select * from {{ source('HOCKEY', 'COACHES') }}