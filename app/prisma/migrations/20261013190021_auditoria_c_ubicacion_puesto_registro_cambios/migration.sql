-- Auditoría y trazabilidad de c_ubicacion_puesto_registro_cambios (issue #114): columnas que faltaban (updated_at, updated_by).
-- Son opcionales: los registros anteriores quedan en NULL salvo lo que se pueda recuperar del historial.
ALTER TABLE `c_ubicacion_puesto_registro_cambios`
    ADD COLUMN `updated_at` DATETIME(0) NULL,
    ADD COLUMN `updated_by` INTEGER NULL;

-- Relleno inicial: última modificación registrada en el historial, sin contar el alta (`__created__`).
UPDATE `c_ubicacion_puesto_registro_cambios` t
JOIN (
    SELECT `registro_id`, MAX(`id`) AS `last_id`
    FROM `c_cambios_apps_modules`
    WHERE `nombre_tabla` = 'c_ubicacion_puesto_registro_cambios' AND `cambios` NOT LIKE '%\_\_created\_\_%'
    GROUP BY `registro_id`
) x ON x.`registro_id` = t.`id`
JOIN `c_cambios_apps_modules` c ON c.`id` = x.`last_id`
SET t.`updated_at` = c.`created_at`, t.`updated_by` = c.`created_by`;
