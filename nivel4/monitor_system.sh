#!/bin/bash

# ===============================
# monitor_system.sh
# Monitoreo de CPU, RAM y Disco
# ===============================

# --- CONFIGURACIÓN ---
CPU_LIMIT=80
RAM_LIMIT=80
DISK_LIMIT=80

ALERTS_LOG="nivel4/logs/alerts.log"
METRICS_DIR="nivel4/metrics"
DATE=$(date "+%Y%m%d")
METRICS_FILE="$METRICS_DIR/metrics_$DATE.log"

# Webhook opcional (Slack/Discord)
WEBHOOK_URL=""   # Colocar URL si quieres notificaciones

# Colores
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"    # No color

# Función para enviar webhook
send_webhook() {
    local msg="$1"
    if [ -n "$WEBHOOK_URL" ]; then
        payload="{\"content\": \"${msg//\"/\\\"}\"}"
        curl -s -X POST -H "Content-Type: application/json" \
        -d "$payload" "$WEBHOOK_URL" > /dev/null 2>&1
    fi
}

# Función para escribir en archivo de alertas
log_alert() {
    local msg="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp | $msg" >> "$ALERTS_LOG"
    send_webhook "⚠️ ALERTA: $msg"
}

# ================================================
# 1) Obtener métricas del sistema
# ================================================

# CPU (%) - usando top
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_USAGE=${CPU_USAGE%.*}   # eliminar decimales

# RAM (%) - usando free
RAM_USAGE=$(free | awk '/Mem:/ { printf("%.0f", $3/$2 * 100) }')

# DISCO (%) - partición root
DISK_USAGE=$(df -h / | awk 'NR==2 {gsub("%",""); print $5}')

# ================================================
# 2) Mostrar datos por pantalla con colores
# ================================================
echo ""
echo "===== MÉTRICAS DEL SISTEMA ====="
[[ $CPU_USAGE -gt $CPU_LIMIT ]] && echo -e "CPU:   ${RED}$CPU_USAGE%${NC}" || echo -e "CPU:   ${GREEN}$CPU_USAGE%${NC}"
[[ $RAM_USAGE -gt $RAM_LIMIT ]] && echo -e "RAM:   ${RED}$RAM_USAGE%${NC}" || echo -e "RAM:   ${GREEN}$RAM_USAGE%${NC}"
[[ $DISK_USAGE -gt $DISK_LIMIT ]] && echo -e "DISCO: ${RED}$DISK_USAGE%${NC}" || echo -e "DISCO: ${GREEN}$DISK_USAGE%${NC}"

# ================================================
# 3) Guardar histórico diario
# ================================================
echo "$(date "+%Y-%m-%d %H:%M:%S") | CPU: $CPU_USAGE% | RAM: $RAM_USAGE% | DISCO: $DISK_USAGE%" >> "$METRICS_FILE"

# ================================================
# 4) Alertas si se supera el límite
# ================================================
if [[ $CPU_USAGE -gt $CPU_LIMIT ]]; then
    log_alert "CPU alta: $CPU_USAGE% (Límite: $CPU_LIMIT%)"
fi

if [[ $RAM_USAGE -gt $RAM_LIMIT ]]; then
    log_alert "RAM alta: $RAM_USAGE% (Límite: $RAM_LIMIT%)"
fi

if [[ $DISK_USAGE -gt $DISK_LIMIT ]]; then
    log_alert "Disco lleno: $DISK_USAGE% (Límite: $DISK_LIMIT%)"
fi

