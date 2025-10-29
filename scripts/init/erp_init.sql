
-- ==========================================================
-- Script de inicialización de tablas ISTAC (PostgreSQL)
-- ==========================================================

-- Tabla 1: infracciones_ambientales
CREATE TABLE IF NOT EXISTS infracciones_ambientales (
    geographical TEXT,
    geographical_code TEXT,
    time INTEGER,
    time_code INTEGER,
    measure TEXT,
    measure_code TEXT,
    obs_value NUMERIC,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    estado_observacion TEXT,
    obs_conf TEXT,
    CONSTRAINT pk_infracciones UNIQUE (geographical_code, time, measure_code)
);

-- Tabla 2: turistas_recibidos
CREATE TABLE IF NOT EXISTS turistas_recibidos (
    geographical TEXT,
    geographical_code TEXT,
    time TEXT,
    time_code TEXT,
    measure TEXT,
    measure_code TEXT,
    obs_value NUMERIC,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    estado_observacion TEXT,
    obs_conf TEXT,
    CONSTRAINT pk_turistas UNIQUE (geographical_code, time_code, measure_code)
);

-- Tabla 3: visitantes_espacios_naturales
CREATE TABLE IF NOT EXISTS visitantes_espacios_naturales (
    medidas TEXT,
    medidas_code TEXT,
    espacio_natural_protegido TEXT,
    espacio_natural_protegido_code TEXT,
    time_period TEXT,
    time_period_code TEXT,
    obs_value NUMERIC,
    periodo_recogida TEXT,
    confidencialidad_observacion TEXT,
    estado_observacion TEXT,
    estado_observacion_code TEXT,
    notas_observacion TEXT,
    CONSTRAINT pk_visitantes UNIQUE (espacio_natural_protegido_code, time_period_code, medidas_code)
);

-- Tabla 4: infracciones_acpmn
CREATE TABLE IF NOT EXISTS infracciones_acpmn (
    tipo_infraccion TEXT,
    tipo_infraccion_code TEXT,
    territorio TEXT,
    territorio_code TEXT,
    time_period TEXT,
    time_period_code TEXT,
    medidas TEXT,
    medidas_code TEXT,
    obs_value NUMERIC,
    estado_observacion TEXT,
    estado_observacion_code TEXT,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    CONSTRAINT pk_infracciones_acpmn UNIQUE (territorio_code, time_period_code, tipo_infraccion_code, medidas_code)
);


CREATE USER airbyte PASSWORD 'admin123';
GRANT USAGE ON SCHEMA public TO airbyte;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO airbyte;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO airbyte;


