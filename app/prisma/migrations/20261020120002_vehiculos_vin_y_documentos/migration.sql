-- Vehículos corporativos: VIN y datos (texto) de los documentos (issues #139 y #143).
-- Todos opcionales. Los booleanos titulo_propiedad / rtv / marchamo siguen igual (Sí/No); las columnas *_num guardan el número o dato
-- del documento. El VIN de los vehículos anteriores se puede rellenar desde la última revisión con scripts/backfillVinVehiculos.ts (en monorepo/apps/server).
ALTER TABLE `c_vehiculos_corporativos`
    ADD COLUMN `vin` VARCHAR(40) NULL,
    ADD COLUMN `titulo_propiedad_num` VARCHAR(100) NULL,
    ADD COLUMN `rtv_num` VARCHAR(100) NULL,
    ADD COLUMN `marchamo_num` VARCHAR(100) NULL;
