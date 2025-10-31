with turistas as (
  select
    fecha_aproximada::date,                     
    codigo_isla,
    medida,
    codigo_medida,
    valor_medicion,
    is_canarias_total
  from {{ ref('stg_turistas_recibidos') }}
),

visitantes as (
  select
    fecha_aproximada::date,                      
    upper(trim(codigo_parque)),                   
    medida,
    codigo_medida,
    valor_medicion
  from {{ ref('stg_visitantes_espacios_naturales') }}
),

infracciones_acpmn as (
  select
    fecha_aproximada::date,                   
    codigo_isla,
    tipo_infraccion,                          
    codigo_medida,
    valor_medicion,
    is_canarias_total
  from {{ ref('stg_infracciones_acpmn') }}
),

infracciones_ambientales as (
  select
    fecha_aproximada::date,                       
    codigo_isla,
    medida,
    codigo_medida,
    valor_medicion,
    is_canarias_total
  from {{ ref('stg_infracciones_ambientales') }}
),

unioned as (
  select fecha_aproximada, codigo_isla,  from turistas
  union all
  select * from visitantes
  union all
  select * from infracciones_acpmn
  union all
  select * from infracciones_ambientales
)

select
  u.fact_date,
  u.codigo_isla,
  u.medida,                                     
  u.codigo_medida,                                  
  u.valor_medicion,                               
  u.source_table,
  u.extra_type,
  u.is_canarias_total
from unioned u
