import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import "./translator/"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

/**
 * AI Translator - Using independent AI service
 */
Item {
    id: root
    property var inputField: inputCanvas.inputTextArea
    property string translatedText: ""
    property list<string> languages: ["auto", "en", "es", "ja", "fr", "de", "it", "pt", "ru", "zh", "ko", "ar", "hi", "th", "vi", "tr", "pl", "nl", "sv", "da", "no", "fi"]
    
    // Language settings
    property string targetLanguage: "es"
    property string sourceLanguage: "ja"
    
    // Language selector properties
    property bool showLanguageSelector: false
    property bool languageSelectorTarget: false

    // Independent translator AI service
    property var translatorAi: TranslatorAi

    Component.onCompleted: {
        console.log("Independent AI Translator loaded");
        root.translatedText = "Translator ready! Type to translate.";
    }

    function showLanguageSelectorDialog(isTargetLang: bool) {
        root.languageSelectorTarget = isTargetLang;
        root.showLanguageSelector = true
    }

    // Text monitoring - check every 3 seconds
    Timer {
        id: textMonitor
        interval: 3000
        repeat: true
        running: true
        property string lastText: ""
        
        onTriggered: {
            if (root.inputField && root.inputField.text !== lastText) {
                lastText = root.inputField.text;
                if (lastText.trim().length > 0) {
                    console.log("Text changed, attempting translation:", lastText.trim());
                    root.translatedText = "Attempting translation...";
                    translateWithAI(lastText.trim());
                } else {
                    root.translatedText = "";
                }
            }
        }
    }
    
    function translateWithAI(text) {
        console.log("translateWithAI called with:", text);
        
        console.log("Using independent translator AI service");
        var prompt = `Translate this text from ${getLanguageName(root.sourceLanguage)} to ${getLanguageName(root.targetLanguage)}. Only respond with the translation, no explanations: ${text}`;
        console.log("Translation prompt:", prompt);
        
        try {
            console.log("Sending message to TranslatorAI...");
            
            // Clear previous messages for clean translation
            if (translatorAi && translatorAi.clearMessages) {
                translatorAi.clearMessages();
            }
            
            // Send translation request
            if (translatorAi && translatorAi.sendUserMessage) {
                translatorAi.sendUserMessage(prompt);
            } else {
                console.log("TranslatorAI service not available");
                root.translatedText = "Translator service not ready";
                return;
            }
            
            console.log("Message sent successfully to TranslatorAI");
            root.translatedText = "Translating...";
            
            // Set up a timer to check for the latest response
            responseTimer.restart();
            
        } catch (error) {
            console.log("Error in TranslatorAI translation:", error);
            root.translatedText = "Translation error: " + error;
        }
    }
    
    // Timer to check for AI responses
    Timer {
        id: responseTimer
        interval: 1000  // Check every second
        repeat: true
        running: false
        property int checks: 0
        
        onTriggered: {
            checks++;
            
            // Check if AI is still processing
            if (translatorAi && translatorAi.isProcessing()) {
                console.log("TranslatorAI is still processing...");
                return;
            }
            
            // Get the latest response
            var response = translatorAi ? translatorAi.getLatestResponse() : "";
            if (response && response.length > 0) {
                console.log("Found TranslatorAI response:", response);
                root.translatedText = response;
                responseTimer.stop();
                checks = 0;
                return;
            }
            
            // Stop checking after 15 seconds
            if (checks >= 15) {
                console.log("TranslatorAI response timeout");
                root.translatedText = "Translation timeout";
                responseTimer.stop();
                checks = 0;
            }
        }
    }
    
    function getLanguageName(code) {
        switch(code) {
            case "auto": return "auto-detect";
            case "en": return "English";
            case "es": return "Spanish"; 
            case "ja": return "Japanese";
            case "fr": return "French";
            case "de": return "German";
            case "it": return "Italian";
            case "pt": return "Portuguese";
            case "ru": return "Russian";
            case "zh": return "Chinese";
            case "ko": return "Korean";
            case "ar": return "Arabic";
            case "hi": return "Hindi";
            case "th": return "Thai";
            case "vi": return "Vietnamese";
            case "tr": return "Turkish";
            case "pl": return "Polish";
            case "nl": return "Dutch";
            case "sv": return "Swedish";
            case "da": return "Danish";
            case "no": return "Norwegian";
            case "fi": return "Finnish";
            default: return code.toUpperCase();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        
        // Target language button (top)
        LanguageSelectorButton {
            displayText: root.targetLanguage
            onClicked: root.showLanguageSelectorDialog(true)
        }

        // Language swap button
        GroupButton {
            Layout.fillWidth: true
            baseHeight: 32
            buttonRadius: Appearance.rounding.small
            contentItem: Row {
                anchors.centerIn: parent
                spacing: 8
                MaterialSymbol {
                    anchors.verticalCenter: parent.verticalCenter
                    iconSize: Appearance.font.pixelSize.larger
                    text: "swap_vert"
                    color: Appearance.colors.colOnLayer1
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Swap Languages"
                    color: Appearance.colors.colOnLayer1
                    font.pixelSize: Appearance.font.pixelSize.smaller
                }
            }
            onClicked: {
                console.log("Swapping languages");
                var temp = root.sourceLanguage;
                root.sourceLanguage = root.targetLanguage;
                root.targetLanguage = temp;
                
                // Re-translate if there's text
                if (root.inputField && root.inputField.text.trim().length > 0) {
                    root.translatedText = "Swapped! Re-translating...";
                    translateWithAI(root.inputField.text.trim());
                }
            }
        }

        // Translation output
        TextCanvas {
            id: outputCanvas
            isInput: false
            placeholderText: "Translation goes here..."
            text: root.translatedText
            
            GroupButton {
                baseWidth: height
                buttonRadius: Appearance.rounding.small
                enabled: outputCanvas.displayedText.trim().length > 0
                contentItem: MaterialSymbol {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    iconSize: Appearance.font.pixelSize.larger
                    text: "content_copy"
                    color: parent.parent.enabled ? Appearance.colors.colOnLayer1 : Appearance.colors.colSubtext
                }
                onClicked: {
                    Quickshell.clipboardText = outputCanvas.displayedText
                }
            }
        }

        // Source language button (middle)  
        LanguageSelectorButton {
            displayText: root.sourceLanguage
            onClicked: root.showLanguageSelectorDialog(false)
        }

        // Text input
        TextCanvas {
            id: inputCanvas
            isInput: true
            placeholderText: "Enter text to translate..."
            
            GroupButton {
                baseWidth: height
                buttonRadius: Appearance.rounding.small
                contentItem: MaterialSymbol {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    iconSize: Appearance.font.pixelSize.larger
                    text: "translate"
                    color: Appearance.colors.colOnLayer1
                }
                onClicked: {
                    console.log("Manual translate button clicked");
                    if (inputCanvas.inputTextArea.text.trim().length > 0) {
                        root.translatedText = "Manual translation...";
                        translateWithAI(inputCanvas.inputTextArea.text.trim());
                    }
                }
            }
            
            GroupButton {
                baseWidth: height
                buttonRadius: Appearance.rounding.small
                enabled: Quickshell.clipboardText && Quickshell.clipboardText.length > 0
                contentItem: MaterialSymbol {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    iconSize: Appearance.font.pixelSize.larger
                    text: "content_paste"
                    color: parent.enabled ? Appearance.colors.colOnLayer1 : Appearance.colors.colSubtext
                }
                onClicked: {
                    console.log("Paste button clicked");
                    if (Quickshell.clipboardText && Quickshell.clipboardText.trim().length > 0) {
                        root.inputField.text = Quickshell.clipboardText.trim();
                        root.translatedText = "Pasted! Translating...";
                        translateWithAI(Quickshell.clipboardText.trim());
                    }
                }
            }
            
            GroupButton {
                baseWidth: height
                buttonRadius: Appearance.rounding.small
                enabled: inputCanvas.inputTextArea.text.length > 0
                contentItem: MaterialSymbol {
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    iconSize: Appearance.font.pixelSize.larger
                    text: "close"
                    color: parent.enabled ? Appearance.colors.colOnLayer1 : Appearance.colors.colSubtext
                }
                onClicked: {
                    root.inputField.text = ""
                    root.translatedText = ""
                }
            }
        }
    }

    // Language selector dialog
    Loader {
        anchors.fill: parent
        active: root.showLanguageSelector
        visible: root.showLanguageSelector
        z: 9999
        sourceComponent: SelectionDialog {
            titleText: root.languageSelectorTarget ? "Select Target Language" : "Select Source Language"
            items: root.languages.map(code => `${root.getLanguageName(code)} (${code})`)
            defaultChoice: {
                const currentCode = root.languageSelectorTarget ? root.targetLanguage : root.sourceLanguage;
                return `${root.getLanguageName(currentCode)} (${currentCode})`;
            }
            onCanceled: () => {
                root.showLanguageSelector = false;
            }
            onSelected: (result) => {
                root.showLanguageSelector = false;
                if (!result || result.length === 0) return;

                // Extract language code from "Language Name (code)" format
                const match = result.match(/\(([^)]+)\)$/);
                if (!match) return;
                
                const selectedCode = match[1];
                console.log("Selected language code:", selectedCode);

                if (root.languageSelectorTarget) {
                    root.targetLanguage = selectedCode;
                    console.log("Target language set to:", selectedCode);
                } else {
                    root.sourceLanguage = selectedCode;
                    console.log("Source language set to:", selectedCode);
                }
                
                // Re-translate if there's text
                if (root.inputField && root.inputField.text.trim().length > 0) {
                    root.translatedText = "Language changed! Re-translating...";
                    translateWithAI(root.inputField.text.trim());
                }
            }
        }
    }
}