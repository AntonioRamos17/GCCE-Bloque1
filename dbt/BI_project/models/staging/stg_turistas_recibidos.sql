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
  codigo_isla,

  -- Como tengo datso con el año nada más y otros que incluye el mes tengo que normalizarlo en función del caso
  to_date(
    case
      when time_code_raw ~ '^\d{4}-\d{2}$' then time_code_raw || '-01'       -- '2017-01' -> '2017-01-01'
      when time_code_raw ~ '^\d{4}$' then time_code_raw || '-01-01'         -- '2016'    -> '2016-01-01'
      else null
    end,
    'YYYY-MM-DD'
  ) as fecha_aproximada,

  medida,
  codigo_medida,
  valor_medicion,
  case when codigo_isla = 'ES70' then true else false end as is_canarias_total
from base