select
    i.island_name,
    s.island_code,
    s.year,
    sum(s.obs_value) as infracciones_ambientales
from {{ ref('stg_infracciones_ambientales') }} s
left join {{ ref('dim_isla') }} i using (island_code)
where s.measure_code in (
    'INTERPERIOD_PUNTUAL_RATE',
    'ANNUAL_PUNTUAL_RATE'
)
and s.obs_value is not null
group by 1,2,3