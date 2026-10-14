-- Auditoría y trazabilidad de c_encuesta_cliente (issue #118): columnas que faltaban (created_by, updated_at, updated_by).
-- Son opcionales: los registros anteriores quedan en NULL salvo lo que se pueda recuperar del historial.
ALTER TABLE `c_encuesta_cliente`
    ADD COLUMN `created_by` INTEGER NULL,
    ADD COLUMN `updated_at` DATETIME(0) NULL,
    ADD COLUMN `updated_by` INTEGER NULL;

-- Relleno inicial: alta registrada en el historial (c_cambios_apps_modules, entrada `__created__`).
UPDATE `c_encuesta_cliente` t
JOIN (
    SELECT `registro_id`, MIN(`id`) AS `first_id`
    FROM `c_cambios_apps_modules`
    WHERE `nombre_tabla` = 'c_encuesta_cliente' AND `cambios` LIKE '%\_\_created\_\_%'
    GROUP BY `registro_id`
) x ON x.`registro_id` = t.`id`
JOIN `c_cambios_apps_modules` c ON c.`id` = x.`first_id`
SET t.`created_by` = c.`created_by`;

-- Relleno inicial: última modificación registrada en el historial, sin contar el alta (`__created__`).
UPDATE `c_encuesta_cliente` t
JOIN (
    SELECT `registro_id`, MAX(`id`) AS `last_id`
    FROM `c_cambios_apps_modules`
    WHERE `nombre_tabla` = 'c_encuesta_cliente' AND `cambios` NOT LIKE '%\_\_created\_\_%'
    GROUP BY `registro_id`
) x ON x.`registro_id` = t.`id`
JOIN `c_cambios_apps_modules` c ON c.`id` = x.`last_id`
SET t.`updated_at` = c.`created_at`, t.`updated_by` = c.`created_by`;
