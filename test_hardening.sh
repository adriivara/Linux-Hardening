#!/bin/bash
# test_hardening.sh
# Script para verificar que las configuraciones de hardening han sido aplicadas correctamente

LOG_FILE="/var/log/test_hardening.log"
echo "---------------------------" | tee -a $LOG_FILE
echo "Iniciando pruebas de validación de hardening..." | tee -a $LOG_FILE

# Verificar que los servicios innecesarios están deshabilitados
echo "Verificando servicios innecesarios..." | tee -a $LOG_FILE
services=("telnet" "ftp" "rsh" "nfs" "smb" "avahi-daemon" "autofs" "nfs-server" "rpcbind" "cups" "lpd" "mysql" "mariadb" "postgresql" "unattended-upgrades" "clamav-freshclam" "sysstat" "sm-notify" "gdm" "lightdm" "bluetooth" "dnsmasq")
for service in "${services[@]}"; do
    if systemctl is-enabled --quiet $service 2>/dev/null; then
        echo "[ERROR] Servicio $service sigue habilitado." | tee -a $LOG_FILE
    else
        echo "[OK] Servicio $service está deshabilitado." | tee -a $LOG_FILE
    fi
done

# Verificar reglas de firewall
echo "Verificando configuración del firewall..." | tee -a $LOG_FILE
if systemctl is-active --quiet ufw; then
    ufw status | tee -a $LOG_FILE
elif systemctl is-active --quiet firewalld; then
    firewall-cmd --list-all | tee -a $LOG_FILE
else
    echo "[ERROR] No se encontró firewall activo." | tee -a $LOG_FILE
fi

# Comprobar permisos en archivos críticos
echo "Verificando permisos en archivos críticos..." | tee -a $LOG_FILE
files=("/etc/passwd" "/etc/shadow" "/etc/sudoers")
for file in "${files[@]}"; do
    ls -l $file | tee -a $LOG_FILE
done

# Verificar configuración de sudo
echo "Verificando configuración de sudo..." | tee -a $LOG_FILE
sudo -l -U $(whoami) | tee -a $LOG_FILE

# Verificar que auditd está funcionando
echo "Verificando auditoría del sistema..." | tee -a $LOG_FILE
if systemctl is-active --quiet auditd; then
    echo "[OK] auditd está en ejecución." | tee -a $LOG_FILE
    auditctl -l | tee -a $LOG_FILE
else
    echo "[ERROR] auditd no está activo." | tee -a $LOG_FILE
fi

echo "---------------------------" | tee -a $LOG_FILE
echo "Pruebas de validación de hardening completadas." | tee -a $LOG_FILE
