import qs.modules.common
import qs.modules.common.functions
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

MouseArea {
    id: root

    required property var bar
    required property SystemTrayItem item
    property bool targetMenuOpen: false
    property int trayItemWidth: Appearance.font.pixelSize.larger
    property bool iconLoadFailed: false

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    Layout.fillHeight: true
    implicitWidth: trayItemWidth
    onClicked: (event) => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu) menu.open();
            break;
        }
        event.accepted = true;
    }

    QsMenuAnchor {
        id: menu

        menu: root.item.menu
        anchor.window: bar
        anchor.rect.x: root.x + bar.width
        anchor.rect.y: root.y
        anchor.rect.height: root.height
        anchor.edges: Edges.Bottom
    }

    // Fallback icon when main icon fails
    Rectangle {
        id: fallbackIcon
        visible: iconLoadFailed
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: parent.height * 0.8
        radius: width * 0.2
        color: Appearance.colors.colPrimary
        
        Text {
            anchors.centerIn: parent
            text: {
                let title = root.item.title || root.item.id || "?"
                return title.substring(0, 2).toUpperCase()
            }
            color: "white"
            font.pixelSize: parent.width * 0.4
            font.bold: true
        }
    }

    IconImage {
        id: trayIcon
        visible: !Config.options.bar.tray.monochromeIcons && !iconLoadFailed
        source: root.item.icon
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        
        onStatusChanged: {
            if (status === Image.Error) {
                console.log("Icon load failed for:", root.item.title || root.item.id)
                iconLoadFailed = true
            } else if (status === Image.Ready) {
                iconLoadFailed = false
            }
        }
    }

    Loader {
        active: Config.options.bar.tray.monochromeIcons && !iconLoadFailed
        anchors.fill: trayIcon
        sourceComponent: Item {
            Desaturate {
                id: desaturatedIcon
                visible: true
                anchors.fill: parent
                source: trayIcon
                desaturation: 0
            }
        }
    }
}
