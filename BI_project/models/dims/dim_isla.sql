select
  codigo_isla,
  nombre_isla
from {{ ref('dim_isla_seed') }}