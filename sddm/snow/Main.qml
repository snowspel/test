// /usr/share/sddm/themes/snow/Main.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root
    width: 1920
    height: 1080

    Image {
        id: bg
        anchors.fill: parent
        source: "background.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.4)
    }

    // Centered Login Card
    Rectangle {
        width: 320
        height: 240
        anchors.centerIn: parent
        radius: 20
        color: Qt.rgba(0.12, 0.12, 0.18, 0.88)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.12)

        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width - 40
            spacing: 16

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "❄ SNOW"
                font.family: "Inter"
                font.pixelSize: 18
                font.weight: Font.Bold
                color: "#ffffff"
            }

            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: 10
                color: Qt.rgba(1, 1, 1, 0.08)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.15)

                TextInput {
                    id: passwordInput
                    anchors.fill: parent
                    anchors.margins: 10
                    echoMode: TextInput.Password
                    font.family: "JetBrains Mono"
                    font.pixelSize: 14
                    color: "#ffffff"
                    verticalAlignment: TextInput.AlignVCenter
                    focus: true
                    Keys.onReturnPressed: sddm.login(userModel.lastUser, passwordInput.text, sessionModel.lastIndex)
                }
            }

            Button {
                Layout.fillWidth: true
                height: 38
                text: "Log In"
                onClicked: sddm.login(userModel.lastUser, passwordInput.text, sessionModel.lastIndex)
            }
        }
    }
}
