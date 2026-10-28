-- Idempotencia del servidor (issues #172 y #181; protocolo de acciones de Guardify): la misma `Idempotency-Key` sobre la misma acción devuelve el mismo
-- resultado sin repetir el efecto. La clave se guarda como SHA-256 (nunca en claro) y su unicidad es el candado entre procesos: solo una petición reserva.
-- Tabla de uso interno del servidor de la app (no es de Planillas). Un resultado se recuerda 30 días (`expira`); una reserva «en_curso» de más de
-- 10 minutos se considera abandonada. Las filas vencidas se retiran al reutilizar su clave; si hace falta limpiarlas en lote:
--   DELETE FROM `c_clave_idempotencia` WHERE `expira` < NOW();
CREATE TABLE `c_clave_idempotencia` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `clave_hash` VARCHAR(64) NOT NULL,
    `ambito` VARCHAR(120) NOT NULL,
    `recurso` VARCHAR(80) NOT NULL,
    `actor_id` INTEGER NULL,
    `estado` VARCHAR(12) NOT NULL,
    `http_status` SMALLINT NULL,
    `respuesta` LONGTEXT NULL,
    `creado` DATETIME(0) NOT NULL,
    `expira` DATETIME(0) NOT NULL,

    UNIQUE INDEX `c_clave_idempotencia_clave_hash_key`(`clave_hash`),
    INDEX `c_clave_idempotencia_expira_idx`(`expira`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
