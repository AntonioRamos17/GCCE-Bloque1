select distinct
  codigo_parque
from {{ ref('dim_parque_seed') }}
