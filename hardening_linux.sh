#!/bin/bash
# hardening_linux.sh
# Script principal que ejecuta el resto de scripts para hacer el hardening en el sistema Linux


echo "---------------------------"
echo "Iniciando el proceso de hardening en Linux..."

# Ejecutar el script de deshabilitar servicios innecesarios
./scripts/disable_services.sh

# Ejecutar el script para configurar el firewall
./scripts/configure_firewall.sh

# Ejecutar el script para reforzar los permisos de archivos
./scripts/configure_permissions.sh

# Ejecutar el script para configurar sudo
./scripts/configure_sudo.sh

# Ejecutar el script para configurar la auditoría
./scripts/configure_audit.sh

echo "---------------------------"
echo "Proceso de hardening finalizado"