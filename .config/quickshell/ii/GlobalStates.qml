import qs.modules.common
import qs
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root
    property bool barOpen: true
    property bool sidebarLeftOpen: false
    property bool sidebarRightOpen: false
    property bool overviewOpen: false
    property bool appLauncherOpen: false
    property bool workspaceShowNumbers: false
    property bool superReleaseMightTrigger: true
    
    // Pinned apps storage with persistence
    property var pinnedApps: Persistent.pinnedApps || []
    
    // Watch for changes and save to persistent storage
    onPinnedAppsChanged: {
        Persistent.pinnedApps = pinnedApps
    }
    
    // Functions to manage pinned apps
    function pinApp(appEntry) {
        // Check if already pinned
        for (let i = 0; i < pinnedApps.length; i++) {
            if (pinnedApps[i].name === appEntry.name) {
                return false; // Already pinned
            }
        }
        
        // Add to pinned apps
        let newPinned = pinnedApps.slice(); // Copy array
        newPinned.push(appEntry);
        pinnedApps = newPinned;
        console.log("Pinned app:", appEntry.name);
        return true;
    }
    
    function unpinApp(appEntry) {
        let newPinned = [];
        let found = false;
        
        for (let i = 0; i < pinnedApps.length; i++) {
            if (pinnedApps[i].name === appEntry.name) {
                found = true;
                continue; // Skip this one (remove it)
            }
            newPinned.push(pinnedApps[i]);
        }
        
        if (found) {
            pinnedApps = newPinned;
            console.log("Unpinned app:", appEntry.name);
            return true;
        }
        return false;
    }
    
    function isAppPinned(appEntry) {
        for (let i = 0; i < pinnedApps.length; i++) {
            if (pinnedApps[i].name === appEntry.name) {
                return true;
            }
        }
        return false;
    }

    property real screenZoom: 1
    onScreenZoomChanged: {
        Quickshell.execDetached(["hyprctl", "keyword", "cursor:zoom_factor", root.screenZoom.toString()]);
    }
    Behavior on screenZoom {
        animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
    }

    // When user is not reluctant while pressing super, they probably don't need to see workspace numbers
    onSuperReleaseMightTriggerChanged: { 
        workspaceShowNumbersTimer.stop()
    }

    Timer {
        id: workspaceShowNumbersTimer
        interval: Config.options.bar.workspaces.showNumberDelay
        // interval: 0
        repeat: false
        onTriggered: {
            workspaceShowNumbers = true
        }
    }

    GlobalShortcut {
        name: "workspaceNumber"
        description: "Hold to show workspace numbers, release to show icons"

        onPressed: {
            workspaceShowNumbersTimer.start()
        }
        onReleased: {
            workspaceShowNumbersTimer.stop()
            workspaceShowNumbers = false
        }
    }

    IpcHandler {
		target: "zoom"

		function zoomIn() {
            screenZoom = Math.min(screenZoom + 0.4, 3.0)
        }

        function zoomOut() {
            screenZoom = Math.max(screenZoom - 0.4, 1)
        } 
	}
}