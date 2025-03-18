# Políticas de Hardening Aplicadas

Este documento describe las medidas de seguridad implementadas en el proyecto de hardening para Linux, explicando su propósito y beneficios.

## 1. Deshabilitación de Servicios Innecesarios
Se deshabilitan servicios que no son esenciales para la operación del sistema y que pueden representar vulnerabilidades de seguridad.

- **Telnet, FTP, RSH**: Protocolos inseguros que transmiten credenciales en texto plano.
- **NFS, SMB**: Servicios de compartición de archivos que pueden exponer datos sensibles si no están configurados correctamente.
- **Avahi, Autofs, RPCBind**: Servicios de red que pueden ser utilizados en ataques de descubrimiento o escalamiento de privilegios.
- **CUPS, LPD**: Servicios de impresión que pueden ser innecesarios en entornos sin impresoras conectadas.
- **MySQL, MariaDB, PostgreSQL**: Motores de bases de datos que no deberían estar corriendo si no se utilizan activamente.
- **Unattended-upgrades**: En algunos entornos, las actualizaciones automáticas pueden interferir con configuraciones personalizadas.
- **ClamAV, Sysstat, Bluetooth, Dnsmasq**: Servicios que pueden representar riesgos si no se necesitan.

## 2. Configuración del Firewall
Se configura un firewall para restringir accesos no autorizados.

- **Ubuntu/Debian**: Uso de `ufw` para definir reglas de entrada y salida.
- **RHEL/Rocky Linux**: Uso de `firewalld` para gestionar zonas y reglas de tráfico.
- **Reglas aplicadas**:
  - Bloqueo de tráfico entrante por defecto.
  - Permitir solo los puertos y protocolos necesarios.
  - Aplicación de políticas estrictas para minimizar la superficie de ataque.

## 3. Refuerzo de Permisos en Archivos Críticos
Se aplican permisos restrictivos a archivos sensibles para evitar accesos no autorizados.

- **/etc/passwd**: Solo lectura para usuarios normales.
- **/etc/shadow**: Acceso restringido solo a root.
- **/etc/sudoers**: Solo modificable por root y protegido contra cambios incorrectos.
- Eliminación de permisos SUID y SGID en binarios innecesarios para evitar escaladas de privilegios.

## 4. Configuración de Sudo
Se endurece la configuración de `sudo` para evitar abusos de privilegios.

- **Solo usuarios autorizados pueden ejecutar sudo**.
- **Se deshabilita el uso de sudo sin contraseña**.
- **Registro de todos los comandos ejecutados con sudo para auditoría**.

## 5. Configuración de Auditoría
Se implementa `auditd` para registrar eventos de seguridad críticos.

- **Registro de accesos a archivos críticos** (`/etc/passwd`, `/etc/shadow`, `/etc/sudoers`).
- **Registro de uso de sudo** para monitoreo de actividad privilegiada.
- **Detección de cambios en archivos clave** para identificar posibles ataques.
- **Registro de intentos fallidos de autenticación** para alertar sobre intentos de acceso no autorizado.

## 6. Validación del Hardening
Se proporciona un script de prueba (`test_hardening.sh`) para verificar que todas las medidas han sido aplicadas correctamente.

---
Este conjunto de políticas asegura un sistema más seguro y resistente a amenazas comunes.

