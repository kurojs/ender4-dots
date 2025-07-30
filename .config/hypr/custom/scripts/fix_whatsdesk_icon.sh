#!/bin/bash

# Hacer ejecutable
chmod +x "$0"

echo "🔧 Arreglando íconos de WhatsDesk..."

# Crear directorio para íconos personalizados si no existe
CUSTOM_ICONS_DIR="$HOME/.local/share/icons/custom"
mkdir -p "$CUSTOM_ICONS_DIR"

# Función para descargar ícono de WhatsApp desde internet
download_whatsapp_icon() {
    echo "📥 Descargando ícono de WhatsApp..."
    
    # URL de un ícono de WhatsApp en formato SVG
    ICON_URL="https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg"
    
    # Descargar el ícono
    if command -v curl &> /dev/null; then
        curl -L "$ICON_URL" -o "$CUSTOM_ICONS_DIR/whatsapp.svg" 2>/dev/null
    elif command -v wget &> /dev/null; then
        wget "$ICON_URL" -O "$CUSTOM_ICONS_DIR/whatsapp.svg" 2>/dev/null
    else
        echo "❌ No se encontró curl ni wget para descargar el ícono"
        return 1
    fi
    
    if [[ -f "$CUSTOM_ICONS_DIR/whatsapp.svg" ]]; then
        echo "✅ Ícono descargado: $CUSTOM_ICONS_DIR/whatsapp.svg"
        return 0
    else
        echo "❌ Error al descargar el ícono"
        return 1
    fi
}

# Función para crear un ícono de emergencia
create_fallback_icon() {
    echo "🎨 Creando ícono de respaldo..."
    
    # Crear un SVG simple de WhatsApp
    cat > "$CUSTOM_ICONS_DIR/whatsapp.svg" << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#25D366">
  <circle cx="12" cy="12" r="10" fill="#25D366"/>
  <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.94-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L8.5 15.5l1.51-5.12C10.89 9.49 11.43 9 12 9s1.11.49 1.99 1.38L15.5 15.5l4.29-5.29c.13.58.21 1.17.21 1.79 0 4.08-3.06 7.44-7 7.93z" fill="white"/>
</svg>
EOF
    
    echo "✅ Ícono de respaldo creado"
}

# Función para instalar tema de iconos completo
install_icon_theme() {
    echo "📦 Instalando tema de iconos Papirus..."
    
    if command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm papirus-icon-theme
        echo "✅ Papirus instalado"
    elif command -v yay &> /dev/null; then
        yay -S --noconfirm papirus-icon-theme
        echo "✅ Papirus instalado con yay"
    else
        echo "⚠️ No se puede instalar automáticamente. Ejecuta:"
        echo "sudo pacman -S papirus-icon-theme"
    fi
}

# Función principal
main() {
    echo "🔍 Verificando WhatsDesk..."
    
    if pgrep -f "whatsdesk" > /dev/null; then
        echo "✅ WhatsDesk está corriendo"
    else
        echo "⚠️ WhatsDesk no está corriendo"
    fi
    
    # Verificar si ya tenemos un buen tema de iconos
    if find /usr/share/icons -name "*whats*" -type f 2>/dev/null | grep -q .; then
        echo "✅ Íconos de WhatsApp encontrados en el sistema"
    else
        echo "❌ No se encontraron íconos de WhatsApp"
        echo "Instalando tema de iconos completo..."
        install_icon_theme
        
        # Si aún no tenemos el ícono, creamos uno
        if ! find /usr/share/icons -name "*whats*" -type f 2>/dev/null | grep -q .; then
            if ! download_whatsapp_icon; then
                create_fallback_icon
            fi
        fi
    fi
    
    # Actualizar cache de iconos
    echo "🔄 Actualizando cache de iconos..."
    if command -v gtk-update-icon-cache &> /dev/null; then
        gtk-update-icon-cache -f ~/.local/share/icons/custom 2>/dev/null || true
    fi
    
    # Reiniciar QuickShell para aplicar cambios
    echo "🔄 Reiniciando QuickShell..."
    pkill quickshell
    sleep 2
    qs -c ii &
    
    echo ""
    echo "✅ ¡Arreglo completado!"
    echo "Si el problema persiste:"
    echo "1. Reinicia WhatsDesk"
    echo "2. Verifica con Super+Alt+T para diagnosticar"
    echo "3. El ícono fallback debería mostrar 'WH' en lugar de la textura rosa"
}

main
