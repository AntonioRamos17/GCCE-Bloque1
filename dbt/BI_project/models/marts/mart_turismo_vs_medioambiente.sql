with joined as (
    select
        i.island_name,
        i.island_code,
        t.year,

        -- Hechos agregados
        t.turistas_totales,
        v.visitantes_naturales,
        ia.infracciones_ambientales,
        im.infracciones_marinas,

        -- Métricas derivadas (ratios normalizados)
        round(ia.infracciones_ambientales / nullif(t.turistas_totales, 0), 6) as ratio_infracciones_turista,
        round(v.visitantes_naturales / nullif(t.turistas_totales, 0), 6) as ratio_visitantes_turista,
        round(im.infracciones_marinas / nullif(t.turistas_totales, 0), 6) as ratio_infracciones_marinas_turista

    from {{ ref('dim_isla') }} i
    left join {{ ref('f_turismo') }} t on i.island_code = t.island_code
    left join {{ ref('f_visitantes_naturales') }} v on i.island_code = v.island_code and t.year = v.year
    left join {{ ref('f_infracciones_ambientales') }} ia on i.island_code = ia.island_code and t.year = ia.year
    left join {{ ref('f_infracciones_acpmn') }} im on (i.island_code = 'ES70' and im.island_code = 'ES70' and t.year = im.year)
)
select
    island_name,
    island_code,
    year,

    turistas_totales,
    visitantes_naturales,
    infracciones_ambientales,
    infracciones_marinas,

    ratio_infracciones_turista,
    ratio_visitantes_turista,
    ratio_infracciones_marinas_turista

from joined