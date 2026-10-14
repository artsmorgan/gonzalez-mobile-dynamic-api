-- Auditoría y trazabilidad de refresh_token (issue #122): columnas que faltaban (created_by, updated_at, updated_by).
-- Son opcionales: los registros anteriores quedan en NULL salvo lo que se pueda recuperar del historial.
ALTER TABLE `refresh_token`
    ADD COLUMN `created_by` INTEGER NULL,
    ADD COLUMN `updated_at` DATETIME(0) NULL,
    ADD COLUMN `updated_by` INTEGER NULL;
