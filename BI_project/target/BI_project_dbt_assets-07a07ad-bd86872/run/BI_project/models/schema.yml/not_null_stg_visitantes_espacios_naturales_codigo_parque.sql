
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select codigo_parque
from "ods_db"."public"."stg_visitantes_espacios_naturales"
where codigo_parque is null



  
  
      
    ) dbt_internal_test