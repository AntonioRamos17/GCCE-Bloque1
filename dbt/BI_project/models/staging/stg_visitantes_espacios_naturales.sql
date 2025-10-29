with base as (
    select
        nullif(trim(medidas), '')                                 as medidas,
        upper(nullif(trim(medidas_code), ''))                     as medidas_code,

        nullif(trim(espacio_natural_protegido), '')               as space_name,
        upper(nullif(trim(espacio_natural_protegido_code), ''))   as space_code,

        nullif(trim(time_period::text), '')                       as time_period_txt,
        nullif(trim(time_period_code::text), '')                  as time_period_code_txt,

        cast(obs_value as numeric)                                as obs_value,

        nullif(trim(periodo_recogida), '')                        as periodo_recogida,
        nullif(trim(confidencialidad_observacion), '')            as confidencialidad_observacion,
        nullif(trim(estado_observacion), '')                      as estado_observacion,
        nullif(trim(estado_observacion_code), '')                 as estado_observacion_code,
        nullif(trim(notas_observacion), '')                       as notas_observacion
    from {{ source('public', 'visitantes_espacios_naturales') }}
),
t_norm as (
    select
        *,
        -- año (anual según muestra)
        case
            when time_period_code_txt ~ '^\d{4}$' then time_period_code_txt::int
            when time_period_txt ~ '^\d{4}$'      then time_period_txt::int
            else null
        end as year
    from base
)
select
    -- espacio protegido (se mapeará a isla más adelante usando un bridge/mapping)
    space_name,
    space_code,

    -- tiempo anual
    year,
    to_date(coalesce(year, 0)::text || '-01-01','YYYY-MM-DD') as period_date,

    -- medida/valor
    medidas,
    medidas_code,
    obs_value,

    -- metadatos
    periodo_recogida,
    confidencialidad_observacion,
    estado_observacion,
    estado_observacion_code,
    notas_observacion
from t_norm