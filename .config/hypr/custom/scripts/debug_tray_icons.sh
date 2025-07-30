#!/bin/bash

# Hacer ejecutable
chmod +x "$0"

echo "🔍 Diagnosticando problema de íconos del system tray..."
echo ""

# Verificar WhatsDesk
if pgrep -f "whatsdesk" > /dev/null; then
    echo "✅ WhatsDesk está corriendo"
else
    echo "❌ WhatsDesk NO está corriendo"
fi

echo ""
echo "📂 Verificando temas de iconos instalados:"
find /usr/share/icons ~/.local/share/icons ~/.icons -maxdepth 1 -type d -name "*" 2>/dev/null | grep -v "^\.$" | sort

echo ""
echo "🎨 Tema de iconos actual:"
echo "GTK: $(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null || echo 'No configurado')"
echo "Qt: $(kreadconfig5 --group Icons --key Theme 2>/dev/null || echo 'No configurado')"

echo ""
echo "🔍 Buscando íconos de WhatsDesk:"
find /usr/share/icons ~/.local/share/icons ~/.icons -name "*whats*" -type f 2>/dev/null
find /usr/share/pixmaps -name "*whats*" -type f 2>/dev/null

echo ""
echo "🖼️ Verificando íconos disponibles para apps comunes en system tray:"
for app in "telegram" "discord" "steam" "firefox" "chrome" "code"; do
    icon_found=$(find /usr/share/icons -name "*$app*" -type f 2>/dev/null | head -1)
    if [[ -n "$icon_found" ]]; then
        echo "✅ $app: $icon_found"
    else
        echo "❌ $app: No encontrado"
    fi
done

echo ""
echo "💡 Soluciones sugeridas:"
echo "1. Instalar un tema de iconos más completo:"
echo "   sudo pacman -S papirus-icon-theme"
echo ""
echo "2. O forzar un ícono específico para WhatsDesk"
echo "3. Verificar si WhatsDesk tiene un ícono personalizado"
