import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Column {
    id: root
    width: parent.width
    spacing: 12

    property MprisPlayer currentPlayer: Mpris.players.values.find(player => 
        player && player.playbackState !== Mpris.Stopped && 
        !player.dbusName?.startsWith('org.mpris.MediaPlayer2.playerctld')
    ) || Mpris.players.values[0]

    // Header
    RowLayout {
        width: parent.width
        spacing: 8

        MaterialSymbol {
            text: "music_note"
            iconSize: 20
            color: Appearance.colors.colOnLayer0
        }

        StyledText {
            text: Translation.tr("Music Control")
            font.pixelSize: Appearance.font.pixelSize.large
            font.weight: Font.Medium
            color: Appearance.colors.colOnLayer0
            Layout.fillWidth: true
        }
    }

    // Current track info
    Rectangle {
        width: parent.width
        height: trackInfoColumn.implicitHeight + 20
        radius: Appearance.rounding.normal
        color: Appearance.colors.colLayer1
        visible: root.currentPlayer && root.currentPlayer.trackTitle

        ColumnLayout {
            id: trackInfoColumn
            anchors.fill: parent
            anchors.margins: 15
            spacing: 8

            // Track title
            StyledText {
                text: root.currentPlayer?.trackTitle || "No track playing"
                font.pixelSize: Appearance.font.pixelSize.normal
                font.weight: Font.Medium
                color: Appearance.colors.colOnLayer1
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Artist
            StyledText {
                text: root.currentPlayer?.trackArtists?.join(", ") || "Unknown artist"
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colOnLayer1
                opacity: 0.7
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Album
            StyledText {
                text: root.currentPlayer?.trackAlbum || ""
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colOnLayer1
                opacity: 0.5
                elide: Text.ElideRight
                Layout.fillWidth: true
                visible: text !== ""
            }

            // Progress bar
            Rectangle {
                Layout.fillWidth: true
                height: 6
                radius: 3
                color: Appearance.colors.colLayer0
                
                Rectangle {
                    width: root.currentPlayer ? (parent.width * root.currentPlayer.position / Math.max(root.currentPlayer.length, 1)) : 0
                    height: parent.height
                    radius: parent.radius
                    color: Appearance.colors.colPrimary
                    
                    Behavior on width {
                        NumberAnimation { duration: 1000 }
                    }
                }
            }

            // Time info
            RowLayout {
                Layout.fillWidth: true

                StyledText {
                    text: root.currentPlayer ? formatTime(root.currentPlayer.position) : "0:00"
                    font.pixelSize: Appearance.font.pixelSize.tiny
                    color: Appearance.colors.colOnLayer1
                    opacity: 0.6
                }

                Item { Layout.fillWidth: true }

                StyledText {
                    text: root.currentPlayer ? formatTime(root.currentPlayer.length) : "0:00"
                    font.pixelSize: Appearance.font.pixelSize.tiny
                    color: Appearance.colors.colOnLayer1
                    opacity: 0.6
                }
            }
        }
    }

    // Control buttons
    Rectangle {
        width: parent.width
        height: 80
        radius: Appearance.rounding.normal
        color: Appearance.colors.colLayer1

        RowLayout {
            anchors.centerIn: parent
            spacing: 15

            // Previous button
            RippleButton {
                implicitWidth: 45
                implicitHeight: 45
                colBackground: "transparent"
                colBackgroundHover: Appearance.colors.colLayer0
                enabled: root.currentPlayer?.canGoPrevious ?? false
                opacity: enabled ? 1.0 : 0.4

                onClicked: root.currentPlayer?.previous()

                contentItem: MaterialSymbol {
                    text: "skip_previous"
                    iconSize: 24
                    color: Appearance.colors.colOnLayer1
                }
            }

            // Play/Pause button
            RippleButton {
                implicitWidth: 55
                implicitHeight: 55
                colBackground: Appearance.colors.colPrimary
                colBackgroundHover: Appearance.colors.colPrimaryContainer
                enabled: (root.currentPlayer?.canPause ?? false) || (root.currentPlayer?.canPlay ?? false)

                onClicked: root.currentPlayer?.playPause()

                contentItem: MaterialSymbol {
                    text: {
                        if (!root.currentPlayer) return "play_arrow"
                        return root.currentPlayer.playbackState === Mpris.Playing ? "pause" : "play_arrow"
                    }
                    iconSize: 28
                    color: Appearance.colors.colOnPrimary
                }
            }

            // Next button
            RippleButton {
                implicitWidth: 45
                implicitHeight: 45
                colBackground: "transparent"
                colBackgroundHover: Appearance.colors.colLayer0
                enabled: root.currentPlayer?.canGoNext ?? false
                opacity: enabled ? 1.0 : 0.4

                onClicked: root.currentPlayer?.next()

                contentItem: MaterialSymbol {
                    text: "skip_next"
                    iconSize: 24
                    color: Appearance.colors.colOnLayer1
                }
            }
        }
    }

    // Additional controls
    RowLayout {
        width: parent.width
        spacing: 8

        // Shuffle button
        RippleButton {
            Layout.fillWidth: true
            implicitHeight: 40
            colBackground: root.currentPlayer?.shuffle ? Appearance.colors.colPrimary : Appearance.colors.colLayer1
            colBackgroundHover: root.currentPlayer?.shuffle ? Appearance.colors.colPrimaryContainer : Appearance.colors.colLayer2
            enabled: root.currentPlayer?.canControl ?? false

            onClicked: {
                if (root.currentPlayer?.shuffle !== undefined) {
                    root.currentPlayer.shuffle = !root.currentPlayer.shuffle
                }
            }

            contentItem: RowLayout {
                spacing: 6

                MaterialSymbol {
                    text: "shuffle"
                    iconSize: 16
                    color: root.currentPlayer?.shuffle ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
                }

                StyledText {
                    text: "Shuffle"
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: root.currentPlayer?.shuffle ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
                }
            }
        }

        // Repeat button
        RippleButton {
            Layout.fillWidth: true
            implicitHeight: 40
            colBackground: (root.currentPlayer?.loopStatus !== Mpris.LoopNone) ? Appearance.colors.colPrimary : Appearance.colors.colLayer1
            colBackgroundHover: (root.currentPlayer?.loopStatus !== Mpris.LoopNone) ? Appearance.colors.colPrimaryContainer : Appearance.colors.colLayer2
            enabled: root.currentPlayer?.canControl ?? false

            onClicked: {
                if (root.currentPlayer?.loopStatus !== undefined) {
                    switch (root.currentPlayer.loopStatus) {
                        case Mpris.LoopNone:
                            root.currentPlayer.loopStatus = Mpris.LoopPlaylist
                            break
                        case Mpris.LoopPlaylist:
                            root.currentPlayer.loopStatus = Mpris.LoopTrack
                            break
                        case Mpris.LoopTrack:
                            root.currentPlayer.loopStatus = Mpris.LoopNone
                            break
                    }
                }
            }

            contentItem: RowLayout {
                spacing: 6

                MaterialSymbol {
                    text: root.currentPlayer?.loopStatus === Mpris.LoopTrack ? "repeat_one" : "repeat"
                    iconSize: 16
                    color: (root.currentPlayer?.loopStatus !== Mpris.LoopNone) ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
                }

                StyledText {
                    text: "Repeat"
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: (root.currentPlayer?.loopStatus !== Mpris.LoopNone) ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
                }
            }
        }
    }

    // App launch button
    RippleButton {
        width: parent.width
        implicitHeight: 40
        colBackground: Appearance.colors.colLayer1
        colBackgroundHover: Appearance.colors.colLayer2

        onClicked: {
            Quickshell.execDetached(["spotify"])
        }

        contentItem: RowLayout {
            anchors.centerIn: parent
            spacing: 8

            MaterialSymbol {
                text: "open_in_new"
                iconSize: 18
                color: Appearance.colors.colOnLayer1
            }

            StyledText {
                text: "Open Spotify"
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer1
            }
        }
    }

    // No player message
    Rectangle {
        width: parent.width
        height: 100
        radius: Appearance.rounding.normal
        color: Appearance.colors.colLayer1
        visible: !root.currentPlayer || !root.currentPlayer.trackTitle

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            MaterialSymbol {
                text: "music_off"
                iconSize: 32
                color: Appearance.colors.colOnLayer1
                opacity: 0.5
                Layout.alignment: Qt.AlignHCenter
            }

            StyledText {
                text: Translation.tr("No music playing")
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.colors.colOnLayer1
                opacity: 0.7
                Layout.alignment: Qt.AlignHCenter
            }

            StyledText {
                text: Translation.tr("Start Spotify to control playback")
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colOnLayer1
                opacity: 0.5
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    function formatTime(microseconds) {
        var totalSeconds = Math.floor(microseconds / 1000000)
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = totalSeconds % 60
        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds
    }
}