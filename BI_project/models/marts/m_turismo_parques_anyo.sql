with turistas_anyo_canarias as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    sum(n_turistas) as n_turistas_canarias
  from {{ ref('f_turistas_isla_mes') }}
  group by anyo
),

visitantes_parques_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    sum(valor_medicion)::numeric as n_visitantes_parques
  from {{ ref('stg_visitantes_espacios_naturales') }}
  group by anyo
),

joined as (
  select
    t.anyo,
    t.n_turistas_canarias,
    v.n_visitantes_parques,
    (v.n_visitantes_parques::numeric / nullif(t.n_turistas_canarias, 0)) as visitantes_parques_por_turista
  from turistas_anyo_canarias t
  left join visitantes_parques_anyo v
    on t.anyo = v.anyo
)

select
  anyo,
  n_turistas_canarias,
  n_visitantes_parques,
  visitantes_parques_por_turista,

  -- Min-max global turistas Canarias
  (n_turistas_canarias
    - min(n_turistas_canarias) over ()
  )
  / nullif(
      max(n_turistas_canarias) over () - min(n_turistas_canarias) over (),
      0
    ) as n_turistas_canarias_minmax,

  -- Min-max global visitantes parques
  (n_visitantes_parques
    - min(n_visitantes_parques) over ()
  )
  / nullif(
      max(n_visitantes_parques) over () - min(n_visitantes_parques) over (),
      0
    ) as n_visitantes_parques_minmax,

  -- Min-max global ratio visitantes/ turista
  (visitantes_parques_por_turista
    - min(visitantes_parques_por_turista) over ()
  )
  / nullif(
      max(visitantes_parques_por_turista) over ()
      - min(visitantes_parques_por_turista) over (),
      0
    ) as visitantes_parques_por_turista_minmax

from joined
order by anyo;
