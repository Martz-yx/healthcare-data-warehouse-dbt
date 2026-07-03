-- mart_consultas: Consultas ambulatorias con paciente, médico, servicio y hospital.
-- Cada fila es una visita/turno con los datos principales pre-unidos.

SELECT
    pa.codigo_establecimiento,
    pa.codigo_asignacion,
    pa.codigo_paciente,
    {{ nombre_paciente('p') }} AS nombre_paciente,
    {{ decodificar_sexo('p') }} AS sexo_paciente,
    {{ edad_con_unidad('pa') }} AS edad_consulta,
    pa.consulta_fecha AS fecha_consulta,
    pa.hora_inicio AS hora_consulta,
    CASE pa.tipo_consulta
        WHEN 'A' THEN 'Ambulatoria'
        WHEN 'U' THEN 'Urgencia'
        WHEN 'T' THEN 'Teleconsulta'
        WHEN 'I' THEN 'Internación'
        WHEN 'E' THEN 'Extramural'
        WHEN 'D' THEN 'Domiciliaria'
        ELSE pa.tipo_consulta
    END AS tipo_consulta,
    est.nombre AS hospital,
    r.nombre_region AS region,
    dis_est.nombre_distrito AS distrito_hospital,
    serv.nombre_servicio AS servicio,
    {{ nombre_medico('u') }} AS medico,

    -- Datos clínicos de la consulta
    c.motivo_consulta,
    c.historia_actual,
    c.impresion_diagnostica,
    c.evolucion AS notas_evolucion,
    CASE c.derivar
        WHEN '0' THEN 'No aplica'
        WHEN '1' THEN 'Se refiere'
        WHEN '2' THEN 'Internación'
        WHEN '3' THEN 'Domicilio'
        WHEN '4' THEN 'Fuga/No se realizó'
        WHEN '5' THEN 'Muerte'
        WHEN '6' THEN 'Re-Evaluar'
        WHEN '7' THEN 'Reasignar'
        ELSE 'No registrado'
    END AS destino_paciente,

    -- Residencia
    dep.nombre_departamento AS departamento_residencia,
    dis.nombre_distrito AS distrito_residencia,
    bar.nombre_barrio AS barrio_residencia

FROM {{ ref('stg_paciente_asignacion') }} pa

JOIN {{ ref('stg_paciente') }} p
    ON pa.codigo_paciente = p.codigo_paciente

LEFT JOIN {{ ref('stg_consulta') }} c
    ON pa.codigo_establecimiento = c.codigo_establecimiento
    AND pa.codigo_asignacion = c.codigo_asignacion

LEFT JOIN {{ ref('stg_usuario') }} u
    ON pa.codigo_medico = u.codigo_usuario

LEFT JOIN {{ ref('stg_establecimiento') }} est
    ON pa.codigo_establecimiento = est.codigo_establecimiento

LEFT JOIN {{ ref('stg_region') }} r
    ON est.codigo_region = r.codigo_region

LEFT JOIN {{ ref('stg_distrito') }} dis_est
    ON est.codigo_region = dis_est.codigo_departamento
    AND est.codigo_distrito = dis_est.codigo_distrito

LEFT JOIN {{ ref('stg_servicio') }} serv
    ON pa.codigo_servicio = serv.codigo_servicio

LEFT JOIN {{ ref('stg_departamento') }} dep
    ON pa.cod_departamento_residencia = dep.codigo_departamento

LEFT JOIN {{ ref('stg_distrito') }} dis
    ON pa.cod_departamento_residencia = dis.codigo_departamento
    AND pa.cod_distrito_residencia = dis.codigo_distrito

LEFT JOIN {{ ref('stg_barrio') }} bar
    ON p.cod_departamento_residencia = bar.codigo_departamento
    AND p.cod_distrito_residencia = bar.codigo_distrito
    AND p.cod_barrio_residencia = bar.codigo_barrio
