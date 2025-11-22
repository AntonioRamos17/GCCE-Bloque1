
  create view "ods_db"."public"."m_turismo_vivienda_anyo__dbt_tmp"
    
    
  as (
    with turistas_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    codigo_isla,
    nombre_isla,
    sum(n_turistas) as n_turistas
  from "ods_db"."public"."f_turistas_isla_mes"
  group by anyo, codigo_isla, nombre_isla
),

vivienda_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    codigo_isla,
    avg(valor_medicion) as precio_m2_medio
  from "ods_db"."public"."stg_valor_vivienda_m2"
  group by anyo, codigo_isla
),

carencia_anyo as (
  select
    extract(year from fecha_aproximada)::int as anyo,
    codigo_isla,
    avg(valor_medicion) as carencia_bienes_vivienda
  from "ods_db"."public"."stg_carencia_bienes_vivienda"
  group by anyo, codigo_isla
)

select
  t.anyo,
  t.codigo_isla,
  t.nombre_isla,
  t.n_turistas,
  v.precio_m2_medio,
  c.carencia_bienes_vivienda,
  ln(nullif(t.n_turistas, 0))           as log_turistas,
  ln(nullif(v.precio_m2_medio, 0))      as log_precio_m2,
  ln(nullif(c.carencia_bienes_vivienda, 0)) as log_carencia
from turistas_anyo t
left join vivienda_anyo v
  on t.anyo = v.anyo
 and t.codigo_isla = v.codigo_isla
left join carencia_anyo c
  on t.anyo = c.anyo
 and t.codigo_isla = c.codigo_isla
order by t.anyo
  );