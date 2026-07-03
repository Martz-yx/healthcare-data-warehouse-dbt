-- mart_altas_egresos: Histórico de altas/egresos hospitalarios.
-- Incluye diagnóstico de egreso, condición, tipo de alta, y días de estancia.

SELECT
    ha.codigo_establecimiento,
    ha.codigo_asignacion,
    ha.codigo_paciente,
    {{ nombre_paciente('p') }} AS nombre_paciente,
    {{ decodificar_sexo('p') }} AS sexo_paciente,
    {{ edad_con_unidad('ha') }} AS edad_ingreso,
    est.nombre AS hospital,
    serv.nombre_servicio AS servicio,

    -- Fechas
    ha.hospitalario_fecha AS fecha_ingreso,
    alta.fecha_egreso,
    alta.fecha_egreso - ha.hospitalario_fecha AS dias_estancia,

    -- Diagnóstico de egreso
    alta.nombre_cie10_main AS diagnostico_egreso_principal,
    alta.codigo_cie10a_main || alta.codigo_cie10b_main AS codigo_cie10_egreso,

    -- Condición y tipo
    CASE alta.condicion_egreso
        WHEN '1' THEN 'Curado/a'
        WHEN '2' THEN 'Mejorado/a'
        WHEN '3' THEN 'Estacionario/a'
        WHEN '4' THEN 'Empeorado/a'
        WHEN '5' THEN 'Fallecido/a'
        ELSE 'No especificado'
    END AS condicion_egreso,
    CASE alta.tipo_egreso
        WHEN '1' THEN 'Alta médica'
        WHEN '2' THEN 'Traslado'
        WHEN '3' THEN 'Retiro voluntario'
        WHEN '4' THEN 'Fuga'
        WHEN '5' THEN 'Defunción'
        WHEN '10' THEN 'Rechazo'
        ELSE 'No especificado'
    END AS tipo_egreso,

    -- Seguimiento
    alta.fecha_proxima_consulta,
    alta.instruccion_alta,
    alta.dieta_alta,
    alta.resumen_evolutivo

FROM {{ ref('stg_hospitalario_doctor_datos_alta') }} alta

JOIN {{ ref('stg_hospitalario_asignacion') }} ha
    ON alta.codigo_establecimiento = ha.codigo_establecimiento
    AND alta.codigo_asignacion = ha.codigo_asignacion
    AND ha.orden_asignacion = 1

JOIN {{ ref('stg_paciente') }} p
    ON ha.codigo_paciente = p.codigo_paciente

LEFT JOIN {{ ref('stg_establecimiento') }} est
    ON ha.codigo_establecimiento = est.codigo_establecimiento

LEFT JOIN {{ ref('stg_servicio') }} serv
    ON ha.codigo_servicio = serv.codigo_servicio

WHERE alta.estado = 'f'  -- Solo altas finalizadas
