#!/bin/bash
# disable_services.sh
# Script para deshabilitar servicios innecesarios

# Definir la ubicación del archivo de log
LOG_FILE="/var/log/deshabilitar_servicios.log"

echo "---------------------------" | tee -a $LOG_FILE
echo "Iniciando el proceso de deshabilitación de servicios innecesarios..." | tee -a $LOG_FILE

# Lista de servicios innecesarios comunes, se pueden añadir o quitar más, como se desee
services=("telnet" "ftp" "rsh" "nfs" "smb" "avahi-daemon" "autofs" "nfs-server" "rpcbind" \
          "cups" "lpd" "mysql" "mariadb" "postgresql" "unattended-upgrades" \
          "clamav-freshclam" "sysstat" "sm-notify" "gdm" "lightdm" "bluetooth" \
          "dnsmasq")

# Iterar a través de cada servicio en la lista
for service in "${services[@]}"; do
    # Verificar si el servicio existe en el sistema
    if systemctl list-units --type=service --all | grep -q "^$service.service"; then
        # Verificar si el servicio está habilitado
        if systemctl is-enabled --quiet $service; then
            echo "Deshabilitando servicio $service..." | tee -a $LOG_FILE
            # Detener el servicio si está activo
            if systemctl is-active --quiet $service; then
                systemctl stop $service
                echo "Servicio $service detenido." | tee -a $LOG_FILE
            fi
            # Deshabilitar el servicio
            systemctl disable $service
            echo "Servicio $service deshabilitado con éxito." | tee -a $LOG_FILE
        else
            echo "Servicio $service ya está deshabilitado o no está habilitado." | tee -a $LOG_FILE
        fi
    else
        echo "El servicio $service no existe en el sistema." | tee -a $LOG_FILE
    fi
done

echo "Proceso de deshabilitación de servicios completado." | tee -a $LOG_FILE