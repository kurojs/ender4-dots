import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

Item {
    id: root
    
    // Color del espectro - puedes cambiar este valor
    property string spectrumColor: "#6B46C1"  // Morado oscuro por defecto
    
    implicitWidth: 55  // Tamaño razonable
    implicitHeight: 22
    
    // Simulación del espectro de audio con barras animadas
    Row {
        anchors.centerIn: parent
        spacing: 1
        
        Repeater {
            model: 10  // Buen balance de barras
            
            Rectangle {
                id: bar
                property int index: model.index
                width: 3
                height: getBarHeight()
                color: root.spectrumColor
                radius: 1
                
                // Función para calcular la altura de cada barra
                function getBarHeight() {
                    // Simulamos diferentes frecuencias con alturas variadas
                    const baseHeight = 4;
                    const maxHeight = root.implicitHeight - 4;
                    
                    // Diferentes patrones para cada barra basados en su índice
                    if (index < 3) {
                        return baseHeight + (maxHeight - baseHeight) * 0.3; // Bajos
                    } else if (index < 6) {
                        return baseHeight + (maxHeight - baseHeight) * 0.6; // Medios
                    } else if (index < 9) {
                        return baseHeight + (maxHeight - baseHeight) * 0.4; // Medios-altos
                    } else {
                        return baseHeight + (maxHeight - baseHeight) * 0.2; // Altos
                    }
                }
                
                // Animación continua para simular el espectro
                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite
                    
                    NumberAnimation {
                        target: bar
                        property: "height"
                        to: bar.getBarHeight() * (0.3 + Math.random() * 0.7)
                        duration: 150 + (bar.index * 50) // Diferentes velocidades por barra
                        easing.type: Easing.InOutQuad
                    }
                    
                    NumberAnimation {
                        target: bar
                        property: "height"
                        to: bar.getBarHeight() * (0.5 + Math.random() * 0.5)
                        duration: 200 + (bar.index * 30)
                        easing.type: Easing.InOutQuad
                    }
                    
                    NumberAnimation {
                        target: bar
                        property: "height"
                        to: bar.getBarHeight() * (0.2 + Math.random() * 0.8)
                        duration: 180 + (bar.index * 40)
                        easing.type: Easing.InOutQuad
                    }
                }
                
                // Animación de opacidad para que sea más dinámico
                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite
                    
                    NumberAnimation {
                        target: bar
                        property: "opacity"
                        to: 0.6 + Math.random() * 0.4
                        duration: 300 + (bar.index * 20)
                    }
                    
                    NumberAnimation {
                        target: bar
                        property: "opacity"
                        to: 0.8 + Math.random() * 0.2
                        duration: 250 + (bar.index * 25)
                    }
                }
            }
        }
    }
    
    // Efecto de resplandor sutil
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: Qt.rgba(root.spectrumColor.r, root.spectrumColor.g, root.spectrumColor.b, 0.3)
        border.width: 1
        radius: 4
        opacity: 0.5
    }
}
