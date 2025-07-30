import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import "./aiChat/"
import "root:/modules/common/functions/fuzzysort.js" as Fuzzy
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell

Item {
    id: root
    property var inputField: messageInputField
    property string commandPrefix: "/"

    property var suggestionQuery: ""
    property var suggestionList: []

    // Sistema de modos DevTools
    property string currentMode: "docs"
    property var modes: [
        {
            id: "docs",
            name: "Docs",
            icon: "library_books",
            description: "Documentación oficial",
            prompt: "You are a documentation link finder. When users ask about programming concepts, frameworks, or technologies, respond ONLY with official documentation links. You must provide AT LEAST 8 high-quality, official documentation URLs. Format your response as a numbered list with brief descriptions."
        },
        {
            id: "code", 
            name: "Code",
            icon: "code",
            description: "Ejemplos de código",
            prompt: "You are a code example generator. When users ask about programming concepts or provide code, respond with multiple COMPLETE, WORKING code examples. ALWAYS provide FULL, COMPLETE, WORKING examples."
        },
        {
            id: "src",
            name: "Src", 
            icon: "search",
            description: "Buscar recursos visuales",
            prompt: "No se usa AI en este modo"
        },
        {
            id: "wallpapers",
            name: "Walls",
            icon: "wallpaper",
            description: "Buscar wallpapers dinámicos",
            prompt: "No se usa AI en este modo"
        }
    ]

    function getCurrentMode() {
        return modes.find(mode => mode.id === currentMode) || modes[0];
    }

    function getCurrentAi() {
        switch (currentMode) {
            case "docs": return DocsAi;
            case "code": return CodeAi;
            default: return DocsAi;
        }
    }

    function setMode(modeId) {
        const mode = modes.find(m => m.id === modeId);
        if (mode) {
            currentMode = modeId;
            const ai = getCurrentAi();
            ai.systemPrompt = mode.prompt;
            
            // Actualizar el AI activo en el ListView
            if (messageListView.currentAi) {
                messageListView.currentAi = ai;
            }
        }
    }

    property var allCommands: [
        {
            name: "mode",
            description: "Cambiar modo: docs, code, src, wallpapers",
            execute: (args) => {
                if (args.length === 0) {
                    const currentModeObj = getCurrentMode();
                    const ai = getCurrentAi();
                    ai.addMessage(`Modo actual: ${currentModeObj.name}\nModos: ${modes.map(m => m.id).join(", ")}`, ai.interfaceRole);
                    return;
                }
                root.setMode(args[0]);
            }
        },
        {
            name: "clear",
            description: "Clear chat history",
            execute: () => {
                getCurrentAi().clearMessages();
            }
        }
    ]

    function handleInput(inputText) {
        if (inputText.startsWith(root.commandPrefix)) {
            const command = inputText.split(" ")[0].substring(1);
            const args = inputText.split(" ").slice(1);
            const commandObj = root.allCommands.find(cmd => cmd.name === command);
            if (commandObj) {
                commandObj.execute(args);
            } else {
                const ai = getCurrentAi();
                ai.addMessage("Unknown command: " + command, ai.interfaceRole);
            }
        }
        else {
            getCurrentAi().sendUserMessage(inputText);
        }
    }

    ColumnLayout {
        anchors.fill: parent

        // Header con tabs mejorados
        Rectangle {
            Layout.fillWidth: true
            Layout.margins: 12
            height: 56
            radius: Appearance.rounding.medium
            color: Appearance.colors.colLayer1
            border.color: Appearance.colors.colOutlineVariant
            border.width: 1

            layer.enabled: true
            layer.effect: DropShadow {
                radius: 8
                samples: 16
                color: Qt.rgba(0, 0, 0, 0.1)
                horizontalOffset: 0
                verticalOffset: 2
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                MaterialSymbol {
                    text: "tune"
                    iconSize: 20
                    color: Appearance.m3colors.m3primary
                }

                StyledText {
                    text: "DevTools"
                    font.pixelSize: Appearance.font.pixelSize.medium
                    font.weight: Font.Medium
                    color: Appearance.m3colors.m3onSurface
                }

                Rectangle {
                    width: 1
                    height: 24
                    color: Appearance.colors.colOutlineVariant
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: Appearance.rounding.medium
                    color: "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 2

                        Repeater {
                            model: root.modes
                            delegate: Rectangle {
                                id: modeTab
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: Appearance.rounding.small
                                
                                property bool isActive: root.currentMode === modelData.id
                                property bool isHovered: tabMouseArea.containsMouse
                                
                                // Fondo sólido con gradiente para tabs activas
                                color: isActive ? Appearance.m3colors.m3primaryContainer : 
                                       (isHovered ? Appearance.colors.colSecondaryContainer : "transparent")

                                // Borde activo
                                border.color: isActive ? Appearance.m3colors.m3primary : "transparent"
                                border.width: isActive ? 2 : 0

                                // Animaciones suaves
                                Behavior on color {
                                    ColorAnimation { duration: 250; easing.type: Easing.OutCubic }
                                }
                                Behavior on border.color {
                                    ColorAnimation { duration: 250; easing.type: Easing.OutCubic }
                                }

                                // Sombra para tab activo
                                layer.enabled: isActive
                                layer.effect: DropShadow {
                                    radius: 4
                                    samples: 8
                                    color: Qt.rgba(0.1, 0.4, 0.8, 0.3)
                                    horizontalOffset: 0
                                    verticalOffset: 1
                                }

                                // Escala sutil en hover
                                transform: Scale {
                                    origin.x: modeTab.width / 2
                                    origin.y: modeTab.height / 2
                                    xScale: isHovered && !isActive ? 1.05 : 1.0
                                    yScale: isHovered && !isActive ? 1.05 : 1.0
                                    
                                    Behavior on xScale {
                                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                                    }
                                    Behavior on yScale {
                                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                                    }
                                }

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 2

                                    MaterialSymbol {
                                        Layout.alignment: Qt.AlignHCenter
                                        iconSize: 20
                                        text: modelData.icon
                                        color: modeTab.isActive ? Appearance.m3colors.m3onPrimaryContainer : 
                                               (modeTab.isHovered ? Appearance.m3colors.m3onSecondaryContainer : Appearance.m3colors.m3onSurface)
                                        
                                        Behavior on color {
                                            ColorAnimation { duration: 250; easing.type: Easing.OutCubic }
                                        }
                                    }
                                    
                                    StyledText {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: modelData.name
                                        font.pixelSize: Appearance.font.pixelSize.small
                                        font.weight: modeTab.isActive ? Font.Bold : Font.Medium
                                        color: modeTab.isActive ? Appearance.m3colors.m3onPrimaryContainer : 
                                               (modeTab.isHovered ? Appearance.m3colors.m3onSecondaryContainer : Appearance.m3colors.m3onSurface)
                                        
                                        Behavior on color {
                                            ColorAnimation { duration: 250; easing.type: Easing.OutCubic }
                                        }
                                    }
                                }

                                MouseArea {
                                    id: tabMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    
                                    onClicked: {
                                        if (root.currentMode !== modelData.id) {
                                            root.setMode(modelData.id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Área principal
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Chat AI (modos docs y code)
            Item {
                anchors.fill: parent
                visible: root.currentMode === "docs" || root.currentMode === "code"
                
                StyledListView {
                    id: messageListView
                    anchors.fill: parent
                    spacing: 10

                    property var currentAi: root.getCurrentAi()
                    
                    // Conexión para actualizar cuando cambie el AI activo
                    Connections {
                        target: messageListView.currentAi
                        function onMessageIDsChanged() {
                            messageListView.model.values = messageListView.currentAi.messageIDs.filter(id => {
                                const message = messageListView.currentAi.messageByID[id];
                                return message && message.visibleToUser !== false;
                            })
                        }
                    }

                    // Actualizar currentAi cuando cambie el modo
                    onVisibleChanged: {
                        if (visible) {
                            currentAi = root.getCurrentAi()
                        }
                    }

                    model: ScriptModel {
                        values: messageListView.currentAi ? messageListView.currentAi.messageIDs.filter(id => {
                            const message = messageListView.currentAi.messageByID[id];
                            return message && message.visibleToUser !== false;
                        }) : []
                    }
                    
                    delegate: AiMessage {
                        required property var modelData
                        required property int index
                        messageIndex: index
                        messageData: messageListView.currentAi ? messageListView.currentAi.messageByID[modelData] : null
                        messageInputField: root.inputField
                    }
                }

                // Placeholder cuando no hay mensajes
                Item {
                    property var currentAi: root.getCurrentAi()
                    opacity: currentAi && currentAi.messageIDs.length === 0 ? 1 : 0
                    visible: opacity > 0
                    anchors.fill: parent

                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        MaterialSymbol {
                            Layout.alignment: Qt.AlignHCenter
                            iconSize: 60
                            color: Appearance.m3colors.m3outline
                            text: root.getCurrentMode().icon
                        }
                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            font.pixelSize: Appearance.font.pixelSize.larger
                            color: Appearance.m3colors.m3outline
                            text: `DevTools - ${root.getCurrentMode().name}`
                        }
                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            font.pixelSize: Appearance.font.pixelSize.small
                            color: Appearance.m3colors.m3outline
                            horizontalAlignment: Text.AlignHCenter
                            text: `${root.getCurrentMode().description}\nTipo /mode para cambiar modo`
                        }
                    }
                }
            }

            // Modo Src - Búsqueda de recursos visuales
            Item {
                anchors.fill: parent
                visible: root.currentMode === "src"
                
                property string searchQuery: ""
                property var searchResults: []

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    // Barra de búsqueda
                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: Appearance.rounding.medium
                        color: Appearance.colors.colLayer1
                        border.color: srcSearchField.activeFocus ? Appearance.m3colors.m3primary : Appearance.colors.colOutlineVariant
                        border.width: 2

                        Behavior on border.color {
                            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 10

                            MaterialSymbol {
                                text: "search"
                                iconSize: 24
                                color: Appearance.m3colors.m3onSurface
                            }

                            StyledTextArea {
                                id: srcSearchField
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                placeholderText: "Buscar iconos, SVGs, imágenes... (github, react, arrow)"
                                background: null
                                wrapMode: TextArea.NoWrap
                                
                                onTextChanged: {
                                    if (text.length > 2) {
                                        parent.parent.parent.parent.performSrcSearch(text.trim())
                                    } else {
                                        parent.parent.parent.parent.searchResults = []
                                    }
                                }

                                Keys.onPressed: (event) => {
                                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                        if (text.trim().length > 0) {
                                            parent.parent.parent.parent.performSrcSearch(text.trim())
                                        }
                                        event.accepted = true
                                    }
                                }
                            }
                        }
                    }

                    // Resultados
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        ColumnLayout {
                            width: parent.width
                            spacing: 15

                            // Placeholder
                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 200
                                visible: parent.parent.parent.searchResults.length === 0

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 15

                                    MaterialSymbol {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "image_search"
                                        iconSize: 80
                                        color: Appearance.m3colors.m3outline
                                    }

                                    StyledText {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Buscar Recursos Visuales"
                                        font.pixelSize: Appearance.font.pixelSize.larger
                                        font.weight: Font.Medium
                                        color: Appearance.m3colors.m3outline
                                    }

                                    StyledText {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Encuentra iconos, SVGs, imágenes y más\nEjemplos: github, react, arrow, logo"
                                        font.pixelSize: Appearance.font.pixelSize.medium
                                        color: Appearance.m3colors.m3outline
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }
                            }

                            // Grid de resultados
                            GridLayout {
                                Layout.fillWidth: true
                                columns: 3
                                columnSpacing: 12
                                rowSpacing: 12
                                visible: parent.parent.parent.searchResults.length > 0

                                Repeater {
                                    model: parent.parent.parent.searchResults
                                    delegate: Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 160
                                        radius: Appearance.rounding.medium
                                        color: cardMouseArea.containsMouse ? Appearance.colors.colSecondaryContainerHover : Appearance.colors.colSecondaryContainer
                                        border.color: Appearance.colors.colOutlineVariant
                                        border.width: 1

                                        Behavior on color {
                                            ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
                                        }

                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 12
                                            spacing: 8

                                            // Imagen/Icono
                                            Rectangle {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                                radius: Appearance.rounding.small
                                                color: Appearance.colors.colSurface
                                                
                                                Image {
                                                    anchors.centerIn: parent
                                                    width: Math.min(parent.width - 20, 64)
                                                    height: Math.min(parent.height - 20, 64)
                                                    source: modelData.url || ""
                                                    fillMode: Image.PreserveAspectFit
                                                    smooth: true
                                                }
                                            }

                                            // Nombre
                                            StyledText {
                                                Layout.fillWidth: true
                                                text: modelData.name || "Sin nombre"
                                                font.pixelSize: Appearance.font.pixelSize.small
                                                color: Appearance.m3colors.m3onSurface
                                                elide: Text.ElideRight
                                                horizontalAlignment: Text.AlignHCenter
                                            }

                                            // Botones
                                            RowLayout {
                                                Layout.fillWidth: true
                                                spacing: 6

                                                RippleButton {
                                                    Layout.fillWidth: true
                                                    implicitHeight: 28
                                                    buttonRadius: Appearance.rounding.small

                                                    contentItem: StyledText {
                                                        text: "Ver"
                                                        font.pixelSize: Appearance.font.pixelSize.small
                                                        color: Appearance.m3colors.m3onPrimary
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }

                                                    MouseArea {
                                                        anchors.fill: parent
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: {
                                                            if (modelData.webUrl) {
                                                                Qt.openUrlExternally(modelData.webUrl)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        MouseArea {
                                            id: cardMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                function performSrcSearch(query) {
                    searchQuery = query
                    searchResults = [
                        {
                            name: `${query} icon`,
                            url: `https://cdn.jsdelivr.net/npm/simple-icons@v9/${query}.svg`,
                            webUrl: `https://iconify.design/icon-sets/simple-icons/`
                        },
                        {
                            name: `${query} color`,
                            url: `https://img.icons8.com/color/96/${query}.png`,
                            webUrl: `https://icons8.com/icons/set/${query}`
                        },
                        {
                            name: `${query} logo`,
                            url: `https://logo.clearbit.com/${query}.com`,
                            webUrl: `https://clearbit.com/logo`
                        }
                    ]
                }
            }

            // Modo Wallpapers - Búsqueda de wallpapers
            Item {
                anchors.fill: parent
                visible: root.currentMode === "wallpapers"
                
                property string searchQuery: ""
                property var searchResults: []

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    // Barra de búsqueda
                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: Appearance.rounding.medium
                        color: Appearance.colors.colLayer1
                        border.color: wallpaperSearchField.activeFocus ? Appearance.m3colors.m3primary : Appearance.colors.colOutlineVariant
                        border.width: 2

                        Behavior on border.color {
                            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 10

                            MaterialSymbol {
                                text: "wallpaper"
                                iconSize: 24
                                color: Appearance.m3colors.m3onSurface
                            }

                            StyledTextArea {
                                id: wallpaperSearchField
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                placeholderText: "Buscar wallpapers... (nature, space, anime, abstract)"
                                background: null
                                wrapMode: TextArea.NoWrap
                                
                                onTextChanged: {
                                    if (text.length > 2) {
                                        parent.parent.parent.parent.performWallpaperSearch(text.trim())
                                    } else {
                                        parent.parent.parent.parent.searchResults = []
                                    }
                                }
                            }
                        }
                    }

                    // Categorías rápidas
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        StyledText {
                            text: "Categorías:"
                            font.pixelSize: Appearance.font.pixelSize.small
                            font.weight: Font.Medium
                            color: Appearance.m3colors.m3onSurface
                        }

                        ScrollView {
                            Layout.fillWidth: true
                            contentHeight: categoryRow.height
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                            RowLayout {
                                id: categoryRow
                                spacing: 6

                                property var categories: ["nature", "space", "abstract", "anime", "cyberpunk", "minimal"]

                                Repeater {
                                    model: categoryRow.categories
                                    delegate: RippleButton {
                                        implicitHeight: 32
                                        buttonRadius: Appearance.rounding.full
                                        colBackground: Appearance.colors.colSecondaryContainer

                                        contentItem: StyledText {
                                            text: modelData
                                            font.pixelSize: Appearance.font.pixelSize.small
                                            color: Appearance.m3colors.m3onSecondaryContainer
                                            horizontalAlignment: Text.AlignHCenter
                                            leftPadding: 12
                                            rightPadding: 12
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                wallpaperSearchField.text = modelData
                                                parent.parent.parent.parent.parent.performWallpaperSearch(modelData)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Resultados placeholder
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 15

                            MaterialSymbol {
                                Layout.alignment: Qt.AlignHCenter
                                text: "landscape"
                                iconSize: 80
                                color: Appearance.m3colors.m3outline
                            }

                            StyledText {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Wallpapers Dinámicos"
                                font.pixelSize: Appearance.font.pixelSize.larger
                                font.weight: Font.Medium
                                color: Appearance.m3colors.m3outline
                            }

                            StyledText {
                                Layout.alignment: Qt.AlignHCenter
                                text: "Busca wallpapers animados y estáticos\nCategorías: nature, space, anime, abstract"
                                font.pixelSize: Appearance.font.pixelSize.medium
                                color: Appearance.m3colors.m3outline
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }

                function performWallpaperSearch(query) {
                    searchQuery = query
                    // Placeholder - functionality to be implemented
                    searchResults = []
                }
            }
        }

        // Input area - solo para modos de chat
        Rectangle {
            visible: root.currentMode === "docs" || root.currentMode === "code"
            Layout.fillWidth: true
            Layout.margins: 12
            radius: Appearance.rounding.small
            color: Appearance.colors.colLayer1
            implicitHeight: 50
            border.color: Appearance.colors.colOutlineVariant
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8

                StyledTextArea {
                    id: messageInputField
                    Layout.fillWidth: true
                    placeholderText: `${root.getCurrentMode().name}: ${root.getCurrentMode().description}...`
                    background: null

                    Keys.onPressed: (event) => {
                        if ((event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
                            if (!(event.modifiers & Qt.ShiftModifier)) {
                                const inputText = text
                                text = ""
                                root.handleInput(inputText)
                                event.accepted = true
                            }
                        }
                    }
                }

                RippleButton {
                    implicitWidth: 36
                    implicitHeight: 36
                    buttonRadius: Appearance.rounding.small
                    enabled: messageInputField.text.length > 0

                    contentItem: MaterialSymbol {
                        text: "send"
                        iconSize: 18
                        color: parent.enabled ? Appearance.m3colors.m3onPrimary : Appearance.colors.colOnLayer2Disabled
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            const inputText = messageInputField.text
                            messageInputField.text = ""
                            root.handleInput(inputText)
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        const docsMode = getCurrentMode();
        const ai = getCurrentAi();
        ai.systemPrompt = docsMode.prompt;
    }
}