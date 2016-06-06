import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4

Item {
    id: configurePage
    width: parent.width
    height: parent.height
    clip: true
    z: 0

    function getLoadingReviewsBy() {
        if (radioReviewByAuthor.checked)
            return "author";
        else if (radioReviewByReviewer.checked)
            return "reviewer";
        else
            return "project";
    }

    function updateSettings() {
        settingsApi.update(
            userEmail.text,
            phabricatorUrl.text,
            token.text,
            projectName.text,
            getLoadingReviewsBy(),
            updateCheckTime.value ? (updateCheckTime.value * 100) : 0
        );
    }

    function resetSettings() {
        userEmail.text = phabricatorUrl.text = token.text = projectName.text = ""
        updateCheckTime.value = 0
        settingsApi.reset();
    }

    Flickable {
        pixelAligned: true
        width: parent.width; height: parent.height
        contentWidth: parent.width; contentHeight: parent.height * 1.20

        Rectangle {
            id: rec
            width: parent.width * 0.90
            height: parent.height
            anchors.centerIn: parent
            color: "transparent"

            Column {
                spacing: 3
                anchors.fill: parent

                Item {width: parent.width; height: 6}

                Text {
                    id: labelInfo
                    width: parent.width
                    color: "#444"
                    wrapMode: Text.WordWrap
                    anchors.left: parent.left
                    text: qsTr("Put the settings below to connect to phabricator API")
                }

                Item {width: parent.width; height: 6}

                Text {
                    text: qsTr("User Email *")
                }

                TextField {
                    id: userEmail
                    width: parent.width * 0.999
                    height: 25
                    inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhPreferLowercase
                    text: user.info.email
                    placeholderText: qsTr("Your phabricator (user) email to retrieve informations")
                }

                Item {width: parent.width; height: 6}

                Text {
                    text: qsTr("Phabricator url *")
                }

                TextField {
                    id: phabricatorUrl
                    width: parent.width
                    text: settingsApi.info.host || ""
                    focus: false
                    inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhUrlCharactersOnly
                    placeholderText: "https://phabricator.sample.com"
                }

                Item {width: parent.width; height: 6}

                Text {
                    text: qsTr("Conduit API Token *")
                    onTextChanged: text += qsTr(" <a href='%1/settings/panel/apitokens/'>Clique here to get a token</a>.".arg(text))
                    onFocusChanged: cursorShape = Qt.PointingHandCursor
                    onLinkActivated: Qt.openUrlExternally(link)
                }

                TextField {
                    id: token
                    width: parent.width
                    text: settingsApi.info.token || ""
                    maximumLength: 32
                    placeholderText: qsTr("Started with: api-alphanumeric_sequence")
                }

                Item {width: parent.width; height: 6}

                Text {
                    text: qsTr("Project name")
                }

                TextField {
                    id: projectName
                    width: parent.width
                    text: project.info.name || ""
                    placeholderText: qsTr("The name of project to retrieve informations")
                }

                Item {width: parent.width; height: 6}

                Text {
                    text: qsTr("Time to check updates. Set zero to disable")
                }

                Slider {
                    id: updateCheckTime
                    width: parent.width
                    maximumValue: 6000
                    minimumValue: 0
                    stepSize: 60
                    value: settingsApi.info.updateCheckTime / 100
                }

                Text {
                    text: "%1 seconds - %2 Minute%3".arg(updateCheckTime.value).arg(updateCheckTime.value / 60).arg(updateCheckTime.value <= 60 ? "" : "s")
                }

                Item {width: parent.width; height: 6}

                GroupBox {
                    width: parent.width
                    title: "Filter Reviews:"

                    ColumnLayout {
                        Layout.fillWidth: true

                        ExclusiveGroup { id: tabPositionGroup }

                        RadioButton {
                            id: radioReviewByAuthor
                            text: "By Author (you)"
                            checked: settingsApi.info.filterReviewsBy === "author"
                            exclusiveGroup: tabPositionGroup
                        }
                        RadioButton {
                            id: radioReviewByProject
                            text: "By Project (from all authors)"
                            checked: settingsApi.info.filterReviewsBy === "project"
                            exclusiveGroup: tabPositionGroup
                        }
                        RadioButton {
                            id: radioReviewByReviewer
                            text: "By Reviewer (if you is a reviewer and not open reviews)"
                            checked: settingsApi.info.filterReviewsBy === "reviewer"
                            exclusiveGroup: tabPositionGroup
                        }
                    }
                }

                Item {width: parent.width; height: 6}

                RowLayout {
                    width: parent.width
                    spacing: 5

                    Button {
                        id: resetButton
                        width: parent.width * 0.15
                        height: parent.width * 0.05
                        anchors.left: parent.left
                        enabled: (userEmail.text && phabricatorUrl.text && token.text)
                        text: qsTr("Reset settings")
                        onClicked: resetSettings();
                    }

                    Button {
                        id: submitButton
                        text: qsTr("Save settings")
                        anchors.right: parent.right
                        onClicked: updateSettings();
                        enabled: (userEmail.text && phabricatorUrl.text && token.text)
                    }
                }
            }
        }
    }
}
