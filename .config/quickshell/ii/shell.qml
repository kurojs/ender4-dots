//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

// Adjust this to make the shell smaller or larger
//@ pragma Env QT_SCALE_FACTOR=1

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Mpris
import "./services/"
import "./modules/common/"
import "./modules/background/"
import "./modules/bar/"
import "./modules/cheatsheet/"
import "./modules/dock/"
import "./modules/appLauncher/"
import "./modules/mediaControls/"
import "./modules/notificationPopup/"
import "./modules/onScreenDisplay/"
import "./modules/onScreenKeyboard/"
import "./modules/overview/"
import "./modules/screenCorners/"
import "./modules/session/"
import "./modules/sidebarLeft/"
import "./modules/sidebarRight/"

ShellRoot {
    // Enable/disable modules here. False = not loaded at all, so rest assured
    // no unnecessary stuff will take up memory if you decide to only use, say, the overview.
    property bool enableBar: true
    property bool enableBackground: true
    property bool enableCheatsheet: true
    property bool enableDock: true
    property bool enableAppLauncher: true
    property bool enableMediaControls: true
    property bool enableNotificationPopup: true
    property bool enableOnScreenDisplayBrightness: true
    property bool enableOnScreenDisplayVolume: true
    property bool enableOnScreenKeyboard: true
    property bool enableOverview: true
    property bool enableReloadPopup: true
    property bool enableScreenCorners: true
    property bool enableSession: true
    property bool enableSidebarLeft: true
    property bool enableSidebarRight: true

    // Force initialization of some singletons
    Component.onCompleted: {
        initializationTimer.start()
    }

    Timer {
        id: initializationTimer
        interval: 1
        repeat: false
        onTriggered: {
            MaterialThemeLoader.reapplyTheme()
            Cliphist.refresh()
            FirstRunExperience.load()
        }
    }

    LazyLoader { active: enableBar; component: Bar {} }
    LazyLoader { active: enableBackground; component: Background {} }
    LazyLoader { active: enableCheatsheet; component: Cheatsheet {} }
    LazyLoader { active: enableDock && Config.options.dock.enable; component: Dock {} }
    LazyLoader { active: enableAppLauncher; component: AppLauncher {} }
    LazyLoader { active: enableMediaControls; component: MediaControls {} }
    LazyLoader { active: enableNotificationPopup; component: NotificationPopup {} }
    LazyLoader { active: enableOnScreenDisplayBrightness; component: OnScreenDisplayBrightness {} }
    LazyLoader { active: enableOnScreenDisplayVolume; component: OnScreenDisplayVolume {} }
    LazyLoader { active: enableOnScreenKeyboard; component: OnScreenKeyboard {} }
    LazyLoader { active: enableOverview; component: Overview {} }
    LazyLoader { active: enableReloadPopup; component: ReloadPopup {} }
    LazyLoader { active: enableScreenCorners; component: ScreenCorners {} }
    LazyLoader { active: enableSession; component: Session {} }
    LazyLoader { active: enableSidebarLeft; component: SidebarLeft {} }
    LazyLoader { active: enableSidebarRight; component: SidebarRight {} }

    /* // Waifu Slideshow Widget
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            required property var modelData
            screen: modelData
            
            anchors {
                left: true
                top: true
            }
            
            margins {
                left: 20
                top: 20
            }
            
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "quickshell:waifu-slideshow"
            color: "transparent"
            
            implicitWidth: 300
            implicitHeight: 320
            
            property int currentImageIndex: 0
            property var imageList: []
            property int slideshowInterval: 4000
            
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                
                Column {
                    anchors.centerIn: parent
                    spacing: 10
                    
                    Image {
                        id: waifuImage
                        width: 260
                        height: 260
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        source: imageList.length > 0 ? "file://" + imageList[currentImageIndex] : ""
                    }
                }
            }
            
            Timer {
                id: slideshowTimer
                interval: slideshowInterval
                running: true
                repeat: true
                onTriggered: nextImage()
            }
            
            Component.onCompleted: {
                loadImageList()
            }
            
            function nextImage() {
                if (imageList.length > 0) {
                    currentImageIndex = (currentImageIndex + 1) % imageList.length
                    console.log("Showing waifu image:", currentImageIndex + 1, "/", imageList.length)
                }
            }
            // Here, replace the path with the path to each of your images
            function loadImageList() {
                console.log("Loading waifu images...")
                imageList = [
                "/home/kuro/Desktop/ファイル/Imagenes/example.jpg"
                ]
                console.log("Loaded", imageList.length, "waifu images")
                if (imageList.length > 0) {
                    currentImageIndex = Math.floor(Math.random() * imageList.length)
                }
            }
        }
    }
    */ // End Waifu Widget

    // Japanese Clock Widget
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            required property var modelData
            screen: modelData
            
            anchors {
                right: true
                top: true
            }
            
            margins {
                right: 15
                top: 5
            }
            
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "quickshell:japanese-clock"
            color: "transparent"
            
            implicitWidth: 450
            implicitHeight: 100
            
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                
                Column {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    spacing: 5
                    
                    Text {
                        id: dateText
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: "Minercraftory"
                        font.pixelSize: 30
                        color: "#FFFFFF"
                        text: "読み込み中..."
                    }
                    
                    Text {
                        id: clockText
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: "Minercraftory"
                        font.pixelSize: 34
                        color: "#FFFFFF"
                        text: "読み込み中..."
                    }
                }
            }
            
            Timer {
                id: clockTimer
                interval: 1000
                running: false
                repeat: true
                onTriggered: updateClock()
            }
            
            Component.onCompleted: {
                updateClock()
                clockTimer.running = true
            }
            
            function updateClock() {
                var now = new Date()
                var hours = now.getHours()
                var minutes = now.getMinutes()
                var seconds = now.getSeconds()
                
                // Date in normal numbers
                var year = now.getFullYear()
                var month = now.getMonth() + 1
                var day = now.getDate()
                dateText.text = year + "年" + month + "月" + day + "日"
                
                // Time in kanji
                var japaneseTime = formatJapaneseTime(hours, minutes, seconds)
                clockText.text = japaneseTime
            }
            
            function formatJapaneseTime(hours, minutes, seconds) {
                var kanjiNumbers = {
                    0: "〇", 1: "一", 2: "二", 3: "三", 4: "四",
                    5: "五", 6: "六", 7: "七", 8: "八", 9: "九",
                    10: "十", 11: "十一", 12: "十二", 13: "十三", 14: "十四",
                    15: "十五", 16: "十六", 17: "十七", 18: "十八", 19: "十九",
                    20: "二十", 21: "二十一", 22: "二十二", 23: "二十三",
                    24: "二十四", 25: "二十五", 26: "二十六", 27: "二十七",
                    28: "二十八", 29: "二十九", 30: "三十", 31: "三十一",
                    32: "三十二", 33: "三十三", 34: "三十四", 35: "三十五",
                    36: "三十六", 37: "三十七", 38: "三十八", 39: "三十九",
                    40: "四十", 41: "四十一", 42: "四十二", 43: "四十三",
                    44: "四十四", 45: "四十五", 46: "四十六", 47: "四十七",
                    48: "四十八", 49: "四十九", 50: "五十", 51: "五十一",
                    52: "五十二", 53: "五十三", 54: "五十四", 55: "五十五",
                    56: "五十六", 57: "五十七", 58: "五十八", 59: "五十九"
                }
                
                var hourKanji = kanjiNumbers[hours] || hours.toString()
                var minuteKanji = kanjiNumbers[minutes] || minutes.toString()
                var secondKanji = kanjiNumbers[seconds] || seconds.toString()
                
                return hourKanji + "時" + minuteKanji + "分" + secondKanji + "秒"
            }
        }
    }

    // Daily Kanji Widget
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            required property var modelData
            screen: modelData
            
            anchors {
                left: true
                top: true
            }
            
            margins {
                left: 20
                top: 370  // Below waifu slideshow
            }
            
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "quickshell:daily-kanji"
            color: "transparent"
            
            implicitWidth: 300
            implicitHeight: 250
            
            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.7)
                radius: 16
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.1)
                
                Column {
                    anchors.centerIn: parent
                    spacing: 16
                    
                    Text {
                        text: "今日の漢字"
                        font.family: "Noto Sans CJK JP"
                        font.pixelSize: 18
                        font.weight: Font.Medium
                        color: "#FFFFFF"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Text {
                        id: kanjiText
                        text: "読み込み中..."
                        font.family: "Noto Sans CJK JP"
                        font.pixelSize: 64
                        font.weight: Font.Bold
                        color: "#FFFFFF"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Column {
                        spacing: 8
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Text {
                            id: meaningsText
                            text: ""
                            font.family: "Noto Sans"
                            font.pixelSize: 14
                            color: "#E0E0E0"
                            wrapMode: Text.WordWrap
                            width: 280
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                        
                        Text {
                            id: readingsText
                            text: ""
                            font.family: "Noto Sans CJK JP"
                            font.pixelSize: 12
                            color: "#B0B0B0"
                            wrapMode: Text.WordWrap
                            width: 280
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (currentKanji) {
                            Qt.openUrlExternally("https://jotoba.de/search/" + encodeURIComponent(currentKanji))
                        }
                    }
                }
            }
            
            property string currentKanji: ""
            property var currentKanjiData: null
            property string lastFetchDate: ""
            
            Timer {
                id: kanjiTimer
                interval: 60000
                running: true
                repeat: true
                onTriggered: checkForNewDay()
            }
            
            Component.onCompleted: {
                // Delay the initial fetch to ensure the event loop is running
                initialFetchTimer.start()
            }

            Timer {
                id: initialFetchTimer
                interval: 1 // ms
                repeat: false
                onTriggered: fetchKanji()
            }
            
            function checkForNewDay() {
                var today = new Date().toDateString()
                if (lastFetchDate !== today) {
                    fetchKanji()
                }
            }
            
            function fetchKanji() {
                console.log("Fetching new kanji...")
                lastFetchDate = new Date().toDateString()
                
                var xhr = new XMLHttpRequest()
                
                var grades = [1, 2, 3, 4, 5, 6]
                var randomGrade = grades[Math.floor(Math.random() * grades.length)]
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            try {
                                var response = JSON.parse(xhr.responseText)
                                console.log("API Response:", response)
                                
                                if (response && response.length > 0) {
                                    var randomIndex = Math.floor(Math.random() * response.length)
                                    var kanjiChar = response[randomIndex]
                                    
                                    if (kanjiChar) {
                                        currentKanji = kanjiChar
                                        kanjiText.text = kanjiChar
                                        fetchKanjiDetails(kanjiChar)
                                    }
                                } else {
                                    console.log("Empty response from API")
                                    kanjiText.text = "エラー"
                                    meaningsText.text = "No hay datos disponibles"
                                    readingsText.text = ""
                                }
                            } catch (e) {
                                console.error("Error parsing kanji data:", e)
                                kanjiText.text = "エラー"
                                meaningsText.text = "Error al procesar datos"
                                readingsText.text = ""
                            }
                        } else {
                            console.error("HTTP error:", xhr.status)
                            kanjiText.text = "エラー"
                            meaningsText.text = "Error de red (" + xhr.status + ")"
                            readingsText.text = ""
                        }
                    }
                }
                
                xhr.open("GET", "https://kanjiapi.dev/v1/kanji/grade-" + randomGrade)
                xhr.send()
            }
            
            function fetchKanjiDetails(kanjiChar) {
                console.log("Fetching details for:", kanjiChar)
                var xhr = new XMLHttpRequest()
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            try {
                                var kanji = JSON.parse(xhr.responseText)
                                console.log("Kanji details:", kanji)
                                
                                var meanings = ""
                                if (kanji.meanings && kanji.meanings.length > 0) {
                                    meanings = kanji.meanings.join(", ")
                                } else {
                                    meanings = "Sin significados disponibles"
                                }
                                meaningsText.text = "Meanings: " + meanings
                                
                                var readingParts = []
                                if (kanji.on_readings && kanji.on_readings.length > 0) {
                                    readingParts.push("音読み: " + kanji.on_readings.join(", "))
                                }
                                if (kanji.kun_readings && kanji.kun_readings.length > 0) {
                                    readingParts.push("訓読み: " + kanji.kun_readings.join(", "))
                                }
                                readingsText.text = readingParts.join("\n")
                                
                                console.log("Successfully loaded kanji details for:", kanjiChar)
                            } catch (e) {
                                console.error("Error parsing kanji details:", e)
                                meaningsText.text = "Error al cargar detalles"
                                readingsText.text = ""
                            }
                        } else {
                            console.error("HTTP error fetching details:", xhr.status)
                            meaningsText.text = "Error cargando detalles"
                            readingsText.text = ""
                        }
                    }
                }
                
                xhr.open("GET", "https://kanjiapi.dev/v1/kanji/" + encodeURIComponent(kanjiChar))
                xhr.send()
            }
        }
    }

    // Spotify Controller Widget
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            required property var modelData
            screen: modelData
            
            anchors {
                right: true
                top: true
            }
            
            margins {
                right: 25
                top: 130  // Below clock widget
            }
            
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "quickshell:spotify-controller"
            color: "transparent"
            
            implicitWidth: 280
            implicitHeight: 500
            
            readonly property MprisPlayer activePlayer: MprisController.activePlayer
            property string artDownloadLocation: "/home/kuro/.config/quickshell/ii/.covers"
            property string artFileName: "default.jpg"
            property string artFilePath: `${artDownloadLocation}/${artFileName}`
            property bool downloaded: false
            property int imageVersion: 0
            
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                radius: 16
                
                // Background with blur effect
                Rectangle {
                    id: controllerBackground
                    anchors.fill: parent
                    color: Qt.rgba(0, 0, 0, 0.8)
                    radius: 16
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.1)
                    
                    // Blurred album art background
                    Image {
                        id: backgroundArt
                        anchors.fill: parent
                        source: (downloaded && artFileName !== "default.jpg") ? `file://${artFilePath}` : ""
                        fillMode: Image.PreserveAspectCrop
                        opacity: 0.3
                        smooth: true
                        cache: false
                        
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            source: backgroundArt
                            saturation: 0.2
                            blurEnabled: true
                            blurMax: 100
                            blur: 1
                        }
                    }
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 15
                        
                        // Album art - más grande y cuadrada
                        Rectangle {
                            id: artContainer
                            width: parent.width
                            height: width  // Cuadrada
                            radius: 16
                            color: Qt.rgba(1, 1, 1, 0.1)
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Image {
                                id: albumArt
                                anchors.fill: parent
                                source: (downloaded && artFileName !== "default.jpg") ? `file://${artFilePath}` : ""
                                fillMode: Image.PreserveAspectCrop
                                smooth: true
                                cache: false
                                
                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: Rectangle {
                                        width: albumArt.width
                                        height: albumArt.height
                                        radius: 16
                                    }
                                }
                            }
                            
                            // Fallback icon when no art
                            Text {
                                anchors.centerIn: parent
                                visible: !downloaded || artFileName === "default.jpg"
                                text: "🎵"
                                font.pixelSize: 64
                                color: "#FFFFFF"
                            }
                        }
                        
                        // Track info section
                        Column {
                            width: parent.width
                            spacing: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            // Track title - más prominente
                            Text {
                                id: trackTitle
                                width: parent.width
                                font.family: "Noto Sans"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                                text: activePlayer?.trackTitle || "No track playing"
                                elide: Text.ElideRight
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                horizontalAlignment: Text.AlignHCenter
                            }
                            
                            // Artist
                            Text {
                                id: trackArtist
                                width: parent.width
                                font.family: "Noto Sans"
                                font.pixelSize: 16
                                color: "#B0B0B0"
                                text: activePlayer?.trackArtist || "Unknown artist"
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignHCenter
                            }
                            
                            // Album name
                            Text {
                                id: trackAlbum
                                width: parent.width
                                font.family: "Noto Sans"
                                font.pixelSize: 14
                                color: "#808080"
                                text: activePlayer?.trackAlbum || "Unknown album"
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                        
                        // Progress section
                        Column {
                            width: parent.width
                            spacing: 8
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            // Progress bar - más ancha
                            Rectangle {
                                width: parent.width
                                height: 6
                                color: Qt.rgba(1, 1, 1, 0.2)
                                radius: 3
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                Rectangle {
                                    width: parent.width * (activePlayer?.position / activePlayer?.length || 0)
                                    height: parent.height
                                    color: "#1DB954"
                                    radius: 3
                                    
                                    Behavior on width {
                                        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                                    }
                                }
                            }
                            
                            // Time display
                            Row {
                                width: parent.width
                                anchors.horizontalCenter: parent.horizontalCenter
                                
                                Text {
                                    font.family: "Noto Sans"
                                    font.pixelSize: 12
                                    color: "#808080"
                                    text: formatTime(activePlayer?.position || 0)
                                }
                                
                                Item { width: parent.width - 120 }
                                
                                Text {
                                    font.family: "Noto Sans"
                                    font.pixelSize: 12
                                    color: "#808080"
                                    text: formatTime(activePlayer?.length || 0)
                                }
                            }
                        }
                        
                        // Control buttons - más grandes y espaciados
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 25
                            
                            // Previous button
                            Rectangle {
                                width: 45
                                height: 45
                                radius: 22.5
                                color: Qt.rgba(1, 1, 1, 0.1)
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "⏮"
                                    font.pixelSize: 20
                                    color: "#FFFFFF"
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: activePlayer?.previous()
                                    
                                    onPressed: {
                                        parent.color = Qt.rgba(1, 1, 1, 0.3)
                                        parent.scale = 0.95
                                    }
                                    onReleased: {
                                        parent.color = Qt.rgba(1, 1, 1, 0.1)
                                        parent.scale = 1.0
                                    }
                                }
                                
                                Behavior on scale {
                                    NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                                }
                                Behavior on color {
                                    ColorAnimation { duration: 100 }
                                }
                            }
                            
                            // Play/Pause button - más grande
                            Rectangle {
                                width: 60
                                height: 60
                                radius: 30
                                color: "#1DB954"
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: activePlayer?.isPlaying ? "⏸" : "▶"
                                    font.pixelSize: 24
                                    color: "#000000"
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: activePlayer?.togglePlaying()
                                    
                                    onPressed: {
                                        parent.color = "#1ed760"
                                        parent.scale = 0.95
                                    }
                                    onReleased: {
                                        parent.color = "#1DB954"
                                        parent.scale = 1.0
                                    }
                                }
                                
                                Behavior on scale {
                                    NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                                }
                                Behavior on color {
                                    ColorAnimation { duration: 100 }
                                }
                            }
                            
                            // Next button
                            Rectangle {
                                width: 45
                                height: 45
                                radius: 22.5
                                color: Qt.rgba(1, 1, 1, 0.1)
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "⏭"
                                    font.pixelSize: 20
                                    color: "#FFFFFF"
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: activePlayer?.next()
                                    
                                    onPressed: {
                                        parent.color = Qt.rgba(1, 1, 1, 0.3)
                                        parent.scale = 0.95
                                    }
                                    onReleased: {
                                        parent.color = Qt.rgba(1, 1, 1, 0.1)
                                        parent.scale = 1.0
                                    }
                                }
                                
                                Behavior on scale {
                                    NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                                }
                                Behavior on color {
                                    ColorAnimation { duration: 100 }
                                }
                            }
                        }
                        
                        // Spacer para balance visual
                        Item {
                            height: 10
                        }
                    }
                }
            }
            
            // Timer to update position
            Timer {
                running: activePlayer?.playbackState == MprisPlaybackState.Playing
                interval: 1000
                repeat: true
                onTriggered: activePlayer.positionChanged()
            }
            
            // Art URL change handler
            Connections {
                target: activePlayer
                function onTrackArtUrlChanged() {
                    if (!activePlayer?.trackArtUrl) {
                        artFileName = "default.jpg"
                        downloaded = false
                        return
                    }
                    
                    artFileName = Qt.md5(activePlayer.trackArtUrl) + ".jpg"
                    downloaded = false
                    imageVersion++
                    
                    // Check if file exists
                    fileChecker.running = true
                }
            }
            
            // File existence checker
            Process {
                id: fileChecker
                command: ["test", "-f", artFilePath]
                onExited: (exitCode, exitStatus) => {
                    if (exitCode === 0) {
                        downloaded = true
                        imageVersion++
                    } else {
                        coverArtDownloader.running = true
                    }
                }
            }
            
            // Cover art downloader
            Process {
                id: coverArtDownloader
                command: ["curl", "-sSL", activePlayer?.trackArtUrl || "", "-o", artFilePath]
                onExited: (exitCode, exitStatus) => {
                    if (exitCode === 0) {
                        downloaded = true
                        imageVersion++
                    }
                }
            }
            
            // Time formatting function
            function formatTime(seconds) {
                if (!seconds || isNaN(seconds)) return "0:00"
                const mins = Math.floor(seconds / 60)
                const secs = Math.floor(seconds % 60)
                return mins + ":" + (secs < 10 ? "0" : "") + secs
            }
            
            Component.onCompleted: {
                if (activePlayer?.trackArtUrl) {
                    artFileName = Qt.md5(activePlayer.trackArtUrl) + ".jpg"
                    // Delay the initial check to ensure the event loop is running
                    initialFileCheckTimer.start()
                }
            }

            Timer {
                id: initialFileCheckTimer
                interval: 1 // ms
                repeat: false
                onTriggered: fileChecker.running = true
            }
        }
    }

    // Album Info Display Widget
    property bool showAlbumInfo: false
    
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            required property var modelData
            screen: modelData
            
            anchors {
                left: true
                bottom: true
            }
            
            margins {
                left: 20
                bottom: 100
            }
            
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "quickshell:album-info"
            color: "transparent"
            
            implicitWidth: 350
            implicitHeight: 120
            
            visible: showAlbumInfo
            
            Rectangle {
                anchors.fill: parent
                color: "#FF0000"  // Rojo brillante para testing
                radius: 15
                border.width: 3
                border.color: "#FFFFFF"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 8
                    
                    Text {
                        id: albumTitleText
                        Layout.fillWidth: true
                        font.family: "Minercraftory"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#FFFFFF"
                        text: MprisController.activePlayer?.trackTitle || "Sin título"
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                    }
                    
                    Text {
                        id: albumArtistText
                        Layout.fillWidth: true
                        font.family: "Minercraftory"
                        font.pixelSize: 14
                        color: "#FF6B73"
                        text: MprisController.activePlayer?.trackArtist || "Artista desconocido"
                        elide: Text.ElideRight
                    }
                    
                    Text {
                        id: albumNameText
                        Layout.fillWidth: true
                        font.family: "Minercraftory"
                        font.pixelSize: 12
                        color: "#CCCCCC"
                        text: MprisController.activePlayer?.trackAlbum || "Álbum desconocido"
                        elide: Text.ElideRight
                    }
                }
                
                // Auto-hide timer
                Timer {
                    id: albumInfoTimer
                    interval: 5000  // 5 seconds
                    running: showAlbumInfo
                    onTriggered: showAlbumInfo = false
                }
                
                // Click to hide
                MouseArea {
                    anchors.fill: parent
                    onClicked: showAlbumInfo = false
                }
            }
        }
    }

    // IPC Handler for album info
    IpcHandler {
        target: "albuminfo"
        
        function toggle(): void {
            console.log("Album info toggle called, current state:", showAlbumInfo)
            showAlbumInfo = !showAlbumInfo
            console.log("Album info new state:", showAlbumInfo)
        }
        
        function show(): void {
            showAlbumInfo = true
        }
        
        function hide(): void {
            showAlbumInfo = false
        }
    }

}