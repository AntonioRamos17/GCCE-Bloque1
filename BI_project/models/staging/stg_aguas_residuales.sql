with base as (
  select
    trim(time_period_code)                      as anyo,
    territorio_code                             as codigo_isla,
    trim(medidas)                               as medida,
    trim(medidas_code)                          as codigo_medida,
    upper(trim(tipo_destino_uso))               as destino,    
    upper(trim(tipo_destino_uso_code))          as codigo_destino,
    cast(obs_value as numeric)                  as valor_medicion
  from {{ source('public', 'aguas_residuales') }}
)


select
  to_date(anyo || '-01-01','YYYY-MM-DD') as fecha_aproximada,
  codigo_isla,
  codigo_medida,
  codigo_destino,
  destino,
  valor_medicion
from base
where upper(destino) LIKE '%AL MAR%'