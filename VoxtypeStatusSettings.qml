import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    pluginId: "voxtypeStatus"

    SelectionSetting {
        settingKey: "iconTheme"
        label: "Icon Theme"
        description: "Icon style for status display"
        options: [
            { label: "Emoji", value: "emoji" },
            { label: "Nerd Font", value: "nerd-font" },
            { label: "Minimal", value: "minimal" },
            { label: "Dots", value: "dots" },
            { label: "Text", value: "text" }
        ]
        defaultValue: "emoji"
    }

    ToggleSetting {
        settingKey: "hideWhenIdle"
        label: "Hide When Idle"
        description: "Only show the icon when recording or transcribing"
        defaultValue: false
    }
}
