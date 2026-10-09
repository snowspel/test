// ~/.config/quickshell/snow/apps/AppsPanel.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "../theme.js" as Theme

PanelWindow {
    id: root
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.55) // Dimmed backdrop
    
    // Dismiss when clicking background
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }
    
    Rectangle {
        width: 740
        height: 640
        anchors.centerIn: parent
        radius: 20
        color: Qt.rgba(Theme.colors.bg.r, Theme.colors.bg.g, Theme.colors.bg.b, 0.94)
        border.width: 1
        border.color: Qt.rgba(255, 255, 255, 0.12)
        
        MouseArea {
            anchors.fill: parent
            preventStealing: true
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16
            
            // Header Bar
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Rectangle {
                    width: 36
                    height: 36
                    radius: 10
                    color: Qt.rgba(Theme.colors.accent.r, Theme.colors.accent.g, Theme.colors.accent.b, 0.2)
                    Text {
                        anchors.centerIn: parent
                        text: "󰕰"
                        font.family: "JetBrains Mono Nerd Font"
                        font.pixelSize: 18
                        color: Theme.colors.accent
                    }
                }
                
                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "System Hub"
                        font.family: "Inter"
                        font.pixelSize: 15
                        font.weight: Font.Bold
                        color: Theme.colors.text
                    }
                }
                
                Item { Layout.fillWidth: true }
                
                Text {
                    text: "SUPER + TAB"
                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                    font.weight: Font.SemiBold
                    color: Theme.colors.accent
                }
                
                Rectangle {
                    width: 26
                    height: 26
                    radius: 8
                    color: Qt.rgba(255, 255, 255, 0.08)
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 12
                        color: Theme.colors.muted
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.visible = false
                    }
                }
            }
            
            // Scrollable Unified Single List
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                
                ColumnLayout {
                    width: parent.width
                    spacing: 16
                    
                    // ==========================================
                    // SECTION 1: System Tray Applets (List)
                    // ==========================================
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "System Tray"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: Theme.colors.accent
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        
                        Repeater {
                            model: [
                                { name: "NetworkManager", icon: "󰤨", info: "Arch-5G · 866 Mbps", proto: "SNI / DBus" },
                                { name: "Bluetooth", icon: "󰂯", info: "Sony WH-1000XM5 Connected", proto: "BlueZ 5.79" },
                                { name: "LocalSend", icon: "󱐋", info: "Share files on LAN", proto: "LocalSend daemon" },
                                { name: "Cloudflare WARP", icon: "󰞀", info: "1.1.1.1 (WARP+) Encrypted", proto: "warp-svc" },
                                { name: "Dunst Notifier", icon: "󰂚", info: "Notification daemon running", proto: "org.freedesktop.Notifications" }
                            ]
                            
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                height: trayExpanded.value ? 76 : 44
                                radius: 10
                                color: Theme.colors.surface
                                border.width: 1
                                border.color: Qt.rgba(255, 255, 255, 0.08)
                                property var trayExpanded: ({ value: false })
                                
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 10
                                        
                                        Text {
                                            text: modelData.icon
                                            font.family: "JetBrains Mono Nerd Font"
                                            font.pixelSize: 15
                                            color: Theme.colors.accent
                                        }
                                        
                                        ColumnLayout {
                                            spacing: 0
                                            Layout.fillWidth: true
                                            Text {
                                                text: modelData.name
                                                font.family: "Inter"
                                                font.pixelSize: 12
                                                font.weight: Font.SemiBold
                                                color: Theme.colors.text
                                            }
                                            Text {
                                                text: modelData.info
                                                font.family: "Inter"
                                                font.pixelSize: 10
                                                color: Theme.colors.muted
                                            }
                                        }
                                        
                                        // Hover X = Quit
                                        Rectangle {
                                            width: 22
                                            height: 22
                                            radius: 6
                                            color: Qt.rgba(239/255, 68/255, 68/255, 0.15)
                                            Text {
                                                anchors.centerIn: parent
                                                text: "✕"
                                                font.pixelSize: 11
                                                color: "#f87171"
                                            }
                                        }
                                    }
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                                    onClicked: (mouse) => {
                                        if (mouse.button === Qt.RightButton) {
                                            console.log("Right click context menu for " + modelData.name)
                                        } else {
                                            trayExpanded.value = !trayExpanded.value
                                        }
                                    }
                                    onDoubleClicked: console.log("Double click open " + modelData.name)
                                }
                            }
                        }
                    }
                    
                    // ==========================================
                    // SECTION 2: Active Windows (List)
                    // ==========================================
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Active Windows"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: "#38bdf8"
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        
                        Repeater {
                            model: [
                                { title: "d@archlinux: ~/snow-dotfiles (fish)", ws: 1, icon: "󰆍", app: "kitty", pid: 14208 },
                                { title: "Zen Browser — Hyprland / Quickshell Documentation", ws: 2, icon: "󰈹", app: "zen-browser", pid: 16844 },
                                { title: "snow/theme.json — Visual Studio Code", ws: 3, icon: "󰨞", app: "code", pid: 18902 },
                                { title: "Pictures / Screenshots — Nautilus", ws: 1, icon: "󰉋", app: "nautilus", pid: 19441 }
                            ]
                            
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                height: 46
                                radius: 10
                                color: Theme.colors.surface
                                border.width: 1
                                border.color: Qt.rgba(255, 255, 255, 0.08)
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 10
                                    
                                    Text {
                                        text: modelData.icon
                                        font.family: "JetBrains Mono Nerd Font"
                                        font.pixelSize: 15
                                        color: "#38bdf8"
                                    }
                                    
                                    Text {
                                        text: modelData.title
                                        font.family: "Inter"
                                        font.pixelSize: 12
                                        font.weight: Font.SemiBold
                                        color: Theme.colors.text
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }
                                    
                                    Text {
                                        text: "WS " + modelData.ws
                                        font.family: "JetBrains Mono"
                                        font.pixelSize: 10
                                        color: Theme.colors.accent
                                    }
                                    
                                    Rectangle {
                                        width: 22
                                        height: 22
                                        radius: 6
                                        color: Qt.rgba(239/255, 68/255, 68/255, 0.15)
                                        Text {
                                            anchors.centerIn: parent
                                            text: "✕"
                                            font.pixelSize: 11
                                            color: "#f87171"
                                        }
                                    }
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    onDoubleClicked: console.log("Focus window pid " + modelData.pid)
                                }
                            }
                        }
                    }
                    
                    // ==========================================
                    // SECTION 3: Background Daemons (List)
                    // ==========================================
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "Background Daemons"
                            font.family: "Inter"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: "#4ade80"
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        
                        Repeater {
                            model: [
                                { name: "hypridle", pid: 3120, cpu: 0.1, mem: 12 },
                                { name: "hyprpaper", pid: 3145, cpu: 0.2, mem: 34 },
                                { name: "pipewire", pid: 2890, cpu: 0.4, mem: 28 },
                                { name: "wireplumber", pid: 2898, cpu: 0.2, mem: 19 },
                                { name: "cliphist", pid: 3310, cpu: 0.05, mem: 8 }
                            ]
                            
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                radius: 10
                                color: Theme.colors.surface
                                border.width: 1
                                border.color: Qt.rgba(255, 255, 255, 0.08)
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 10
                                    
                                    Rectangle {
                                        width: 7
                                        height: 7
                                        radius: 3.5
                                        color: "#4ade80"
                                    }
                                    
                                    Text {
                                        text: modelData.name + ".service"
                                        font.family: "JetBrains Mono"
                                        font.pixelSize: 11
                                        font.weight: Font.SemiBold
                                        color: Theme.colors.text
                                        Layout.fillWidth: true
                                    }
                                    
                                    Text {
                                        text: "PID " + modelData.pid + " · " + modelData.cpu + "% CPU · " + modelData.mem + "MB"
                                        font.family: "JetBrains Mono"
                                        font.pixelSize: 10
                                        color: Theme.colors.muted
                                    }
                                    
                                    Rectangle {
                                        width: 22
                                        height: 22
                                        radius: 6
                                        color: Qt.rgba(239/255, 68/255, 68/255, 0.15)
                                        Text {
                                            anchors.centerIn: parent
                                            text: "✕"
                                            font.pixelSize: 11
                                            color: "#f87171"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Footer Hints
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "SUPER + TAB"
                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                    color: Theme.colors.accent
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: "Double-click: Open/Focus · Single-click: Details · Right-click: Options · ✕ Close"
                    font.family: "Inter"
                    font.pixelSize: 10
                    color: Theme.colors.muted
                }
            }
        }
    }
}
