import QtQuick 2.6
import QtQuick.Controls 1.5

Rectangle {
    id: commitsTab
    width: initialPlasmoidWidth
    height: initialPlasmoidHeight
    color: "transparent"
    state: "started"

    property int totalMembers: 0
    property string currentUserRoles: ""

    function appendMemberToList() {
        for (var i = 0; i < project.info.members.length; i++) {
            __membersListModel.append(project.info.members[i]);
            currentUserRoles = project.info.members[i].roles.join(" - ");
        }

        totalMembers = i;
    }

    Component.onCompleted: appendMemberToList();

    Rectangle {
        id: projectInfoSection
        width: parent.width
        height: parent.height
        radius: 3
        color: "#fff"
        border.color: "#aaa"

        Column {
            id: projectInfo
            spacing: 8
            anchors.fill: parent
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10

            Text {
                text: "Project Name: " + project.info.name
            }
            Text {
                text: "Project slugs: " + project.info.slugs.join(", ")
            }
            Text {
                text: "Creation Date: " + new Date(project.info.dateCreated * 1000).toDateString();
            }
            Text {
                id: memberId
                text: "Project members: (%1)".arg(totalMembers)
            }

            ListModel {
                id: __membersListModel
            }

            Component {
               id: membersDelegate
               Item {
                   width: projectInfoSection.width * 0.90; height: 85
                   Rectangle {
                       anchors.fill: parent
                       radius: 3
                       color: "#f0ffff"
                       border.color: "#dfdfdf"

                       Row {
                           spacing: 10
                           anchors.verticalCenter: parent.verticalCenter
                           anchors.left: parent.left
                           anchors.leftMargin: 5

                           Image {
                               id: userImage
                               width: 75
                               height: 75
                               asynchronous: true
                               clip: true
                               source: image
                           }

                           Column {
                               anchors.left: userImage.right
                               anchors.leftMargin: 5
                               spacing: 5

                               Text {
                                   width: parent.width - 85
                                   text: "<b>Name:</b> %1".arg(realName ? realName : "Name for this user is not defined")
                               }

                               Text {
                                   width: parent.width - 85
                                   text: "<b>Profile:</b> %1".arg(uri)
                                   linkColor: "blue"
                                   z: 99
                                   textFormat: Text.RichText
                                   onLinkActivated: Qt.openUrlExternally(uri)
                               }

                               Text {
                                   width: parent.width - 85
                                   text: "<b>Phabricator Roles:</b> %1".arg(currentUserRoles)
                               }
                           }
                       }
                   }
               }
            }

            ListView {
                width: parent.width
                height: parent.height * 0.70
                clip: true
                z: -1
                model: __membersListModel
                spacing: 3
                delegate: membersDelegate
            }
        }
    }
}
