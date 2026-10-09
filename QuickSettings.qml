// ~/.config/quickshell/snow/quicksettings/QuickSettings.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Services.Network
import Quickshell.Services.Bluetooth
import "../theme.js" as Theme

PanelWindow {
    id: root
    
    // Hyprland Layer Shell Anchoring: Bottom-Right
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    
    anchors {
        bottom: true
        right: true
    }
    
    margins {
        bottom: 48
        right: 16
    }
    
    width: 380
    height: 560
    color: "transparent"
    
    property bool isLightMode: false
    property bool warpActive: true
    property bool audioMenuOpen: false
    property string activeAudioSink: "Sony WH-1000XM5"
    property real downloadSpeed: 84.2
    property real uploadSpeed: 16.5
    
    Rectangle {
        anchors.fill: parent
        radius: 20
        color: Qt.rgba(Theme.colors.bg.r, Theme.colors.bg.g, Theme.colors.bg.b, 0.94)
        border.width: 1
        border.color: Qt.rgba(255, 255, 255, 0.12)
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14
            
            // Top Status Bar: Hostname & 12h Clock + Date (Desktop setup, battery removed)
            RowLayout {
                Layout.fillWidth: true
                
                RowLayout {
                    spacing: 10
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 16
                        color: Theme.colors.accent
                        Text {
                            anchors.centerIn: parent
                            text: "D"
                            font.family: "Inter"
                            font.weight: Font.Bold
                            color: "#ffffff"
                            font.pixelSize: 13
                        }
                    }
                    Text {
                        text: "d@archlinux"
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.SemiBold
                        color: Theme.colors.text
                    }
                }
                
                Item { Layout.fillWidth: true }
                
                // 12h Time and Date (e.g. 11:04 PM, 01 Jan 2026)
                ColumnLayout {
                    spacing: 0
                    Layout.alignment: Qt.AlignRight
                    Text {
                        text: Qt.formatDateTime(new Date(), "hh:mm AP")
                        font.family: "JetBrains Mono"
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        color: Theme.colors.text
                        Layout.alignment: Qt.AlignRight
                    }
                    Text {
                        text: Qt.formatDateTime(new Date(), "dd MMM yyyy")
                        font.family: "JetBrains Mono"
                        font.pixelSize: 10
                        color: Theme.colors.accent
                        Layout.alignment: Qt.AlignRight
                    }
                }
            }
            
            // Quick Toggles: 2x2 Grid (Row 1: Wi-Fi, BT; Row 2: WARP, Theme)
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 8
                columnSpacing: 8
                
                // Row 1, Col 1: Wi-Fi Toggle
                Rectangle {
                    Layout.fillWidth: true
                    height: 56
                    radius: 14
                    color: wifiActive ? Theme.colors.accent : Theme.colors.surface
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 2
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: wifiActive ? "󰤨" : "󰤭"
                                font.family: "JetBrains Mono Nerd Font"
                                font.pixelSize: 16
                                color: "#ffffff"
                            }
                            Item { Layout.fillWidth: true }
                            Text { text: "›"; color: Qt.rgba(1, 1, 1, 0.5); font.pixelSize: 14 }
                        }
                        Text {
                            text: "Wi-Fi"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.SemiBold
                            color: "#ffffff"
                        }
                        Text {
                            text: wifiActive ? "Arch-5G" : "Off"
                            font.family: "Inter"
                            font.pixelSize: 9
                            color: Qt.rgba(1, 1, 1, 0.7)
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.RightButton) {
                                wifiMenuOpen = !wifiMenuOpen;
                            } else {
                                wifiActive = !wifiActive;
                            }
                        }
                    }
                }
                
                // Row 1, Col 2: Bluetooth Toggle
                Rectangle {
                    Layout.fillWidth: true
                    height: 56
                    radius: 14
                    color: btActive ? Theme.colors.accent : Theme.colors.surface
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 2
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: btActive ? "󰂯" : "󰂲"
                                font.family: "JetBrains Mono Nerd Font"
                                font.pixelSize: 16
                                color: "#ffffff"
                            }
                            Item { Layout.fillWidth: true }
                            Text { text: "›"; color: Qt.rgba(1, 1, 1, 0.5); font.pixelSize: 14 }
                        }
                        Text {
                            text: "Bluetooth"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.SemiBold
                            color: "#ffffff"
                        }
                        Text {
                            text: btActive ? "XM5 Audio" : "Off"
                            font.family: "Inter"
                            font.pixelSize: 9
                            color: Qt.rgba(1, 1, 1, 0.7)
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.RightButton) {
                                btMenuOpen = !btMenuOpen;
                            } else {
                                btActive = !btActive;
                            }
                        }
                    }
                }
                
                // Row 2, Col 1: Cloudflare WARP Toggle
                Rectangle {
                    Layout.fillWidth: true
                    height: 56
                    radius: 14
                    color: warpActive ? Theme.colors.accent : Theme.colors.surface
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 2
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "󰞌" // Shield / VPN icon
                                font.family: "JetBrains Mono Nerd Font"
                                font.pixelSize: 16
                                color: warpActive ? "#4ade80" : Theme.colors.muted
                            }
                            Item { Layout.fillWidth: true }
                            Rectangle { width: 6; height: 6; radius: 3; color: warpActive ? "#4ade80" : "transparent" }
                        }
                        Text {
                            text: "Cloudflare WARP"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.SemiBold
                            color: "#ffffff"
                        }
                        Text {
                            text: warpActive ? "1.1.1.1 (WARP+)" : "Disconnected"
                            font.family: "Inter"
                            font.pixelSize: 9
                            color: Qt.rgba(1, 1, 1, 0.7)
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: warpActive = !warpActive
                    }
                }
                
                // Row 2, Col 2: Light/Dark Theme Switcher
                Rectangle {
                    Layout.fillWidth: true
                    height: 56
                    radius: 14
                    color: isLightMode ? Theme.colors.accent : Theme.colors.surface
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 2
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: isLightMode ? "󰖨" : "󰃚"
                                font.family: "JetBrains Mono Nerd Font"
                                font.pixelSize: 16
                                color: isLightMode ? "#fbbf24" : Theme.colors.accent
                            }
                            Item { Layout.fillWidth: true }
                            Rectangle { width: 6; height: 6; radius: 3; color: "#4ade80" }
                        }
                        Text {
                            text: isLightMode ? "Light Theme" : "Dark Theme"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.SemiBold
                            color: "#ffffff"
                        }
                        Text {
                            text: isLightMode ? "Snow Light" : "Mocha Dark"
                            font.family: "Inter"
                            font.pixelSize: 9
                            color: Qt.rgba(1, 1, 1, 0.6)
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: isLightMode = !isLightMode
                    }
                }
            }
            
            // Volume Slider Bar with Audio Device Dropdown (PipeWire)
            Rectangle {
                Layout.fillWidth: true
                height: 52
                radius: 14
                color: Theme.colors.surface
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4
                    
                    RowLayout {
                        Layout.fillWidth: true
                        
                        RowLayout {
                            spacing: 8
                            Text {
                                text: volumeLevel === 0 ? "󰝟" : (volumeLevel < 50 ? "󰕿" : "󰕾")
                                font.family: "JetBrains Mono Nerd Font"
                                font.pixelSize: 16
                                color: Theme.colors.accent
                            }
                            Text {
                                text: "Volume (" + volumeLevel + "%)"
                                font.family: "Inter"
                                font.pixelSize: 11
                                font.weight: Font.Medium
                                color: Theme.colors.text
                            }
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        // Audio Device Dropdown Pill
                        Rectangle {
                            height: 22
                            radius: 6
                            color: Qt.rgba(0, 0, 0, 0.3)
                            border.width: 1
                            border.color: Qt.rgba(255, 255, 255, 0.1)
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 4
                                spacing: 4
                                Text { text: "󰋋"; font.pixelSize: 11; color: Theme.colors.accent }
                                Text { text: activeAudioSink; font.pixelSize: 10; color: Theme.colors.text }
                                Text { text: "▾"; font.pixelSize: 10; color: Theme.colors.muted }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: audioMenuOpen = !audioMenuOpen
                            }
                        }
                    }
                    
                    Slider {
                        id: volSlider
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        value: volumeLevel
                        onMoved: volumeLevel = Math.round(value)
                    }
                }
                
                WheelHandler {
                    onWheel: (event) => {
                        volumeLevel = Math.max(0, Math.min(100, volumeLevel + (event.angleDelta.y > 0 ? 5 : -5)));
                    }
                }
            }
            
            // Brightness Slider Bar with Mouse Wheel support
            Rectangle {
                Layout.fillWidth: true
                height: 48
                radius: 14
                color: Theme.colors.surface
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12
                    
                    Text {
                        text: "󰃠"
                        font.family: "JetBrains Mono Nerd Font"
                        font.pixelSize: 18
                        color: Theme.colors.warn
                    }
                    
                    Slider {
                        id: brightSlider
                        Layout.fillWidth: true
                        from: 5
                        to: 100
                        value: brightnessLevel
                        onMoved: brightnessLevel = Math.round(value)
                    }
                    
                    Text {
                        text: brightnessLevel + "%"
                        font.family: "JetBrains Mono"
                        font.pixelSize: 12
                        color: Theme.colors.text
                    }
                }
                
                WheelHandler {
                    onWheel: (event) => {
                        brightnessLevel = Math.max(5, Math.min(100, brightnessLevel + (event.angleDelta.y > 0 ? 5 : -5)));
                    }
                }
            }
            
            // Ethernet LAN Connection Status & Realtime Speed Monitor
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 14
                color: Theme.colors.surfaceHi
                border.width: 1
                border.color: Qt.rgba(255, 255, 255, 0.08)
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8
                    
                    // Ethernet Header
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        
                        Rectangle {
                            width: 26
                            height: 26
                            radius: 8
                            color: Qt.rgba(74/255, 222/255, 128/255, 0.15)
                            Text {
                                anchors.centerIn: parent
                                text: "󰌗"
                                font.family: "JetBrains Mono Nerd Font"
                                font.pixelSize: 15
                                color: "#4ade80"
                            }
                        }
                        
                        ColumnLayout {
                            spacing: 0
                            Text {
                                text: "Ethernet (enp3s0)"
                                font.family: "Inter"
                                font.pixelSize: 12
                                font.weight: Font.SemiBold
                                color: Theme.colors.text
                            }
                            Text {
                                text: "1000 Mbps · Full Duplex"
                                font.family: "JetBrains Mono"
                                font.pixelSize: 10
                                color: Theme.colors.muted
                            }
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        Rectangle {
                            height: 20
                            radius: 6
                            color: Qt.rgba(74/255, 222/255, 128/255, 0.12)
                            border.width: 1
                            border.color: Qt.rgba(74/255, 222/255, 128/255, 0.25)
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                spacing: 4
                                Rectangle { width: 6; height: 6; radius: 3; color: "#4ade80" }
                                Text {
                                    text: "Connected"
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 9
                                    font.weight: Font.DemiBold
                                    color: "#4ade80"
                                }
                            }
                        }
                    }
                    
                    // Live Download and Upload Speed Meters
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 42
                            radius: 10
                            color: Qt.rgba(0, 0, 0, 0.3)
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 6
                                Text { text: "󰁝"; font.pixelSize: 14; color: "#4ade80" }
                                ColumnLayout {
                                    spacing: 0
                                    Text { text: "DOWNLOAD"; font.pixelSize: 8; color: Theme.colors.muted; font.family: "JetBrains Mono" }
                                    Text { text: downloadSpeed + " MB/s"; font.pixelSize: 11; font.weight: Font.Bold; color: Theme.colors.text; font.family: "JetBrains Mono" }
                                }
                            }
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            height: 42
                            radius: 10
                            color: Qt.rgba(0, 0, 0, 0.3)
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 6
                                Text { text: "󰁪"; font.pixelSize: 14; color: "#38bdf8" }
                                ColumnLayout {
                                    spacing: 0
                                    Text { text: "UPLOAD"; font.pixelSize: 8; color: Theme.colors.muted; font.family: "JetBrains Mono" }
                                    Text { text: uploadSpeed + " MB/s"; font.pixelSize: 11; font.weight: Font.Bold; color: Theme.colors.text; font.family: "JetBrains Mono" }
                                }
                            }
                        }
                    }
                }
            }
            
            // Footer Info
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "SUPER + A"
                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                    color: Theme.colors.accent
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: "Right-click icon for list · Wheel for volume"
                    font.family: "Inter"
                    font.pixelSize: 10
                    color: Theme.colors.muted
                }
            }
        }
    }
}
