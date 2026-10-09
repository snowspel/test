// ~/.config/quickshell/snow/shell.qml
import QtQuick
import Quickshell
import Quickshell.Wayland
import "theme.js" as Theme
import "launcher" as LauncherModule
import "quicksettings" as QuickSettingsModule
import "apps" as AppsModule
import "power" as PowerModule
import "osd" as OSDModule
import "polkit" as PolkitModule
import "notifications" as NotificationModule

ShellRoot {
    id: root

    // Component singletons
    LauncherModule.Launcher { id: launcherPopup; visible: false }
    QuickSettingsModule.QuickSettings { id: quickSettingsPopup; visible: false }
    AppsModule.AppsPanel { id: appsPopup; visible: false }
    PowerModule.PowerMenu { id: powerPopup; visible: false }

    OSDModule.VolumeOSD { id: volumeOsd }
    OSDModule.BrightnessOSD { id: brightnessOsd }
    OSDModule.ClockOSD { id: clockOsd; visible: false }

    PolkitModule.PolkitDialog { id: polkitDialog; visible: false }
    NotificationModule.NotificationPopup { id: notificationPopup }

    // External CLI dispatcher for Hyprland keybindings:
    // quickshell -p ~/.config/quickshell/snow -d <target>
    Connections {
        target: Quickshell
        function onCommand(command) {
            if (command === "launcher") {
                launcherPopup.visible = !launcherPopup.visible;
            } else if (command === "quicksettings") {
                quickSettingsPopup.visible = !quickSettingsPopup.visible;
            } else if (command === "apps") {
                appsPopup.visible = !appsPopup.visible;
            } else if (command === "power") {
                powerPopup.visible = !powerPopup.visible;
            } else if (command === "clock") {
                clockOsd.visible = !clockOsd.visible;
            } else if (command === "volume") {
                volumeOsd.showTemporary();
            } else if (command === "brightness") {
                brightnessOsd.showTemporary();
            }
        }
    }
}
