#!/bin/bash

# ============================
# Script: deploy_app.sh
# Descripción:
#   Despliega una aplicación desde GitHub:
#     - Clona o hace pull del repositorio
#     - Reinicia un servicio (nginx, pm2, etc.)
#     - Registra el resultado en un archivo de log
#     - (Bonus) Envía notificación a un webhook (Slack/Discord)
# ============================

# --- CONFIGURACIÓN ---

# URL del repositorio a desplegar
REPO_URL="https://github.com/rayner-villalba-coderoad-com/clash-of-clan"

# Directorio donde se clonará/actualizará la app
# Puedes cambiarlo por una ruta que te guste, por ejemplo:
# APP_DIR="/var/www/clash-of-clan"
APP_DIR="$HOME/apps/clash-of-clan"

# Nombre del servicio a reiniciar (cambia esto según tu entorno)
# Ejemplos: "nginx", "apache2", "pm2-app"
SERVICE_NAME="nginx"

# Archivo de log
LOG_FILE="nivel3/logs/deploy.log"

# Webhook para Slack/Discord (opcional, dejar vacío si no se usa)
WEBHOOK_URL="https://discord.com/api/webhooks/1439995356157841471/iQzpuaKMqUFmkdC8dohY3FnTc0mT0sQitAbAJLKfrUGkyU5VZRcF2zYEzeK5p_cdmmXp"
# ============================

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Función para escribir en log
log() {
    local message="$1"
    echo "$TIMESTAMP | $message" | tee -a "$LOG_FILE"
}

# Función para enviar notificación al webhook (Discord/Slack)
notify_webhook() {
    local message="$1"

    # Si no hay webhook configurado, no hace nada
    if [ -z "$WEBHOOK_URL" ]; then
        return
    fi

    # Ejemplo de payload JSON simple (para Discord o Slack con webhook sencillo)
    payload="{\"content\": \"${message//\"/\\\"}\"}"

    curl -s -X POST -H "Content-Type: application/json" \
        -d "$payload" "$WEBHOOK_URL" > /dev/null 2>&1
}

log "===== Inicio de despliegue ====="

# 1) Crear directorio de la app si no existe
if [ ! -d "$APP_DIR" ]; then
    log "Directorio $APP_DIR no existe. Creándolo..."
    mkdir -p "$APP_DIR"
    if [ $? -ne 0 ]; then
        log "ERROR: No se pudo crear el directorio $APP_DIR."
        notify_webhook "❌ Despliegue fallido: no se pudo crear el directorio $APP_DIR."
        exit 1
    fi
fi

# 2) Clonar o actualizar el repositorio
if [ ! -d "$APP_DIR/.git" ]; then
    log "Repositorio no encontrado en $APP_DIR. Clonando desde $REPO_URL..."
    git clone "$REPO_URL" "$APP_DIR" >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        log "ERROR: Falló git clone."
        notify_webhook "❌ Despliegue fallido: error en git clone."
        exit 1
    fi
else
    log "Repositorio encontrado en $APP_DIR. Actualizando con git pull..."
    git -C "$APP_DIR" pull >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
        log "ERROR: Falló git pull."
        notify_webhook "❌ Despliegue fallido: error en git pull."
        exit 1
    fi
fi

log "Código actualizado correctamente desde GitHub."

# 3) Reiniciar el servicio
log "Reiniciando servicio: $SERVICE_NAME..."

# Nota: puede requerir sudo dependiendo del servicio
systemctl restart "$SERVICE_NAME" >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    log "ERROR: No se pudo reiniciar el servicio $SERVICE_NAME."
    notify_webhook "❌ Despliegue fallido: no se pudo reiniciar el servicio $SERVICE_NAME."
    exit 1
fi

log "Servicio $SERVICE_NAME reiniciado correctamente."

log "✅ Despliegue completado con éxito."
notify_webhook "✅ Despliegue completado con éxito para el servicio $SERVICE_NAME en $(hostname)."

