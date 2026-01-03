
  create view "ods_db"."schema.yml"."dim_parque__dbt_tmp"
    
    
  as (
    select distinct
  codigo_parque,codigo_isla,nombre_parque
from "ods_db"."schema.yml"."dim_parque_seed"
  );