-- Columnas que las migraciones 20261013* van a AGREGAR y que YA existen en la base (el resultado debe estar vacío).
-- Córrela en la base destino antes de `npm run db:migrate`. Si devuelve filas, esas migraciones fallarían con "Duplicate column name".
SELECT TABLE_NAME, COLUMN_NAME
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND (TABLE_NAME, COLUMN_NAME) IN (
    ('e_manual_puesto', 'updated_at'),
    ('e_manual_puesto', 'updated_by'),
    ('e_registro_vehiculos', 'created_by'),
    ('e_registro_vehiculos', 'updated_by'),
    ('c_empleado_almuerzo', 'created_at'),
    ('c_empleado_almuerzo', 'updated_at'),
    ('c_empleado_almuerzo', 'updated_by'),
    ('c_solicitud_permiso', 'updated_at'),
    ('c_solicitud_permiso', 'updated_by'),
    ('c_bitacora_vehiculo_detenido', 'updated_at'),
    ('c_bitacora_vehiculo_detenido', 'updated_by'),
    ('e_registro_personas', 'created_by'),
    ('e_registro_personas', 'updated_by'),
    ('c_vehiculos_corporativos', 'updated_at'),
    ('c_vehiculos_corporativos', 'updated_by'),
    ('e_registro_capacitaciones', 'created_at'),
    ('e_registro_capacitaciones', 'created_by'),
    ('e_registro_capacitaciones', 'updated_at'),
    ('e_registro_capacitaciones', 'updated_by'),
    ('c_notas_voz', 'updated_at'),
    ('c_notas_voz', 'updated_by'),
    ('c_articulo_mantenimiento', 'created_by'),
    ('c_articulo_mantenimiento', 'updated_by'),
    ('c_login_marca_almuerzo', 'created_at'),
    ('c_login_marca_almuerzo', 'created_by'),
    ('c_login_marca_almuerzo', 'updated_at'),
    ('c_login_marca_almuerzo', 'updated_by'),
    ('e_llave', 'updated_at'),
    ('e_llave', 'updated_by'),
    ('e_llavero', 'updated_at'),
    ('e_llavero', 'updated_by'),
    ('refresh_token', 'created_by'),
    ('refresh_token', 'updated_at'),
    ('refresh_token', 'updated_by'),
    ('c_incidente', 'updated_at'),
    ('c_incidente', 'updated_by'),
    ('c_evaluacion_empleado', 'created_by'),
    ('c_evaluacion_empleado', 'updated_at'),
    ('c_evaluacion_empleado', 'updated_by'),
    ('e_registro_entrega_puesto', 'updated_at'),
    ('e_registro_entrega_puesto', 'updated_by'),
    ('c_encuesta_cliente', 'created_by'),
    ('c_encuesta_cliente', 'updated_at'),
    ('c_encuesta_cliente', 'updated_by'),
    ('e_control_documento_entregado_cliente', 'created_at'),
    ('e_control_documento_entregado_cliente', 'created_by'),
    ('e_control_documento_entregado_cliente', 'updated_at'),
    ('e_control_documento_entregado_cliente', 'updated_by'),
    ('c_control_asistencia', 'updated_at'),
    ('c_control_asistencia', 'updated_by'),
    ('c_checklist_supervision', 'updated_at'),
    ('c_checklist_supervision', 'updated_by'),
    ('c_ubicacion_puesto_registro_cambios', 'updated_at'),
    ('c_ubicacion_puesto_registro_cambios', 'updated_by'),
    ('c_puesto_notas', 'created_by'),
    ('c_puesto_notas', 'updated_by'),
    ('c_boleta_apreciacion_vulnerabilidad', 'created_at'),
    ('c_boleta_apreciacion_vulnerabilidad', 'created_by'),
    ('c_boleta_apreciacion_vulnerabilidad', 'updated_at'),
    ('c_boleta_apreciacion_vulnerabilidad', 'updated_by'),
    ('c_apertura_cierre_puesto', 'updated_at'),
    ('c_apertura_cierre_puesto', 'updated_by'),
    ('c_agenda_minuta', 'updated_at'),
    ('c_agenda_minuta', 'updated_by'),
    ('e_actividades', 'created_at'),
    ('e_actividades', 'created_by'),
    ('e_actividades', 'updated_at'),
    ('e_actividades', 'updated_by'),
    ('c_acta_entre_producto', 'created_at'),
    ('c_acta_entre_producto', 'created_by'),
    ('c_acta_entre_producto', 'updated_at'),
    ('c_acta_entre_producto', 'updated_by'),
    ('c_ubicacion_puesto_registro_cambios', 'empresa_id'),
    ('c_ubicacion_puesto_registro_cambios', 'cliente_id'),
    ('c_ubicacion_puesto_registro_cambios', 'division_id'),
    ('c_ubicacion_puesto_registro_cambios', 'contrato_id'),
    ('c_ubicacion_puesto_registro_cambios', 'corpo_id'),
    ('e_registro_entrega_puesto', 'empresa_id'),
    ('e_registro_entrega_puesto', 'contrato_id'),
    ('e_registro_entrega_puesto', 'division_id'),
    ('c_login_marca_almuerzo', 'empresa_id'),
    ('c_login_marca_almuerzo', 'cliente_id'),
    ('c_login_marca_almuerzo', 'division_id'),
    ('c_login_marca_almuerzo', 'contrato_id'),
    ('c_login_marca_almuerzo', 'corpo_id'),
    ('e_actividades', 'empresa_id'),
    ('e_actividades', 'cliente_id'),
    ('e_actividades', 'division_id'),
    ('e_actividades', 'contrato_id'),
    ('e_actividades', 'corpo_id'),
    ('e_actividades', 'puesto_id'),
    ('refresh_token', 'empresa_id'),
    ('refresh_token', 'cliente_id'),
    ('refresh_token', 'division_id'),
    ('refresh_token', 'contrato_id'),
    ('refresh_token', 'corpo_id'),
    ('refresh_token', 'puesto_id')
  )
