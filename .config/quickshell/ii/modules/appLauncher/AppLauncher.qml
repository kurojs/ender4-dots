import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope { // Scope
    id: root
    property int launcherPadding: 15
    property bool detach: false

    Loader {
        id: launcherLoader
        active: true
        
        sourceComponent: PanelWindow { // Window
            id: launcherRoot
            visible: GlobalStates.appLauncherOpen
            
            property bool extend: false
            property real launcherWidth: 640 // Raycast style width
            property var contentParent: appLauncherBackground

            function hide() {
                GlobalStates.appLauncherOpen = false
            }

            exclusiveZone: 0
            implicitWidth: launcherWidth + 40
            WlrLayershell.namespace: "quickshell:appLauncher"
            color: "transparent"

            // Raycast-like dimensions and positioning
            width: launcherWidth + 180
            height: 470
            
            // Center the window on screen, slightly higher
            Component.onCompleted: {
                x = (screen.geometry.width - width) / 2
                y = (screen.geometry.height - height) / 2 - 100
            }

            mask: Region {
                item: appLauncherBackground
            }

            HyprlandFocusGrab { // Click outside to close
                id: grab
                windows: [ launcherRoot ]
                active: launcherRoot.visible
                onActiveChanged: { // Focus the launcher
                    if (active) {
                        appLauncherBackground.forceActiveFocus();
                    }
                }
                onCleared: () => {
                    if (!active) launcherRoot.hide()
                }
            }

            // Content
            StyledRectangularShadow {
                target: appLauncherBackground
                radius: appLauncherBackground.radius
                spread: 8
                opacity: 0.7
            }
            
            Rectangle {
                id: appLauncherBackground
                anchors.fill: parent
                anchors.margins: 15
                
                // Raycast-like dark background with translucency
                color: Appearance.customColors.raycastBackground
                border.width: 0
                border.color: Qt.rgba(
                    Appearance.m3colors.m3outlineVariant.r,
                    Appearance.m3colors.m3outlineVariant.g,
                    Appearance.m3colors.m3outlineVariant.b,
                    0.3 // borde 0.3
                )
                radius: 20
                
                // Subtle inner glow for modern glass effect
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    border.width: 0
                    border.color: Qt.rgba(1, 1, 1, 0.08)
                    radius: parent.radius - 1
                }
                
                // Put content directly here
                AppLauncherContent {
                    id: appLauncherContent
                    anchors.fill: parent
                    scopeRoot: root
                    
                    // Auto-focus when launcher becomes visible
                    Component.onCompleted: {
                        // Connect to visibility changes
                        launcherRoot.visibleChanged.connect(function() {
                            if (launcherRoot.visible) {
                                focusTimer.start();
                            } else {
                                // Clear search text when closing
                                appLauncherContent.clearSearch();
                            }
                        });
                    }
                    
                    Timer {
                        id: focusTimer
                        interval: 150
                        repeat: false
                        onTriggered: {
                            appLauncherContent.focusActiveItem();
                        }
                    }
                }
                
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        launcherRoot.hide();
                    }
                }
            }
        }
    }

    Loader {
        id: detachedLauncherLoader
        active: false

        sourceComponent: FloatingWindow {
            id: detachedLauncherRoot
            visible: GlobalStates.appLauncherOpen
            property var contentParent: detachedLauncherBackground
            
            Rectangle {
                id: detachedLauncherBackground
                anchors.fill: parent
                color: Appearance.colors.colLayer0
            }
        }
    }

    IpcHandler {
        target: "appLauncher"

        function toggle(): void {
            GlobalStates.appLauncherOpen = !GlobalStates.appLauncherOpen
        }

        function close(): void {
            GlobalStates.appLauncherOpen = false
        }

        function open(): void {
            GlobalStates.appLauncherOpen = true
        }
        
        function toggleReleaseInterrupt() {
            GlobalStates.superReleaseMightTrigger = false
        }
    }

    GlobalShortcut {
        name: "appLauncherToggle"
        description: "Toggles app launcher on press"

        onPressed: {
            GlobalStates.appLauncherOpen = !GlobalStates.appLauncherOpen;
        }
    }

    GlobalShortcut {
        name: "appLauncherToggleRelease"
        description: "Toggles app launcher on release"

        onPressed: {
            GlobalStates.superReleaseMightTrigger = true
        }

        onReleased: {
            if (!GlobalStates.superReleaseMightTrigger) {
                GlobalStates.superReleaseMightTrigger = true
                return
            }
            GlobalStates.appLauncherOpen = !GlobalStates.appLauncherOpen;
        }
    }

    GlobalShortcut {
        name: "appLauncherToggleReleaseInterrupt"
        description: "Interrupts app launcher toggle on release"

        onPressed: {
            GlobalStates.superReleaseMightTrigger = false
        }
    }

    GlobalShortcut {
        name: "appLauncherOpen"
        description: "Opens app launcher on press"

        onPressed: {
            GlobalStates.appLauncherOpen = true;
        }
    }

    GlobalShortcut {
        name: "appLauncherClose"
        description: "Closes app launcher on press"

        onPressed: {
            GlobalStates.appLauncherOpen = false;
        }
    }
}