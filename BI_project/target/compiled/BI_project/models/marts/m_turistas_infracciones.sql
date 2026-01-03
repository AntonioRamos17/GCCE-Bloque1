with infrac as (
    select
        anyo,
        codigo_isla,
        nombre_isla,
        n_turistas as n_turistas,
        n_infracciones_ambientales
    from "ods_db"."schema.yml"."m_turistas_infracciones_año"
)

select
    anyo,
    codigo_isla,
    nombre_isla,
    n_turistas,
    n_infracciones_ambientales,
    -- Min-max global turistas
    (n_turistas
        - min(n_turistas) over ()
    )
    / nullif(
        max(n_turistas) over () - min(n_turistas) over (),
        0
    ) as n_turistas_minmax,

    -- Min-max global infracciones ambientales
    (n_infracciones_ambientales
        - min(n_infracciones_ambientales) over ()
    )
    / nullif(
        max(n_infracciones_ambientales) over () - min(n_infracciones_ambientales) over (),
        0
    ) as n_infracciones_minmax

from infrac
order by anyo, codigo_isla