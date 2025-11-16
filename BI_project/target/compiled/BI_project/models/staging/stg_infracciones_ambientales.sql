with base as (
  select
    upper(trim(geographical_code))                  as codigo_isla,
    time_code                                       as anyo,
    trim(measure)                                   as medida,
    trim(measure_code)                              as codigo_medida,
    cast(obs_value as numeric)                      as valor_medicion
  from "ods_db"."public"."infracciones_ambientales"
)

select
  to_date(anyo || '-01-01','YYYY-MM-DD') as fecha_aproximada,
  codigo_isla,
  codigo_medida,
  medida,
  valor_medicion
from base