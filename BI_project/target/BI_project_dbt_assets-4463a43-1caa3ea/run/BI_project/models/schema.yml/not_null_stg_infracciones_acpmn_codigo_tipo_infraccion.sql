
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select codigo_tipo_infraccion
from "ods_db"."public"."stg_infracciones_acpmn"
where codigo_tipo_infraccion is null



  
  
      
    ) dbt_internal_test