-- Jerarquía propia de c_ubicacion_puesto_registro_cambios (issue #114): empresa_id, cliente_id, division_id, contrato_id, corpo_id.
-- Opcionales: se llenan al crear el registro a partir de su puesto.
ALTER TABLE `c_ubicacion_puesto_registro_cambios`
    ADD COLUMN `empresa_id` INTEGER NULL,
    ADD COLUMN `cliente_id` INTEGER NULL,
    ADD COLUMN `division_id` INTEGER NULL,
    ADD COLUMN `contrato_id` INTEGER NULL,
    ADD COLUMN `corpo_id` INTEGER NULL;

-- Sin relleno aquí: las tablas de estructura (e_estructura_*) viven en la base de Planillas, no en esta base.
-- Los registros anteriores se rellenan desde el servidor con: npx tsx scripts/backfillJerarquia.ts --apply (apps/server del monorepo).
