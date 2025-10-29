with base as (
    select
        nullif(trim(geographical), '')                                   as raw_island_name,
        upper(nullif(trim(geographical_code), ''))                       as raw_island_code,
        time                                                             as time_year_int,
        time_code                                                        as time_code_int,
        nullif(trim(measure), '')                                        as measure,
        upper(nullif(trim(measure_code), ''))                            as measure_code,
        cast(obs_value as numeric)                                       as obs_value,
        nullif(trim(confidencialidad_observacion), '')                   as confidencialidad_observacion,
        nullif(trim(notas_observacion), '')                              as notas_observacion,
        nullif(trim(estado_observacion), '')                             as estado_observacion,
        nullif(trim(obs_conf), '')                                       as obs_conf
    from {{ source('public', 'infracciones_ambientales') }}
)
select
    -- normalización geo
    raw_island_name                                  as island_name,
    raw_island_code                                  as island_code,

    -- tiempo (prioriza TIME, con fallback a TIME_CODE)
    coalesce(time_year_int, time_code_int)::int      as year,
    to_date(coalesce(time_year_int, time_code_int)::text || '-01-01','YYYY-MM-DD') as period_date,

    -- medidas y valor
    measure,
    measure_code,
    obs_value,

    -- metadatos
    case when raw_island_code = 'ES70' then true else false end as is_canarias_total,
    confidencialidad_observacion,
    notas_observacion,
    estado_observacion,
    obs_conf
from base