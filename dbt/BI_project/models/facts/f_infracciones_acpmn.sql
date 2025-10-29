select
    i.island_name,
    s.region_code as island_code,
    s.year,
    sum(s.obs_value) as infracciones_marinas
from {{ ref('stg_infracciones_acpmn') }} s
left join {{ ref('dim_isla') }} i on s.region_code = i.island_code
where s.medidas_code ilike '%VARIACION_ANUAL%'
and s.obs_value is not null
group by 1,2,3
