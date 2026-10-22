-- Documentos (manuales de trabajo): versiones con histórico (#155), entrega a los empleados (#154), nota del quiz consolidada (#156)
-- y asignaciones vigentes que llegan desde Guardify (#157). Todo es aditivo: lo existente queda en la versión 1.

-- Versión vigente del documento y datos de Guardify (id del documento/versión allá y huellas del contenido).
ALTER TABLE `e_manual_puesto`
    ADD COLUMN `version` INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN `externo_documento_id` VARCHAR(64) NULL,
    ADD COLUMN `externo_version_id` VARCHAR(64) NULL,
    ADD COLUMN `sello` VARCHAR(64) NULL,
    ADD COLUMN `archivo_sha256` VARCHAR(64) NULL;
CREATE UNIQUE INDEX `uq_e_manual_puesto_externo_documento` ON `e_manual_puesto`(`externo_documento_id`);

-- Histórico: una fila por versión anterior (la vigente vive en e_manual_puesto). Nunca se borra.
CREATE TABLE `e_manual_puesto_version` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `manual_puesto_id` INTEGER NOT NULL,
    `version` INTEGER NOT NULL,
    `title` LONGTEXT NOT NULL,
    `description` LONGTEXT NOT NULL,
    `classification` LONGTEXT NULL,
    `quiz` LONGTEXT NULL,
    `externo_version_id` VARCHAR(64) NULL,
    `sello` VARCHAR(64) NULL,
    `archivo_sha256` VARCHAR(64) NULL,
    `publicado_por` VARCHAR(190) NULL,
    `publicado_en` DATETIME(0) NOT NULL,

    UNIQUE INDEX `uq_e_manual_puesto_version`(`manual_puesto_id`, `version`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Archivos: cada uno pertenece a la versión en que se agregó y deja de aplicar desde `retirado_en_version` (no se borra: el histórico lo conserva).
ALTER TABLE `e_archivos_manual_puesto`
    ADD COLUMN `version` INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN `retirado_en_version` INTEGER NULL,
    ADD COLUMN `sha256` VARCHAR(64) NULL;

-- Firma / visualización por versión + nota consolidada del quiz (calculada una vez, inmutable).
ALTER TABLE `e_empleado_visualizacion_manual_puesto`
    ADD COLUMN `version` INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN `sello_version` VARCHAR(64) NULL,
    ADD COLUMN `nota` DOUBLE NULL,
    ADD COLUMN `nota_puntos` DOUBLE NULL,
    ADD COLUMN `nota_total` DOUBLE NULL,
    ADD COLUMN `nota_minimo` DOUBLE NULL,
    ADD COLUMN `nota_fecha` DATETIME(0) NULL,
    ADD COLUMN `nota_calificado_por` INTEGER NULL;

-- Entrega a cada empleado: cuándo se le entregó, qué versión, y por qué vía llegó.
ALTER TABLE `e_empleados_manual_puesto`
    ADD COLUMN `created_at` DATETIME(0) NULL,
    ADD COLUMN `entregado_en` DATETIME(0) NULL,
    ADD COLUMN `version` INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN `origen` VARCHAR(20) NULL;

-- Asignaciones vigentes (Guardify): una REGLA mientras nadie la termine; quien entra después al puesto/empresa recibe el documento.
CREATE TABLE `e_documento_asignacion` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `manual_puesto_id` INTEGER NOT NULL,
    `externo_envio_id` VARCHAR(64) NULL,
    `audience` VARCHAR(20) NOT NULL,
    `scope` LONGTEXT NULL,
    `vigente` BOOLEAN NOT NULL DEFAULT true,
    `solicitado_por` VARCHAR(190) NULL,
    `creado_en` DATETIME(0) NOT NULL,
    `terminado_en` DATETIME(0) NULL,
    `terminado_por` VARCHAR(190) NULL,

    INDEX `e_documento_asignacion_manual_idx`(`manual_puesto_id`),
    INDEX `e_documento_asignacion_vigente_idx`(`vigente`),
    UNIQUE INDEX `uq_e_documento_asignacion_externo`(`externo_envio_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
