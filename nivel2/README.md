# Nivel 2 – Automatización de tareas de mantenimiento

## Objetivo
Aprender a:
- Manipular archivos
- Redirigir salidas (`>`, `>>`)
- Usar `find` para filtrar por fecha
- Comprimir archivos (`tar`)
- Programar tareas automáticas con cron

## Escenario
El equipo DevOps necesita limpiar logs antiguos del sistema para liberar espacio en disco.

## Laboratorio

Debes crear un script `cleanup_logs.sh` que:

1. Busque en `/var/log` todos los archivos con **más de 7 días**:
   ```bash
   find /var/log -type f -mtime +7

