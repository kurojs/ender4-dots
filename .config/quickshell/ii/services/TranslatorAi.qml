pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions as CF
import qs.modules.common
import qs
import Quickshell
import Quickshell.Io
import QtQuick

/**
 * Independent AI service for the Translator module
 * Based on the main Ai.qml but completely separate instance
 */
Singleton {
    id: root

    readonly property string interfaceRole: "interface"
    readonly property string apiKeyEnvVarName: "API_KEY"
    property Component aiMessageComponent: AiMessageData {}
    property string systemPrompt: "You are a helpful translator. Translate text accurately and only respond with the translation, no explanations."
    property var messageIDs: []
    property var messageByID: ({})
    readonly property var apiKeys: KeyringStorage.keyringData?.apiKeys ?? {}
    readonly property var apiKeysLoaded: KeyringStorage.loaded
    property var postResponseHook
    property real temperature: 0.1 // Lower temperature for consistent translations

    function idForMessage(message) {
        // Generate a unique ID using timestamp and random value
        return "tr_" + Date.now().toString(36) + Math.random().toString(36).substr(2, 8);
    }

    function safeModelName(modelName) {
        return modelName.replace(/:/g, "_").replace(/\./g, "_")
    }

    // Use same models as main AI but just the ones we need for translation
    property var models: {
        "gemini-2.0-flash-search": {
            "name": "Gemini 2.0 Flash (Search)",
            "icon": "google-gemini-symbolic",
            "description": "Online | Google's model for translation",
            "homepage": "https://aistudio.google.com",
            "endpoint": "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:streamGenerateContent",
            "model": "gemini-2.0-flash",
            "requires_key": true,
            "key_id": "gemini",
            "key_get_link": "https://aistudio.google.com/app/apikey",
            "key_get_description": "Free API key for translation",
            "api_format": "gemini",
            "tools": []
        }
    }
    property var modelList: Object.keys(root.models)
    property var currentModelId: "gemini-2.0-flash-search"

    Component.onCompleted: {
        console.log("TranslatorAi service initialized");
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
        root.messageIDs = [...root.messageIDs, id];
        root.messageByID[id] = aiMessage;
    }

    function getModel() {
        return models[currentModelId];
    }

    function clearMessages() {
        root.messageIDs = [];
        root.messageByID = ({});
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
            root.messageIDs = [...root.messageIDs, id];
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
                console.log("[TranslatorAI] Could not parse response from stream: ", e);
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
                    console.log("[TranslatorAI] Could not parse response from stream: ", e);
                    requester.message.rawContent += data;
                    requester.message.content += data;
                }
            }
        }

        onExited: (exitCode, exitStatus) => {
            requester.parseGeminiBuffer();
            
            if (requester.message.content.includes("API key not valid")) {
                console.log("[TranslatorAI] API key not valid");
            }
        }
    }

    function sendUserMessage(message) {
        if (message.length === 0) return;
        console.log("[TranslatorAI] Sending message:", message);
        root.addMessage(message, "user");
        requester.makeRequest();
    }

    // Get the latest response
    function getLatestResponse() {
        if (messageIDs.length === 0) return "";
        
        // Find the latest assistant message
        for (let i = messageIDs.length - 1; i >= 0; i--) {
            const messageId = messageIDs[i];
            const message = messageByID[messageId];
            if (message && message.role === "assistant" && message.done) {
                return message.content.trim();
            }
        }
        return "";
    }

    // Check if AI is currently processing
    function isProcessing() {
        if (messageIDs.length === 0) return false;
        
        const latestMessageId = messageIDs[messageIDs.length - 1];
        const latestMessage = messageByID[latestMessageId];
        return latestMessage && latestMessage.role === "assistant" && !latestMessage.done;
    }
}