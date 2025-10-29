-- Limpieza y renombrado de datos de valor del m2 de vivienda
SELECT
  geographical AS region,
  geographical_code AS region_code,
  CAST(SUBSTRING(time FROM '([0-9]{4})') AS INTEGER) AS year,
  time_code,
  measure,
  measure_code,
  obs_value::NUMERIC AS value,
  notas_observacion AS notes,
  confidencialidad_observacion AS confidentiality,
  estado_observacion AS status,
  obs_conf AS confidence
FROM {{ source('public', 'valor_m2_vivienda') }}
