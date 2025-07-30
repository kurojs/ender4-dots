import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import "../bar"
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Mpris

Scope { // Scope
    id: root
    property bool pinned: Config.options?.dock.pinnedOnStartup ?? false

    Variants { // For each monitor
        model: Quickshell.screens

        PanelWindow { // Window
            required property var modelData
            id: dockRoot
            screen: modelData
            
            property bool reveal: root.pinned 
                || (Config.options?.dock.hoverToReveal && dockMouseArea.containsMouse) 
                || dockApps.requestDockShow 
                || (!ToplevelManager.activeToplevel?.activated)

            anchors {
                bottom: true
                left: true
                right: true
            }

            exclusiveZone: root.pinned ? implicitHeight - Appearance.sizes.elevationMargin : 0

            implicitWidth: dockRoot.screen.width
            WlrLayershell.namespace: "quickshell:dock"
            color: "transparent"

            implicitHeight: (Config.options?.dock.height ?? 70)

            mask: Region {
                item: dockMouseArea
            }

            MouseArea {
                id: dockMouseArea
                height: parent.height
                anchors {
                    top: parent.top
                    topMargin: dockRoot.reveal ? 0 : 
                        Config.options?.dock.hoverToReveal ? (dockRoot.implicitHeight - Config.options.dock.hoverRegionHeight) :
                        (dockRoot.implicitHeight)
                    horizontalCenter: parent.horizontalCenter
                }
                implicitWidth: dockRoot.screen.width
                hoverEnabled: true

                Behavior on anchors.topMargin {
                    animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                }

                Item {
                    id: dockHoverRegion
                    anchors {
                        fill: parent
                        leftMargin: 60   // Mucha más separación lateral como macOS
                        rightMargin: 60  // Mucha más separación lateral como macOS
                        bottomMargin: 0  // Sin separación inferior, pegado abajo como macOS
                    }
                    implicitWidth: dockRoot.screen.width - 120  // Ancho reducido por los márgenes laterales

                    Item { // Wrapper for the dock background
                        id: dockBackground
                        anchors {
                            fill: parent
                        }

                        implicitWidth: dockRoot.screen.width - 120  // Ajustado por los márgenes laterales
                        height: parent.height

                        // Background shadow (similar to bar)
                        Loader {
                            active: Config.options.bar.cornerStyle === 1
                            anchors.fill: dockVisualBackground
                            sourceComponent: StyledRectangularShadow {
                                anchors.fill: undefined
                                target: dockVisualBackground
                            }
                        }
                        Rectangle { // The real rectangle that is visible (similar to bar background)
                            id: dockVisualBackground
                            anchors {
                                fill: parent
                                margins: 0
                                topMargin: 0
                                bottomMargin: 0  // Cambiado: era 0, ahora 2 para reducir la altura
                            }
                            color: Qt.rgba(0, 0, 0, 0.6) // Black with 70% opacity
                            radius: 12  // Esquinas redondeadas como macOS
                            border.width: Config.options.bar.cornerStyle === 1 ? 1 : 0
                            border.color: Appearance.m3colors.m3outlineVariant
                        }

                        RowLayout {
                            id: dockRow
                            anchors {
                                left: parent.left
                                leftMargin: 0
                                verticalCenter: parent.verticalCenter  // Volvemos a verticalCenter
                            }
                            spacing: 3
                            property real padding: 5

                            // Pin button (más minimalista, como opción del dock)
                            GroupButton {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.topMargin: 2
                                baseWidth: 25  // Más pequeño y minimalista
                                baseHeight: 25
                                clickedWidth: baseWidth
                                clickedHeight: baseHeight + 15
                                buttonRadius: Appearance.rounding.small // Radio más pequeño
                                toggled: root.pinned
                                onClicked: root.pinned = !root.pinned
                                colBackgroundToggled: "#000000ff"
                                contentItem: MaterialSymbol {
                                    text: "keep"
                                    horizontalAlignment: Text.AlignHCenter
                                    iconSize: 14 // Icono más pequeño, valor fijo
                                    color: root.pinned ? "#FFFFFF" : Appearance.colors.colOnLayer0
                                }
                                
                                StyledToolTip {
                                    content: "Pin dock"
                                }
                            }
                            
                            // Botón de Arch Linux / App Launcher
                            GroupButton {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.topMargin: 2
                                baseWidth: 0  // Más grande para ser el botón principal
                                baseHeight: 0
                                clickedWidth: baseWidth
                                clickedHeight: baseHeight + 20
                                buttonRadius: Appearance.rounding.normal
                                onClicked: {
                                    Hyprland.dispatch('global quickshell:appLauncherToggle');
                                }
                                contentItem: Image {
                                    source: "file:///home/kuro/Desktop/ファイル/Imagenes/arch.png"
                                    width: 32  // Tamaño del icono
                                    height: 32
                                    fillMode: Image.PreserveAspectFit
                                    anchors.centerIn: parent
                                    smooth: true
                                }
                                
                                StyledToolTip {
                                    content: "App Launcher (Arch Linux)"
                                }
                            }
                            
                            DockSeparator {}
                            DockApps { 
                                id: dockApps
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        // Media widget y medidores en el lado derecho
                        RowLayout {
                            id: dockRightRow
                            anchors {
                                right: parent.right
                                rightMargin: 0
                                verticalCenter: parent.verticalCenter  // Volvemos a verticalCenter
                            }
                            spacing: 10
                            
                            // Medidores de rendimiento
//                            Resources {
//                                Layout.alignment: Qt.AlignVCenter
//                                alwaysShowAllResources: true
//                            }
                            
                            MouseArea {
                                id: dockMediaArea
                                Layout.alignment: Qt.AlignVCenter
                                implicitWidth: dockMediaRow.implicitWidth
                                implicitHeight: dockMediaRow.implicitHeight
                                
                                onPressed: {
                                    Hyprland.dispatch('global quickshell:mediaControlsToggle');
                                }
                                
                                RowLayout {
                                    id: dockMediaRow
                                    anchors.fill: parent
                                    spacing: 6
                                    
                                    // GIF animado muy pequeño
                                    AnimatedImage {
                                        id: musicIconDock
                                        Layout.alignment: Qt.AlignVCenter
                                        Layout.preferredWidth: 40
                                        Layout.preferredHeight: 40
                                        Layout.maximumWidth: 40
                                        Layout.maximumHeight: 40
                                        source: "file:///home/kuro/.config/quickshell/ii/assets/icons/icon.gif"
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        cache: false
                                        asynchronous: true
                                        visible: MprisController.activePlayer && MprisController.activePlayer.trackTitle
                                        
                                        Component.onCompleted: {
                                            playing = true
                                        }
                                        
                                        onStatusChanged: {
                                            if (status === AnimatedImage.Ready) {
                                                playing = true
                                            }
                                        }
                                    }
                                    
                                    Media {
                                        id: dockMedia
                                        Layout.alignment: Qt.AlignVCenter
                                        Layout.preferredWidth: 200  // Ancho fijo para evitar movimiento
                                        Layout.maximumWidth: 200
                                    }
                                    
                                    // Espectro de audio
                                    AudioSpectrum {
                                        id: audioSpectrum
                                        Layout.alignment: Qt.AlignVCenter
                                        visible: MprisController.activePlayer?.playbackState == MprisPlaybackState.Playing
                                        spectrumColor: "#6B46C1"  // Morado oscuro - cambia este color aquí
                                    }
                                }
                            }
                       }
                    }

                    // Round decorators (similar to bar)
                    Loader {
                        id: roundDecorators
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                        width: parent.width
                        height: Appearance.rounding.screenRounding
                        active: false // Disabled to remove gaps

                        sourceComponent: Item {
                            implicitHeight: Appearance.rounding.screenRounding
                            RoundCorner {
                                id: leftCorner
                                anchors {
                                    bottom: parent.bottom
                                    left: parent.left
                                }

                                size: Appearance.rounding.screenRounding
                                color: "black"

                                corner: RoundCorner.CornerEnum.BottomLeft
                            }
                            RoundCorner {
                                id: rightCorner
                                anchors {
                                    right: parent.right
                                    bottom: parent.bottom
                                }
                                size: Appearance.rounding.screenRounding
                                color: "black"

                                corner: RoundCorner.CornerEnum.BottomRight
                            }
                        }
                    }

                }

            }
        }
    }
}