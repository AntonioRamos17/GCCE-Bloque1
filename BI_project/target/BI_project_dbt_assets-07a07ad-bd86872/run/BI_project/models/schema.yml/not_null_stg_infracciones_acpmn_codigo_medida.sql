
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select codigo_medida
from "ods_db"."public"."stg_infracciones_acpmn"
where codigo_medida is null



  
  
      
    ) dbt_internal_test