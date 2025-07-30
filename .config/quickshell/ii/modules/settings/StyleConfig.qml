import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

ContentPage {
    baseWidth: lightDarkButtonGroup.implicitWidth
    forceWidth: true

    ContentSection {
        title: Translation.tr("Colors & Wallpaper")

        // Light/Dark mode preference
        ButtonGroup {
            id: lightDarkButtonGroup
            Layout.fillWidth: true
            LightDarkPreferenceButton {
                dark: false
            }
            LightDarkPreferenceButton {
                dark: true
            }
        }

        // Material palette selection
        ContentSubsection {
            title: Translation.tr("Material palette")
            ConfigSelectionArray {
                currentValue: Config.options.appearance.palette.type
                configOptionName: "appearance.palette.type"
                onSelected: (newValue) => {
                    Config.options.appearance.palette.type = newValue;
                    Quickshell.execDetached(["bash", "-c", `${Directories.wallpaperSwitchScriptPath} --noswitch`])
                }
                options: [
                    {"value": "auto", "displayName": Translation.tr("Auto")},
                    {"value": "custom", "displayName": Translation.tr("Custom")},
                    {"value": "scheme-content", "displayName": Translation.tr("Content")},
                    {"value": "scheme-expressive", "displayName": Translation.tr("Expressive")},
                    {"value": "scheme-fidelity", "displayName": Translation.tr("Fidelity")},
                    {"value": "scheme-fruit-salad", "displayName": Translation.tr("Fruit Salad")},
                    {"value": "scheme-monochrome", "displayName": Translation.tr("Monochrome")},
                    {"value": "scheme-neutral", "displayName": Translation.tr("Neutral")},
                    {"value": "scheme-rainbow", "displayName": Translation.tr("Rainbow")},
                    {"value": "scheme-tonal-spot", "displayName": Translation.tr("Tonal Spot")}
                ]
            }
        }

        // Custom accent color selection
        ContentSubsection {
            title: Translation.tr("Custom accent color")
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 15
                
                // Color preview button
                RippleButton {
                    id: colorPreviewButton
                    implicitWidth: 80
                    implicitHeight: 40
                    buttonRadius: Appearance.rounding.small
                    
                    property string customColor: Config.options?.appearance?.customAccentColor ?? "#91689E"
                    
                    colBackground: customColor
                    colBackgroundHover: Qt.lighter(customColor, 1.2)
                    
                    onClicked: {
                        colorInputField.focus = true;
                        colorInputField.selectAll();
                    }
                    
                    StyledToolTip {
                        content: Translation.tr("Click to edit color or use the text field")
                    }
                }
                
                // Color input field  
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 5
                    
                    StyledText {
                        text: Translation.tr("Hex color (e.g., #FF5722)")
                        font.pixelSize: Appearance.font.pixelSize.smaller
                        color: Appearance.colors.colSubtext
                    }
                    
                    MaterialTextField {
                        id: colorInputField
                        Layout.fillWidth: true
                        placeholderText: "#91689E"
                        text: colorPreviewButton.customColor
                        
                        // Validate hex color input
                        property bool isValidColor: {
                            const hexPattern = /^#[0-9A-Fa-f]{6}$/;
                            return hexPattern.test(text);
                        }
                        
                        // Change the bottom border color based on validation
                        background: Rectangle {
                            implicitHeight: 56
                            color: Appearance.m3colors.m3surface
                            topLeftRadius: 4
                            topRightRadius: 4
                            Rectangle {
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                    bottom: parent.bottom
                                }
                                height: 1
                                color: !colorInputField.isValidColor ? Appearance.m3colors.m3error :
                                    colorInputField.focus ? Appearance.m3colors.m3primary : 
                                    colorInputField.hovered ? Appearance.m3colors.m3outline : Appearance.m3colors.m3outlineVariant

                                Behavior on color {
                                    animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
                                }
                            }
                        }
                        
                        onTextChanged: {
                            if (isValidColor) {
                                colorPreviewButton.customColor = text;
                            }
                        }
                        
                        Keys.onReturnPressed: {
                            if (isValidColor) {
                                applyCustomColorButton.clicked();
                            }
                        }
                    }
                }
                
                // Apply button
                RippleButton {
                    id: applyCustomColorButton
                    buttonText: Translation.tr("Apply Accent Only")
                    buttonRadius: Appearance.rounding.small
                    enabled: colorInputField.isValidColor
                    
                    onClicked: {
                        if (colorInputField.isValidColor) {
                            // Save custom color to config
                            Config.options.appearance.customAccentColor = colorInputField.text;
                            Config.options.appearance.palette.type = "custom";
                            
                            // Apply only accent color without changing the whole scheme
                            Quickshell.execDetached([
                                "bash", "-c", 
                                `${Directories.scriptPath}/colors/apply_accent_only.sh "${colorInputField.text}"`
                            ]);
                        }
                    }
                    
                    StyledToolTip {
                        content: Translation.tr("Apply this color as accent only (preserves current theme)")
                    }
                }
            }
            
            // Color presets row
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 10
                spacing: 8
                
                StyledText {
                    text: Translation.tr("Presets:")
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: Appearance.colors.colSubtext
                }
                
                // Color preset buttons
                Repeater {
                    model: [
                        {"color": "#E91E63", "name": "Pink"},
                        {"color": "#9C27B0", "name": "Purple"}, 
                        {"color": "#673AB7", "name": "Deep Purple"},
                        {"color": "#3F51B5", "name": "Indigo"},
                        {"color": "#2196F3", "name": "Blue"},
                        {"color": "#00BCD4", "name": "Cyan"},
                        {"color": "#4CAF50", "name": "Green"},
                        {"color": "#FF9800", "name": "Orange"},
                        {"color": "#FF5722", "name": "Deep Orange"}
                    ]
                    
                    RippleButton {
                        required property var modelData
                        implicitWidth: 24
                        implicitHeight: 24
                        buttonRadius: Appearance.rounding.full
                        
                        colBackground: modelData.color
                        colBackgroundHover: Qt.lighter(modelData.color, 1.2)
                        
                        onClicked: {
                            colorInputField.text = modelData.color;
                            colorPreviewButton.customColor = modelData.color;
                        }
                        
                        StyledToolTip {
                            content: modelData.name + " (" + modelData.color + ")"
                        }
                    }
                }
            }
        }


    }

    ContentSection {
        title: Translation.tr("Decorations & Effects")

        ContentSubsection {
            title: Translation.tr("Transparency")

            ConfigRow {
                ConfigSwitch {
                    text: Translation.tr("Enable")
                    checked: Config.options.appearance.transparency
                    onCheckedChanged: {
                        Config.options.appearance.transparency = checked;
                    }
                    StyledToolTip {
                        content: Translation.tr("Might look ass. Unsupported.")
                    }
                }
            }
        }

        ContentSubsection {
            title: Translation.tr("Fake screen rounding")

            ButtonGroup {
                id: fakeScreenRoundingButtonGroup
                property int selectedPolicy: Config.options.appearance.fakeScreenRounding
                spacing: 2
                SelectionGroupButton {
                    property int value: 0
                    leftmost: true
                    buttonText: Translation.tr("No")
                    toggled: (fakeScreenRoundingButtonGroup.selectedPolicy === value)
                    onClicked: {
                        Config.options.appearance.fakeScreenRounding = value;
                    }
                }
                SelectionGroupButton {
                    property int value: 1
                    buttonText: Translation.tr("Yes")
                    toggled: (fakeScreenRoundingButtonGroup.selectedPolicy === value)
                    onClicked: {
                        Config.options.appearance.fakeScreenRounding = value;
                    }
                }
                SelectionGroupButton {
                    property int value: 2
                    rightmost: true
                    buttonText: Translation.tr("When not fullscreen")
                    toggled: (fakeScreenRoundingButtonGroup.selectedPolicy === value)
                    onClicked: {
                        Config.options.appearance.fakeScreenRounding = value;
                    }
                }
            }
        }

        ContentSubsection {
            title: Translation.tr("Shell windows")

            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: Translation.tr("Title bar")
                    checked: Config.options.windows.showTitlebar
                    onCheckedChanged: {
                        Config.options.windows.showTitlebar = checked;
                    }
                }
                ConfigSwitch {
                    text: Translation.tr("Center title")
                    checked: Config.options.windows.centerTitle
                    onCheckedChanged: {
                        Config.options.windows.centerTitle = checked;
                    }
                }
            }
        }

        ContentSubsection {
            title: Translation.tr("Wallpaper parallax")

            ConfigRow {
                uniform: true
                ConfigSwitch {
                    text: Translation.tr("Depends on workspace")
                    checked: Config.options.background.parallax.enableWorkspace
                    onCheckedChanged: {
                        Config.options.background.parallax.enableWorkspace = checked;
                    }
                }
                ConfigSwitch {
                    text: Translation.tr("Depends on sidebars")
                    checked: Config.options.background.parallax.enableSidebar
                    onCheckedChanged: {
                        Config.options.background.parallax.enableSidebar = checked;
                    }
                }
            }
            ConfigSpinBox {
                text: Translation.tr("Preferred wallpaper zoom (%)")
                value: Config.options.background.parallax.workspaceZoom * 100
                from: 100
                to: 150
                stepSize: 1
                onValueChanged: {
                    console.log(value/100)
                    Config.options.background.parallax.workspaceZoom = value / 100;
                }
            }
        }
    }
}