
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select codigo_isla
from "ods_db"."public"."stg_infracciones_ambientales"
where codigo_isla is null



  
  
      
    ) dbt_internal_test