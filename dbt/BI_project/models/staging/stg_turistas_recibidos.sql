with base as (
    select
        nullif(trim(geographical), '')                 as raw_island_name,
        upper(nullif(trim(geographical_code), ''))     as raw_island_code,
        nullif(trim(time), '')                         as time_txt,        -- suele venir como '2025-08' o '2025M08' según extracto
        nullif(trim(time_code::text), '')              as time_code_txt,   -- texto por seguridad
        nullif(trim(measure), '')                      as measure,
        upper(nullif(trim(measure_code), ''))          as measure_code,
        cast(obs_value as numeric)                     as obs_value,
        nullif(trim(confidencialidad_observacion), '') as confidencialidad_observacion,
        nullif(trim(notas_observacion), '')            as notas_observacion,
        nullif(trim(estado_observacion), '')           as estado_observacion,
        nullif(trim(obs_conf), '')                     as obs_conf
    from {{ source('public', 'turistas_recibidos') }}
),
t_norm as (
    -- Normaliza año/mes desde TIME/TIME_CODE en formatos posibles: 'YYYY-MM', 'YYYYMMM', 'YYYYMM', 'YYYY'
    select
        *,
        coalesce(time_txt, time_code_txt)                          as t_any,

        -- YEAR
        case
            when coalesce(time_txt, time_code_txt) ~ '^\d{4}-\d{2}$'           then left(coalesce(time_txt, time_code_txt), 4)
            when coalesce(time_txt, time_code_txt) ~ '^\d{4}M\d{2}$'           then left(coalesce(time_txt, time_code_txt), 4)
            when coalesce(time_txt, time_code_txt) ~ '^\d{6}$'                 then left(coalesce(time_txt, time_code_txt), 4)
            when coalesce(time_txt, time_code_txt) ~ '^\d{4}$'                 then coalesce(time_txt, time_code_txt)
            else null
        end::int                                                      as year,

        -- MONTH (si no hay mes, null)
        case
            when coalesce(time_txt, time_code_txt) ~ '^\d{4}-\d{2}$' then right(coalesce(time_txt, time_code_txt), 2)
            when coalesce(time_txt, time_code_txt) ~ '^\d{4}M\d{2}$' then right(coalesce(time_txt, time_code_txt), 2)
            when coalesce(time_txt, time_code_txt) ~ '^\d{6}$'       then right(coalesce(time_txt, time_code_txt), 2)
            else null
        end::int                                                      as month
    from base
)
select
    -- geo
    raw_island_name                              as island_name,
    raw_island_code                              as island_code,

    -- tiempo mensual + fecha periodo (primer día del mes si hay month; si no, 1 enero)
    year,
    month,
    case when month is not null
         then to_date(year::text || '-' || lpad(month::text, 2, '0') || '-01','YYYY-MM-DD')
         else to_date(year::text || '-01-01','YYYY-MM-DD')
    end                                           as period_date,

    -- medidas y valor (sin filtrar; filtrarás aguas arriba)
    measure,
    measure_code,
    obs_value,

    -- flags y metadatos
    (raw_island_code = 'ES70')                    as is_canarias_total,
    confidencialidad_observacion,
    notas_observacion,
    estado_observacion,
    obs_conf
from t_norm