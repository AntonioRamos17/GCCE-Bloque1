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

infracciones_ambientales_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    codigo_isla,
    nombre_isla,
    sum(n_infracciones_ambientales) as n_infracciones_ambientales
  from {{ ref('f_infracciones_ambientales_mes') }}
  group by anyo, codigo_isla, nombre_isla
  having extract(year from fecha_aproximada)::int >= 2010
     and extract(year from fecha_aproximada)::int <= 2024
     and codigo_isla like '%ES70'
),

joined as (
  select
    t.anyo,
    t.codigo_isla,
    t.nombre_isla,
    t.n_turistas,
    i.n_infracciones_ambientales
  from turistas_anyo t
  full join infracciones_ambientales_anyo i
    on t.anyo = i.anyo
   -- si quieres que matchee también por isla:
   -- and t.codigo_isla = i.codigo_isla
   -- and t.nombre_isla = i.nombre_isla
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
      max(n_infracciones_ambientales) over ()
      - min(n_infracciones_ambientales) over (),
      0
    ) as n_infracciones_ambientales_minmax

from joined;
