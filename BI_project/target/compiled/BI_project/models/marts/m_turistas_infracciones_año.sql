with turistas_anyo as (
  select
  EXTRACT(YEAR FROM fecha_aproximada)::int as anyo,
  codigo_isla,
  nombre_isla,
  sum(n_turistas) as n_turistas
  from "ods_db"."public"."f_turistas_isla_mes"
  group by anyo, codigo_isla, nombre_isla
  having EXTRACT(YEAR FROM fecha_aproximada)::int >= 2010 and 
  EXTRACT(YEAR FROM fecha_aproximada)::int <= 2024 and
  codigo_isla LIKE '%ES70'
),

infracciones_ambientales_anyo as (
  select
  EXTRACT(YEAR FROM fecha_aproximada)::int as anyo,
  codigo_isla,
  nombre_isla,
  sum(n_infracciones_ambientales) as n_infracciones_ambientales
  from "ods_db"."public"."f_infracciones_ambientales_mes"
  group by anyo, codigo_isla, nombre_isla
  having EXTRACT(YEAR FROM fecha_aproximada)::int >= 2010 and 
  EXTRACT(YEAR FROM fecha_aproximada)::int <= 2024 and
  codigo_isla LIKE '%ES70'
)

select
  t.anyo,
  t.codigo_isla,
  t.nombre_isla,
  t.n_turistas as n_turistas,
  i.n_infracciones_ambientales as n_infracciones_ambientales,
  ln(t.n_turistas) as escalado_turistas,
  ln(i.n_infracciones_ambientales) as escalado_infracciones_ambientales
from turistas_anyo t
full join infracciones_ambientales_anyo i
on t.anyo = i.anyo