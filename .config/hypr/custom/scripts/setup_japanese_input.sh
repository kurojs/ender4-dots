#!/bin/bash

# Hacer el script ejecutable
chmod +x "$0"

# Script para configurar input japonés automáticamente
echo "Configurando input method japonés..."

# Verificar si fcitx5 está corriendo
if ! pgrep -x "fcitx5" > /dev/null; then
    echo "Iniciando fcitx5..."
    fcitx5 --replace -d &
    sleep 2
fi

# Agregar Mozc (japonés) como método de entrada
echo "Agregando método de entrada japonés (Mozc)..."
fcitx5-remote -a mozc

# Configurar mozc como método de entrada disponible
if command -v fcitx5-configtool &> /dev/null; then
    echo "Para configurar más opciones, ejecuta: fcitx5-configtool"
else
    echo "Instala fcitx5-configtool para configuración GUI: sudo pacman -S fcitx5-configtool"
fi

echo "¡Configuración completada!"
echo "Uso:"
echo "- Alt + \` para cambiar entre US Internacional y japonés"
echo "- AltGr + n para ñ en modo US Internacional"
echo "- Escribe en romaji y se convertirá automáticamente en japonés"
