with aguas as (
    select
        anyo,
        codigo_isla,
        nombre_isla,
        n_turistas,
        v_aguas_residuales
    from {{ ref('m_aguas_turistas') }}
),

infrac as (
    select
        anyo,
        codigo_isla,
        nombre_isla,
        n_turistas as n_turistas_infrac,
        n_infracciones_ambientales
    from {{ ref('m_turistas_infracciones_año') }}
),

joined as (
    select
        coalesce(a.anyo, i.anyo)          as anyo,
        coalesce(a.codigo_isla, i.codigo_isla) as codigo_isla,
        coalesce(a.nombre_isla, i.nombre_isla) as nombre_isla,

        -- Turistas (si viene de ambos sitios, preferimos el de aguas, pero deberían coincidir)
        coalesce(a.n_turistas, i.n_turistas_infrac) as n_turistas,

        a.v_aguas_residuales,
        i.n_infracciones_ambientales
    from aguas a
    full join infrac i
      on a.anyo = i.anyo
     and a.codigo_isla = i.codigo_isla
)

select
    anyo,
    codigo_isla,
    nombre_isla,
    n_turistas,
    v_aguas_residuales,
    n_infracciones_ambientales,

    -- Min-max global turistas
    (n_turistas
        - min(n_turistas) over ()
    )
    / nullif(
        max(n_turistas) over () - min(n_turistas) over (),
        0
    ) as n_turistas_minmax,

    -- Min-max global aguas residuales
    (v_aguas_residuales
        - min(v_aguas_residuales) over ()
    )
    / nullif(
        max(v_aguas_residuales) over () - min(v_aguas_residuales) over (),
        0
    ) as v_aguas_residuales_minmax,

    -- Min-max global infracciones ambientales
    (n_infracciones_ambientales
        - min(n_infracciones_ambientales) over ()
    )
    / nullif(
        max(n_infracciones_ambientales) over () - min(n_infracciones_ambientales) over (),
        0
    ) as n_infracciones_minmax

from joined
order by anyo, codigo_isla;
