with aguas as (
    select
        anyo,
        codigo_isla,
        nombre_isla,
        n_turistas,
        v_aguas_residuales
    from "ods_db"."public"."m_aguas_turistas"
),

infrac as (
  select
    anyo,
    codigo_isla,
    nombre_isla,
    n_turistas as n_turistas_infrac,
    n_infracciones_ambientales
  from "ods_db"."public"."m_turistas_infracciones_año"
)

select
  coalesce(a.anyo, i.anyo) as anyo,
  coalesce(a.codigo_isla, i.codigo_isla) as codigo_isla,
  coalesce(a.nombre_isla, i.nombre_isla) as nombre_isla,

  -- Turistas (si viene de ambos sitios, preferimos el de aguas, pero deberían coincidir)
  coalesce(a.n_turistas, i.n_turistas_infrac) as n_turistas,

  a.v_aguas_residuales,
  i.n_infracciones_ambientales,

  ln(nullif(coalesce(a.n_turistas, i.n_turistas_infrac), 0))      as log_turistas,
  ln(nullif(a.v_aguas_residuales, 0))                             as log_aguas_residuales,
  ln(nullif(i.n_infracciones_ambientales, 0))                     as log_infracciones
from aguas a
full join infrac i
  on a.anyo = i.anyo
 and a.codigo_isla = i.codigo_isla
 order by a.anyo