
  create view "ods_db"."public"."f_infracciones_ambientales_mes__dbt_tmp"
    
    
  as (
    with base as (
  select
    ia.fecha_aproximada,
    ia.codigo_isla,
    i.nombre_isla,
    ia.valor_medicion::numeric as n_infracciones_ambientales
  from "ods_db"."public"."stg_infracciones_ambientales" ia
  join "ods_db"."public"."dim_isla" i
    on i.codigo_isla = ia.codigo_isla
  where ia.codigo_medida LIKE '%ABSOLUTE%'
  order by ia.codigo_isla, ia.fecha_aproximada
)
select
  fecha_aproximada,
  codigo_isla,
  nombre_isla,
  n_infracciones_ambientales
from base
  );