-- my_incremental_model.sql

WITH source_data AS (
    SELECT 
        PLAYERID,        -- Renamed from order_id to PLAYERID
        YEAR,            -- Renamed from product_name to YEAR
        STINT,           -- Renamed from status to STINT
        TMID,            -- Renamed from price to TMID
        LGID,            -- Renamed from created_at to LGID
        POS,             -- Renamed from updated_at to POS
        -- Set current flag to 'Y' for active records (updated within the last 7 days)
        CASE 
            WHEN updated_at >= CURRENT_DATE - INTERVAL '7 DAY' THEN 'Y'
            ELSE 'N'
        END AS current_flag
    FROM {{ source('HOCKEY', 'SCORING') }}  -- Replace with your actual source table
),

-- This CTE will be used to find existing records in the target table
existing_data AS (
    SELECT 
        PLAYERID,        -- Renamed from order_id to PLAYERID
        YEAR,            -- Renamed from product_name to YEAR
        STINT,           -- Renamed from status to STINT
        TMID,            -- Renamed from price to TMID
        LGID,            -- Renamed from created_at to LGID
        POS,             -- Renamed from updated_at to POS
        current_flag
    FROM {{ ref('STG_SCORING') }}  -- Replace with the actual target table in DBT
)

-- Main logic: Merge new data (from source) with existing data (in the target table)
SELECT 
    s.PLAYERID,     -- Renamed from order_id to PLAYERID
    s.YEAR,         -- Renamed from product_name to YEAR
    s.STINT,        -- Renamed from status to STINT
    s.TMID,         -- Renamed from price to TMID
    s.LGID,         -- Renamed from created_at to LGID
    s.POS,          -- Renamed from updated_at to POS
    s.current_flag
FROM source_data s

{% if is_incremental() %}

-- For incremental models, only update records that have changed, or are newly added
LEFT JOIN existing_data e
    ON s.PLAYERID = e.PLAYERID  -- Match on PLAYERID
WHERE s.current_flag = 'Y'  -- Only include records marked as 'Y' for active
  AND (
      e.PLAYERID IS NULL  -- New records that do not exist in the target table
      OR s.updated_at > e.updated_at  -- Updated records (change in updated_at)
  )

{% else %}

-- For full refresh (initial run), select all records
SELECT 
    s.PLAYERID,     -- Renamed from order_id to PLAYERID
    s.YEAR,         -- Renamed from product_name to YEAR
    s.STINT,        -- Renamed from status to STINT
    s.TMID,         -- Renamed from price to TMID
    s.LGID,         -- Renamed from created_at to LGID
    s.POS,          -- Renamed from updated_at to POS
    s.current_flag
FROM source_data s

{% endif %}
