with base as (
  select
    upper(trim(geographical_code))                  as codigo_isla,
    time_code                                       as anyo,
    trim(measure)                                   as medida,
    trim(measure_code)                              as codigo_medida,
    cast(obs_value as numeric)                      as valor_medicion
  from {{ source('public', 'infracciones_ambientales') }}
)

select
  codigo_isla,
  anyo,
  to_date(anyo || '-01-01','YYYY-MM-DD') as fecha_aproximada,
  medida,
  codigo_medida,
  valor_medicion,
  case when codigo_isla = 'ES70' then true else false end as is_canarias_total
from base