with base as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    v.codigo_parque,
    v.valor_medicion::numeric as n_visitantes
  from "ods_db"."public"."stg_visitantes_espacios_naturales" v
)

select
  anyo,
  p.codigo_parque,
  sum(n_visitantes) as n_visitantes
from base b
left join "ods_db"."public"."dim_parque" p
  on b.codigo_parque = p.codigo_parque
group by anyo, p.codigo_parque