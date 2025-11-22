with turistas_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    codigo_isla,
    nombre_isla,
    sum(n_turistas) as n_turistas
  from {{ ref('f_turistas_isla_mes') }}
  group by anyo, codigo_isla, nombre_isla
  having extract(year from fecha_aproximada)::int >= 2010
     and extract(year from fecha_aproximada)::int <= 2024
     and codigo_isla like '%ES70'
),

aguas_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    codigo_isla,
    sum(valor_medicion) as v_aguas_residuales
  from {{ ref('stg_aguas_residuales') }}
  group by anyo, codigo_isla, codigo_medida
  having extract(year from fecha_aproximada)::int >= 2020
     and extract(year from fecha_aproximada)::int <= 2025
     and codigo_isla like '%ES70'
     and codigo_medida like '%VOLUMEN'
),

joined as (
  select
    t.anyo,
    t.codigo_isla,
    t.nombre_isla,
    t.n_turistas,
    a.v_aguas_residuales
  from turistas_anyo t
  full join aguas_anyo a
    on t.anyo = a.anyo
)

select
  anyo,
  codigo_isla,
  nombre_isla,
  n_turistas,
  v_aguas_residuales,

  -- Normalización min-max global de turistas
  (n_turistas
    - min(n_turistas) over ()
  )
  / nullif(
      max(n_turistas) over () - min(n_turistas) over (),
      0
    ) as n_turistas_minmax,

  -- Normalización min-max global de aguas residuales
  (v_aguas_residuales
    - min(v_aguas_residuales) over ()
  )
  / nullif(
      max(v_aguas_residuales) over () - min(v_aguas_residuales) over (),
      0
    ) as v_aguas_residuales_minmax

from joined;
