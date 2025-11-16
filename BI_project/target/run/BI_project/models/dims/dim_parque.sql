
  create view "ods_db"."public"."dim_parque__dbt_tmp"
    
    
  as (
    select distinct
  codigo_parque
from "ods_db"."public"."dim_parque_seed"
  );