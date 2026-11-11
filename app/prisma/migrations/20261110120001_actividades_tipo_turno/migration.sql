-- Tipos de turno de una actividad: una actividad puede aplicar a varios (D = Diurno, M = Mixto, N = Nocturno). Una fila por combinación
-- actividad + tipo. Reemplaza al valor único de `e_actividades.tipo_turno`, que se conserva como respaldo (el servidor de la app guarda ahí el primer
-- tipo) para lo que aún lo lea; la fuente de verdad es esta tabla.
CREATE TABLE `c_actividades_tipo_turno` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `actividad_id` INTEGER NOT NULL,
    `tipo_turno` VARCHAR(1) NOT NULL,

    UNIQUE INDEX `c_actividades_tipo_turno_actividad_id_tipo_turno_key`(`actividad_id`, `tipo_turno`),
    INDEX `c_actividades_tipo_turno_tipo_turno_idx`(`tipo_turno`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Al borrar la actividad se borran sus tipos de turno.
ALTER TABLE `c_actividades_tipo_turno` ADD CONSTRAINT `c_actividades_tipo_turno_actividad_id_fkey` FOREIGN KEY (`actividad_id`) REFERENCES `e_actividades`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- Las actividades que ya existían conservan su tipo único (solo D, M o N; cualquier otro valor se ignora y la actividad queda sin restricción de turno).
INSERT INTO `c_actividades_tipo_turno` (`actividad_id`, `tipo_turno`)
SELECT `id`, UPPER(TRIM(`tipo_turno`)) FROM `e_actividades` WHERE UPPER(TRIM(`tipo_turno`)) IN ('D', 'M', 'N');
