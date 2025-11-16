with base as (
  select
    upper(trim(geographical_code))          as codigo_isla,
    trim(time_code)                         as time_code_raw,
    trim(measure)                           as medida,
    trim(measure_code)                      as codigo_medida,
    cast(obs_value as numeric)              as valor_medicion
  from "ods_db"."public"."valor_vivienda_m2"
  where measure_code like 'ABSOLUTE'
)

select
  make_date(
    split_part(time_code_raw, '-', 1)::int,
    case split_part(time_code_raw, '-', 2) 
      when 'Q1' then 1   -- enero
      when 'Q2' then 4   -- abril
      when 'Q3' then 7   -- julio
      when 'Q4' then 10  -- octubre
    end,
    1
  )::date as fecha_aproximada,
  codigo_isla,
  codigo_medida,
  medida,
  valor_medicion
from base
where time_code_raw !~* '^\d{4}$'