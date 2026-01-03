
  create view "ods_db"."schema.yml"."dim_isla__dbt_tmp"
    
    
  as (
    select
  codigo_isla,
  nombre_isla
from "ods_db"."schema.yml"."dim_isla_seed"
  );