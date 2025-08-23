#!/bin/bash

# Script para reparar iconos del system tray
echo "🔧 Reparando iconos del system tray..."

# Hacer el script de diagnóstico ejecutable y ejecutarlo
chmod +x /home/kuro/.config/quickshell/diagnose_icons.sh

# Limpiar cache de iconos de Qt
echo "🧹 Limpiando cache de iconos de Qt..."
rm -rf ~/.cache/qt*
rm -rf ~/.cache/quickshell*

# Reconstruir cache de iconos del sistema (requiere sudo)
echo "🔄 Intentando reconstruir cache de iconos..."
echo "Esto puede requerir tu contraseña:"

# Para cada tema de iconos común, intentar reconstruir el cache
for theme_dir in /usr/share/icons/*; do
    if [ -d "$theme_dir" ]; then
        theme_name=$(basename "$theme_dir")
        echo "Procesando tema: $theme_name"
        sudo gtk-update-icon-cache -f -t "$theme_dir" 2>/dev/null || true
    fi
done

# Actualizar variables de entorno
echo "🌍 Verificando variables de entorno..."
export XDG_DATA_DIRS="/usr/local/share:/usr/share:$HOME/.local/share"

# Reiniciar servicios relacionados
echo "🔄 Reiniciando servicios..."
pkill quickshell 2>/dev/null || true
sleep 2

echo "✅ Reparación completada!"
echo "Ahora ejecuta 'quickshell' para verificar si el problema se solucionó."
echo
echo "Si el problema persiste:"
echo "1. Ejecuta: ./diagnose_icons.sh"
echo "2. Instala más temas de iconos: sudo pacman -S papirus-icon-theme breeze-icons"
echo "3. Verifica los logs: journalctl --user -f -u quickshell"
