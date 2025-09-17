#!/bin/bash
# Script para OCR de japonés y traducción en Wayland

# 1. Definir archivo temporal para la captura
TMP_IMG="/tmp/ocr_screenshot_$(date +%s).png"

# 2. Seleccionar área y tomar captura con spectacle (para KDE)
# -n deshabilita la notificación de "guardado como..."
spectacle -b -n -r -o "$TMP_IMG"

# 3. Verificar que la captura se creó y no está vacía
if [ ! -s "$TMP_IMG" ]; then
    notify-send -u critical "Error de Captura" "Captura cancelada o fallida. No se creó el archivo."
    # Limpiar por si se creó un archivo vacío
    [ -f "$TMP_IMG" ] && rm "$TMP_IMG"
    exit 1
fi

# 4. Hacer OCR del texto japonés con Tesseract
JAPANESE_TEXT=$(tesseract "$TMP_IMG" stdout -l jpn)

# Verificar si el OCR extrajo texto
if [ -z "$JAPANESE_TEXT" ]; then
    notify-send "Error de OCR" "No se pudo extraer texto japonés del área seleccionada."
    rm "$TMP_IMG"
    exit 1
fi

# 4. Traducir el texto de japonés a español con translate-shell
TRANSLATED_TEXT=$(trans -b -s ja -t es "$JAPANESE_TEXT")

# Verificar si la traducción funcionó
if [ -z "$TRANSLATED_TEXT" ]; then
    notify-send "Error de Traducción" "Fallo al traducir el texto. Copiando original."
    # Si la traducción falla, igualmente copiamos el texto original
    echo -n "$JAPANESE_TEXT" | wl-copy
    rm "$TMP_IMG"
    exit 1
fi

# 5. Copiar el texto japonés original al portapapeles
echo -n "$JAPANESE_TEXT" | wl-copy

# 6. Mostrar notificación con la traducción en español
notify-send "Traducción" "$TRANSLATED_TEXT"

# 7. Borrar el archivo temporal
rm "$TMP_IMG"

exit 0
