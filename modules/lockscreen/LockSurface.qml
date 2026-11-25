import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: root
    required property LockContext context

    readonly property color bg: "#0a0e0b"
    readonly property color fg: "#d4e4d6"
    readonly property color blue: "#79c0ff"
    readonly property color orange: "#ffa657"
    readonly property color muted: "#7d8f80"
    readonly property color white: "#ffffff"
    readonly property color danger: "#ff7b72"

    readonly property string user: "aina"
    readonly property string monoFamily: "JetBrains Mono"

    function prompt(cmd) {
        return `<font color="${orange}">~</font><font color="${white}">$</font> <font color="${blue}">${cmd}</font>`;
    }

    color: bg

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    ColumnLayout {
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 96
            topMargin: 96
        }
        spacing: 6

        Text {
            textFormat: Text.StyledText
            text: root.prompt("date")
            color: root.fg
            font.family: root.monoFamily
            font.pixelSize: 18
            renderType: Text.NativeRendering
        }

        Text {
            Layout.topMargin: 4
            Layout.bottomMargin: 12
            text: clock.date.toLocaleString(Qt.locale("en_EN"), "ddd d MMM yyyy HH:mm:ss t")
            color: root.orange
            font.family: root.monoFamily
            font.pixelSize: 48
            font.letterSpacing: -0.96  // -0.02em
            lineHeight: 1.2
            renderType: Text.NativeRendering
        }

        Text {
            Layout.topMargin: 12
            textFormat: Text.StyledText
            text: root.prompt("whoami")
            color: root.fg
            font.family: root.monoFamily
            font.pixelSize: 18
            renderType: Text.NativeRendering
        }

        Text {
            text: root.user
            color: root.muted
            font.family: root.monoFamily
            font.pixelSize: 18
            renderType: Text.NativeRendering
        }

        Text {
            Layout.topMargin: 12
            textFormat: Text.StyledText
            text: root.prompt("loginctl show-session --property=State")
            color: root.fg
            font.family: root.monoFamily
            font.pixelSize: 18
            renderType: Text.NativeRendering
        }

        Text {
            text: "State=locked"
            color: root.muted
            font.family: root.monoFamily
            font.pixelSize: 18
            renderType: Text.NativeRendering
        }

        Text {
            Layout.topMargin: 12
            textFormat: Text.StyledText
            text: root.prompt("unlock --force")
            color: root.fg
            font.family: root.monoFamily
            font.pixelSize: 18
            renderType: Text.NativeRendering
        }

        Text {
            text: "unlock: permission denied (are you root?)"
            color: root.danger
            font.family: root.monoFamily
            font.pixelSize: 18
            renderType: Text.NativeRendering
        }

        Text {
            Layout.topMargin: 12
            textFormat: Text.StyledText
            text: root.prompt("sudo !!")
            color: root.fg
            font.family: root.monoFamily
            font.pixelSize: 18
            renderType: Text.NativeRendering
        }

        RowLayout {
            spacing: 8

            Text {
                text: `[sudo] password for ${root.user} :`
                color: root.fg
                font.family: root.monoFamily
                font.pixelSize: 18
                renderType: Text.NativeRendering
            }

            Item {
                implicitWidth: 260
                implicitHeight: passwordMetrics.height

                TextInput {
                    id: passwordBox
                    anchors.fill: parent
                    verticalAlignment: TextInput.AlignVCenter
                    focus: true
                    enabled: !root.context.unlockInProgress
                    opacity: enabled ? 1 : 0.5
                    echoMode: TextInput.Password
                    passwordCharacter: "•"
                    inputMethodHints: Qt.ImhSensitiveData
                    color: root.fg
                    selectionColor: root.blue
                    selectedTextColor: root.bg
                    font.family: root.monoFamily
                    font.pixelSize: 18
                    renderType: Text.NativeRendering

                    cursorDelegate: Rectangle {
                        id: blockCursor
                        width: Math.ceil(passwordMetrics.averageCharacterWidth)
                        color: root.orange

                        SequentialAnimation on opacity {
                            id: cursorBlink
                            loops: Animation.Infinite
                            running: passwordBox.activeFocus && passwordBox.enabled

                            PauseAnimation { duration: 500 }
                            NumberAnimation { to: 0.0; duration: 1 }
                            PauseAnimation { duration: 500 }
                            NumberAnimation { to: 1.0; duration: 1 }
                        }

                        Connections {
                            target: passwordBox
                            function onTextChanged() {
                                blockCursor.opacity = 1.0;
                                cursorBlink.restart();
                            }
                            function onCursorPositionChanged() {
                                blockCursor.opacity = 1.0;
                                cursorBlink.restart();
                            }
                        }
                    }

                    FontMetrics {
                        id: passwordMetrics
                        font: passwordBox.font
                    }

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
        }

        Text {
            visible: root.context.showFailure
            text: "Wrong password. This incident will be reported."
            color: root.danger
            font.family: root.monoFamily
            font.pixelSize: 18
            renderType: Text.NativeRendering
        }
    }

    RowLayout {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 96
            rightMargin: 96
            bottomMargin: 48
        }

        Text {
            text: root.statusLeft
            color: root.muted
            font.family: root.monoFamily
            font.pixelSize: 14
            renderType: Text.NativeRendering
        }

        Item { Layout.fillWidth: true }

        Text {
            text: root.statusRight
            color: root.muted
            font.family: root.monoFamily
            font.pixelSize: 14
            renderType: Text.NativeRendering
        }
    }
}
