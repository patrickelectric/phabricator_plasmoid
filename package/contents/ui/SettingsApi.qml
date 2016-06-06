import QtQuick 2.0

Item {

    property var info: {
        var infoTemp = __storage.get("api_settings", []);

        if (!infoTemp.length)
            return {}

        return JSON.parse(infoTemp);
    }

    function save(json) {
        storage.save("api_settings", JSON.stringify(json));
        info = json;
        labelWarnings.text = qsTr("Save successfully!");
    }

    function update(userEmail, phabricatorUrl, token, projectName, reviewsByOption, updateTimerVerify) {
        save({
            "host": phabricatorUrl.trim().toLowerCase(),
            "token": token.trim(),
            "filterReviewsBy": reviewsByOption,
            "updateCheckTime": updateTimerVerify
        });
        user.update(userEmail);
        project.update(projectName);
    }

    function reset() {
        save({});
        user.reset();
        project.reset();
    }
}
