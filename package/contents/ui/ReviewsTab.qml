import QtQuick 2.6
import QtQuick.Controls 1.5

Rectangle {
    id: reviewsTab
    width: initialPlasmoidWidth
    height: initialPlasmoidHeight
    color: "transparent"
    state: "started"

    property int next: 0
    property int totalItens: 0
    property var reviewsIds: ({})

    property alias listView: reviewTabTemplate.listView
    property alias listModel: reviewTabTemplate.listModel

    function loadDataFromApi() {
        if (!settingsApi.info.token) return;

        reviewsTab.state = "loading";

        listModel.clear();

        totalItens = 0;

        var params = ({
            "api.token": settingsApi.info.token
        });

        if (settingsApi.info.filterReviewsBy === "reviewer")
            params["reviewers[0]"] = user.info.phid;
        else if (settingsApi.info.filterReviewsBy === "author")
            params["authors[phid]"] = user.info.phid;
        else //by project
            params = project.getAllAuthorsIds(params);

        requesterApi.requestMessage = qsTr("Loading reviews...");
        requesterApi.post("differential.query", requesterApi.serialize(params), function (jsonResult, statusCode) {
            if (jsonResult && jsonResult.result)
                for (var i = 0; i < jsonResult.result.length; i++)
                    listModel.append(jsonResult.result[i])
            else
                setResponseErrorMessage(jsonResult.error_info)

            reviewsTab.state = "stopped";
        });
    }

    Component.onCompleted: loadDataFromApi();

    TabTemplate {
        id: reviewTabTemplate
        emptyListMessage: qsTr("No reviews to show!")
        usesDescription: false
    }
}
