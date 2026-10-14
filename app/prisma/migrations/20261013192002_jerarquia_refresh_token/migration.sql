-- Jerarquía propia de refresh_token (issue #122): empresa_id, cliente_id, division_id, contrato_id, corpo_id, puesto_id.
-- Opcionales y sin relleno: la tabla ya no se escribe desde la app, así que las columnas existen para cuando se vuelva a usar
-- (la jerarquía sería la de la plaza del empleado al iniciar sesión).
ALTER TABLE `refresh_token`
    ADD COLUMN `empresa_id` INTEGER NULL,
    ADD COLUMN `cliente_id` INTEGER NULL,
    ADD COLUMN `division_id` INTEGER NULL,
    ADD COLUMN `contrato_id` INTEGER NULL,
    ADD COLUMN `corpo_id` INTEGER NULL,
    ADD COLUMN `puesto_id` INTEGER NULL;
