with base as (
  select
    tr.fecha_aproximada,
    tr.codigo_isla,
    i.nombre_isla,
    tr.valor_medicion::numeric as n_turistas
  from "ods_db"."public"."stg_turistas_recibidos" tr
  join "ods_db"."public"."dim_isla" i
    on i.codigo_isla = tr.codigo_isla
  where tr.codigo_medida LIKE '%ABSOLUTE%'
  order by tr.codigo_isla, tr.fecha_aproximada
  -- group by tr.fecha_aproximada, tr.codigo_isla, tr.codigo_medida, i.nombre_isla
  -- having tr.codigo_medida LIKE '%ABSOLUTE%'
)
select
  fecha_aproximada,
  codigo_isla,
  nombre_isla,
  n_turistas
from base