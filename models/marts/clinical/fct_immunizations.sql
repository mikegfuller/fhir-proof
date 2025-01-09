with immunizations as (
    select * from {{ ref('stg_immunizations') }}
),

final as (
    select 
        immunization_id,
        patient_id,
        vaccine_code,
        vaccine_name,
        status,
        occurrence_date,
        manufacturer,
        lot_number,
        expiration_date,
        site,
        route,
        dose_value,
        dose_unit,
        current_timestamp() as dbt_loaded_at
    from immunizations
)

select * from final
