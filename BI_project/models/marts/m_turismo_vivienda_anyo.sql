with turistas_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    codigo_isla,
    nombre_isla,
    sum(n_turistas) as n_turistas
  from {{ ref('f_turistas_isla_mes') }}
  group by anyo, codigo_isla, nombre_isla
),

vivienda_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    codigo_isla,
    avg(valor_medicion) as precio_m2_medio
  from {{ ref('stg_valor_vivienda_m2') }}
  group by anyo, codigo_isla
),

carencia_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    codigo_isla,
    avg(valor_medicion) as carencia_bienes_vivienda
  from {{ ref('stg_carencia_bienes_vivienda') }}
  group by anyo, codigo_isla
),

joined as (
  select
    t.anyo,
    t.codigo_isla,
    t.nombre_isla,
    t.n_turistas,
    v.precio_m2_medio,
    c.carencia_bienes_vivienda
  from turistas_anyo t
  left join vivienda_anyo v
    on t.anyo = v.anyo
   and t.codigo_isla = v.codigo_isla
  left join carencia_anyo c
    on t.anyo = c.anyo
   and t.codigo_isla = c.codigo_isla
)

select
  anyo,
  codigo_isla,
  nombre_isla,
  n_turistas,
  precio_m2_medio,
  carencia_bienes_vivienda,

  -- Min-max global turistas
  (n_turistas
    - min(n_turistas) over ()
  )
  / nullif(
      max(n_turistas) over () - min(n_turistas) over (),
      0
    ) as n_turistas_minmax,

  -- Min-max global precio m2
  (precio_m2_medio
    - min(precio_m2_medio) over ()
  )
  / nullif(
      max(precio_m2_medio) over () - min(precio_m2_medio) over (),
      0
    ) as precio_m2_medio_minmax,

  -- Min-max global carencia
  (carencia_bienes_vivienda
    - min(carencia_bienes_vivienda) over ()
  )
  / nullif(
      max(carencia_bienes_vivienda) over () - min(carencia_bienes_vivienda) over (),
      0
    ) as carencia_bienes_vivienda_minmax

from joined
order by anyo;
