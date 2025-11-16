
  create view "ods_db"."public"."m_aguas_turistas__dbt_tmp"
    
    
  as (
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

aguas_anyo as (
  select
  EXTRACT(YEAR FROM fecha_aproximada)::int as anyo,
  codigo_isla,
  sum(valor_medicion) as v_aguas_residuales
  from "ods_db"."public"."stg_aguas_residuales"
  group by anyo, codigo_isla, codigo_medida
  having EXTRACT(YEAR FROM fecha_aproximada)::int >= 2020 and 
  EXTRACT(YEAR FROM fecha_aproximada)::int <= 2025 and
  codigo_isla LIKE '%ES70' and
  codigo_medida LIKE '%VOLUMEN'
)

select
  t.anyo,
  t.codigo_isla,
  t.nombre_isla,
  t.n_turistas as n_turistas,
  a.v_aguas_residuales as v_aguas_residuales,
  ln(t.n_turistas) as escalado_turistas,
  ln(a.v_aguas_residuales) as escalado_aguas_residuales
from turistas_anyo t
full join aguas_anyo a
on t.anyo = a.anyo
  );