#!/bin/bash

# ===============================
# Script: cleanup_logs.sh
# Objetivo:
#   - Buscar logs con más de 7 días en la carpeta del script
#   - Comprimirlos en un .tar.gz dentro de backup/logs
#   - Eliminar los originales solo si la compresión fue exitosa
#   - Registrar la actividad en logs/cleanup_activity.log
# ===============================

# Directorio donde está el script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BACKUP_DIR="$SCRIPT_DIR/backup/logs"
LOG_FILE="$SCRIPT_DIR/logs/cleanup_activity.log"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# Asegurarse de que existan las carpetas de logs y backup
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

echo "===== Limpieza iniciada en $TIMESTAMP =====" >> "$LOG_FILE"

# 1) Buscar archivos con más de 7 días en el mismo directorio del script
OLD_FILES=$(find "$SCRIPT_DIR" -maxdepth 1 -type f -mtime +7)

if [ -z "$OLD_FILES" ]; then
    echo "$TIMESTAMP - No se encontraron archivos antiguos." >> "$LOG_FILE"
    echo "No hay archivos antiguos para procesar."
    exit 0
fi

echo "$TIMESTAMP - Archivos encontrados para procesar:" >> "$LOG_FILE"
echo "$OLD_FILES" >> "$LOG_FILE"

# 2) Crear nombre del archivo comprimido
ARCHIVE_NAME="logs_backup_$(date '+%Y%m%d_%H%M%S').tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

# 3) Comprimir los archivos antiguos
tar -czf "$ARCHIVE_PATH" $OLD_FILES 2>> "$LOG_FILE"

if [ $? -ne 0 ]; then
    echo "$TIMESTAMP - ERROR: Falló la compresión de logs." >> "$LOG_FILE"
    echo "Ocurrió un error al comprimir los archivos."
    exit 1
fi

echo "$TIMESTAMP - Compresión exitosa: $ARCHIVE_PATH" >> "$LOG_FILE"

# 4) Eliminar archivos originales
echo "$OLD_FILES" | xargs rm -f

echo "$TIMESTAMP - Archivos originales eliminados." >> "$LOG_FILE"
echo "===== Limpieza finalizada =====" >> "$LOG_FILE"
