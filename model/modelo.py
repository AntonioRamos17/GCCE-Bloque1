import os
import pickle
import pandas as pd
import numpy as np
from prophet import Prophet
from sqlalchemy import create_engine, text

# =====================================================
# CONFIGURACIÓN
# =====================================================

MODEL_PATH = "prophet_es70.pkl"
RETRAIN_MODEL = False  # ponlo a True si quieres forzar reentrenamiento

engine = create_engine(
    "postgresql+psycopg2://postgres:admin123@localhost:5433/ods_db"
)

# =====================================================
# 1. EXTRAER DATOS
# =====================================================

query = """
SELECT
    fecha_aproximada,
    codigo_isla,
    codigo_medida,
    medida,
    valor_medicion
FROM public.stg_turistas_recibidos
WHERE codigo_isla = 'ES70' AND medida = 'Dato'
ORDER BY fecha_aproximada;
"""

df = pd.read_sql(query, engine)

# =====================================================
# 2. PREPARAR DATASET PARA PROPHET
# =====================================================

df_prophet = df.rename(
    columns={
        "fecha_aproximada": "ds",
        "valor_medicion": "y"
    }
)[["ds", "y"]]

df_prophet["ds"] = pd.to_datetime(df_prophet["ds"])
df_prophet = df_prophet.sort_values("ds").reset_index(drop=True)
# =====================================================
# 3. CARGAR O ENTRENAR MODELO
# =====================================================

if os.path.exists(MODEL_PATH) and not RETRAIN_MODEL:
    print("📦 Cargando modelo Prophet existente...")
    with open(MODEL_PATH, "rb") as f:
        model = pickle.load(f)
else:
    print("🧠 Entrenando modelo Prophet...")
    model = Prophet(
        yearly_seasonality=True,
        weekly_seasonality=False,
        daily_seasonality=False,
        interval_width=0.80
    )
    model.fit(df_prophet)

    with open(MODEL_PATH, "wb") as f:
        pickle.dump(model, f)
    print("💾 Modelo guardado")

# =====================================================
# 4. PREDICCIÓN FUTURA
# =====================================================

future = model.make_future_dataframe(periods=48, freq="MS")
forecast = model.predict(future)

# Solo fechas futuras
last_date = df_prophet["ds"].max()

df_pred = forecast[forecast["ds"] > last_date][
    ["ds", "yhat", "yhat_lower", "yhat_upper"]
].copy()

df_pred.rename(
    columns={
        "ds": "fecha_aproximada",
        "yhat": "valor_predicho",
        "yhat_lower": "minimo_prediccion",
        "yhat_upper": "maximo_prediccion"
    },
    inplace=True
)

df_pred["codigo_isla"] = "ES70"
df_pred["codigo_medida"] = "ABSOLUTE"
df_pred["medida"] = "Dato"
df_pred["valor_medicion"] = np.nan

df_pred = df_pred[
    [
        "fecha_aproximada",
        "codigo_isla",
        "codigo_medida",
        "medida",
        "valor_medicion",
        "valor_predicho",
        "minimo_prediccion",
        "maximo_prediccion"
    ]
]

# =====================================================
# 5. CARGA EN STAGING
# =====================================================

with engine.begin() as conn:
    conn.execute(text("""
        CREATE TABLE IF NOT EXISTS public.prediccion_turistas_stg (
            fecha_aproximada DATE,
            codigo_isla TEXT,
            codigo_medida TEXT,
            medida TEXT,
            valor_medicion NUMERIC,
            valor_predicho NUMERIC,
            minimo_prediccion NUMERIC,
            maximo_prediccion NUMERIC
        );
    """))

    conn.execute(text("TRUNCATE TABLE public.prediccion_turistas_stg"))

    # Históricos
    conn.execute(text("""
        INSERT INTO public.prediccion_turistas_stg (
            fecha_aproximada, codigo_isla, codigo_medida, medida, valor_medicion,
            valor_predicho, minimo_prediccion, maximo_prediccion
        )
        SELECT
            fecha_aproximada, codigo_isla, codigo_medida, medida, valor_medicion,
            NULL, NULL, NULL
        FROM public.stg_turistas_recibidos
        WHERE codigo_isla = 'ES70' and medida = 'Dato'
    """))

# Predicciones
df_pred.to_sql(
    "prediccion_turistas_stg",
    engine,
    schema="public",
    if_exists="append",
    index=False
)

print("✅ Predicciones cargadas correctamente")
