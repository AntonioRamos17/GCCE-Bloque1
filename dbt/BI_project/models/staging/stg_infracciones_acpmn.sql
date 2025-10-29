with base as (
    select
        nullif(trim(tipo_infraccion), '')                      as tipo_infraccion,
        upper(nullif(trim(tipo_infraccion_code), ''))          as tipo_infraccion_code,

        nullif(trim(territorio), '')                           as territorio_name,
        upper(nullif(trim(territorio_code), ''))               as territorio_code,

        nullif(trim(time_period::text), '')                    as time_period_txt,
        nullif(trim(time_period_code::text), '')
 as time_period_code_txt,

        nullif(trim(medidas), '')                              as medidas,
        upper(nullif(trim(medidas_code), ''))                  as medidas_code,

        cast(obs_value as numeric)                             as obs_value,

        nullif(trim(estado_observacion), '')                   as estado_observacion,
        nullif(trim(estado_observacion_code), '')              as estado_observacion_code,
        nullif(trim(confidencialidad_observacion), '')         as confidencialidad_observacion,
        nullif(trim(notas_observacion), '')                    as notas_observacion
    from {{ source('public', 'infracciones_acpmn') }}
),
t_norm as (
    select
        *,
        case
            when time_period_code_txt ~ '^\d{4}$' then time_period_code_txt::int
            when time_period_txt ~ '^\d{4}$'      then time_period_txt::int
            else null
        end as year
    from base
)
select
    -- geo (nivel Canarias o territorio agregado)
    territorio_name                               as region_name,
    territorio_code                               as region_code,   -- 'ES70' = Canarias

    -- tiempo anual
    year,
    to_date(coalesce(year, 0)::text || '-01-01','YYYY-MM-DD') as period_date,

    -- tipología y medidas
    tipo_infraccion,
    tipo_infraccion_code,
    medidas,
    medidas_code,

    -- valor
    obs_value,

    -- metadatos
    estado_observacion,
    estado_observacion_code,
    confidencialidad_observacion,
    notas_observacion
from t_norm
