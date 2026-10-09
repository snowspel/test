// ~/.config/quickshell/snow/polkit/PolkitDialog.qml
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
    color: Qt.rgba(0, 0, 0, 0.6)

    signal authenticated(string password)
    signal cancelled()

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.cancelled()
            root.visible = false
        }
    }

    // Ultra-compact minimal authentication container
    Rectangle {
        width: 310
        height: 165
        anchors.centerIn: parent
        radius: 16
        color: Qt.rgba(Theme.colors.bg.r, Theme.colors.bg.g, Theme.colors.bg.b, 0.96)
        border.width: 1
        border.color: Qt.rgba(255, 255, 255, 0.12)

        MouseArea {
            anchors.fill: parent
            preventStealing: true
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            // Header: Shield Icon + Title
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    width: 28
                    height: 28
                    radius: 8
                    color: Qt.rgba(Theme.colors.accent.r, Theme.colors.accent.g, Theme.colors.accent.b, 0.18)
                    Text {
                        anchors.centerIn: parent
                        text: "󰌾"
                        font.family: "JetBrains Mono Nerd Font"
                        font.pixelSize: 15
                        color: Theme.colors.accent
                    }
                }

                Text {
                    text: "Authenticate"
                    font.family: "Inter"
                    font.pixelSize: 14
                    font.weight: Font.SemiBold
                    color: Theme.colors.text
                }
            }

            // Compact Password Input Field
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 38
                radius: 10
                color: Theme.colors.surface
                border.width: pwdInput.activeFocus ? 1.5 : 1
                border.color: pwdInput.activeFocus ? Theme.colors.accent : Qt.rgba(255, 255, 255, 0.08)

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 8

                    TextInput {
                        id: pwdInput
                        Layout.fillWidth: true
                        font.family: "JetBrains Mono"
                        font.pixelSize: 13
                        color: Theme.colors.text
                        echoMode: TextInput.Password
                        focus: true
                        verticalAlignment: TextInput.AlignVCenter

                        Keys.onReturnPressed: {
                            if (pwdInput.text.length > 0) {
                                root.authenticated(pwdInput.text)
                                root.visible = false
                            }
                        }
                        Keys.onEscapePressed: {
                            root.cancelled()
                            root.visible = false
                        }

                        Text {
                            text: "Enter password..."
                            font.family: "Inter"
                            font.pixelSize: 12
                            color: Theme.colors.muted
                            visible: !pwdInput.text && !pwdInput.activeFocus
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            // Buttons: Cancel & Authenticate
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    radius: 8
                    color: Theme.colors.surface
                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.family: "Inter"
                        font.pixelSize: 12
                        color: Theme.colors.muted
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.cancelled()
                            root.visible = false
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    radius: 8
                    color: Theme.colors.accent
                    Text {
                        anchors.centerIn: parent
                        text: "Authenticate"
                        font.family: "Inter"
                        font.pixelSize: 12
                        font.weight: Font.SemiBold
                        color: "#ffffff"
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (pwdInput.text.length > 0) {
                                root.authenticated(pwdInput.text)
                                root.visible = false
                            }
                        }
                    }
                }
            }
        }
    }
}
