-- Jerarquía propia de e_actividades (issue #107): empresa_id, cliente_id, division_id, contrato_id, corpo_id, puesto_id.
-- Una actividad puede tener varios puestos: cada nivel solo se llena cuando todos sus puestos coinciden en él (si no, queda NULL);
-- `puesto_id` solo cuando la actividad tiene exactamente un puesto. Una actividad sin puestos queda con todos los niveles en NULL.
ALTER TABLE `e_actividades`
    ADD COLUMN `empresa_id` INTEGER NULL,
    ADD COLUMN `cliente_id` INTEGER NULL,
    ADD COLUMN `division_id` INTEGER NULL,
    ADD COLUMN `contrato_id` INTEGER NULL,
    ADD COLUMN `corpo_id` INTEGER NULL,
    ADD COLUMN `puesto_id` INTEGER NULL;

-- Sin relleno aquí: las tablas de estructura (e_estructura_*) viven en la base de Planillas, no en esta base.
-- Los registros anteriores se rellenan desde el servidor con: npx tsx scripts/backfillJerarquia.ts --apply (apps/server del monorepo).
