import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    z: 100
    clip: true
    visible: true
    width: initialPlasmoidWidth
    height: initialPlasmoidHeight
    anchors.horizontalCenter: parent.horizontalCenter

    property alias user: __user
    property alias project: __project
    property alias storage: __storage
    property alias settingsApi: __settingsApi
    property alias requesterApi: __requesterApi
    property alias labelWarnings: __labelWarnings

    property string version: "1.0"
    property string client: "qml-phabricator-client"

    property real initialPlasmoidWidth: parent.width * 0.999
    property real initialPlasmoidHeight: parent.height * 0.999

    function setResponseErrorMessage(message) {
        labelWarnings.color = "red";
        labelWarnings.text  = message ? "Error: %1".arg(message) : qsTr("Error on load data from phabricator!");
    }

    Storage {
        id: __storage
    }

    RequesterApi {
        id: __requesterApi
    }

    User {
        id: __user
    }

    SettingsApi {
        id: __settingsApi
    }

    Project {
        id: __project
    }

    ColumnLayout {
        width: parent.width; height: parent.height

        Tabs {
            id: __tabs
            z: 10
            width: parent.width; height: parent.height - __messageSection.height * 2
        }

        Rectangle {
            id: __messageSection
            z: 11
            width: parent.width; height: parent.height * 0.075
            anchors.bottom: __tabs.bottom
            color: "#fff"
            border.color: "#bbb"

            Timer {
                id: __labelWarningDisplayTimer
                running: __labelWarnings.text.length
                repeat: false
                interval: 5000
                onTriggered: {
                    __labelWarnings.text  = ""
                    __labelWarnings.color = "#41506e";
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 5

                BusyIndicator {
                    id: __progressIndicator
                    width: 16; height: 16
                    implicitWidth: 16; implicitHeight: 16
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.01
                    running: requesterApi.state === "running"
                    NumberAnimation on opacity {
                        from: 0
                        to: 1
                        duration: 1500
                    }
                }

                Text {
                    id: __labelWarnings
                    width: parent.width * 0.70
                    anchors.left: __progressIndicator.running ? __progressIndicator.right : parent.left
                    anchors.leftMargin: parent.width * 0.01
                    text: requesterApi.requestMessage
                    color: "#41506e"
                    font.pixelSize: 11
                    NumberAnimation on opacity {
                        from: 0
                        to: 1
                        duration: 800
                    }
                }

                Button {
                    id: __forceReload
                    width: 24; height: 24
                    iconSource: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAtFBMVEX///8ZMUIZMkEZMUIYMUIYMUIXMEMVK0AZMkEYMUIYMUIYMUIYMUIXMEIYMUIYMUIXMUIXMUEYMT0AAAAYMUIYMUIXMEEAVVUXMUEYMUMWLEMYMUIYMkIYMUIaM0IYMUIYMUIWM0IYMUIYMkMVNUAXMUIYMUMYMUIYMUIYMkIYMEMYMUIYMUMYMEEAQEAYMEEYMkIYMEEYMUIYMUEgQEAZMkIYMUIYMUIYMUERM0QYMUIAAAA3xMoEAAAAOnRSTlMAH3Gl2bJvDGbz46t3hMb772IVAa35eQOYcxfUbPcy/uoj9XYY5H7c159fiOZqBIm+S/xeCJDx27cPXE/KmwAAAAFiS0dEEwy7XJYAAAAJcEhZcwAADdcAAA3XAUIom3gAAAAHdElNRQfgBgUDCR88grxVAAAAi0lEQVQY02WP1xKCQAxFjwpiwYpSbKDYu9j3/z9MdpSdZTxPuXeS3ARSCsWSYZhlix+Vaq1uN5qtdge64PT6rid9yxfBYAij8SRrdcNIMJ3FmWa+EILlylN6LVLD3KiG7S6F/YE8f4Y28kVbCkeHXCynM7nDLskV7fSbndy15wI/eqhA+f7zFb9l/QE2Vwwtdfi7BQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxNi0wNi0wNVQwMzowOTozMSswMjowMCwjUJIAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTYtMDYtMDVUMDM6MDk6MzErMDI6MDBdfuguAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAABJRU5ErkJggg=="
                    enabled: __tabs.currentIndex !== 3 && requesterApi.state !== "running"
                    text: qsTr("Update")
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width * 0.01
                    onClicked: __tabs.getTab(__tabs.currentIndex).item.loadDataFromApi()
                }
            }

            MouseArea {
                hoverEnabled: true
                width: parent.width - __forceReload.width; height: parent.height
                onEntered: labelWarnings.text = ""
            }
        }
    }
}
