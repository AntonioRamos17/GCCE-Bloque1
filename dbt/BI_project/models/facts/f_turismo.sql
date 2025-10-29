with base as (
    select
        island_code,
        year,
        sum(obs_value) as turistas_totales
    from {{ ref('stg_turistas_recibidos') }}
    where measure_code in (
        'INTERPERIOD_PUNTUAL_RATE',
        'ANNUAL_PUNTUAL_RATE'
    )
    and obs_value is not null
    group by 1,2
)
select
    i.island_name,
    b.island_code,
    b.year,
    b.turistas_totales
from base b
left join {{ ref('dim_isla') }} i using (island_code)