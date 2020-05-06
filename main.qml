import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import com.renda.core 1.0

ApplicationWindow {
    property var state: 0
    property var progressText: "Ready"

    flags: Qt.FramelessWindowHint
    title: qsTr("Baclup Tool")

    Material.theme: Material.Dark
    Material.accent: Material.Purple

    id: window
    visible: true
    width: 300
    height: 400

    screen: Qt.application.screens[0]
    x: screen.width - this.width
    y: screen.height - this.height - 30

    Component.onCompleted: {
        progressBar.value = core.workload
    }

    MouseArea {
        property variant clickPos: "1,1"
        anchors.fill: parent

        onPressed: {
            clickPos  = Qt.point(mouse.x,mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            window.x += delta.x;
            window.y += delta.y;
        }
    }

    Core {
        id: core
        onStarted:  { progressText = "Backing up.. " }
        onStopped:  { Qt.quit() }
        onPaused:   { progressText = "Paused " }
        onResumed:  { progressText = "Backing up.. " }
        onProgress: {
            lblStatus.text = progressText + core.workload + "%"
            progressBar.value = (core.workload * 0.01)
        }
    }

    Label {
        id: lblStatus
        text: "Status"
        color: "gray"
        x: 10
        y: parent.height - 45
    }

    Label {
        id: lblTitle
        text: "Backup Tool"
        color: "gray"
        x: 10
        y: 10
    }

    ProgressBar {
        y: parent.height - 20
        id: progressBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        value: 0.5
    }

    Rectangle {
        id: button
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 150
        height: 150
        radius: width
        color: "#9C27B0"
        opacity: 0.5

        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onEntered: parent.opacity = 1
            onExited: parent.opacity = 0.5

            onClicked: {
                if (state == 0) {
                    state = 1
                    buttonLbl.text = qsTr("Pause")
                    core.start()
                } else if (state == 1) {
                    state = 2
                    buttonLbl.text = qsTr("Resume")
                    core.pause()
                } else if (state == 2) {
                    state = 1
                    buttonLbl.text = qsTr("Pause")
                    core.resume()
                }
                console.log(state)
            }
        }
    }

    Label {
        id: buttonLbl
        text: qsTr("Start")
        color: "black"
        anchors.centerIn: parent
    }

    TitleBarButton {
        id: quitButton
        x: parent.width - (this.width + 20)
        y: 10
        buttonColor: "red"
        function onclickFunc() { core.stop() }
    }

    TitleBarButton {
        id: settingsButton
        x: parent.width - (this.width + 35)
        y: 10
        buttonColor: "blue"
        function onclickFunc() { popup.open() }
    }

    Button {
        x: 0
        y: 50
        text: "test"
        onClicked: Qt.quit()
    }

    Popup {
            id: popup
            anchors.centerIn: parent
            width: 200
            height: 300
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnReleaseOutside
        }
}
