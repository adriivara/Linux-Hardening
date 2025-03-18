#!/bin/bash
# configure_sudo.sh
# Script para configurar sudo de manera segura

LOG_FILE="/var/log/configure_sudo.log"
echo "---------------------------" | tee -a $LOG_FILE
echo "Iniciando configuración de sudo..." | tee -a $LOG_FILE

# Asegurar que solo los usuarios del grupo sudo pueden usar sudo
echo "Verificando grupo de sudo..." | tee -a $LOG_FILE
if grep -q '^%sudo' /etc/sudoers; then
    echo "Grupo sudo ya definido en /etc/sudoers." | tee -a $LOG_FILE
else
    echo "%sudo ALL=(ALL) ALL" | tee -a /etc/sudoers.d/sudo_group
    echo "Grupo sudo añadido a /etc/sudoers." | tee -a $LOG_FILE
fi

# Evitar el uso de NOPASSWD en sudoers
echo "Revisando configuraciones de NOPASSWD en sudoers..." | tee -a $LOG_FILE
if grep -q 'NOPASSWD' /etc/sudoers; then
    sed -i 's/\(.*NOPASSWD:.*\)/#\1/' /etc/sudoers
    visudo -cf /etc/sudoers && echo "Se ha deshabilitado NOPASSWD en sudoers." | tee -a $LOG_FILE
else
    echo "No se encontraron configuraciones inseguras de NOPASSWD." | tee -a $LOG_FILE
fi

# Registrar todos los comandos ejecutados con sudo
echo "Configurando registro de comandos sudo..." | tee -a $LOG_FILE
if grep -q '^Defaults logfile="/var/log/sudo.log"' /etc/sudoers; then
    echo "El registro de sudo ya está configurado." | tee -a $LOG_FILE
else
    echo 'Defaults logfile="/var/log/sudo.log"' | tee -a /etc/sudoers.d/logging
    echo "Se ha habilitado el registro de comandos ejecutados con sudo." | tee -a $LOG_FILE
fi

# Restringir uso de sudo su
echo "Restringiendo escalada de privilegios con sudo su..." | tee -a $LOG_FILE
echo 'Defaults !rootpw, !targetpw, !runaspw' >> /etc/sudoers.d/restrictions
echo "Restricciones de sudo aplicadas." | tee -a $LOG_FILE

# Proteger el archivo /etc/sudoers y sus directorios
echo "Protegiendo archivos de configuración de sudo..." | tee -a $LOG_FILE
chmod 440 /etc/sudoers && echo "Permisos de /etc/sudoers asegurados." | tee -a $LOG_FILE
chmod 750 /etc/sudoers.d && echo "Permisos de /etc/sudoers.d asegurados." | tee -a $LOG_FILE

# Configurar timeout de sudo para reducir riesgos
echo "Configurando timeout de sudo..." | tee -a $LOG_FILE
if grep -q '^Defaults timestamp_timeout=' /etc/sudoers; then
    sed -i 's/^Defaults timestamp_timeout=.*/Defaults timestamp_timeout=5/' /etc/sudoers
else
    echo 'Defaults timestamp_timeout=5' | tee -a /etc/sudoers.d/timeout
fi
visudo -cf /etc/sudoers && echo "Timeout de sudo configurado a 5 minutos." | tee -a $LOG_FILE

# Finalización
echo "Configuración de sudo completada." | tee -a $LOG_FILE
