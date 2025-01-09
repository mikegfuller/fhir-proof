with procedures as (
    select * from {{ ref('stg_procedures') }}
),

final as (
    select 
        procedure_id,
        patient_id,
        performer_id,
        location_id,
        status,
        procedure_code,
        procedure_name,
        performed_date,
        performer_display,
        location_display,
        outcome,
        current_timestamp() as dbt_loaded_at
    from procedures
)

select * from final
