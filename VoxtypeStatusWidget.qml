import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property string currentState: "stopped"
    property string currentIcon: ""
    property string tooltip: "Voxtype"

    // Icon theme from settings, default to emoji
    property string iconTheme: pluginData.iconTheme || "emoji"

    // Whether to hide when idle
    property bool hideWhenIdle: pluginData.hideWhenIdle ?? false

    // Icon maps per theme
    readonly property var iconThemes: ({
        "emoji": { idle: "\uD83C\uDFA4", recording: "\uD83D\uDD34", transcribing: "\u23F3", stopped: "" },
        "nerd-font": { idle: "\uDB80\uDD89", recording: "\uDB82\uDD51", transcribing: "\uDB84\uDD59", stopped: "\uDB84\uDD5A" },
        "minimal": { idle: "\u25CB", recording: "\u25CF", transcribing: "\u25D0", stopped: "\u00D7" },
        "dots": { idle: "\u25EF", recording: "\u2B24", transcribing: "\u25D4", stopped: "\u25CC" },
        "text": { idle: "[MIC]", recording: "[REC]", transcribing: "[...]", stopped: "[OFF]" }
    })

    function getIcon(state) {
        var theme = iconThemes[iconTheme] || iconThemes["emoji"];
        return theme[state] || theme["idle"];
    }

    function parseStatus(line) {
        try {
            var data = JSON.parse(line);
            currentState = data.alt || "idle";
            currentIcon = data.text || getIcon(currentState);
            tooltip = data.tooltip || ("Voxtype: " + currentState);
        } catch (e) {
            // Not valid JSON, ignore partial lines
        }
    }

    // Long-running process: voxtype status --follow --format json
    Process {
        id: statusProcess

        command: ["voxtype", "status", "--follow", "--format", "json", "--icon-theme", root.iconTheme]
        running: true

        stdout: SplitParser {
            onRead: data => root.parseStatus(data)
        }

        onRunningChanged: {
            if (!running) {
                // Process died, restart after delay
                restartTimer.start();
                root.currentState = "stopped";
                root.currentIcon = root.getIcon("stopped");
                root.tooltip = "Voxtype: not running";
            }
        }
    }

    Timer {
        id: restartTimer
        interval: 5000
        onTriggered: {
            statusProcess.running = true;
        }
    }

    // Restart process when icon theme changes
    onIconThemeChanged: {
        if (statusProcess.running) {
            statusProcess.running = false;
        }
        statusProcess.command = ["voxtype", "status", "--follow", "--format", "json", "--icon-theme", iconTheme];
        statusProcess.running = true;
    }

    property bool shouldShow: !hideWhenIdle || currentState !== "idle"

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingS
            visible: root.shouldShow

            StyledText {
                text: root.currentIcon
                font.pixelSize: Theme.fontSizeMedium
                color: root.currentState === "recording" ? Theme.error
                     : root.currentState === "transcribing" ? Theme.tertiary
                     : Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS
            visible: root.shouldShow

            StyledText {
                text: root.currentIcon
                font.pixelSize: Theme.fontSizeMedium
                color: root.currentState === "recording" ? Theme.error
                     : root.currentState === "transcribing" ? Theme.tertiary
                     : Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            headerText: "Voxtype"
            detailsText: root.tooltip

            Column {
                width: parent.width
                spacing: Theme.spacingM

                StyledText {
                    text: root.currentIcon
                    font.pixelSize: 48
                    color: root.currentState === "recording" ? Theme.error
                         : root.currentState === "transcribing" ? Theme.tertiary
                         : Theme.surfaceText
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                StyledText {
                    text: {
                        switch (root.currentState) {
                            case "idle": return "Ready - hold hotkey to record";
                            case "recording": return "Recording...";
                            case "transcribing": return "Transcribing...";
                            default: return "Not running";
                        }
                    }
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.surfaceText
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    popoutWidth: 280
    popoutHeight: 200
}
