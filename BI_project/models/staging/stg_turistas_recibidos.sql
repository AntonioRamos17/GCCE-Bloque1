with base as (
  select
    upper(trim(geographical_code))          as codigo_isla,
    trim(time_code)                         as time_code_raw,
    trim(measure)                           as medida,
    trim(measure_code)                      as codigo_medida,
    cast(obs_value as numeric)              as valor_medicion
  from {{ source('public', 'turistas_recibidos') }}
)

select
  to_date(time_code_raw || '-01', 'YYYY-MM-DD') as fecha_aproximada,
  codigo_isla,
  codigo_medida,
  medida,
  valor_medicion
from base
where time_code_raw !~* '^\d{4}$'