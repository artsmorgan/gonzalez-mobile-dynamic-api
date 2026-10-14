-- Jerarquía propia de e_registro_entrega_puesto (issue #119): empresa_id, contrato_id, division_id.
-- Opcionales: se llenan al crear el registro a partir de su puesto.
ALTER TABLE `e_registro_entrega_puesto`
    ADD COLUMN `empresa_id` INTEGER NULL,
    ADD COLUMN `contrato_id` INTEGER NULL,
    ADD COLUMN `division_id` INTEGER NULL;

-- Sin relleno aquí: las tablas de estructura (e_estructura_*) viven en la base de Planillas, no en esta base.
-- Los registros anteriores se rellenan desde el servidor con: npx tsx scripts/backfillJerarquia.ts --apply (apps/server del monorepo).
