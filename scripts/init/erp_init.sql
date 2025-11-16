-- ==========================================================
-- Script de inicialización de tablas ISTAC (PostgreSQL)
-- ==========================================================


-- Tabla 5: aguas_residuales
CREATE TABLE IF NOT EXISTS public.aguas_residuales (
    territorio TEXT,
    territorio_code TEXT,
    time_period TEXT,
    time_period_code TEXT,
    tipo_destino_uso TEXT,
    tipo_destino_uso_code TEXT,
    medidas TEXT,
    medidas_code TEXT,
    obs_value TEXT,
    estado_observacion TEXT,
    estado_observacion_code TEXT,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    CONSTRAINT pk_aguas_residuales UNIQUE (territorio_code, time_period_code, tipo_destino_uso_code, medidas_code)
);


-- Tabla 6: valor_vivienda_m2
CREATE TABLE IF NOT EXISTS public.valor_vivienda_m2 (
    geographical TEXT,
    geographical_code TEXT,
    time TEXT,  -- Trimestres
    time_code TEXT,
    measure TEXT,
    measure_code TEXT,
    obs_value TEXT,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    estado_observacion TEXT,
    obs_conf TEXT,
    CONSTRAINT pk_valor_vivienda UNIQUE (geographical_code, time, measure_code)
);

-- Tabla 7: carencia_bienes_vivienda
CREATE TABLE IF NOT EXISTS public.carencia_bienes_vivienda (
    geographical TEXT,
    geographical_code TEXT,
    time TEXT, -- Año
    time_code TEXT,
    measure TEXT,
    measure_code TEXT,
    obs_value TEXT,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    estado_observacion TEXT,
    obs_conf TEXT,
    CONSTRAINT pk_carencia_vivienda UNIQUE (geographical_code, time, measure_code)
);

-- Tabla 8: menores_pobreza
CREATE TABLE IF NOT EXISTS public.menores_pobreza (
    geographical TEXT,
    geographical_code TEXT,
    time TEXT, -- Año
    time_code TEXT,
    measure TEXT,
    measure_code TEXT,
    obs_value TEXT,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    estado_observacion TEXT,
    obs_conf TEXT,
    CONSTRAINT pk_menores_pobreza UNIQUE (geographical_code, time, measure_code)
);

-- Tabla 9: ipc_mes
CREATE TABLE IF NOT EXISTS public.ipc_mes (
    geographical TEXT,
    geographical_code TEXT,
    time TEXT, -- Mes, Año
    time_code TEXT,
    measure TEXT,
    measure_code TEXT,
    obs_value TEXT,
    confidencialidad_observacion TEXT,
    periodo_recogida TEXT,
    multiplicador_unidad TEXT,
    estado_observacion TEXT,
    obs_conf TEXT,
    unidad_medida TEXT,
    CONSTRAINT pk_ipc UNIQUE (geographical_code, time, measure_code)
);

-- Tabla 10: afiliaciones_turismo
CREATE TABLE IF NOT EXISTS public.afiliaciones_turismo (
    geographical TEXT,
    geographical_code TEXT,
    time TEXT, -- Año
    time_code TEXT,
    measure TEXT,
    measure_code TEXT,
    obs_value TEXT,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    estado_observacion TEXT,
    obs_conf TEXT,
    CONSTRAINT pk_afil_turismo UNIQUE (geographical_code, time, measure_code)
);


-- Tabla 1: infracciones_ambientales
CREATE TABLE IF NOT EXISTS public.infracciones_ambientales (
    geographical TEXT,
    geographical_code TEXT,
    time TEXT,
    time_code TEXT,
    measure TEXT,
    measure_code TEXT,
    obs_value TEXT,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    estado_observacion TEXT,
    obs_conf TEXT,
    CONSTRAINT pk_infracciones UNIQUE (geographical_code, time, measure_code)
);

-- Tabla 2: turistas_recibidos
CREATE TABLE IF NOT EXISTS public.turistas_recibidos (
    geographical TEXT,
    geographical_code TEXT,
    time TEXT,
    time_code TEXT,
    measure TEXT,
    measure_code TEXT,
    obs_value TEXT,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    estado_observacion TEXT,
    obs_conf TEXT,
    CONSTRAINT pk_turistas UNIQUE (geographical_code, time_code, measure_code)
);

-- Tabla 3: visitantes_espacios_naturales
CREATE TABLE IF NOT EXISTS public.visitantes_espacios_naturales (
    medidas TEXT,
    medidas_code TEXT,
    espacio_natural_protegido TEXT,
    espacio_natural_protegido_code TEXT,
    time_period TEXT,
    time_period_code TEXT,
    obs_value TEXT,
    periodo_recogida TEXT,
    confidencialidad_observacion TEXT,
    estado_observacion TEXT,
    estado_observacion_code TEXT,
    notas_observacion TEXT,
    CONSTRAINT pk_visitantes UNIQUE (espacio_natural_protegido_code, time_period_code, medidas_code)
);

-- Tabla 4: infracciones_acpmn
CREATE TABLE IF NOT EXISTS public.infracciones_acpmn (
    tipo_infraccion TEXT,
    tipo_infraccion_code TEXT,
    territorio TEXT,
    territorio_code TEXT,
    time_period TEXT,
    time_period_code TEXT,
    medidas TEXT,
    medidas_code TEXT,
    obs_value TEXT,
    estado_observacion TEXT,
    estado_observacion_code TEXT,
    confidencialidad_observacion TEXT,
    notas_observacion TEXT,
    CONSTRAINT pk_infracciones_acpmn UNIQUE (territorio_code, time_period_code, tipo_infraccion_code, medidas_code)
);



CREATE USER airbyte PASSWORD 'admin123';

-- Permisos de lectura para airbyte
GRANT USAGE ON SCHEMA public TO airbyte;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO airbyte;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO airbyte;

-- Privilegios por defecto para objetos futuros creados por el usuario que ejecuta este script
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO airbyte;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO airbyte;
