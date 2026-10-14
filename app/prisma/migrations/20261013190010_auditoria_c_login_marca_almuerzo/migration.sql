-- Auditoría y trazabilidad de c_login_marca_almuerzo (issue #125): columnas que faltaban (created_at, created_by, updated_at, updated_by).
-- Son opcionales: los registros anteriores quedan en NULL salvo lo que se pueda recuperar del historial.
ALTER TABLE `c_login_marca_almuerzo`
    ADD COLUMN `created_at` DATETIME(0) NULL,
    ADD COLUMN `created_by` INTEGER NULL,
    ADD COLUMN `updated_at` DATETIME(0) NULL,
    ADD COLUMN `updated_by` INTEGER NULL;