ORDER BY TABLE_NAME, COLUMN_NAME;

-- Tablas que las migraciones usan y que deben existir (el resultado debe estar vacío).
SELECT t.n AS tabla_que_falta FROM (
  SELECT 'e_manual_puesto' AS n
  UNION ALL
  SELECT 'e_registro_vehiculos' AS n
  UNION ALL
  SELECT 'c_empleado_almuerzo' AS n
  UNION ALL
  SELECT 'c_solicitud_permiso' AS n
  UNION ALL
  SELECT 'c_bitacora_vehiculo_detenido' AS n
  UNION ALL
  SELECT 'e_registro_personas' AS n
  UNION ALL
  SELECT 'c_vehiculos_corporativos' AS n
  UNION ALL
  SELECT 'e_registro_capacitaciones' AS n
  UNION ALL
  SELECT 'c_notas_voz' AS n
  UNION ALL
  SELECT 'c_articulo_mantenimiento' AS n
  UNION ALL
  SELECT 'c_login_marca_almuerzo' AS n
  UNION ALL
  SELECT 'e_llave' AS n
  UNION ALL
  SELECT 'e_llavero' AS n
  UNION ALL
  SELECT 'refresh_token' AS n
  UNION ALL
  SELECT 'c_incidente' AS n
  UNION ALL
  SELECT 'c_evaluacion_empleado' AS n
  UNION ALL
  SELECT 'e_registro_entrega_puesto' AS n
  UNION ALL
  SELECT 'c_encuesta_cliente' AS n
  UNION ALL
  SELECT 'e_control_documento_entregado_cliente' AS n
  UNION ALL
  SELECT 'c_control_asistencia' AS n
  UNION ALL
  SELECT 'c_checklist_supervision' AS n
  UNION ALL
  SELECT 'c_ubicacion_puesto_registro_cambios' AS n
  UNION ALL
  SELECT 'c_puesto_notas' AS n
  UNION ALL
  SELECT 'c_boleta_apreciacion_vulnerabilidad' AS n
  UNION ALL
  SELECT 'c_apertura_cierre_puesto' AS n
  UNION ALL
  SELECT 'c_agenda_minuta' AS n
  UNION ALL
  SELECT 'e_actividades' AS n
  UNION ALL
  SELECT 'c_acta_entre_producto' AS n
  UNION ALL
  SELECT 'c_cambios_apps_modules' AS n
) t
LEFT JOIN information_schema.TABLES x ON x.TABLE_SCHEMA = DATABASE() AND x.TABLE_NAME = t.n
WHERE x.TABLE_NAME IS NULL;
