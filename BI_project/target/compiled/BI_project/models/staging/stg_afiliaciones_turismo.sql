with base as (
  select
    upper(trim(geographical_code))          as codigo_isla,
    trim(time_code)                         as time_code_raw,
    trim(measure)                           as medida,
    trim(measure_code)                      as codigo_medida,
    cast(obs_value as numeric)              as valor_medicion
  from "ods_db"."public"."afiliaciones_turismo"
  where measure_code like 'ABSOLUTE'
),

con_fechas as (
  select
    codigo_isla,
    codigo_medida,
    medida,
    valor_medicion,
    -- ajusta esto si tu formato no es YYYY-MM
    to_date(time_code_raw || '-01', 'YYYY-MM-DD') as fecha_real,
    extract(year from to_date(time_code_raw || '-01', 'YYYY-MM-DD')) as anio
  from base
),

ranked as (
  select
    *,
    row_number() over (
      partition by codigo_isla, codigo_medida, anio
      order by fecha_real desc
    ) as rn
  from con_fechas
)

select
  fecha_real as fecha_aproximada,
  codigo_isla,
  codigo_medida,
  medida,
  valor_medicion
from ranked
where rn = 1