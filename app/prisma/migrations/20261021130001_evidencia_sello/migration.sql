-- La firma de la evidencia sigue el contrato de Guardify: huella SHA-256 del JSON canónico (sin clave). El HMAC con la clave del servidor pasa a
-- ser un SELLO adicional y opcional (solo existe si el servidor tiene EVIDENCE_SIGNING_KEY), así que `firma_kid` también puede quedar vacío.
ALTER TABLE `c_evidencia_registro`
    ADD COLUMN `sello` VARCHAR(64) NULL,
    MODIFY COLUMN `firma_kid` VARCHAR(20) NULL;
