# Nivel 1 – Fundamentos del Scripting en Bash

## Objetivo
Aprender a crear y ejecutar scripts básicos usando:
- Variables
- Parámetros
- Condicionales (`if`)
- Loops (en los ejemplos)
- Uso de comandos del sistema (`systemctl`)
- Creación de logs

## Descripción del Laboratorio
Tu empresa necesita un script para verificar la salud de un servicio en Linux (por ejemplo, Nginx o Apache).

## Requerimientos del script `check_service.sh`
El script debe:

1. Recibir el nombre de un servicio como parámetro  
   **Ejemplo:**  
   ```bash
   ./check_service.sh nginxO
   ./check_service.sh apache2
