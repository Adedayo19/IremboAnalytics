-- This test fails if any staging table contains columns that could hold PII
-- (e.g. names, national IDs, emails, phone numbers).
-- Guards against future data changes accidentally introducing PII into the analytics layer.

{% set pii_patterns = [
    'name', 'first_name', 'last_name', 'full_name',
    'national_id', 'nid', 'id_number',
    'email', 'email_address',
    'phone', 'phone_number', 'mobile',
    'address', 'street', 'postal_code',
    'date_of_birth', 'dob', 'birth_date'
] %}

{% set staging_models = [
    ref('stg_users'),
    ref('stg_voice_sessions'),
    ref('stg_voice_turns'),
    ref('stg_voice_ai_metrics'),
    ref('stg_applications')
] %}

{% set ns = namespace(queries=[]) %}

{% for model in staging_models %}
    {% set columns = adapter.get_columns_in_relation(model) %}
    {% for col in columns %}
        {% if col.name.lower() in pii_patterns %}
            {% set _ = ns.queries.append(
                "SELECT '" ~ model ~ "' AS model_name, '" ~ col.name ~ "' AS column_name"
            ) %}
        {% endif %}
    {% endfor %}
{% endfor %}

{% if ns.queries | length > 0 %}
    {{ ns.queries | join(' UNION ALL ') }}
{% else %}
    SELECT NULL AS model_name, NULL AS column_name WHERE 1 = 0
{% endif %}