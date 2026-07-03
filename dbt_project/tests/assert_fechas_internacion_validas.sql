-- tests/assert_fechas_internacion_validas.sql
-- This custom data test ensures that a patient is never discharged BEFORE they are admitted.
-- A true Senior Engineer guards data integrity at the source.

select
    internacion_id,
    paciente_id,
    fecha_ingreso,
    fecha_egreso
from {{ ref('mart_internados_activos') }}
where fecha_egreso < fecha_ingreso
