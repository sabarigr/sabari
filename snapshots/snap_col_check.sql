{% snapshot snap_col_check %}
    {{
        config(
           target_schema='DBT_SSUKRAJ',
            target_database='TRAINING_DS',
            unique_key='order_id',
            strategy='check',
            check_cols =['product_name','status','price']
        )
    }}

    select order_id,product_name,status,price from {{ ref('snap_orders') }}
 {% endsnapshot %}