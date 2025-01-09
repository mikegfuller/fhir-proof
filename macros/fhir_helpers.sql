{% macro extract_id(reference_field) %}
    split_part({{ reference_field }}, '/', -1)
{% endmacro %}

{% macro parse_coding(coding_array, index=0) %}
    object_construct(
        'system', {{ coding_array }}[{{ index }}]:system::string,
        'code', {{ coding_array }}[{{ index }}]:code::string,
        'display', {{ coding_array }}[{{ index }}]:display::string
    )
{% endmacro %}
