-- Inducción y recorrido: tipo de capacitación (issue #142). Opcional: Presencial / Virtual, las mismas opciones del registro de capacitaciones.
-- Los registros anteriores quedan en NULL.
ALTER TABLE `c_registro_induccion_recorrido`
    ADD COLUMN `tipo_capacitacion` VARCHAR(20) NULL;
