// ~/.config/quickshell/snow/osd/BrightnessOSD.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../theme.js" as Theme

PanelWindow {
    id: root
    
    WlrLayershell.layer: WlrLayer.Overlay
    
    anchors.bottom: true
    margins.bottom: 64
    
    width: 260
    height: 48
    color: "transparent"
    
    Rectangle {
        anchors.fill: parent
        radius: 24
        color: Qt.rgba(Theme.colors.bg.r, Theme.colors.bg.g, Theme.colors.bg.b, 0.9)
        border.width: 1
        border.color: Qt.rgba(255, 255, 255, 0.12)
        
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12
            
            Text {
                text: "󰃠"
                font.family: "JetBrains Mono Nerd Font"
                font.pixelSize: 18
                color: Theme.colors.warn
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 6
                radius: 3
                color: Theme.colors.surfaceHi
                
                Rectangle {
                    width: parent.width * (brightnessLevel / 100)
                    height: parent.height
                    radius: 3
                    color: Theme.colors.warn
                }
            }
            
            Text {
                text: brightnessLevel + "%"
                font.family: "JetBrains Mono"
                font.pixelSize: 12
                font.weight: Font.SemiBold
                color: Theme.colors.text
            }
        }
    }
}
