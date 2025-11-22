with turistas_anyo as (
    select
      extract(year from fecha_aproximada)::int as anyo,
      codigo_isla,
      nombre_isla,
      sum(n_turistas) as n_turistas
    from {{ ref('f_turistas_isla_mes') }}
    group by anyo, codigo_isla, nombre_isla
),

afiliaciones_anyo as (
    select
      extract(year from fecha_aproximada)::int as anyo,
      codigo_isla,
      sum(valor_medicion) as n_afiliaciones_turismo
    from {{ ref('stg_afiliaciones_turismo') }}
    group by anyo, codigo_isla
),

joined as (
    select
      t.anyo,
      t.codigo_isla,
      t.nombre_isla,
      t.n_turistas,
      a.n_afiliaciones_turismo,
      (a.n_afiliaciones_turismo::numeric / nullif(t.n_turistas, 0)) as afiliaciones_por_turista
    from turistas_anyo t
    left join afiliaciones_anyo a
      on t.anyo = a.anyo
     and t.codigo_isla = a.codigo_isla
)

select
  anyo,
  codigo_isla,
  nombre_isla,
  n_turistas,
  n_afiliaciones_turismo,
  afiliaciones_por_turista,

  -- Min-max global de turistas
  (n_turistas
    - min(n_turistas) over ()
  )
  / nullif(
      max(n_turistas) over () - min(n_turistas) over (),
      0
    ) as n_turistas_minmax,

  -- Min-max global de afiliaciones
  (n_afiliaciones_turismo
    - min(n_afiliaciones_turismo) over ()
  )
  / nullif(
      max(n_afiliaciones_turismo) over () - min(n_afiliaciones_turismo) over (),
      0
    ) as n_afiliaciones_minmax,

  -- Min-max global del ratio afiliaciones/turista
  (afiliaciones_por_turista
    - min(afiliaciones_por_turista) over ()
  )
  / nullif(
      max(afiliaciones_por_turista) over () - min(afiliaciones_por_turista) over (),
      0
    ) as afiliaciones_por_turista_minmax

from joined
order by anyo;
