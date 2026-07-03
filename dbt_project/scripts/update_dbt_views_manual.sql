-- ====================================================================
-- CREACIÓN MANUAL DE VISTAS DBT (Para usuarios de Solo Lectura)
-- Ejecutar en DBeaver/pgAdmin con un usuario administrador
-- ====================================================================

-- 1. NOTA DE SEGURIDAD (IMPORTANTE)
-- El usuario `gemma` es estrictamente READ-ONLY.
-- Si necesitas correr este script o cualquier materialización de dbt,
-- DEBES usar el usuario `demo_user` que tiene permisos de escritura.

-- 2. CREAR EL MART LIGERO (Súper rápido para preguntas generales)
DROP VIEW IF EXISTS dbt_analytics.mart_ocupacion_camas CASCADE;

CREATE VIEW dbt_analytics.mart_ocupacion_camas AS
SELECT
    c.codigo_establecimiento,
    est.nombre_establecimiento AS hospital,
    serv.nombre_servicio AS servicio,
    c.nombre_cama AS cama,
    CASE c.tipo_cama
        WHEN 'G' THEN 'General'
        WHEN 'T' THEN 'UTI/Terapia Intensiva'
        ELSE c.tipo_cama
    END AS tipo_cama,
    CASE ce.estado
        WHEN '1' THEN 'Disponible'
        WHEN '2' THEN 'Ocupado'
        WHEN '3' THEN 'Preparación'
        WHEN '4' THEN 'Aislado'
        WHEN '5' THEN 'En reparación'
        ELSE 'Desconocido'
    END AS estado,
    ce.codigo_asignacion AS asignacion_actual
FROM public.cama c
LEFT JOIN public.cama_estado ce
    ON c.codigo_establecimiento = ce.codigo_establecimiento
    AND c.codigo_cama = ce.codigo_cama
LEFT JOIN public.servicio serv
    ON c.codigo_servicio = serv.codigo_servicio
LEFT JOIN public.establecimiento est
    ON c.codigo_establecimiento = est.codigo_establecimiento
WHERE c.activo = 'Y';


-- 2. CREAR EL MART EXTENDIDO (Pesado, para preguntas de ubicación exacta)
CREATE OR REPLACE VIEW dbt_analytics.mart_ubicacion_camas AS
SELECT
    c.codigo_establecimiento,
    est.nombre_establecimiento AS hospital,
    ed.nombre_edificio AS edificio,
    pi.nombre_piso AS piso,
    sal.nombre_sala AS sala,
    serv.nombre_servicio AS servicio,
    c.nombre_cama AS cama,
    CASE c.tipo_cama
        WHEN 'G' THEN 'General'
        WHEN 'T' THEN 'UTI/Terapia Intensiva'
        ELSE c.tipo_cama
    END AS tipo_cama,
    CASE ce.estado
        WHEN '1' THEN 'Disponible'
        WHEN '2' THEN 'Ocupado'
        WHEN '3' THEN 'Preparación'
        WHEN '4' THEN 'Aislado'
        WHEN '5' THEN 'En reparación'
        ELSE 'Desconocido'
    END AS estado,
    ce.codigo_asignacion AS asignacion_actual
FROM public.cama c
LEFT JOIN public.cama_estado ce
    ON c.codigo_establecimiento = ce.codigo_establecimiento
    AND c.codigo_cama = ce.codigo_cama
LEFT JOIN public.sala sal
    ON c.codigo_establecimiento = sal.codigo_establecimiento
    AND c.codigo_sala = sal.codigo_sala
LEFT JOIN public.piso pi
    ON c.codigo_establecimiento = pi.codigo_establecimiento
    AND c.codigo_piso = pi.codigo_piso
LEFT JOIN public.edificio ed
    ON c.codigo_establecimiento = ed.codigo_establecimiento
    AND c.codigo_edificio = ed.codigo_edificio
LEFT JOIN public.servicio serv
    ON c.codigo_servicio = serv.codigo_servicio
LEFT JOIN public.establecimiento est
    ON c.codigo_establecimiento = est.codigo_establecimiento
WHERE c.activo = 'Y';
