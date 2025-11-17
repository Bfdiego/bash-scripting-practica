# Nivel 3 – Despliegue automatizado (mini CI/CD)

## Objetivo
Practicar la integración continua y la automatización de despliegues simples usando Bash.

## Escenario
Cada vez que un desarrollador actualiza el repositorio en GitHub, se debe desplegar el nuevo código en un servidor web.

En este nivel crearemos un script de despliegue llamado `deploy_app.sh`.

## Requerimientos del laboratorio

El script `deploy_app.sh` debe:

1. **Clonar o actualizar el repositorio** desde GitHub:

   ```text
   https://github.com/rayner-villalba-coderoad-com/clash-of-clan
