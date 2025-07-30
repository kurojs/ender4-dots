#!/bin/bash

# Script para asegurar conexión WiFi automática al iniciar sesión
# Espera un poco y luego intenta conectar al WiFi si no está conectado

sleep 5

# Verificar si ya hay conexión WiFi
if nmcli device status | grep -q "wlan0.*connected"; then
    echo "WiFi ya está conectado"
    exit 0
fi

# Intentar conectar al WiFi
echo "Intentando conectar al WiFi..."
nmcli connection up "IZZI-1DAD-5G"

if [ $? -eq 0 ]; then
    echo "WiFi conectado exitosamente"
    notify-send "WiFi" "Conectado a IZZI-1DAD-5G" -i network-wireless
else
    echo "Error al conectar WiFi"
    notify-send "WiFi" "Error al conectar a IZZI-1DAD-5G" -i network-wireless-disconnected
fi