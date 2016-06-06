import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: tasksTab
    width: initialPlasmoidWidth
    height: initialPlasmoidHeight
    color: "transparent"
    state: "started"

    property int next: 0
    property int totalItens: 0
    property var tasksIds: ({})

    property alias listView: tasksTabTemplate.listView
    property alias listModel: tasksTabTemplate.listModel

    function loadItens() {
        if (!settingsApi.info.token) return;

        requesterApi.requestMessage = qsTr("Waiting server response...");
        requesterApi.post("maniphest.query", requesterApi.serialize(tasksIds), function (jsonResult, statusCode) {
            if (jsonResult && jsonResult.result) {
                for (var prop in jsonResult.result) {
                    listModel.append(jsonResult.result[prop]);
                }
            } else {
                setResponseErrorMessage(jsonResult.error_info);
            }
            tasksTab.state = "stopped";
        });
    }

    function loadDataFromApi() {
        if (!settingsApi.info.token) return;

        tasksTab.state = "loading";

        listModel.clear();

        totalItens = 0;

        tasksIds   = ({
            "api.token": settingsApi.info.token
        });

        var params = {
            "api.token": settingsApi.info.token
        };

        if (project.info.phid)
            params["projectPHIDs[0]"] = project.info.phid;
        else
            params["authorPHIDs[0]"]  = user.info.phid;

        requesterApi.requestMessage = qsTr("Loading tasks...");
        requesterApi.post("maniphest.query", requesterApi.serialize(params), function (jsonResult, statusCode) {
            if (jsonResult && jsonResult.result) {
                for (var prop in jsonResult.result) {
                    tasksIds["ids[%1]".arg(totalItens++)] = jsonResult.result[prop].id;
                }
                loadItens();
            } else {
                setResponseErrorMessage((jsonResult && jsonResult.error_info) ? jsonResult.error_info : "The tasks list is empty!");
                tasksTab.state = "stopped";
            }
        });
    }

//    Component.onCompleted: loadDataFromApi();

    TabTemplate {
        id: tasksTabTemplate
        emptyListMessage: qsTr("No tasks to show!")
        usesDescription: true
    }
}
