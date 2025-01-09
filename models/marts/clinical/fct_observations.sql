with observations as (
    select * from {{ ref('stg_observations') }}
),

final as (
    select 
        observation_id,
        patient_id,
        status,
        category_code,
        category_display,
        observation_code,
        observation_name,
        effective_date,
        value_quantity,
        value_unit,
        current_timestamp() as dbt_loaded_at
    from observations
)

select * from final
