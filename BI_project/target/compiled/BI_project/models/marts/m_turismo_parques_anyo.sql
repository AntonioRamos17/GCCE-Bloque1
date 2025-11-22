with turistas_anyo_canarias as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    sum(n_turistas) as n_turistas_canarias
  from "ods_db"."public"."f_turistas_isla_mes"
  group by anyo
),

visitantes_parques_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    sum(valor_medicion)::numeric as n_visitantes_parques
  from "ods_db"."public"."stg_visitantes_espacios_naturales"
  group by anyo
)

select
  t.anyo,
  t.n_turistas_canarias,
  v.n_visitantes_parques,
  (v.n_visitantes_parques::numeric / nullif(t.n_turistas_canarias, 0)) as visitantes_parques_por_turista,
  ln(nullif(t.n_turistas_canarias, 0))    as log_turistas_canarias,
  ln(nullif(v.n_visitantes_parques, 0))   as log_visitantes_parques
from turistas_anyo_canarias t
left join visitantes_parques_anyo v
  on t.anyo = v.anyo