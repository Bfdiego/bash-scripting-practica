#!/bin/bash

# ============================
# Script: check_service.sh
# Descripción:
#   Verifica el estado de un servicio en Linux usando systemd.
#   Guarda el resultado en un archivo de log y (opcionalmente)
#   envía un correo si el servicio está inactivo.
# ============================

# 1) Validar que se haya pasado el nombre del servicio como parámetro
if [ -z "$1" ]; then
    echo "Uso: $0 <nombre-servicio>"
    echo "Ejemplo: $0 nginx"
    exit 1
fi

SERVICE="$1"
LOG_FILE="nivel1/logs/service_status.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Cambia este correo por el tuyo para el bonus
ADMIN_EMAIL="dayo.alba.p@gmail.com"

# 2) Verificar si el servicio existe (systemctl status devuelve error si no existe)
systemctl status "$SERVICE" &> /dev/null
if [ $? -ne 0 ]; then
    echo "$TIMESTAMP - El servicio '$SERVICE' no existe o no está administrado por systemd."
    echo "$TIMESTAMP | Servicio: $SERVICE | Estado: desconocido (no existe)" >> "$LOG_FILE"
    exit 1
fi

# 3) Obtener el estado del servicio
STATUS=$(systemctl is-active "$SERVICE")

# 4) Mostrar mensaje en pantalla según el estado
if [ "$STATUS" = "active" ]; then
    echo "$TIMESTAMP - ✔ El servicio '$SERVICE' está ACTIVO."
else
    echo "$TIMESTAMP - ❌ ALERTA: El servicio '$SERVICE' está INACTIVO."
    
    # BONUS: enviar correo si está inactivo (requiere tener configurado mail/sendmail)
    if command -v mail &> /dev/null; then
        echo "El servicio $SERVICE está INACTIVO en $(hostname) a las $TIMESTAMP." \
            | mail -s "Alerta: servicio $SERVICE inactivo" "$ADMIN_EMAIL"
    fi
fi

# 5) Guardar resultado en el archivo de log con timestamp
echo "$TIMESTAMP | Servicio: $SERVICE | Estado: $STATUS" >> "$LOG_FILE"
