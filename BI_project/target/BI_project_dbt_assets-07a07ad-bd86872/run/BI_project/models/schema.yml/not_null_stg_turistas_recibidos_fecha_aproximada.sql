
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select fecha_aproximada
from "ods_db"."public"."stg_turistas_recibidos"
where fecha_aproximada is null



  
  
      
    ) dbt_internal_test