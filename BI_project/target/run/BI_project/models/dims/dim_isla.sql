
  create view "ods_db"."public"."dim_isla__dbt_tmp"
    
    
  as (
    select
  codigo_isla,
  nombre_isla
from "ods_db"."public"."dim_isla_seed"
  );