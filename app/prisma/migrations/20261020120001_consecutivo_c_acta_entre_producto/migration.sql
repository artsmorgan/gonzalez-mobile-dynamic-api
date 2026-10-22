-- Consecutivo del acta de entrega de productos (issue #138). Es por EMPRESA y empieza en 1 (se muestra con ceros a la izquierda: 0001).
-- Es opcional en la tabla (NULL = acta aún sin numerar); el servidor lo asigna al crear el acta y la unicidad por empresa la garantiza el índice.
ALTER TABLE `c_acta_entre_producto`
    ADD COLUMN `consecutivo` INTEGER NULL;

-- Relleno de las actas existentes: por orden de `id` dentro de cada empresa (requiere MySQL 8, funciones de ventana).
UPDATE `c_acta_entre_producto` t
JOIN (
    SELECT `id`, ROW_NUMBER() OVER (PARTITION BY `empresa_id` ORDER BY `id`) AS `n`
    FROM `c_acta_entre_producto`
) x ON x.`id` = t.`id`
SET t.`consecutivo` = x.`n`
WHERE t.`consecutivo` IS NULL;

-- Un consecutivo no se repite dentro de la empresa (varios NULL sí están permitidos por MySQL).
CREATE UNIQUE INDEX `uq_acta_entre_producto_empresa_consecutivo` ON `c_acta_entre_producto`(`empresa_id`, `consecutivo`);
