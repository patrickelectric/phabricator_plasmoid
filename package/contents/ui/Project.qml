import QtQuick 2.0

Item {

    property var userInfo: ({});

    property var info: {
        var infoTemp = __storage.get("project_settings", []);

        if (!infoTemp.length)
            return {}

        return JSON.parse(infoTemp);
    }

    function getAllAuthorsIds(params) {
        for (var i = 0; i < info.members.length; i++)
            params["authors["+i+"]"] = info.members[i];

        return params;
    }

    function getUserInfoById(strPhabId, callback) {
        if (!strPhabId || !settingsApi.info.token) return;

        var params = {
            "api.token": settingsApi.info.token,
            "phids[0]": strPhabId
        };

        requesterApi.requestMessage = qsTr("Loading user informations...");
        requesterApi.post("user.query", requesterApi.serialize(params), function (jsonResult, statusCode) {
            if (jsonResult && jsonResult.result)
                callback(jsonResult.result[0]);
            else
                setResponseErrorMessage(jsonResult.error_info);
        });
    }

    function loadProjectMembers() {
        var membersIdsTemp = info.members;
        info.members = [];

        for (var i = 0; i < membersIdsTemp.length; i++) {
            getUserInfoById(membersIdsTemp[i], function(json) {
                if (json.phid) {
                    if (json.roles && json.roles.length) json["phabUserRoles"] = json.roles
                    info.members.push(json);
                    storage.save("project_settings", JSON.stringify(info));
                }
            });
        }
    }

    function reset() {
        save({}, false);
    }

    function save(json, toNotLoadMembers) {
        info = json;
        if (! toNotLoadMembers || toNotLoadMembers !== false) loadProjectMembers();
        storage.save("project_settings", JSON.stringify(json));
    }

    function update(projectName) {
        if (!projectName || !settingsApi.info.token) return;

        var params = {
            "api.token": settingsApi.info.token,
            "names[0]": projectName.trim()
        };

        requesterApi.requestMessage = qsTr("Loading project informations...");
        requesterApi.post("project.query", requesterApi.serialize(params), function (jsonResult, statusCode) {
            if (jsonResult && jsonResult.result)
                for (var prop in jsonResult.result.data)
                    save(jsonResult.result.data[prop]);
            else
                setResponseErrorMessage(jsonResult ? jsonResult.error_info : null)
        });
    }
}
