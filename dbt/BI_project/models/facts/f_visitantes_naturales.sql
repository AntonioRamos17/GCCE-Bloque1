with base as (
    select
        coalesce(b.island_code, 'ES70') as island_code,
        v.year,
        sum(v.obs_value) as visitantes_naturales
    from {{ ref('stg_visitantes_espacios_naturales') }} v
    left join {{ ref('bridge_space_island') }} b
        on upper(v.space_code) = upper(b.space_code)
    where v.obs_value is not null
    group by 1,2
)
select
    i.island_name,
    b.island_code,
    b.year,
    b.visitantes_naturales
from base b
left join {{ ref('dim_isla') }} i using (island_code)