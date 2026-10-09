// ~/.config/quickshell/snow/power/PowerMenu.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../theme.js" as Theme

PanelWindow {
    id: root
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.6)
    
    property int selectedIndex: 0

    Process {
        id: powerProc
    }

    function executePowerAction(idx) {
        var actions = [
            ["hyprctl", "dispatch", "exit"],
            ["systemctl", "reboot"],
            ["systemctl", "poweroff"]
        ];
        if (idx >= 0 && idx < actions.length) {
            powerProc.command = actions[idx];
            powerProc.running = true;
        }
        root.visible = false;
    }
    
    // Handle keyboard navigation: left/right arrow + Enter as per restore guide
    Item {
        focus: true
        Keys.onLeftPressed: {
            selectedIndex = (selectedIndex - 1 + 3) % 3
        }
        Keys.onRightPressed: {
            selectedIndex = (selectedIndex + 1) % 3
        }
        Keys.onReturnPressed: {
            executePowerAction(selectedIndex)
        }
        Keys.onEscapePressed: {
            root.visible = false
        }
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }
    
    Rectangle {
        width: 320
        height: 120
        anchors.centerIn: parent
        radius: 20
        color: Qt.rgba(Theme.colors.bg.r, Theme.colors.bg.g, Theme.colors.bg.b, 0.94)
        border.width: 1
        border.color: Qt.rgba(255, 255, 255, 0.14)
        
        MouseArea {
            anchors.fill: parent
            preventStealing: true
        }
        
        // Compact 3 Power Options Row: Logout, Reboot, Shutdown
        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10
            
            Repeater {
                model: [
                    { name: "Log Out", icon: "󰍃", action: "hyprctl dispatch exit" },
                    { name: "Restart", icon: "󰜉", action: "systemctl reboot" },
                    { name: "Shut Down", icon: "󰐥", action: "systemctl poweroff" }
                ]
                
                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 14
                    color: selectedIndex === index ? Theme.colors.accent : Theme.colors.surface
                    border.width: selectedIndex === index ? 1.5 : 1
                    border.color: selectedIndex === index ? "#ffffff" : Qt.rgba(255, 255, 255, 0.08)
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: modelData.icon
                            font.family: "JetBrains Mono Nerd Font"
                            font.pixelSize: 26
                            color: selectedIndex === index ? "#ffffff" : (index === 2 ? Theme.colors.danger : Theme.colors.text)
                        }
                        
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: modelData.name
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.SemiBold
                            color: selectedIndex === index ? "#ffffff" : Theme.colors.text
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: selectedIndex = index
                        onClicked: executePowerAction(index)
                    }
                }
            }
        }
    }
}
