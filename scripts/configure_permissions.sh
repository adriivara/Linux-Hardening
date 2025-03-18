#!/bin/bash
# configure_permissions.sh
# Script para configurar permisos seguros en el sistema

LOG_FILE="/var/log/configure_permissions.log"
echo "---------------------------" | tee -a $LOG_FILE
echo "Iniciando configuración de permisos..." | tee -a $LOG_FILE

# Asegurar archivos críticos en /etc
echo "Configurando permisos en archivos críticos del sistema..." | tee -a $LOG_FILE
chmod 640 /etc/passwd /etc/group /etc/gshadow /etc/shadow 2>/dev/null && echo "Permisos de /etc/passwd y similares configurados." | tee -a $LOG_FILE

# Asegurar directorios de logs
echo "Asegurando permisos en /var/log..." | tee -a $LOG_FILE
chmod -R go-rwx /var/log && echo "Permisos en /var/log configurados." | tee -a $LOG_FILE

# Restringir permisos en archivos de claves SSH
echo "Asegurando permisos en claves SSH..." | tee -a $LOG_FILE
chmod 600 /root/.ssh/id_rsa 2>/dev/null && echo "Permisos en claves SSH configurados." | tee -a $LOG_FILE

# Asegurar directorio /home para cada usuario
for dir in /home/*; do
    if [ -d "$dir" ]; then
        chmod 700 "$dir" && echo "Directorio $dir asegurado." | tee -a $LOG_FILE
    fi
done

# Proteger scripts críticos en /usr/local/bin
echo "Asegurando permisos en scripts personalizados..." | tee -a $LOG_FILE
chmod -R 750 /usr/local/bin 2>/dev/null && echo "Permisos en /usr/local/bin configurados." | tee -a $LOG_FILE

# Restringir acceso a /root
echo "Protegiendo el directorio /root..." | tee -a $LOG_FILE
chmod 700 /root 2>/dev/null && echo "Permisos en /root configurados." | tee -a $LOG_FILE

# Asegurar permisos en /tmp y /var/tmp
echo "Protegiendo /tmp y /var/tmp..." | tee -a $LOG_FILE
chmod 1777 /tmp /var/tmp && echo "Permisos en /tmp y /var/tmp configurados." | tee -a $LOG_FILE
mount -o remount,noexec /tmp && mount -o remount,noexec /var/tmp && echo "Ejecución de binarios en /tmp y /var/tmp deshabilitada." | tee -a $LOG_FILE

# Asegurar el PATH eliminando '.'
echo "Asegurando la variable PATH..." | tee -a $LOG_FILE
if echo "$PATH" | grep -q "\."; then
    export PATH=$(echo "$PATH" | sed -e 's/:\.//g' -e 's/\.://g')
    echo "Variable PATH asegurada." | tee -a $LOG_FILE
else
    echo "PATH ya está seguro." | tee -a $LOG_FILE
fi

# Finalización
echo "Configuración de permisos completada." | tee -a $LOG_FILE
