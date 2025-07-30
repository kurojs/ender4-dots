pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions as CF
import qs.modules.common
import qs
import Quickshell
import Quickshell.Io
import QtQuick

/**
 * Independent AI service for DevTools
 * Based on main Ai.qml but completely separate instance
 */
Singleton {
    id: root

    readonly property string interfaceRole: "interface"
    readonly property string apiKeyEnvVarName: "API_KEY"
    property Component aiMessageComponent: AiMessageData {}
    property string systemPrompt: "You are a helpful AI assistant for developers. Provide concise, practical answers focused on development tasks."
    property var messageIDs: []
    property var messageByID: ({})
    readonly property var apiKeys: KeyringStorage.keyringData?.apiKeys ?? {}
    readonly property var apiKeysLoaded: KeyringStorage.loaded
    property var postResponseHook
    property real temperature: 0.7
    property bool isStreaming: false

    // Use the same models from main AI service
    readonly property var models: Ai.models
    property var modelList: Ai.modelList
    property var currentModelId: Ai.currentModelId
    readonly property var promptFiles: Ai.promptFiles
    property var savedChats: []

    function idForMessage(message) {
        return "dev_" + Date.now().toString(36) + Math.random().toString(36).substr(2, 8);
    }

    function safeModelName(modelName) {
        return modelName.replace(/:/g, "_").replace(/\./g, "_")
    }

    Component.onCompleted: {
        console.log("DevToolsAi service initialized");
    }

    function addMessage(message, role) {
        if (message.length === 0) return;
        const aiMessage = aiMessageComponent.createObject(root, {
            "role": role,
            "content": message,
            "rawContent": message,
            "thinking": false,
            "done": true,
        });
        const id = idForMessage(aiMessage);
        root.messageIDs = root.messageIDs.concat([id]);
        root.messageByID[id] = aiMessage;
    }

    function getModel() {
        return models[currentModelId];
    }

    function clearMessages() {
        root.messageIDs = [];
        root.messageByID = ({});
    }

    function setModel(modelId) {
        if (models[modelId]) {
            currentModelId = modelId;
            addMessage(Translation.tr("Model set to %1").arg(models[modelId].name), interfaceRole);
        } else {
            addMessage(Translation.tr("Unknown model: %1").arg(modelId), interfaceRole);
        }
    }

    function setApiKey(key) {
        const model = getModel();
        if (!model.requires_key) {
            addMessage(Translation.tr("%1 does not require an API key").arg(model.name), interfaceRole);
            return;
        }
        addMessage(Translation.tr("API key set for %1").arg(model.name), interfaceRole);
    }

    function printApiKey() {
        const model = getModel();
        if (model.requires_key) {
            const key = apiKeys[model.key_id];
            if (key) {
                addMessage(Translation.tr("API key:\n\n```txt\n%1\n```").arg(key), interfaceRole);
            } else {
                addMessage(Translation.tr("No API key set for %1").arg(model.name), interfaceRole);
            }
        } else {
            addMessage(Translation.tr("%1 does not require an API key").arg(model.name), interfaceRole);
        }
    }

    function setTemperature(value) {
        if (value < 0 || value > 2) {
            addMessage(Translation.tr("Temperature must be between 0 and 2"), interfaceRole);
            return;
        }
        temperature = value;
        addMessage(Translation.tr("Temperature set to %1").arg(value), interfaceRole);
    }

    function printTemperature() {
        addMessage(Translation.tr("Temperature: %1").arg(root.temperature), interfaceRole);
    }

    function loadPrompt(promptName) {
        systemPrompt = promptName;
        addMessage(Translation.tr("System prompt set to: %1").arg(promptName), interfaceRole);
    }

    function printPrompt() {
        addMessage(Translation.tr("Current system prompt:\n\n```\n%1\n```").arg(systemPrompt), interfaceRole);
    }

    function saveChat(chatName) {
        addMessage(Translation.tr("Chat saving not implemented in DevTools yet"), interfaceRole);
    }

    function loadChat(chatName) {
        addMessage(Translation.tr("Chat loading not implemented in DevTools yet"), interfaceRole);
    }

    function removeMessage(index) {
        if (index < 0 || index >= messageIDs.length) return;
        
        const messageId = messageIDs[index];
        const newMessageIDs = messageIDs.slice();
        newMessageIDs.splice(index, 1);
        
        const newMessageByID = Object.assign({}, messageByID);
        delete newMessageByID[messageId];
        
        messageIDs = newMessageIDs;
        messageByID = newMessageByID;
    }

    function isProcessing() {
        return requester.running;
    }

    function getLatestResponse() {
        if (root.messageIDs.length === 0) return "";
        const lastId = root.messageIDs[root.messageIDs.length - 1];
        const lastMessage = root.messageByID[lastId];
        if (lastMessage && lastMessage.role === "assistant" && lastMessage.done) {
            return lastMessage.content;
        }
        return "";
    }

    Process {
        id: requester
        property var baseCommand: ["bash", "-c"]
        property var message
        property bool isReasoning
        property string apiFormat: "gemini"
        property string geminiBuffer: ""

        function buildGeminiEndpoint(model) {
            return model.endpoint + `?key=\$\{${root.apiKeyEnvVarName}\}`;
        }

        function markDone() {
            requester.message.done = true;
            root.isStreaming = false;
            if (root.postResponseHook) {
                root.postResponseHook();
                root.postResponseHook = null;
            }
        }

        function buildGeminiRequestData(model, messages) {
            let baseData = {
                "contents": messages.filter(message => (message.role != root.interfaceRole)).map(message => {
                    const geminiApiRoleName = (message.role === "assistant") ? "model" : message.role;
                    return {
                        "role": geminiApiRoleName,
                        "parts": [{ 
                            text: message.rawContent,
                        }]
                    }
                }),
                "system_instruction": {
                    "parts": [{ text: root.systemPrompt }]
                },
                "generationConfig": {
                    "temperature": root.temperature,
                },
            };
            return baseData;
        }

        function makeRequest() {
            const model = models[currentModelId];
            requester.apiFormat = model.api_format ?? "gemini";
            root.isStreaming = true;

            /* Put API key in environment variable */
            if (model.requires_key) requester.environment[`${root.apiKeyEnvVarName}`] = root.apiKeys ? (root.apiKeys[model.key_id] ?? "") : ""

            /* Build endpoint, request data */
            const endpoint = buildGeminiEndpoint(model);
            const messageArray = root.messageIDs.map(id => root.messageByID[id]);
            const data = buildGeminiRequestData(model, messageArray);

            let requestHeaders = {
                "Content-Type": "application/json",
            }
            
            /* Create local message object */
            requester.message = root.aiMessageComponent.createObject(root, {
                "role": "assistant",
                "model": currentModelId,
                "content": "",
                "rawContent": "",
                "thinking": true,
                "done": false,
            });
            const id = idForMessage(requester.message);
            root.messageIDs = root.messageIDs.concat([id]);
            root.messageByID[id] = requester.message;

            /* Build header string for curl */ 
            let headerString = Object.entries(requestHeaders)
                .filter(([k, v]) => v && v.length > 0)
                .map(([k, v]) => `-H '${k}: ${v}'`)
                .join(' ');

            /* Create command string */
            const requestCommandString = `curl --no-buffer "${endpoint}"`
                + ` ${headerString}`
                + ` -d '${CF.StringUtils.shellSingleQuoteEscape(JSON.stringify(data))}'`
            
            requester.command = baseCommand.concat([requestCommandString]);

            /* Reset vars and make the request */
            requester.isReasoning = false
            requester.running = true
        }

        function parseGeminiBuffer() {
            try {
                if (requester.geminiBuffer.length === 0) return;
                const dataJson = JSON.parse(requester.geminiBuffer);
                if (!dataJson.candidates) return;
                
                if (dataJson.candidates[0]?.finishReason) {
                    requester.markDone();
                }
                
                // Normal text response
                const responseContent = dataJson.candidates[0]?.content?.parts[0]?.text
                requester.message.rawContent += responseContent;
                requester.message.content += responseContent;
                
            } catch (e) {
                console.log("[DevToolsAI] Could not parse response from stream: ", e);
                requester.message.rawContent += requester.geminiBuffer;
                requester.message.content += requester.geminiBuffer
            } finally {
                requester.geminiBuffer = "";
            }
        }

        function handleGeminiResponseLine(line) {
            if (line.startsWith("[")) {
                requester.geminiBuffer += line.slice(1).trim();
            } else if (line == "]") {
                requester.geminiBuffer += line.slice(0, -1).trim();
                parseGeminiBuffer();
            } else if (line.startsWith(",")) {
                parseGeminiBuffer();
            } else {
                requester.geminiBuffer += line.trim();
            }
        }

        stdout: SplitParser {
            onRead: data => {
                if (data.length === 0) return;

                if (requester.message.thinking) requester.message.thinking = false;
                try {
                    requester.handleGeminiResponseLine(data);
                } catch (e) {
                    console.log("[DevToolsAI] Could not parse response from stream: ", e);
                    requester.message.rawContent += data;
                    requester.message.content += data;
                }
            }
        }

        onExited: (exitCode, exitStatus) => {
            requester.parseGeminiBuffer();
            
            if (requester.message.content.includes("API key not valid")) {
                console.log("[DevToolsAI] API key not valid");
            }
        }
    }

    function sendUserMessage(message) {
        if (message.length === 0) return;
        console.log("[DevToolsAI] Sending message:", message);
        root.addMessage(message, "user");
        requester.makeRequest();
    }
}