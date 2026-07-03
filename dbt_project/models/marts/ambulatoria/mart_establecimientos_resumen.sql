{{ config(materialized='table') }}

-- mart_establecimientos_resumen: Resumen histórico por establecimiento.
-- Como es un total histórico (incluyendo COUNT DISTINCT), se materializa como tabla y se refresca diariamente.

-- mart_establecimientos_resumen: Resumen de actividad por establecimiento (fechas, pacientes).

SELECT
    e.codigo_establecimiento,
    e.nombre AS hospital,
    r.nombre_region AS region,
    MIN(pa.consulta_fecha) AS fecha_primera_consulta,
    MAX(pa.consulta_fecha) AS fecha_ultima_consulta,
    COUNT(DISTINCT pa.codigo_paciente) AS total_pacientes_atendidos
FROM {{ ref('stg_establecimiento') }} e
JOIN {{ ref('stg_region') }} r
    ON e.codigo_region = r.codigo_region
LEFT JOIN {{ ref('stg_paciente_asignacion') }} pa
    ON e.codigo_establecimiento = pa.codigo_establecimiento
GROUP BY
    e.codigo_establecimiento,
    e.nombre,
    r.nombre_region
