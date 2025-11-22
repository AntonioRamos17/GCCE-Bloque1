
  create view "ods_db"."public"."m_turismo_empleo_anyo__dbt_tmp"
    
    
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

afiliaciones_anyo as (
    select
      extract(year from fecha_aproximada)::int as anyo,
      codigo_isla,
      sum(valor_medicion) as n_afiliaciones_turismo
    from "ods_db"."public"."stg_afiliaciones_turismo"
    group by anyo, codigo_isla
)

select
  t.anyo,
  t.codigo_isla,
  t.nombre_isla,
  t.n_turistas,
  a.n_afiliaciones_turismo,
  (a.n_afiliaciones_turismo::numeric / nullif(t.n_turistas, 0)) as afiliaciones_por_turista,
  ln(t.n_turistas)              as log_turistas,
  ln(nullif(a.n_afiliaciones_turismo, 0)) as log_afiliaciones
from turistas_anyo t
left join afiliaciones_anyo a
  on t.anyo = a.anyo
 and t.codigo_isla = a.codigo_isla
order by t.anyo
  );