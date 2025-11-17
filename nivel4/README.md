# Nivel 4 – Monitoreo y Alertas

## Objetivo
Aprender a recopilar métricas del sistema, analizarlas y generar alertas cuando se superen ciertos límites.

## Escenario
La empresa quiere monitorear constantemente el servidor para detectar sobrecarga en:

- Uso de CPU
- Consumo de RAM
- Espacio en disco

Si se supera un umbral crítico (por ejemplo, 80%), se debe registrar una alerta y notificar al equipo.

## Requerimientos del laboratorio

El script `monitor_system.sh` debe:

1. Medir:
   - Porcentaje de CPU (usando `top` o `mpstat`)
   - Uso de RAM (`free -m`)
   - Uso de disco (`df -h /`)

2. Comparar los valores con límites predefinidos:
   - CPU > 80%
   - RAM > 80%
   - Disco > 80%

3. Si supera los límites, generar una alerta y guardar en:
	nivel4/logs/alerts.log
4. Enviar una notificación por correo o webhook.

## Bonus

- Agregar colores verdes (OK) y rojos (ALERTA) en la salida del terminal.
- Guardar un histórico diario de métricas en:
	nivel4/metrics/metrics_YYYYMMDD.log
## Cómo ejecutar el script

Desde la raíz del repositorio:

```bash
./nivel4/monitor_system.sh

