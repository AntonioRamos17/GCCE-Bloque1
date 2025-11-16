
-- ==========================================================
-- Script de inicialización de tablas ISTAC (PostgreSQL)
-- ==========================================================

CREATE USER airbyte PASSWORD 'admin123';
GRANT CREATE, TEMPORARY ON DATABASE ods_db TO airbyte;


-- Da permiso de uso sobre el schema "public"
GRANT USAGE ON SCHEMA public TO airbyte;

-- Da permiso para crear objetos en el schema (opcional)
GRANT CREATE ON SCHEMA public TO airbyte;

-- Da permisos de lectura sobre todas las tablas existentes
GRANT SELECT ON ALL TABLES IN SCHEMA public TO airbyte;

-- Hace que las futuras tablas creadas en "public" también sean legibles
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO airbyte;