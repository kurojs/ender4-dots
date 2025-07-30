import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

Item {
    id: root
    property var scopeRoot

    // Tab management
    property int currentTab: 1  // 0 = All Apps, 1 = Pinned (default is Pinned)
    
    function focusActiveItem() {
        searchField.forceActiveFocus()
    }
    
    function clearSearch() {
        searchField.text = ""
        selectedIndex = -1
    }
    
    // Keyboard navigation properties
    property int selectedIndex: -1
    property var currentAppsList: []
    
    // Calculator functionality
    function isCalculatorExpression(text) {
        // Check if text contains math operators and numbers
        return /^[\d+\-*/().\s%^]+$/.test(text) && /[+\-*/%^]/.test(text);
    }
    
    function evaluateExpression(expression) {
        try {
            // Replace ^ with ** for power operations
            let expr = expression.replace(/\^/g, '**');
            // Handle percentage (simple case: number%)
            expr = expr.replace(/(\d+(\.\d+)?)%/g, '($1/100)');
            
            // Simple evaluation - in production you'd want a safer parser
            let result = Function('"use strict"; return (' + expr + ')')();
            
            // Format result nicely
            if (Number.isInteger(result)) {
                return result.toString();
            } else {
                return parseFloat(result.toFixed(10)).toString(); // Remove trailing zeros
            }
        } catch (e) {
            return "Error";
        }
    }
    
    // Unit conversion functionality
    function isUnitConversion(text) {
        // Check for common unit conversion patterns
        return /\d+\s*(cm|mm|m|km|in|ft|yd|mi|kg|g|lb|oz|c|f|k)\s*(to|in)\s*(cm|mm|m|km|in|ft|yd|mi|kg|g|lb|oz|c|f|k)$/i.test(text);
    }
    
    function convertUnits(text) {
        try {
            let match = text.match(/(\d+(?:\.\d+)?)\s*(\w+)\s*(?:to|in)\s*(\w+)/i);
            if (!match) return "Error";
            
            let value = parseFloat(match[1]);
            let fromUnit = match[2].toLowerCase();
            let toUnit = match[3].toLowerCase();
            
            // Length conversions
            const lengthUnits = {
                'mm': 0.001, 'cm': 0.01, 'm': 1, 'km': 1000,
                'in': 0.0254, 'ft': 0.3048, 'yd': 0.9144, 'mi': 1609.34
            };
            
            // Weight conversions  
            const weightUnits = {
                'g': 1, 'kg': 1000, 'lb': 453.592, 'oz': 28.3495
            };
            
            // Temperature conversions
            if (fromUnit === 'c' && toUnit === 'f') {
                return ((value * 9/5) + 32).toFixed(2) + " °F";
            }
            if (fromUnit === 'f' && toUnit === 'c') {
                return ((value - 32) * 5/9).toFixed(2) + " °C";
            }
            if (fromUnit === 'c' && toUnit === 'k') {
                return (value + 273.15).toFixed(2) + " K";
            }
            if (fromUnit === 'k' && toUnit === 'c') {
                return (value - 273.15).toFixed(2) + " °C";
            }
            
            // Length conversions
            if (lengthUnits[fromUnit] && lengthUnits[toUnit]) {
                let meters = value * lengthUnits[fromUnit];
                let result = meters / lengthUnits[toUnit];
                return result.toFixed(4).replace(/\.?0+$/, '') + " " + toUnit;
            }
            
            // Weight conversions
            if (weightUnits[fromUnit] && weightUnits[toUnit]) {
                let grams = value * weightUnits[fromUnit];
                let result = grams / weightUnits[toUnit];
                return result.toFixed(4).replace(/\.?0+$/, '') + " " + toUnit;
            }
            
            return "Conversion not supported";
        } catch (e) {
            return "Error";
        }
    }
    
    // Check if text looks like a web search
    function isWebSearchQuery(text) {
        return text.length > 2 && !/^[\d+\-*/().\s]+$/.test(text);
    }

    // Update current apps list when model changes
    function updateAppsList() {
        let allApps = searchField.text.length > 0 ? 
                      AppSearch.fuzzyQuery(searchField.text) : 
                      AppSearch.list;
        
        if (searchField.text.length > 0) {
            // When searching, show all results regardless of tab
            currentAppsList = allApps;
        } else {
            // Filter based on current tab
            if (currentTab === 1) {
                // Pinned tab - show only pinned apps
                currentAppsList = GlobalStates.pinnedApps;
            } else {
                // All apps tab - show all apps
                currentAppsList = allApps;
            }
        }
        
        // Reset selection if out of bounds
        if (selectedIndex >= currentAppsList.length) {
            selectedIndex = currentAppsList.length > 0 ? 0 : -1;
        }
    }
    
    // Execute selected app
    function executeSelectedApp() {
        if (selectedIndex >= 0 && selectedIndex < currentAppsList.length) {
            let app = currentAppsList[selectedIndex];
            console.log("Executing selected app:", app.name);
            if (app.execute) {
                app.execute();
            }
            GlobalStates.appLauncherOpen = false;
        }
    }
    
    // Ensure selected item is visible in list
    function ensureVisible() {
        if (selectedIndex < 0) return
        
        let itemHeight = 60
        let targetY = selectedIndex * itemHeight
        
        // Calculate visible area
        let visibleTop = appsScrollView.contentY
        let visibleBottom = visibleTop + appsScrollView.height
        let itemTop = targetY
        let itemBottom = targetY + itemHeight
        
        // Scroll if item is not fully visible
        if (itemTop < visibleTop) {
            appsScrollView.contentY = itemTop - 10
        } else if (itemBottom > visibleBottom) {
            appsScrollView.contentY = itemBottom - appsScrollView.height + 10
        }
    }

    // Search field at top - Raycast style
    Rectangle {
        id: searchContainer
        x: 24
        y: 24
        width: parent.width - 48
        height: 52
        color: Qt.rgba(
            Appearance.colors.colLayer1.r,
            Appearance.colors.colLayer1.g,
            Appearance.colors.colLayer1.b,
            0.6
        )
        radius: 12
        border.width: 1
        border.color: searchField.activeFocus ? 
                      Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.4) : 
                      Qt.rgba(Appearance.colors.colOutlineVariant.r, Appearance.colors.colOutlineVariant.g, Appearance.colors.colOutlineVariant.b, 0.2)
        
        Behavior on border.color {
            ColorAnimation { duration: 200 }
        }
        
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            spacing: 16
            
            MaterialSymbol {
                text: "search"
                iconSize: 22
                color: Qt.rgba(Appearance.m3colors.m3onSurfaceVariant.r, Appearance.m3colors.m3onSurfaceVariant.g, Appearance.m3colors.m3onSurfaceVariant.b, 0.7)
                anchors.verticalCenter: parent.verticalCenter
            }
            
            TextField {
                id: searchField
                width: searchContainer.width - 80
                height: 40
                placeholderText: "Search applications..."
                color: Appearance.colors.colOnLayer0
                font.pixelSize: 16
                font.weight: Font.Normal
                background: Item {}
                
                // Custom placeholder text
                Text {
                    id: placeholder
                    x: searchField.leftPadding
                    y: searchField.topPadding
                    width: searchField.width - (searchField.leftPadding + searchField.rightPadding)
                    height: searchField.height - (searchField.topPadding + searchField.bottomPadding)
                    text: searchField.placeholderText
                    font: searchField.font
                    color: Qt.rgba(Appearance.m3colors.m3onSurfaceVariant.r, Appearance.m3colors.m3onSurfaceVariant.g, Appearance.m3colors.m3onSurfaceVariant.b, 0.6)
                    verticalAlignment: Text.AlignVCenter
                    visible: !searchField.length && !searchField.preeditText && !searchField.activeFocus
                    elide: Text.ElideRight
                }
                
                // Update apps list when text changes
                onTextChanged: {
                    root.updateAppsList();
                    // Auto-select first item when searching
                    if (searchField.text.length > 0 && currentAppsList.length > 0) {
                        selectedIndex = 0;
                        ensureVisible();
                    } else {
                        selectedIndex = -1;
                    }
                }
                
                // Handle keyboard navigation
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Up) {
                        if (selectedIndex > 0) {
                            selectedIndex--
                            ensureVisible()
                        } else if (currentAppsList.length > 0) {
                            selectedIndex = currentAppsList.length - 1
                            ensureVisible()
                        }
                        event.accepted = true
                    } else if (event.key === Qt.Key_Down) {
                        if (selectedIndex < currentAppsList.length - 1) {
                            selectedIndex++
                            ensureVisible()
                        } else if (currentAppsList.length > 0) {
                            selectedIndex = 0
                            ensureVisible()
                        }
                        event.accepted = true
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        // Handle calculator expressions
                        if (searchField.text.length > 0 && (isCalculatorExpression(searchField.text) || isUnitConversion(searchField.text))) {
                            let result = isUnitConversion(searchField.text) ? 
                                        convertUnits(searchField.text) : 
                                        evaluateExpression(searchField.text);
                            if (result !== "Error") {
                                // Copy result to clipboard and show notification
                                Quickshell.clipboard = result;
                                console.log("Result:", result, "(copied to clipboard)");
                            }
                            event.accepted = true
                            return;
                        }
                        
                        // Handle web search when no apps found
                        if (currentAppsList.length === 0 && searchField.text.length > 0 && isWebSearchQuery(searchField.text)) {
                            let searchUrl = "https://www.google.com/search?q=" + encodeURIComponent(searchField.text);
                            Qt.openUrlExternally(searchUrl);
                            GlobalStates.appLauncherOpen = false;
                            event.accepted = true
                            return;
                        }
                        
                        // Handle app execution
                        if (selectedIndex >= 0 && selectedIndex < currentAppsList.length) {
                            currentAppsList[selectedIndex].execute()
                            GlobalStates.appLauncherOpen = false
                        }
                        event.accepted = true
                    } else if (event.key === Qt.Key_Escape) {
                        GlobalStates.appLauncherOpen = false
                        event.accepted = true
                    } else if (event.key === Qt.Key_Tab) {
                        // Switch between tabs
                        currentTab = currentTab === 0 ? 1 : 0
                        root.updateAppsList()
                        event.accepted = true
                    }
                }
                
                Component.onCompleted: {
                    root.updateAppsList();
                }
            }
        }
    }

    // Tab indicator - Subtle Raycast style
    Row {
        id: tabBar
        x: 24
        y: searchContainer.y + searchContainer.height + 16
        spacing: 8
        visible: searchField.text.length === 0  // Hide when searching
        
        Rectangle {
            id: pinnedTab
            width: 80
            height: 32
            color: currentTab === 1 ? Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.15) : "transparent"
            radius: 8
            border.width: currentTab === 1 ? 1 : 0
            border.color: Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.3)
            
            StyledText {
                text: "Pinned"
                font.pixelSize: 13
                font.weight: currentTab === 1 ? Font.Medium : Font.Normal
                color: currentTab === 1 ? 
                       Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.9) :
                       Qt.rgba(Appearance.colors.colOnLayer0.r, Appearance.colors.colOnLayer0.g, Appearance.colors.colOnLayer0.b, 0.7)
                anchors.centerIn: parent
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentTab = 1
                    root.updateAppsList()
                }
            }
        }
        
        Rectangle {
            id: allAppsTab
            width: 60
            height: 32
            color: currentTab === 0 ? Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.15) : "transparent"
            radius: 8
            border.width: currentTab === 0 ? 1 : 0
            border.color: Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.3)
            
            StyledText {
                text: "All"
                font.pixelSize: 13
                font.weight: currentTab === 0 ? Font.Medium : Font.Normal
                color: currentTab === 0 ? 
                       Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.9) :
                       Qt.rgba(Appearance.colors.colOnLayer0.r, Appearance.colors.colOnLayer0.g, Appearance.colors.colOnLayer0.b, 0.7)
                anchors.centerIn: parent
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentTab = 0
                    root.updateAppsList()
                }
            }
        }
    }

    // Main content area
    Item {
        id: mainContent
        x: 24
        y: tabBar.visible ? (tabBar.y + tabBar.height + 16) : (searchContainer.y + searchContainer.height + 20)
        width: parent.width - 48
        height: parent.height - y - 24
        
        // Search results label when searching
        StyledText {
            id: searchLabel
            text: searchField.text.length > 0 ? `Results for "${searchField.text}"` : ""
            font.pixelSize: 14
            font.weight: Font.Medium
            color: Qt.rgba(Appearance.colors.colOnLayer0.r, Appearance.colors.colOnLayer0.g, Appearance.colors.colOnLayer0.b, 0.8)
            visible: searchField.text.length > 0
        }

        // Calculator result display
        Rectangle {
            id: calculatorResult
            width: parent.width
            height: 60
            y: searchLabel.visible ? 32 : 0
            visible: searchField.text.length > 0 && (isCalculatorExpression(searchField.text) || isUnitConversion(searchField.text))
            color: Qt.rgba(Appearance.m3colors.m3primaryContainer.r, Appearance.m3colors.m3primaryContainer.g, Appearance.m3colors.m3primaryContainer.b, 0.15)
            border.width: 1
            border.color: Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.3)
            radius: 10
            
            Row {
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 16
                
                MaterialSymbol {
                    text: isUnitConversion(searchField.text) ? "straighten" : "calculate"
                    iconSize: 24
                    color: Appearance.m3colors.m3primary
                    anchors.verticalCenter: parent.verticalCenter
                }
                
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    
                    StyledText {
                        text: isUnitConversion(searchField.text) ? 
                              convertUnits(searchField.text) : 
                              evaluateExpression(searchField.text)
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: Appearance.m3colors.m3onPrimaryContainer
                    }
                    
                    StyledText {
                        text: "Press Enter to copy result"
                        font.pixelSize: 12
                        color: Qt.rgba(Appearance.m3colors.m3onPrimaryContainer.r, Appearance.m3colors.m3onPrimaryContainer.g, Appearance.m3colors.m3onPrimaryContainer.b, 0.7)
                    }
                }
            }
        }
        
        // Web search suggestion
        Rectangle {
            id: webSearchSuggestion
            width: parent.width
            height: 60
            y: calculatorResult.visible ? (calculatorResult.y + calculatorResult.height + 8) : (searchLabel.visible ? 32 : 0)
            visible: searchField.text.length > 0 && currentAppsList.length === 0 && !isCalculatorExpression(searchField.text) && !isUnitConversion(searchField.text) && isWebSearchQuery(searchField.text)
            color: Qt.rgba(Appearance.m3colors.m3secondaryContainer.r, Appearance.m3colors.m3secondaryContainer.g, Appearance.m3colors.m3secondaryContainer.b, 0.15)
            border.width: 1
            border.color: Qt.rgba(Appearance.m3colors.m3secondary.r, Appearance.m3colors.m3secondary.g, Appearance.m3colors.m3secondary.b, 0.3)
            radius: 10
            
            Row {
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 16
                
                MaterialSymbol {
                    text: "search"
                    iconSize: 24
                    color: Appearance.m3colors.m3secondary
                    anchors.verticalCenter: parent.verticalCenter
                }
                
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    
                    StyledText {
                        text: `Search "${searchField.text}" on Google`
                        font.pixelSize: 15
                        font.weight: Font.Medium
                        color: Appearance.m3colors.m3onSecondaryContainer
                    }
                    
                    StyledText {
                        text: "Press Enter to search"
                        font.pixelSize: 12
                        color: Qt.rgba(Appearance.m3colors.m3onSecondaryContainer.r, Appearance.m3colors.m3onSecondaryContainer.g, Appearance.m3colors.m3onSecondaryContainer.b, 0.7)
                    }
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    let searchUrl = "https://www.google.com/search?q=" + encodeURIComponent(searchField.text);
                    Qt.openUrlExternally(searchUrl);
                    GlobalStates.appLauncherOpen = false;
                }
            }
        }

        // Apps list - Raycast style
        ScrollView {
            id: appsScrollView
            width: parent.width
            y: {
                let yPos = searchLabel.visible ? 32 : 0;
                if (calculatorResult.visible) yPos = calculatorResult.y + calculatorResult.height + 8;
                if (webSearchSuggestion.visible) yPos = webSearchSuggestion.y + webSearchSuggestion.height + 8;
                return yPos;
            }
            height: parent.height - y
            clip: true
            
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.vertical.stepSize: 0.2
            
            ListView {
                id: appsList
                anchors.fill: parent
                spacing: 2
                
                model: currentAppsList
                
                delegate: Rectangle {
                    width: appsList.width
                    height: 60
                    
                    property bool isSelected: selectedIndex === index
                    property bool isPinned: GlobalStates.isAppPinned(modelData)
                    
                    color: isSelected ? 
                           Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.12) :
                           (appMouseArea.containsMouse ? 
                            Qt.rgba(Appearance.colors.colLayer2.r, Appearance.colors.colLayer2.g, Appearance.colors.colLayer2.b, 0.3) : 
                            "transparent")
                    radius: 10
                    
                    // Subtle selection border
                    border.width: isSelected ? 1 : 0
                    border.color: Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.4)
                    
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                    
                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 16
                        
                        // App icon - larger Raycast style
                        Item {
                            width: 40
                            height: 40
                            anchors.verticalCenter: parent.verticalCenter
                            
                            IconImage {
                                id: appIcon
                                width: 40
                                height: 40
                                anchors.centerIn: parent
                                source: Quickshell.iconPath(modelData.icon ?? AppSearch.guessIcon(modelData), "image-missing")
                                
                                // Enhanced fallback with better colors
                                Rectangle {
                                    anchors.fill: parent
                                    color: isPinned ? 
                                           Qt.rgba(Appearance.m3colors.m3primaryContainer.r, Appearance.m3colors.m3primaryContainer.g, Appearance.m3colors.m3primaryContainer.b, 0.8) : 
                                           Qt.rgba(Appearance.m3colors.m3secondaryContainer.r, Appearance.m3colors.m3secondaryContainer.g, Appearance.m3colors.m3secondaryContainer.b, 0.6)
                                    border.width: 1
                                    border.color: isPinned ? 
                                                  Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.3) : 
                                                  Qt.rgba(Appearance.m3colors.m3secondary.r, Appearance.m3colors.m3secondary.g, Appearance.m3colors.m3secondary.b, 0.2)
                                    radius: 10
                                    visible: appIcon.status === Image.Error || appIcon.status === Image.Null
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.name ? modelData.name.charAt(0).toUpperCase() : "?"
                                        font.pixelSize: 18
                                        font.weight: Font.Bold
                                        color: isPinned ? Appearance.m3colors.m3onPrimaryContainer : Appearance.m3colors.m3onSecondaryContainer
                                    }
                                }
                            }
                        }
                        
                        // App info column
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            
                            // App name - Raycast typography
                            StyledText {
                                text: modelData.name || "Unknown"
                                font.pixelSize: 15
                                font.weight: Font.Medium
                                color: Appearance.colors.colOnLayer0
                                width: appsList.width - 120
                                elide: Text.ElideRight
                            }
                            
                            // App description/path - subtle
                            StyledText {
                                text: modelData.comment || modelData.exec || ""
                                font.pixelSize: 12
                                font.weight: Font.Normal
                                color: Qt.rgba(Appearance.colors.colOnLayer0.r, Appearance.colors.colOnLayer0.g, Appearance.colors.colOnLayer0.b, 0.6)
                                width: appsList.width - 120
                                elide: Text.ElideRight
                                visible: text.length > 0
                            }
                        }
                    }
                    
                    // Pin indicator - subtle
                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        width: 6
                        height: 6
                        radius: 3
                        color: Qt.rgba(Appearance.m3colors.m3primary.r, Appearance.m3colors.m3primary.g, Appearance.m3colors.m3primary.b, 0.7)
                        visible: isPinned
                    }
                    
                    MouseArea {
                        id: appMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        
                        onClicked: function(mouse) {
                            if (mouse.button === Qt.LeftButton) {
                                console.log("Launching app:", modelData.name)
                                if (modelData.execute) {
                                    modelData.execute()
                                }
                                GlobalStates.appLauncherOpen = false
                            } else if (mouse.button === Qt.RightButton) {
                                // Toggle pin/unpin
                                if (isPinned) {
                                    console.log("Unpinning app:", modelData.name)
                                    GlobalStates.unpinApp(modelData)
                                } else {
                                    console.log("Pinning app:", modelData.name)
                                    GlobalStates.pinApp(modelData)
                                }
                                root.updateAppsList()
                            }
                        }
                        
                        onEntered: {
                            // Update selection on hover
                            selectedIndex = index
                        }
                    }
                }
            }
        }
        
        // Empty state message
        Column {
            anchors.centerIn: parent
            spacing: 12
            visible: currentAppsList.length === 0 && !calculatorResult.visible && !webSearchSuggestion.visible
            
            MaterialSymbol {
                text: searchField.text.length > 0 ? "search_off" : "apps"
                iconSize: 48
                color: Qt.rgba(Appearance.m3colors.m3onSurfaceVariant.r, Appearance.m3colors.m3onSurfaceVariant.g, Appearance.m3colors.m3onSurfaceVariant.b, 0.5)
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            StyledText {
                text: searchField.text.length > 0 ? "No applications found" : 
                      (currentTab === 1 ? "No pinned applications" : "No applications")
                font.pixelSize: 14
                color: Qt.rgba(Appearance.colors.colOnLayer0.r, Appearance.colors.colOnLayer0.g, Appearance.colors.colOnLayer0.b, 0.6)
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
    
    // Update apps list when tab changes
    onCurrentTabChanged: {
        updateAppsList()
    }
}