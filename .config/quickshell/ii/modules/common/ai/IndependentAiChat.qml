import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.modules.common.widgets
import Qt5Compat.GraphicalEffects

// Componente de chat AI completamente independiente y reutilizable
Item {
    id: root
    
    // Propiedades públicas
    property string systemPrompt: ""
    property string placeholderText: "Type your message..."
    property string chatTitle: "AI Chat"
    property color userMessageColor: Appearance.colors.colPrimaryContainer
    property color assistantMessageColor: Appearance.colors.colLayer1
    
    // API pública
    property alias messages: chatModel.messages
    property alias isStreaming: chatModel.isStreaming
    
    signal messageAdded(var message)
    signal responseReceived(string content)
    
    // Modelo de chat independiente
    QtObject {
        id: chatModel
        
        property var messages: []
        property bool isStreaming: false
        property bool waitingForResponse: false
        
        // Timer para monitorear respuestas del AI global
        property Timer responseTimer: Timer {
            interval: 1000
            repeat: true
            running: false
            property int checks: 0
            
            onTriggered: {
                checks++
                
                if (!Ai.isStreaming && chatModel.waitingForResponse) {
                    // AI terminó, capturar respuesta
                    if (Ai.messageIDs && Ai.messageIDs.length > 0) {
                        const lastMsgId = Ai.messageIDs[Ai.messageIDs.length - 1]
                        const lastMsg = Ai.messageByID[lastMsgId]
                        
                        if (lastMsg && lastMsg.role === "assistant" && lastMsg.content) {
                            console.log("IndependentAI: Captured response:", lastMsg.content.substring(0, 50))
                            
                            // Agregar respuesta a nuestro chat
                            const assistantMessage = {
                                id: "assistant_" + Date.now() + "_" + Math.random(),
                                role: "assistant",
                                content: lastMsg.content,
                                timestamp: Date.now()
                            }
                            
                            chatModel.messages.push(assistantMessage)
                            chatModel.messagesChanged()
                            root.messageAdded(assistantMessage)
                            root.responseReceived(lastMsg.content)
                            
                            // Limpiar AI global inmediatamente
                            Ai.clearMessages()
                            
                            // Finalizar
                            chatModel.isStreaming = false
                            chatModel.waitingForResponse = false
                            stop()
                            checks = 0
                            return
                        }
                    }
                }
                
                if (checks >= 30) {
                    console.log("IndependentAI: Response timeout")
                    
                    // Agregar mensaje de error
                    const errorMessage = {
                        id: "error_" + Date.now(),
                        role: "assistant", 
                        content: "Error: No se pudo obtener respuesta. Intenta de nuevo.",
                        timestamp: Date.now()
                    }
                    
                    chatModel.messages.push(errorMessage)
                    chatModel.messagesChanged()
                    
                    chatModel.isStreaming = false
                    chatModel.waitingForResponse = false
                    stop()
                    checks = 0
                }
            }
        }
        
        function sendMessage(content) {
            if (isStreaming || Ai.isStreaming) {
                console.log("IndependentAI: Busy, cannot send message")
                return false
            }
            
            console.log("IndependentAI: Sending message:", content.substring(0, 50))
            
            // Agregar mensaje del usuario
            const userMessage = {
                id: "user_" + Date.now() + "_" + Math.random(),
                role: "user",
                content: content,
                timestamp: Date.now()
            }
            
            messages.push(userMessage)
            messagesChanged()
            root.messageAdded(userMessage)
            
            // Configurar AI global temporalmente
            isStreaming = true
            waitingForResponse = true
            
            Ai.systemPrompt = root.systemPrompt
            Ai.sendUserMessage(content)
            
            // Iniciar monitoreo
            responseTimer.checks = 0
            responseTimer.start()
            
            return true
        }
        
        function clearMessages() {
            messages = []
            messagesChanged()
            isStreaming = false
            waitingForResponse = false
            responseTimer.stop()
        }
        
        function removeMessage(messageId) {
            const index = messages.findIndex(msg => msg.id === messageId)
            if (index > -1) {
                messages.splice(index, 1)
                messagesChanged()
            }
        }
    }
    
    // Función pública para enviar mensajes
    function sendMessage(content) {
        return chatModel.sendMessage(content)
    }
    
    function clearMessages() {
        chatModel.clearMessages()
    }
    
    // UI del chat
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Lista de mensajes
        StyledListView {
            id: messageListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 15
            clip: true
            
            model: chatModel.messages
            
            delegate: Rectangle {
                width: messageListView.width
                color: "transparent"
                implicitHeight: messageColumn.implicitHeight + 30
                
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 8
                    color: modelData.role === "user" ? root.userMessageColor : root.assistantMessageColor
                    radius: Appearance.rounding.medium
                    border.color: Appearance.colors.colOutlineVariant
                    border.width: 1
                    
                    ColumnLayout {
                        id: messageColumn
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 8
                        
                        // Header con avatar y nombre
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            
                            MaterialSymbol {
                                iconSize: Appearance.font.pixelSize.medium
                                text: modelData.role === "user" ? "person" : "smart_toy"
                                color: Appearance.m3colors.m3onSurface
                            }
                            
                            StyledText {
                                font.pixelSize: Appearance.font.pixelSize.small
                                font.weight: Font.Medium
                                color: Appearance.m3colors.m3onSurfaceVariant
                                text: modelData.role === "user" ? "You" : root.chatTitle
                            }
                            
                            Item { Layout.fillWidth: true }
                            
                            StyledText {
                                font.pixelSize: Appearance.font.pixelSize.smaller
                                color: Appearance.m3colors.m3outline
                                text: Qt.formatTime(new Date(modelData.timestamp), "hh:mm")
                            }
                        }
                        
                        // Contenido del mensaje
                        StyledText {
                            Layout.fillWidth: true
                            text: modelData.content || ""
                            color: Appearance.m3colors.m3onSurface
                            wrapMode: Text.Wrap
                            textFormat: Text.MarkdownText
                            
                            onLinkActivated: function(link) {
                                Qt.openUrlExternally(link)
                            }
                        }
                    }
                }
            }
            
            // Auto scroll al final
            onCountChanged: {
                Qt.callLater(() => {
                    messageListView.positionViewAtEnd()
                })
            }
        }
        
        // Indicador de "escribiendo"
        Rectangle {
            Layout.fillWidth: true
            height: visible ? 40 : 0
            color: Appearance.colors.colLayer2
            visible: chatModel.isStreaming
            
            RowLayout {
                anchors.centerIn: parent
                spacing: 8
                
                BusyIndicator {
                    implicitWidth: 20
                    implicitHeight: 20
                    running: parent.parent.visible
                }
                
                StyledText {
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.m3colors.m3onSurfaceVariant
                    text: root.chatTitle + " is typing..."
                }
            }
        }
        
        // Área de input
        Rectangle {
            Layout.fillWidth: true
            radius: Appearance.rounding.small
            color: Appearance.colors.colLayer1
            implicitHeight: Math.max(inputRow.implicitHeight + 20, 50)
            border.color: Appearance.colors.colOutlineVariant
            border.width: 1
            
            RowLayout {
                id: inputRow
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8
                
                StyledTextArea {
                    id: messageInput
                    Layout.fillWidth: true
                    padding: 12
                    wrapMode: TextArea.Wrap
                    color: Appearance.m3colors.m3onSurface
                    placeholderText: root.placeholderText
                    background: null
                    enabled: !chatModel.isStreaming
                    
                    function accept() {
                        const text = messageInput.text.trim()
                        if (text.length > 0) {
                            if (chatModel.sendMessage(text)) {
                                messageInput.text = ""
                            }
                        }
                    }
                    
                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                            if (event.modifiers & Qt.ShiftModifier) {
                                insert(cursorPosition, "\n")
                            } else {
                                accept()
                            }
                            event.accepted = true
                        }
                    }
                }
                
                RippleButton {
                    implicitWidth: 40
                    implicitHeight: 40
                    buttonRadius: Appearance.rounding.small
                    enabled: messageInput.text.trim().length > 0 && !chatModel.isStreaming
                    toggled: enabled
                    
                    contentItem: MaterialSymbol {
                        anchors.centerIn: parent
                        iconSize: Appearance.font.pixelSize.large
                        color: parent.enabled ? Appearance.m3colors.m3onPrimary : Appearance.colors.colOnLayer2Disabled
                        text: chatModel.isStreaming ? "stop" : "send"
                    }
                    
                    onClicked: {
                        messageInput.accept()
                    }
                }
            }
        }
    }
    
    // Estado vacío
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 15
        visible: chatModel.messages.length === 0 && !chatModel.isStreaming
        
        MaterialSymbol {
            Layout.alignment: Qt.AlignHCenter
            iconSize: 80
            color: Appearance.m3colors.m3outline
            text: "chat"
        }
        
        StyledText {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Appearance.font.pixelSize.large
            font.weight: Font.Medium
            color: Appearance.m3colors.m3outline
            text: root.chatTitle
        }
        
        StyledText {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Appearance.font.pixelSize.medium
            color: Appearance.m3colors.m3outline
            text: "Start a conversation"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}