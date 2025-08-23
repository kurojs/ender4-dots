#!/bin/bash

# Diagnóstico para iconos del system tray en Quickshell
echo "=== Diagnóstico de iconos del system tray ==="
echo

# Verificar temas de iconos instalados
echo "📁 Temas de iconos instalados:"
ls -la /usr/share/icons/ | grep "^d" | awk '{print $NF}' | grep -v "\.$" | head -10
echo

# Verificar tema de iconos actual
echo "🎨 Tema de iconos actual:"
gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null || echo "No se pudo obtener (no GNOME)"
echo "KDE: $(kreadconfig5 --group Icons --key Theme 2>/dev/null || echo "No configurado")"
echo

# Verificar aplicaciones en system tray
echo "📱 Aplicaciones actualmente en system tray:"
# No podemos acceder directamente, pero podemos sugerir comandos
echo "Ejecuta: ps aux | grep -E '(whatsdesk|discord|telegram|steam)' para ver las apps ejecutándose"
echo

# Verificar si los paquetes de iconos están instalados
echo "📦 Verificando paquetes de iconos importantes:"
echo "hicolor-icon-theme: $(dpkg -l | grep hicolor-icon-theme | awk '{print $2 " " $3}' 2>/dev/null || echo "No encontrado")"
echo "adwaita-icon-theme: $(dpkg -l | grep adwaita-icon-theme | awk '{print $2 " " $3}' 2>/dev/null || echo "No encontrado")"
echo

# Sugerencias de solución
echo "🔧 Posibles soluciones:"
echo "1. Instalar temas de iconos faltantes:"
echo "   sudo pacman -S hicolor-icon-theme adwaita-icon-theme breeze-icons"
echo
echo "2. Reconstruir cache de iconos:"
echo "   sudo gtk-update-icon-cache -f -t /usr/share/icons/*"
echo
echo "3. Reiniciar Quickshell:"
echo "   pkill quickshell && quickshell &"
echo
echo "4. Verificar variables de entorno:"
echo "   echo \$XDG_DATA_DIRS"
echo "   echo \$ICON_THEME"
echo

# Verificar logs de Quickshell
echo "📋 Para ver los logs de Quickshell:"
echo "   journalctl --user -f -u quickshell"
echo "   o ejecuta quickshell desde la terminal para ver errores en tiempo real"
echo

echo "=== Fin del diagnóstico ==="
