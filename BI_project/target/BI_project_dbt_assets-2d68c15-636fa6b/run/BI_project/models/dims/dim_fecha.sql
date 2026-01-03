
  create view "ods_db"."public"."dim_fecha__dbt_tmp"
    
    
  as (
    with fechas as (
  select
    date_trunc('month', d)::date as fecha
  from generate_series(
    date '1995-01-01',
    date '2030-12-01',
    interval '1 month'
  ) as d
)

select
  fecha,
  extract(year from fecha)::int        as anyo,
  extract(month from fecha)::int       as mes,
  to_char(fecha, 'TMMonth')            as nombre_mes,
  extract(quarter from fecha)::int     as trimestre,
  case when extract(month from fecha) in (6,7,8,9) then true else false end as es_temporada_alta
from fechas
order by fecha
  );