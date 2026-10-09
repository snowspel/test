// ~/.config/quickshell/snow/clock/ClockOSD.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../theme.js" as Theme

PanelWindow {
    id: root
    
    WlrLayershell.layer: WlrLayer.Overlay
    
    anchors.bottom: true
    anchors.right: true
    margins.bottom: 48
    margins.right: 16
    
    width: 130
    height: 60
    color: "transparent"
    
    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Qt.rgba(Theme.colors.bg.r, Theme.colors.bg.g, Theme.colors.bg.b, 0.94)
        border.width: 1
        border.color: Qt.rgba(255, 255, 255, 0.12)
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 2
            
            // Time row with hour & minute (no seconds) and small AP font
            RowLayout {
                spacing: 4
                Text {
                    text: Qt.formatDateTime(new Date(), "h:mm")
                    font.family: "JetBrains Mono"
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: Theme.colors.text
                }
                Text {
                    text: Qt.formatDateTime(new Date(), "AP")
                    font.family: "JetBrains Mono"
                    font.pixelSize: 9
                    font.weight: Font.DemiBold
                    color: Qt.rgba(255, 255, 255, 0.6)
                }
                Item { Layout.fillWidth: true }
            }
            
            // Compact Date: Friday - 09th Oct
            Text {
                text: Qt.formatDateTime(new Date(), "dddd - dd'th' MMM")
                font.family: "Inter"
                font.pixelSize: 9
                font.weight: Font.Medium
                color: Qt.rgba(255, 255, 255, 0.9)
            }
        }
    }
}
