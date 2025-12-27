select distinct
  codigo_parque,codigo_isla,nombre_parque
from {{ ref('dim_parque_seed') }}
