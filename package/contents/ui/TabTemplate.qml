import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4

Item {
    id: tabTemplate
    visible: true
    width: parent.width
    height: parent.height
    state: parent.state

    property bool usesDescription
    property alias listView: __listView
    property alias listModel: __listModel
    property string emptyListMessage: qsTr("No itens to show!")

    Rectangle {
        width: parent.width / 4
        height: parent.height / 4
        radius: 3
        color: "#fff"
        border.color: "#777"
        anchors.centerIn: parent
        visible: tabTemplate.state === "stopped" && tabTemplate.parent.totalItens === 0

        Text {
            anchors.centerIn: parent
            text: emptyListMessage
        }
    }

    Timer {
        repeat: true
        running: settingsApi.info.updateCheckTime !== 0
        interval: settingsApi.info.updateCheckTime || 0
        onTriggered: loadDataFromApi()
    }

    ListModel {
        id: __listModel
    }

    ScrollView {
        frameVisible: true
        anchors.fill: parent
        highlightOnFocus: true
        style: ScrollViewStyle {
            transientScrollBars: true
            handle: Item {
                implicitWidth: 8
                Rectangle {
                    color: "#888"
                    radius: 1
                    anchors.fill: parent
                    anchors.topMargin: 0
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                }
            }
        }

        ListView {
            id: __listView
            spacing: 2
            anchors.fill: parent
            anchors.margins: 10
            model: listModel
            delegate: ListModelTemplate { hasDescription: usesDescription }
            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 800 }
            }
            displaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
            }
        }
    }
}
