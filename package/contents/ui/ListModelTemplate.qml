import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
    id: itemListModelTemplate
    width: parent.width; height: 65
    clip: true

    property bool hasDescription
    property string authorRealName

    Component.onCompleted: {
        if (authorPHID) {
            project.getUserInfoById(authorPHID, function(jsonResult){
                if (jsonResult && jsonResult.realName)
                    authorRealName = jsonResult.realName;
            });
        }
    }

    function getDescription(str) {
        return str ? str.replace(/(\r\n|\n|\r)/gm, "").substr(0, 80) + " [...]" : ""
    }

    function getEpoch(str) {
        return new Date(str * 1000).toDateString();
    }

    Rectangle {
        id: parentRec
        width: parent.width; height: parent.height
        clip: true
        radius: 3
        color: "#fff"
        border.color: "#bfcfda"

        RowLayout {
            spacing: 5
            width: parent.width; height: parent.height

            ColumnLayout {
                spacing: 5
                width: parent.width * 0.80; height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: titleText
                    width: parent.width
                    text: title ? getDescription(title) : ""
                    font.pixelSize: 12
                    color: "#41506e"
                    wrapMode: Text.WordWrap
                }

                Text {
                    id: descriptionText
                    width: parent.width
                    font.pixelSize: 11
                    color: "#777"
                    wrapMode: Text.WordWrap
                    text: {
                        if (hasDescription)
                            return getDescription(description);
                        else
                            return getDescription(summary);
                    }
                }
            }

            ColumnLayout {
                spacing: 5
                width: parent.width * 0.20
                height: parent.height
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: authorText
                    anchors.right: parent.right
                    width: parent.width
                    font.italic: true
                    font.pixelSize: 10
                    color: "#919ebb"
                    text: statusName !== undefined ? statusName : author !== undefined ? author : ""
                }

                Text {
                    id: dateCreatedText
                    anchors.right: parent.right
                    width: parent.width
                    text: dateCreated ? getEpoch(dateCreated) : epoch ? getEpoch(epoch) : ""
                    font.italic: true
                    font.pixelSize: 10
                    color: "#777"
                }

                Text {
                    id: authorNameText
                    anchors.right: parent.right
                    width: parent.width
                    font.italic: true
                    font.pixelSize: 10
                    color: "blue"
                    text: authorRealName
                }
            }
        }

        MouseArea {
            hoverEnabled: true
            width: parent.width; height: parent.height
            onClicked: Qt.openUrlExternally(uri)
            cursorShape: Qt.PointingHandCursor
            onExited: {
                parentRec.color = "#fff"
                labelWarnings.text = ""
                labelWarnings.font.italic = false
            }
            onEntered: {
                parentRec.color = "#f0fffa"
                labelWarnings.text = "" + uri
                labelWarnings.font.italic = true
            }
        }
    }
}
