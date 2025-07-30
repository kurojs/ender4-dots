#!/bin/bash

# Script para aplicar solo color de acento sin cambiar todo el esquema
# Uso: apply_accent_only.sh "#FF5722"

ACCENT_COLOR="$1"
APPEARANCE_FILE="$HOME/.config/quickshell/ii/modules/common/Appearance.qml"

if [[ ! "$ACCENT_COLOR" =~ ^#[0-9A-Fa-f]{6}$ ]]; then
    echo "Error: Color inválido. Usa formato #RRGGBB"
    exit 1
fi

if [[ ! -f "$APPEARANCE_FILE" ]]; then
    echo "Error: No se encontró Appearance.qml"
    exit 1
fi

# Crear backup adicional por seguridad
cp "$APPEARANCE_FILE" "$APPEARANCE_FILE.backup_$(date +%Y%m%d_%H%M%S)"

# Calcular colores derivados del acento
python3 << EOF
import re
import colorsys

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hex(rgb):
    return "#{:02X}{:02X}{:02X}".format(int(rgb[0]), int(rgb[1]), int(rgb[2]))

def lighten_color(hex_color, factor=0.2):
    r, g, b = hex_to_rgb(hex_color)
    r = min(255, r + (255 - r) * factor)
    g = min(255, g + (255 - g) * factor)
    b = min(255, b + (255 - b) * factor)
    return rgb_to_hex((r, g, b))

def darken_color(hex_color, factor=0.3):
    r, g, b = hex_to_rgb(hex_color)
    r = max(0, r * (1 - factor))
    g = max(0, g * (1 - factor))
    b = max(0, b * (1 - factor))
    return rgb_to_hex((r, g, b))

# Color de acento principal
accent = "$ACCENT_COLOR"
primary_light = lighten_color(accent, 0.15)
primary_dark = darken_color(accent, 0.4)
secondary_container = darken_color(accent, 0.6)
on_secondary_container = lighten_color(accent, 0.3)

# Leer archivo actual
with open("$APPEARANCE_FILE", 'r') as f:
    content = f.read()

# Solo reemplazar las propiedades específicas de acento
replacements = {
    r'property color m3primary: "[^"]*"': f'property color m3primary: "{accent}"',
    r'property color m3surfaceTint: "[^"]*"': f'property color m3surfaceTint: "{accent}"',
    r'property color m3primaryFixedDim: "[^"]*"': f'property color m3primaryFixedDim: "{accent}"',
    r'property color m3onPrimary: "[^"]*"': f'property color m3onPrimary: "{primary_dark}"',
    r'property color m3primaryContainer: "[^"]*"': f'property color m3primaryContainer: "{secondary_container}"',
    r'property color m3onPrimaryContainer: "[^"]*"': f'property color m3onPrimaryContainer: "{primary_light}"',
    r'property color m3secondaryContainer: "[^"]*"': f'property color m3secondaryContainer: "{secondary_container}"',
    r'property color m3onSecondaryContainer: "[^"]*"': f'property color m3onSecondaryContainer: "{on_secondary_container}"'
}

# Aplicar reemplazos
for pattern, replacement in replacements.items():
    content = re.sub(pattern, replacement, content)

# Escribir archivo modificado
with open("$APPEARANCE_FILE", 'w') as f:
    f.write(content)

print(f"✅ Aplicado color de acento: {accent}")
print("🔄 Reinicia QuickShell para ver los cambios")
EOF

# Notificar al usuario
notify-send "Color de acento aplicado" "Reinicia QuickShell para ver los cambios\nColor: $ACCENT_COLOR" -i "palette" -t 3000

echo "✅ Color de acento aplicado: $ACCENT_COLOR"
echo "🔄 Reinicia QuickShell para ver los cambios"