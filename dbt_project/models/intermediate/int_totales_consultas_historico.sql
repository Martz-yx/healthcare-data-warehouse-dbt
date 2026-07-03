{{ config(
    materialized='incremental',
    unique_key=['fecha_consulta', 'codigo_establecimiento', 'tipo_consulta_raw']
) }}

SELECT
    pa.consulta_fecha AS fecha_consulta,
    e.codigo_establecimiento,
    e.nombre AS hospital,
    r.nombre_region AS region,
    pa.tipo_consulta AS tipo_consulta_raw,
    CASE pa.tipo_consulta
        WHEN 'A' THEN 'Ambulatoria'
        WHEN 'U' THEN 'Urgencia'
        WHEN 'T' THEN 'Teleconsulta'
        WHEN 'I' THEN 'Internación'
        WHEN 'E' THEN 'Extramural'
        WHEN 'D' THEN 'Domiciliaria'
        ELSE pa.tipo_consulta
    END AS tipo_consulta,
    COUNT(pa.codigo_asignacion) AS total_consultas,
    COUNT(DISTINCT pa.codigo_paciente) AS total_pacientes_distintos
FROM {{ ref('stg_paciente_asignacion') }} pa
JOIN {{ ref('stg_establecimiento') }} e
    ON pa.codigo_establecimiento = e.codigo_establecimiento
JOIN {{ ref('stg_region') }} r
    ON e.codigo_region = r.codigo_region
WHERE pa.consulta_fecha < CURRENT_DATE
{% if is_incremental() %}
  AND pa.consulta_fecha >= (SELECT MAX(fecha_consulta) FROM {{ this }})
{% endif %}
GROUP BY
    pa.consulta_fecha,
    e.codigo_establecimiento,
    e.nombre,
    r.nombre_region,
    pa.tipo_consulta
