
  create view "ods_db"."schema.yml"."stg_visitantes_espacios_naturales__dbt_tmp"
    
    
  as (
    with base as ( 
    select
        upper(trim(espacio_natural_protegido_code)) as codigo_parque,
        trim(time_period_code)                      as raw_anyo,
        trim(medidas)                               as medida,
        trim(medidas_code)                          as codigo_medida,
        cast(obs_value as numeric)                  as valor_medicion
    from "ods_db"."public"."visitantes_espacios_naturales"
),

fechas as (
    select
        case
            when raw_anyo ~ '^\d{4}$'
                then to_date(raw_anyo || '-01-01','YYYY-MM-DD')
            when raw_anyo ~ '^\d{4}-M\d{2}$'
                then to_date(regexp_replace(raw_anyo, '-M', '-') || '-01','YYYY-MM-DD')
            else null
        end as fecha_aproximada,
        codigo_parque,
        codigo_medida,
        medida,
        valor_medicion
    from base
),

parques as (
    select distinct
        codigo_parque,
        codigo_isla,
        nombre_parque
    from "ods_db"."schema.yml"."dim_parque_seed"
)

select
    f.fecha_aproximada,
    f.codigo_parque,
    p.codigo_isla,
    p.nombre_parque,
    f.codigo_medida,
    f.medida,
    f.valor_medicion
from fechas f
left join parques p
    on f.codigo_parque = p.codigo_parque
  );