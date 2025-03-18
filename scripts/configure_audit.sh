#!/bin/bash
# configure_audit.sh
# Script para configurar auditoría de seguridad en el sistema

LOG_FILE="/var/log/configure_audit.log"
echo "---------------------------" | tee -a $LOG_FILE
echo "Iniciando auditoría del sistema..." | tee -a $LOG_FILE

# Verificar si auditd está instalado
echo "Verificando instalación de auditd..." | tee -a $LOG_FILE
if ! command -v auditctl &> /dev/null; then
    echo "auditd no está instalado. Instalándolo..." | tee -a $LOG_FILE
    apt install -y auditd || yum install -y audit || dnf install -y auditd
fi

# Habilitar auditd y asegurarse de que inicie al arrancar
systemctl enable auditd && systemctl start auditd

echo "Auditd está en ejecución." | tee -a $LOG_FILE

# Configurar reglas de auditoría críticas
echo "Configurando reglas de auditoría..." | tee -a $LOG_FILE
AUDIT_RULES="/etc/audit/rules.d/custom.rules"
echo "-w /etc/passwd -p wa -k passwd_changes" > $AUDIT_RULES  # Monitorea cambios en /etc/passwd
echo "-w /etc/shadow -p wa -k shadow_changes" >> $AUDIT_RULES  # Monitorea cambios en /etc/shadow (contraseñas)
echo "-w /etc/sudoers -p wa -k sudoers_changes" >> $AUDIT_RULES  # Monitorea cambios en el archivo de sudoers
echo "-w /var/log/sudo.log -p wa -k sudo_activity" >> $AUDIT_RULES  # Registra actividad en sudo
echo "-a always,exit -F arch=b64 -S execve -k command_execution" >> $AUDIT_RULES  # Registra cada ejecución de comando
echo "-w /var/log/auth.log -p wa -k auth_logs" >> $AUDIT_RULES  # Monitorea cambios en logs de autenticación (Debian/Ubuntu)
echo "-w /var/log/secure -p wa -k secure_logs" >> $AUDIT_RULES  # Monitorea cambios en logs de seguridad (RHEL/CentOS/Rocky)
augenrules --load

echo "Reglas de auditoría aplicadas." | tee -a $LOG_FILE

# Listar archivos con SUID y SGID
echo "Buscando archivos con SUID y SGID..." | tee -a $LOG_FILE
find / -perm -4000 -o -perm -2000 2>/dev/null | tee -a $LOG_FILE

echo "Listado de archivos SUID/SGID guardado." | tee -a $LOG_FILE

# Identificar usuarios sin contraseña en /etc/shadow
echo "Verificando usuarios sin contraseña..." | tee -a $LOG_FILE
grep -E "^[^:]+::" /etc/shadow | tee -a $LOG_FILE

# Verificar intentos de acceso fallidos
echo "Revisando intentos de acceso fallidos..." | tee -a $LOG_FILE
auth_failures=$(grep "Failed password" /var/log/auth.log | wc -l)
echo "Intentos de acceso fallidos detectados: $auth_failures" | tee -a $LOG_FILE

echo "Auditoría completada." | tee -a $LOG_FILE
-