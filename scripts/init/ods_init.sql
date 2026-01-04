
-- ==========================================================
-- Script de inicialización de tablas ISTAC (PostgreSQL)
-- ==========================================================

CREATE USER airbyte PASSWORD 'admin123';
GRANT CREATE, TEMPORARY ON DATABASE ods_db TO airbyte;

GRANT USAGE ON SCHEMA public TO airbyte;
GRANT CREATE ON SCHEMA public TO airbyte;

GRANT SELECT, DELETE ON ALL TABLES IN SCHEMA public TO airbyte;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, DELETE ON TABLES TO airbyte;
