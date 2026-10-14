-- Auditoría de modificación de e_manual_puesto (issue #136): quién y cuándo modificó cada manual.
-- Las columnas son opcionales: un manual que nunca se modificó queda con NULL.
ALTER TABLE `e_manual_puesto`
    ADD COLUMN `updated_at` DATETIME(0) NULL,
    ADD COLUMN `updated_by` INTEGER NULL;

-- Relleno inicial: la última modificación registrada en el historial (c_cambios_apps_modules), sin contar la alta (`__created__`).
UPDATE `e_manual_puesto` m
JOIN (
    SELECT `registro_id`, MAX(`id`) AS `last_id`
    FROM `c_cambios_apps_modules`
    WHERE `nombre_tabla` = 'e_manual_puesto' AND `cambios` NOT LIKE '%\_\_created\_\_%'
    GROUP BY `registro_id`
) x ON x.`registro_id` = m.`id`
JOIN `c_cambios_apps_modules` c ON c.`id` = x.`last_id`
SET m.`updated_at` = c.`created_at`, m.`updated_by` = c.`created_by`;
