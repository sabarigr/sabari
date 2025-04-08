{% snapshot snap_orders %}
    {{
        config(
            target_schema='DBT_SSUKRAJ',
            target_database='TRAINING_DS',
            unique_key='order_id',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}

    select * from {{ source('TRAINING_DS', 'orders') }}
 {% endsnapshot %}