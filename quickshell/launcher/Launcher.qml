// ~/.config/quickshell/snow/launcher/Launcher.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "../theme.js" as Theme

PanelWindow {
    id: root
    property string viewMode: "list" // "list" | "grid"
    
    // Exact hyprland layer shell configuration
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    
    color: Qt.rgba(0, 0, 0, 0.45) // Modern dimmed acrylic backdrop
    
    // Dismiss on outside click
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }
    
    // Centered Floating Modern Pop-Up Container
    Rectangle {
        id: container
        width: 640
        height: 520
        anchors.centerIn: parent
        radius: 20
        color: Qt.rgba(Theme.colors.bg.r, Theme.colors.bg.g, Theme.colors.bg.b, 0.88)
        border.width: 1
        border.color: Qt.rgba(255, 255, 255, 0.12)
        
        // Prevent dismissal when clicking inside
        MouseArea {
            anchors.fill: parent
            preventStealing: true
        }
        
        // Modern Drop Shadow & Glow
        layer.enabled: true
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16
            
            // Search Bar Header
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 52
                radius: 14
                color: Theme.colors.surface
                border.width: searchInput.activeFocus ? 1.5 : 1
                border.color: searchInput.activeFocus ? Theme.colors.accent : Qt.rgba(255, 255, 255, 0.08)
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 12
                    
                    Text {
                        text: "󰍉" // Search icon
                        font.family: "JetBrains Mono Nerd Font"
                        font.pixelSize: 18
                        color: searchInput.activeFocus ? Theme.colors.accent : Theme.colors.muted
                    }
                    
                    TextInput {
                        id: searchInput
                        Layout.fillWidth: true
                        font.family: "Inter"
                        font.pixelSize: 15
                        color: Theme.colors.text
                        verticalAlignment: TextInput.AlignVCenter
                        clip: true
                        focus: true
                        
                        Text {
                            text: "Search..."
                            font.family: "Inter"
                            font.pixelSize: 15
                            color: Theme.colors.muted
                            visible: !searchInput.text && !searchInput.activeFocus
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    
                    Rectangle {
                        visible: searchInput.text.length > 0
                        width: 22
                        height: 22
                        radius: 11
                        color: Theme.colors.surfaceHi
                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            font.pixelSize: 11
                            color: Theme.colors.muted
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: searchInput.text = ""
                        }
                    }
                    
                    // List / Grid View Mode Switcher
                    Rectangle {
                        width: 62
                        height: 28
                        radius: 8
                        color: Theme.colors.surfaceHi
                        border.width: 1
                        border.color: Qt.rgba(255, 255, 255, 0.08)
                        
                        RowLayout {
                            anchors.fill: parent
                            spacing: 2
                            
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 6
                                color: root.viewMode === "list" ? Qt.rgba(Theme.colors.accent.r, Theme.colors.accent.g, Theme.colors.accent.b, 0.3) : "transparent"
                                Text {
                                    anchors.centerIn: parent
                                    text: "󰕘"
                                    font.family: "JetBrains Mono Nerd Font"
                                    font.pixelSize: 13
                                    color: root.viewMode === "list" ? Theme.colors.accent : Theme.colors.muted
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.viewMode = "list"
                                }
                            }
                            
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 6
                                color: root.viewMode === "grid" ? Qt.rgba(Theme.colors.accent.r, Theme.colors.accent.g, Theme.colors.accent.b, 0.3) : "transparent"
                                Text {
                                    anchors.centerIn: parent
                                    text: "󰕚"
                                    font.family: "JetBrains Mono Nerd Font"
                                    font.pixelSize: 13
                                    color: root.viewMode === "grid" ? Theme.colors.accent : Theme.colors.muted
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.viewMode = "grid"
                                }
                            }
                        }
                    }
                }
            }
            
            // App Results ListView (Clean, Minimal, Fast)
            ListView {
                id: appList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                
                // Keyboard navigation
                Keys.onReturnPressed: launchCurrentApp()
                Keys.onEscapePressed: root.visible = false
                
                delegate: Rectangle {
                    width: appList.width
                    height: 48
                    radius: 12
                    color: ListView.isCurrentItem ? Theme.colors.surfaceHi : "transparent"
                    border.width: ListView.isCurrentItem ? 1 : 0
                    border.color: Qt.rgba(Theme.colors.accent.r, Theme.colors.accent.g, Theme.colors.accent.b, 0.4)
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 12
                        
                        // Icon Container
                        Rectangle {
                            width: 32
                            height: 32
                            radius: 8
                            color: Theme.colors.surface
                            
                            Image {
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                source: model.iconSource
                            }
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            
                            Text {
                                text: model.name
                                font.family: "Inter"
                                font.pixelSize: 14
                                font.weight: Font.SemiBold
                                color: Theme.colors.text
                            }
                            
                            Rectangle {
                                visible: model.running
                                width: 6
                                height: 6
                                radius: 3
                                color: Theme.colors.success
                            }
                        }
                        
                        Text {
                            text: model.exec
                            font.family: "JetBrains Mono"
                            font.pixelSize: 11
                            color: Theme.colors.muted
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: appList.currentIndex = index
                        onClicked: launchCurrentApp()
                    }
                }
            }
            
            // Modern Footer with Keybind Hints
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 28
                
                Text {
                    text: "SUPER + SPACE"
                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                    color: Theme.colors.accent
                }
                
                Item { Layout.fillWidth: true }
                
                Text {
                    text: "󰌑 Enter to launch   ↑↓ Navigate   Esc Close"
                    font.family: "Inter"
                    font.pixelSize: 11
                    color: Theme.colors.muted
                }
            }
        }
    }
}
