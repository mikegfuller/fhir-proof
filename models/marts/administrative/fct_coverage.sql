with coverage as (
    select * from {{ ref('stg_coverage') }}
),

final as (
    select 
        coverage_id,
        subscriber_id,
        beneficiary_id,
        status,
        coverage_type_code,
        coverage_type_display,
        dependent,
        relationship_code,
        period_start,
        period_end,
        payor_display,
        class_code,
        class_value,
        class_name,
        current_timestamp() as dbt_loaded_at
    from coverage
)

select * from final
