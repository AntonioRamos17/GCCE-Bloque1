-- Limpieza y renombrado de datos de infracciones ambientales
SELECT
  geographical AS region,
  geographical_code AS region_code,
  CAST(time AS INTEGER) AS year,
  time_code,
  measure,
  measure_code,
  obs_value::NUMERIC AS value,
  confidencialidad_observacion AS confidentiality,
  notas_observacion AS notes,
  estado_observacion AS status,
  obs_conf AS confidence
FROM {{ source('public', 'infracciones_ambientales') }}
