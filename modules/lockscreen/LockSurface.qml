import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell.Wayland

Rectangle {
    id: root
    color: colors.window
    required property LockContext context
    readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive
    Button {
        text: "It's not working ? It's your fault."
        onClicked: context.unlocked()
    }
    Label {
        id: clock
        property var date: new Date()
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 100
        }
        renderType: Text.NativeRendering
        font.pointSize: 80
        Timer {
            running: true
            repeat: true
            interval: 1000
            onTriggered: clock.date = new Date()
        }
        text: {
            const hours = this.date.getHours().toString().padStart(2, '0');
            const minutes = this.date.getMinutes().toString().padStart(2, '0');
            return `${hours}:${minutes}`;
        }
    }
    ColumnLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.verticalCenter
        }
        RowLayout {
            TextField {
                id: passwordBox
                implicitWidth: 400
                padding: 10
                focus: true
                enabled: !root.context.unlockInProgress
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveDate
                onTextChanged: root.context.currentText = this.text
                onAccepted: root.context.tryUnlock()
                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        passwordBox.text = root.context.currentText;
                    }
                }
            }
        }
        Label {
            visible: root.context.showFailure
            text: "Incorrect password bro !"
        }
    }
}
