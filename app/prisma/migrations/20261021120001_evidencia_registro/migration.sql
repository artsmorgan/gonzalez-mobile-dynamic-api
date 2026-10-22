-- Evidencia de cada acción guardada (issue #153): dispositivo, latitud, longitud, firma, cédula, usuario y sesión.
-- Tabla CENTRAL de solo inserción (el servicio dinámico rechaza UPDATE/DELETE sobre ella): sirve también para las tablas de Planillas,
-- que no se pueden alterar. Una fila por alta o edición; el reporte muestra la más reciente de cada registro.
CREATE TABLE `c_evidencia_registro` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tabla` VARCHAR(80) NOT NULL,
    `registro_id` INTEGER NOT NULL,
    `accion` VARCHAR(10) NOT NULL,
    `dispositivo_id` VARCHAR(64) NULL,
    `latitud` VARCHAR(24) NULL,
    `longitud` VARCHAR(24) NULL,
    `ubicacion_origen` VARCHAR(12) NOT NULL,
    `capturado_en` DATETIME(0) NOT NULL,
    `cedula` VARCHAR(30) NULL,
    `usuario_id` INTEGER NULL,
    `sesion_id` VARCHAR(64) NULL,
    `firma` VARCHAR(128) NOT NULL,
    `firma_version` SMALLINT NOT NULL,
    `firma_kid` VARCHAR(20) NOT NULL,
    `creado` DATETIME(0) NOT NULL,

    INDEX `c_evidencia_registro_tabla_registro_idx`(`tabla`, `registro_id`),
    INDEX `c_evidencia_registro_usuario_idx`(`usuario_id`),
    INDEX `c_evidencia_registro_dispositivo_idx`(`dispositivo_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
