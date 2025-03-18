# Hardening Linux - Automatización de Seguridad

## Descripción
Este proyecto proporciona una serie de scripts automatizados para mejorar la seguridad de un sistema Linux mediante la aplicación de políticas de hardening. Incluye medidas para deshabilitar servicios innecesarios, configurar el firewall, reforzar permisos, mejorar la configuración de sudo y habilitar auditorías de seguridad.

## Estructura del Proyecto
```
📂 hardening_linux/
├── 📂 scripts/
│   ├── disable_services.sh      # Deshabilita servicios innecesarios
│   ├── configure_firewall.sh    # Configura el firewall
│   ├── configure_permissions.sh # Reforza permisos de archivos
│   ├── configure_sudo.sh        # Configura sudo
│   ├── configure_audit.sh       # Configura auditoría de seguridad
├── hardening_linux.sh           # Script principal que ejecuta los demás
├── test_hardening.sh            # Verifica que las configuraciones se aplicaron correctamente
├── README.md                    # Descripción del proyecto
├── POLICIES.md                  # Explicación detallada de las políticas de hardening
```

## Instalación y Uso
1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/tu_usuario/hardening_linux.git
   cd hardening_linux
   ```

2. **Dar permisos de ejecución a los scripts**
   ```bash
   chmod +x hardening_linux.sh
   chmod +x test_hardening.sh
   chmod +x scripts/*.sh
   ```

3. **Ejecutar el script principal**
   ```bash
   sudo ./hardening_linux.sh
   ```

4. **Verificar que el hardening se ha aplicado correctamente**
   ```bash
   sudo ./test_hardening.sh
   ```

## Contribuciones
Las contribuciones son bienvenidas. Si tienes mejoras o nuevas reglas de seguridad, abre un Pull Request o crea un Issue.
