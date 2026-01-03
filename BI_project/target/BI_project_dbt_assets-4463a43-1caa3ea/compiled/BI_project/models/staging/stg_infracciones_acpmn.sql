with base as (
  select
    upper(trim(tipo_infraccion))       as tipo_infraccion,    
    upper(trim(tipo_infraccion_code))  as codigo_tipo_infraccion,
    territorio_code                         as codigo_isla,
    trim(time_period_code)                  as anyo,
    trim(medidas)                           as medida,
    trim(medidas_code)                      as codigo_medida,
    cast(obs_value as numeric)              as valor_medicion
  from "ods_db"."public"."infracciones_acpmn"
)

select
  to_date(anyo || '-01-01','YYYY-MM-DD') as fecha_aproximada,
  codigo_isla,
  codigo_tipo_infraccion,
  tipo_infraccion,
  codigo_medida,
  valor_medicion
from base