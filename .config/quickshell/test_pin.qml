import QtQuick

Rectangle {
    width: 200
    height: 100
    color: "lightblue"
    
    property bool pinned: false
    
    Text {
        anchors.centerIn: parent
        text: "Pinned: " + parent.pinned
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.pinned = !parent.pinned
            console.log("Pin toggled:", parent.pinned)
        }
    }
    
    Keys.onPressed: (event) => {
        if (event.modifiers === Qt.ControlModifier && event.key === Qt.Key_P) {
            pinned = !pinned
            console.log("Ctrl+P pressed, pinned:", pinned)
        }
    }
    
    focus: true
}
