#!/bin/bash
# configure_firewall.sh
# Script para configurar un firewall tanto en sistemas Debian/Ubuntu como en distribuciones basadas en RedHat

# Definir la ubicación del archivo de log
LOG_FILE="/var/log/configurar_firewall.log"

echo "---------------------------" | tee -a $LOG_FILE
echo "Iniciando la configuración del firewall..." | tee -a $LOG_FILE

# Comprobamos la distribución del sistema a través de /etc/os-release
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION=$VERSION_ID
else
    echo "No se pudo detectar la distribución del sistema." | tee -a $LOG_FILE
    exit 1
fi

# Comprobamos si estamos en una distribución basada en Debian/Ubuntu
if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "debian" ]]; then
    # Si estamos en Debian/Ubuntu, usamos UFW
    echo "Sistema basado en Debian/Ubuntu detectado. Usando UFW..." | tee -a $LOG_FILE

    # Verificar si UFW está instalado
    if ! command -v ufw &> /dev/null; then
        echo "UFW no está instalado. Instalando..." | tee -a $LOG_FILE
        sudo apt-get update
        sudo apt-get install ufw -y
    fi

    # Habilitar UFW si no está habilitado
    if ! ufw status | grep -q "active"; then
        echo "Habilitando UFW..." | tee -a $LOG_FILE
        sudo ufw enable
        echo "UFW habilitado con éxito." | tee -a $LOG_FILE
    else
        echo "UFW ya está habilitado." | tee -a $LOG_FILE
    fi

    # Configurar reglas básicas de firewall
    echo "Permitiendo acceso SSH (puerto 22)..." | tee -a $LOG_FILE
    sudo ufw allow ssh
    echo "Permitiendo acceso HTTP (puerto 80)..." | tee -a $LOG_FILE
    sudo ufw allow http
    echo "Permitiendo acceso HTTPS (puerto 443)..." | tee -a $LOG_FILE
    sudo ufw allow https

    # Denegar todo el tráfico por defecto (es decir, todo el tráfico entrante)
    echo "Denegando todo el tráfico entrante por defecto..." | tee -a $LOG_FILE
    sudo ufw default deny incoming

    # Permitir tráfico saliente
    echo "Permitiendo tráfico saliente por defecto..." | tee -a $LOG_FILE
    sudo ufw default allow outgoing

    # Habilitar el firewall para que se inicie automáticamente en el arranque
    echo "Habilitando UFW para inicio automático..." | tee -a $LOG_FILE
    sudo ufw enable

    # Ver el estado del firewall
    echo "Estado del firewall:" | tee -a $LOG_FILE
    sudo ufw status verbose | tee -a $LOG_FILE

    echo "Configuración del firewall completada." | tee -a $LOG_FILE

elif [[ "$DISTRO" == "rhel" || "$DISTRO" == "centos" || "$DISTRO" == "fedora" || "$DISTRO" == "rocky" ]]; then
    # Si estamos en una distribución basada en Red Hat (RHEL, CentOS, Fedora, Rocky Linux), usamos firewalld
    echo "Sistema basado en Red Hat detectado. Usando firewalld..." | tee -a $LOG_FILE

    # Verificar si firewalld está instalado
    if ! command -v firewall-cmd &> /dev/null; then
        echo "firewalld no está instalado. Instalando..." | tee -a $LOG_FILE
        sudo dnf install firewalld -y   # Para sistemas basados en DNF (como Fedora/Rocky/RHEL8+)
        sudo yum install firewalld -y   # Para sistemas basados en YUM (como CentOS/RHEL7-)
    fi

    # Verificar si firewalld está en ejecución
    if ! systemctl is-active --quiet firewalld; then
        echo "Habilitando firewalld..." | tee -a $LOG_FILE
        sudo systemctl start firewalld
        sudo systemctl enable firewalld
        echo "firewalld habilitado con éxito." | tee -a $LOG_FILE
    else
        echo "firewalld ya está habilitado." | tee -a $LOG_FILE
    fi

    # Configurar reglas básicas de firewall con firewalld

    # Permitir SSH (puerto 22)
    echo "Permitiendo acceso SSH (puerto 22)..." | tee -a $LOG_FILE
    sudo firewall-cmd --zone=public --add-service=ssh --permanent

    # Permitir HTTP (puerto 80)
    echo "Permitiendo acceso HTTP (puerto 80)..." | tee -a $LOG_FILE
    sudo firewall-cmd --zone=public --add-service=http --permanent

    # Permitir HTTPS (puerto 443)
    echo "Permitiendo acceso HTTPS (puerto 443)..." | tee -a $LOG_FILE
    sudo firewall-cmd --zone=public --add-service=https --permanent

    # Denegar todo el tráfico entrante por defecto (hacemos un rechazo explícito)
    echo "Denegando todo el tráfico entrante por defecto..." | tee -a $LOG_FILE
    sudo firewall-cmd --zone=public --set-target=DROP --permanent

    # Permitir tráfico saliente
    echo "Permitiendo tráfico saliente por defecto..." | tee -a $LOG_FILE
    sudo firewall-cmd --zone=public --set-target=ACCEPT --permanent

    # Recargar la configuración del firewall para aplicar los cambios
    echo "Recargando la configuración del firewall..." | tee -a $LOG_FILE
    sudo firewall-cmd --reload

    # Ver el estado del firewall
    echo "Estado del firewall:" | tee -a $LOG_FILE
    sudo firewall-cmd --list-all | tee -a $LOG_FILE

    echo "Configuración del firewall completada." | tee -a $LOG_FILE

else
    echo "Distribución no reconocida. No se puede configurar el firewall automáticamente." | tee -a $LOG_FILE
    exit 1
fi
