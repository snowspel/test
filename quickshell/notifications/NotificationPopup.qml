// ~/.config/quickshell/snow/notifications/NotificationPopup.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../theme.js" as Theme

PanelWindow {
    id: root
    
    WlrLayershell.layer: WlrLayer.Overlay
    
    anchors.top: true
    anchors.right: true
    margins.top: 48
    margins.right: 16
    
    width: 360
    height: 100
    color: "transparent"
    
    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Qt.rgba(Theme.colors.surface.r, Theme.colors.surface.g, Theme.colors.surface.b, 0.95)
        border.width: 1
        border.color: Qt.rgba(255, 255, 255, 0.12)
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12
            
            Rectangle {
                width: 38
                height: 38
                radius: 10
                color: Theme.colors.surfaceHi
                Text {
                    anchors.centerIn: parent
                    text: "󰂚"
                    font.pixelSize: 18
                    color: Theme.colors.accent
                }
            }
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                
                RowLayout {
                    Text {
                        text: model.title
                        font.family: "Inter"
                        font.pixelSize: 13
                        font.weight: Font.SemiBold
                        color: Theme.colors.text
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "now"
                        font.family: "Inter"
                        font.pixelSize: 10
                        color: Theme.colors.muted
                    }
                }
                
                Text {
                    text: model.message
                    font.family: "Inter"
                    font.pixelSize: 12
                    color: Theme.colors.muted
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
        }
    }
}
